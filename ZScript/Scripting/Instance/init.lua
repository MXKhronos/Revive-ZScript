local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local RunService = game:GetService("RunService");
local ReflectionService = game:GetService("ReflectionService");

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	zEnv.Instance = zScr.Instance;
	zEnv.new = zScr.getOrNewInstance;

	zScr.Sandbox = function(data, instanceCast)
		if typeof(data) == "function" then
			local func = data;
			if instanceCast then
				return zScr.getOrNewInstance(instanceCast, function(...)
					local args = zScr.Sandbox({...});
					return func(unpack(args or {}));
				end);
			end

			return function(...)
				local args = zScr.Sandbox({...});
				return func(unpack(args or {}));
			end;

		elseif typeof(data) == "table" then
			local n = {};
			for k, v in pairs(data) do
				local newK = zScr.Sandbox(k);
				if newK == nil then continue end;
				n[newK] = zScr.Sandbox(v);
			end

			if instanceCast then
				n.ClassName = instanceCast;
				return zScr.getOrNewInstance(instanceCast, n);
			end

			return n;

		elseif (typeof(data) == "userdata" or typeof(data) == "Instance") and data.ClassName then
			local instancePackage = zScr.InstancePackages[data.ClassName];
			local class = instancePackage and instancePackage.Class;
			if class == nil then
				return nil;
			end

			return zScr.getOrNewInstance(data.ClassName, data);

		elseif typeof(data) == "string" or typeof(data) == "number" or typeof(data) == "boolean"  then
			return data;

		end

		return nil;
	end

	zScr.UnSandbox = function(data)
		if typeof(data) == "Instance" then
			error(`This can't be happening..`);

		elseif typeof(data) == "userdata" then
			for realInstance, proxyInstance in pairs(zScr.RealInstances) do
				if proxyInstance == data then
					return realInstance;
				end
			end

		elseif typeof(data) == "table" then
			local n = {};
			for k, v in pairs(data) do
				local nK = zScr.UnSandbox(k);
				if nK == nil then continue end;
				
				n[nK] = zScr.UnSandbox(v);
			end
			
		elseif typeof(data) == "string" or typeof(data) == "number" or typeof(data) == "boolean"  then
			return data;

		end

		return nil;
	end
end

function ZScript.Init(zScr)
	local realInstancesList = {};
	zScr.RealInstances = realInstancesList;

	local InstancePackages = {};
	zScr.InstancePackages = InstancePackages;

	local Instance, InstanceMeta = zScr.newLib();
	Instance.ClassName = "Instance";
	Instance.ClassList = {};

	
	--==
	function Instance:FindFirst(name: string)
		for id, userdata in pairs(zScr.ProxyInstances) do
			if userdata.Name == name then
				return userdata;
			end
		end
		return nil;
	end
	InstanceMeta.hintFindFirst = "Get an existing instance.";
	InstanceMeta.descFindFirst = [[Get an existing instance by name.
		<b>Instance:FindFirst</b>(name: <i>string</i>): <i>Instance?</i>
	]];
	

	--==
	function Instance:List(pattern: string?, search: boolean?)
		local r = {};
		
		for id, userdata in pairs(zScr.ProxyInstances) do
			local add = false;
			if pattern == nil then
				add = true;
			elseif search == true and string.match(userdata.Name, pattern) then
				add = true;
			elseif userdata.Name == pattern then
				add = true;
			end
			
			if add then
				table.insert(r, userdata);
			end
		end
		
		table.sort(r, function(a, b)
			return (a.Name or a.ClassName) > (b.Name or a.ClassName);
		end)
		return r;
	end
	InstanceMeta.hintList = "Get a list of instances by name.";
	InstanceMeta.descList = [[Get a list of instances by name or matching name patterns.
		if search is false, pattern is be used to match instances name. 
		if search is true, pattern will be used in string.match to match instance names.
		<b>Instance:List</b>(pattern: <i>string?</i>, search: boolean?): <i>Instance</i>
	]];
	

	--==
	function Instance:MatchList(func: (any)->boolean)
		local r = {};
		for id, userdata in pairs(zScr.ProxyInstances) do
			local isMatch, breakRequest = func(userdata);
			if isMatch == true then
				table.insert(r, userdata);
			end
			if breakRequest == true then
				break;
			end
		end
		return r;
	end
	InstanceMeta.hintMatchList = "Get an existing instance by matching.";
	InstanceMeta.descMatchList= [[Get an existing instance by matching property key and values. Match function should return one or two booleans. First boolean is for a match, second boolean is to break search loop.
		<b>Instance:MatchList</b>(matchFunc: <i>(instance: Instance) -> boolean, boolean</i>): <i>{Instance}</i>
	]];


	--==
	function Instance:DestroyList(pattern: string, search: boolean)
		local r = self:List(pattern, search);
		for a=1, #r do
			r[a]:Destroy();
		end
	end
	InstanceMeta.hintDestroyList = "Destroy a list of instances.";
	InstanceMeta.descDestroyList = [[Destroy a list of instances by name or matching name patterns.
		if search is false, pattern is be used to match instances name. 
		if search is true, pattern will be used in string.match to match instance names.
		<b>Instance:List</b>(pattern: <i>string?</i>, search: boolean?): <i>Instance</i>
	]];
	

	for _, obj in pairs(script:GetChildren()) do
		if not obj:IsA("ModuleScript") then continue end;
		
		local zInstance = shared.require(obj);
		local className = obj.Name;

		zInstance.Class.Name = className;
		zInstance.Class.ClassName = className;

		zScr.InstancePackages[className] = zInstance;
	end

	for key, _ in pairs(zScr.InstancePackages) do
		local proxy = newproxy(true);
		local meta = getmetatable(proxy);
		meta.__metatable = "The metatable is locked";
		meta.ClassName = key;
		
		Instance.ClassList[key] = proxy;
	end

	zScr.Instance = Instance;
	zScr.getOrNewInstance = function(className: string, realInstance, ...)
		if getfenv(1).Instance == nil and realInstance then -- instance should be nil in sandbox.
			realInstance = nil;
		end

		if className == nil then
			error("Missing class name for new()");
		end

		local instancePackage = zScr.InstancePackages[className];
		if instancePackage == nil then
			error(`Class name does not exist for new({className})`);
		end

		local baseClass = instancePackage.Class;
		if baseClass == nil then
			error(`Class name does not exist for new({className})`);
		end

		local constructor = instancePackage.Constructor;
		if constructor == nil then
			error(`Class {className} does not have a constructor.`);
		end

		local proxyInstance = realInstance and zScr.RealInstances[realInstance] or nil;
		if proxyInstance ~= nil then 
			return proxyInstance;
		end
		proxyInstance = newproxy(true);


		local public = getmetatable(proxyInstance);
		zScr.InstanceCounter = zScr.InstanceCounter+1;
		local id = zScr.InstanceCounter;
		local private = {
			Id = id;
			ClassName = className;
			__instance = realInstance;
		};

		local rTuple = {constructor(zScr, public, private, realInstance, ...)};
		if realInstance == nil then
			realInstance = private.__instance;
		end

		for k, func in pairs(baseClass) do
			if typeof(func) ~= "function" then continue end;
			
			private[k] = function(...)
				return func(private, ...);
			end
		end

		function public.__call(_, ...) -- instance being called. 
			local properties = ...;

			if typeof(properties) ~= "table" then
				error(`Invalid properties initialization for {className}`);
				return;
			end

			for k, v in pairs(properties) do
				public[k] = v;
			end
			
			return proxyInstance;
		end;

		function public.__index(_, k)
			if k == "__instance" then
				error(`{k} is not a valid member of {className}!`);
			end

			if public[k] then
				return public[k];
			end

			if private[k] then
				return private[k];
			end

			if typeof(realInstance) == "Instance" then
				local classProps = ReflectionService:GetPropertiesOfClass(className);
				for a=1, #classProps do
					local prop = classProps[a];
					if prop.Name ~= k then continue end;
					if zScr.DataTypes[prop.Type.ScriptType] == nil then continue end;

					return realInstance[k];
				end
			end

			if baseClass[k] == nil then
				error(`{k} is not a valid member of {className}`);
			end

			return nil;
		end;
	
		function public.__newindex(_, k, v)
			if k == "__instance" or k == "Id" or k == "ClassName" then
				error(`Can not modify Instance.{k}.`);
			end

			if baseClass[k] == nil then
				error(`{k} is not a valid member of {className} to set.`);
			end
			
			if realInstance then
				realInstance[k] = v;
			end
		end;

		local _tostring = rawget(private, "__tostring");
		function public.__tostring(_)
			local str = _tostring and _tostring(public) or tostring(proxyInstance);
			str = str:gsub("userdata", className);
			return str;
		end;

		function private.Destroy()
			if private.OnDestroy then
				private.OnDestroy();
			end
			if realInstance and instancePackage.CanDestroy ~= false then
				Debugger.Expire(realInstance);
			end
			zScr.ProxyInstances[id] = nil;
			realInstancesList[realInstance] = nil;
		end

		if RunService:IsStudio() then
			function public.KeyValues()
				local keyValues = {};
				for k, v in pairs(baseClass) do
					keyValues[k] = public[k] or private[k] or realInstance and realInstance[k];
				end
				
				return keyValues;
			end
		end


		public.__metatable = "The metatable is locked";
		zScr.ProxyInstances[id] = proxyInstance;

		if realInstance then
			zScr.RealInstances[realInstance] = proxyInstance;

			if typeof(realInstance) == "Instance" then
				realInstance.Destroying:Connect(function()
					proxyInstance:Destroy();
				end)

				if RunService:IsStudio() then
					realInstance:SetAttribute("ZScriptId", id);
				end
				realInstance:AddTag("ZScriptInstance");
			end
		end

		return proxyInstance;
	end;
end

return ZScript;