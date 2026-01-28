local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");

local modLoadstring = shared.require(script.Parent:WaitForChild("Loadstring"));
local modZScriptLang = shared.require(script.Parent:WaitForChild("Lexer"):WaitForChild("Lang"));

local zscriptsFolder = script.Parent:WaitForChild("Scripts");
--
local Scripting = {};
Scripting.__index = Scripting;
Scripting.Debugger = Debugger;

Scripting.ConsoleOutput = shared.EventSignal.new("OnConsoleOutput");

Scripting.ProxyInstances = {};
Scripting.InstanceCounter = 0;
Scripting.getOrNewInstance = nil;

Scripting.ThreadList = {};

Scripting.GlobalZEnv = nil;
Scripting.ZScrLangInit = false;

Scripting.shared = {};

Scripting.DataTypes = {["string"]="string"; ["boolean"]=true; ["number"]=1; ["EnumItem"]=true;};
--==

function Scripting.newLib(m)
	local meta = m or {};
	meta.__index = meta;
	meta.__metatable = "The metatable is locked";

	local self = {};
	setmetatable(self, meta);

	return self, meta;
end

function Scripting.regDataType(name, type)
	Scripting.DataTypes[name] = type;
end

function Scripting.initLib()
	if Scripting.GlobalZEnv == nil then
		local globalMeta = {};

		local loadList = {};
		for _, src in pairs(script:GetChildren()) do
			if not src:IsA("ModuleScript") then continue end;
			local obj = shared.require(src);
			
			if obj.Init and obj._init ~= true then
				obj._init = true;
				obj.Init(Scripting);
			end
			
			loadList[src.Name] = obj;
		end
		for _, obj in pairs(loadList) do
			obj.Load(Scripting, globalMeta);
			
			if not Scripting.ZScrLangInit then
				Scripting.ZScrLangInit = true;

				for k, _ in pairs(globalMeta) do
					if modZScriptLang.builtin[k] ~= nil then 
						modZScriptLang.builtin[k] = true;
						continue 
					end;
					modZScriptLang.zscript[k] = true;
				end

				modZScriptLang.builtin["script"] = true;
			end
		end
		table.clear(loadList);

		globalMeta.__index = globalMeta;
		globalMeta.__metatable = "The metatable is locked";

		Scripting.GlobalZEnv = globalMeta;
	end
end

function Scripting.Clean()
	for id, userdata in pairs(Scripting.ProxyInstances) do
		if typeof(userdata) == "Instance" then
			Debugger:StudioWarn("Unexpected instance", userdata:GetFullName())
			continue;
		end
		if userdata.Destroy then
			userdata:Destroy();
		end
	end
	table.clear(Scripting.ProxyInstances);
end

function Scripting.HandleError(zEnv, s, e)
	local errMsg = e;
	local scriptName = zEnv.script and zEnv.script.Name;
	if errMsg ~= nil then
		errMsg = errMsg:gsub("$ScriptName", `{scriptName}.zs`);
		errMsg = errMsg:gsub(" ReplicatedStorage.Plugin.ZScript.Loadstring.Fiu:%d+:", "");
	end
	
	if s and e then
		error(`Compile Error: {errMsg}`, 0);
		
	elseif not s and e then
		error(`Runtime Error: {errMsg}`, 0);
		
	end
end

function Scripting.LoadLib(zConfig, zScr, zEnv)
	local zEnvMeta = {};
	zEnvMeta.__index = zEnvMeta;
	zEnvMeta.__metatable = "The metatable is locked";

	setmetatable(zEnvMeta, Scripting.GlobalZEnv);
	setmetatable(zEnv, zEnvMeta);

	zEnvMeta.log = function(...)
		local logPrefix = `{zEnv.script.Name}.zs>>  `;
		Scripting.GlobalZEnv.log(logPrefix, ...);
	end
	zEnvMeta.print = function(...)
		local logPrefix = `{zEnv.script.Name}.zs>>  `;
		Scripting.GlobalZEnv.print(logPrefix, ...);
	end
	zEnvMeta.getfenv = function()
		return zEnv;
	end

	local scriptMeta = {};
	scriptMeta.__index = scriptMeta;
	scriptMeta.__metatable = "The metatable is locked";
	
	local Script = {};
	setmetatable(Script, scriptMeta);
	scriptMeta.hint = "The source container of this ZScript.";

	scriptMeta.hintName = "Name of the script.";
	Script.Name = zConfig.ScriptName;

	scriptMeta.hintGetFullName = "Get the full name of the script.";
	function Script:GetFullName()
		return `{zConfig.ScriptFullName}.zs`;
	end

	zEnvMeta.script = Script;
	zEnvMeta.shared = Scripting.shared;

	return zEnvMeta;
end

function Scripting.Run(zConfig)
	local zEnv = {};
	
	local scriptName = zConfig.Name;
	local zEnvMeta = Scripting.LoadLib({
		ScriptName = scriptName; 
		ScriptFullName = scriptName;
	}, Scripting, zEnv);
	
	local loadFunction, loadFailReason;

	local s, e = pcall(function()
		zConfig.Thread = coroutine.running();
		if zConfig.BindSetupEnv then
			zConfig.BindSetupEnv(Scripting, zEnv, zEnvMeta);
		end

		loadFunction, loadFailReason = modLoadstring(zConfig.Source, zEnv);
		if loadFunction then
			loadFunction();
		end
	end)
	
	Scripting.HandleError(zEnv, s, loadFailReason or e);
end

function Scripting.createZScript(name)
	local new = Instance.new("Configuration");
	new.Name = name;
	new:AddTag("ZScript");
	return new;
end

function Scripting.LoadZScriptConfig(config: Configuration)
	if config == nil or not config:IsA("Configuration") and not config:HasTag("ZScript") then return end;
	if not workspace:IsAncestorOf(config) then return end;

	local source = config:GetAttribute("_zs");
	if source == nil then return end;

	local zEnv = {};
	
	local scriptName = config.Name;
	Scripting.LoadLib({
		ScriptName = scriptName; 
		ScriptFullName = config:GetFullName();
	}, Scripting, zEnv);

	local loadFunction, loadFailReason;
	local s, e = pcall(function()
		loadFunction, loadFailReason = modLoadstring(source, zEnv);
		if loadFunction then
			local tup = {loadFunction()};
			local scope = getfenv(loadFunction);
		end
	end)
	
	-- if s then
	-- Scripting.ThreadList[config] = {
	-- 	Coroutine = coroutine.running();

	-- };
	-- end

	Scripting.HandleError(zEnv, s, loadFailReason or e);
end


function Scripting.onRequire()
	Scripting.initLib();

	local function load(config: Configuration)
		if config == nil or not config:IsA("Configuration") and not config:HasTag("ZScript") then return end;

		config:GetPropertyChangedSignal("Parent"):Connect(function() 
			if not workspace:IsAncestorOf(config) then return end;
			Scripting.LoadZScriptConfig(config);
		end)

		Scripting.LoadZScriptConfig(config);
	end
	for _, config in pairs(CollectionService:GetTagged("ZScript")) do
		task.spawn(load, config);
	end
	CollectionService:GetInstanceAddedSignal("ZScript"):Connect(load);

	shared.modCommandsLibrary.bind{
		["zscript"]={
			Permission = shared.modCommandsLibrary.PermissionLevel.DevBranch;
			Description = [[ZScript commands.
			
			/zscript runscript [scriptName]
			/zscript scripts [search]
			/zscript run [luau]
			]];

			RequiredArgs = 0;
			UsageInfo = "/zscript [action]";
			Function = function(speaker, args)
				local action = args[1];
				
				if action == "runscript" then
					local scriptName = args[2];

					local srcStringValue = zscriptsFolder:FindFirstChild(scriptName);
					if srcStringValue == nil then
						shared.Notify(speaker, `Script {scriptName} does not exist.`, "Negative");
						return;
					end

					local scriptSource = srcStringValue.Value;

					local scrConfig = Scripting.createZScript(scriptName);
					scrConfig:SetAttribute("_zs", scriptSource);
					scrConfig.Parent = workspace;

					shared.Notify(speaker, `Script {scriptName} loaded.`, "Inform");

				elseif action == "scripts" then
					local scripts = {};

					local searchStr = args[2];

					for _, script in pairs(zscriptsFolder:GetChildren()) do
						if searchStr and string.match(script.Name, searchStr) == nil then
							continue;
						end
						table.insert(scripts, script.Name);
					end

					shared.Notify(speaker, `Available scripts: \n{table.concat(scripts, "\n")}`, "Inform");

				elseif action == "run" then
					local statements = args[2];
					if statements == nil then
						shared.Notify(speaker, "No statements provided.", "Negative");
						return;
					end

					Scripting.Run({
						Name = "cmd";
						Source = statements;
					})
				end
			end
		};
	};
end
return Scripting;