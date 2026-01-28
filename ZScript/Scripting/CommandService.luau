local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local modCommandsLibrary = shared.require(game.ReplicatedStorage.Library.CommandsLibrary);
local modCommandHandler = shared.require(game.ReplicatedStorage.Library.CommandHandler);

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local CommandService, CommandServicecMeta = zScr.newLib();

	local _customCommands = {};
	local freezeMeta = {
		__index = _customCommands;
		__newindex = function(t, k, v)
			error(`Attempt to modify locked table.`);
		end;
		__metatable = "The metatable is locked";
	}
	CommandService.CustomCommands = setmetatable({}, freezeMeta);


    --==
	function CommandService:BindCommand(cmdName, options)
		if modCommandsLibrary.Library[cmdName] then
			error(`Command /{cmdName} is already bound.`);
		end

		local cmdFunc = options.Function;
		if typeof(cmdFunc) == nil then
			error(`Command /{cmdName} options.Function needs a function to handle command.`);
		elseif typeof(cmdFunc) ~= "function" then
			error(`Command /{cmdName} options.Function is not a function.`);
		end
		local function sandboxedCmdFunc(speaker, args)
			return cmdFunc(zScr.Sandbox(speaker), args);
		end

		local cmdLib = {
			Permission = modCommandsLibrary.PermissionLevel.DevBranch;
			Description = "No description for this command.";
			UsageInfo = `/{cmdName}`;
			Function = sandboxedCmdFunc;
			ClientFunction = sandboxedCmdFunc;
		};
		if options.Permission then
			if options.Permission == 1 or options.Permission == "All" then
				cmdLib.Permission = modCommandsLibrary.PermissionLevel.All;
			elseif options.Permission == 2 or options.Permission == "ServerOwner" then
				cmdLib.Permission = modCommandsLibrary.PermissionLevel.ServerOwner;
			elseif options.Permission == 3 or options.Permission == "DevBranch" then
				cmdLib.Permission = modCommandsLibrary.PermissionLevel.DevBranch;
			else
				error(`Command /{cmdName} options.Permission is invalid.`);
			end
		end
		if options.Description then
			if typeof(options.Description) == "string" then
				cmdLib.Description = options.Description;
			else
				error(`Command /{cmdName} options.Description is not a string.`);
			end
		end
		if options.UsageInfo then
			if typeof(options.UsageInfo) == "string" then
				cmdLib.UsageInfo = options.UsageInfo;
			else
				error(`Command /{cmdName} options.UsageInfo is not a string.`);
			end
		end

		modCommandsLibrary:HookChatCommand(cmdName, cmdLib);
		_customCommands[cmdName] = options;
	end
	CommandServicecMeta.hintBindCommand = "Bind a command.";
	CommandServicecMeta.descBindCommand = [[Binds a command.
		<b>BindCommand</b>(cmd: <i>string</i>, options: <i>anydict</i>): <i>nil</i>
	]];


    --==
	function CommandService:UnbindCommand(cmdName)
		if not _customCommands[cmdName] then
			error(`Command /{cmdName} is not bound.`);
		end

		_customCommands[cmdName] = nil;
		modCommandsLibrary.Library[cmdName] = nil;
	end
	CommandServicecMeta.hintUnbindCommand = "Unbind a command.";
	CommandServicecMeta.descUnbindCommand = [[Unbinds a ZScript binded command.
		<b>UnbindCommand</b>(): <i>nil</i>
	]];
	
	zEnv.CommandService = CommandService;
end

return ZScript;