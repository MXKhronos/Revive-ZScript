local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local modRichFormatter = shared.require(game.ReplicatedStorage.Library.UI.RichFormatter);
local modZScriptLexer = shared.require(game.ReplicatedStorage.Plugin.ZScript.Lexer);

local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local function outputConsole(...)
		print(...);
		
		local toStringify = {};
		for _, v in pairs({...}) do
			table.insert(toStringify, tostring(v));
		end
		local str = table.concat(toStringify, " ");
		
		zScr.ConsoleOutput:Fire(`{modZScriptLexer.buildStr(str, true)}`);
	end

	local function outputConsoleNoFormat(...)
		local toStringify = {};
		for _, v in pairs({...}) do
			table.insert(toStringify, tostring(v));
		end
		local str = table.concat(toStringify, " ");
		
		zScr.ConsoleOutput:Fire(`{str}`);
	end

	zEnv.log = function(...)
		local str = Debugger:Stringify(...);
		outputConsole(str);
	end
	
	zEnv.print = function(...)
		outputConsole(...);
	end
	
	zEnv.help = function(hierachy)
		local function printTable(t)
			local str = "";
			local sorted = {};
			for key, v in pairs(t) do
				table.insert(sorted, key);
			end
			table.sort(sorted);
			
			for a=1, #sorted do
				local key = sorted[a];
				local v = t[key];
				
				local hintV;
				pcall(function()
					hintV = t["hint"..key];

					if hintV == nil then
						hintV = t[key].hint;
					end
				end)
				hintV = hintV or "Missing hint.";

				str = str..`\n   <b>{key}</b>: <i>{typeof(v)}</i>{hintV and modRichFormatter.ColorCommentText("    -- "..hintV) or ""}`;
			end
			
			table.clear(sorted);
			return str;
		end
		
		if hierachy then
			hierachy = tostring(hierachy);
			
			local keys = string.split(hierachy,".");
			local currDir = "";
			
			local currEnv = zEnv;
			
			for a=1, #keys do
				local dir = keys[a];
				currDir = currDir..dir..(a==#keys and "" or ".");
				
				if typeof(currEnv[dir]) ~= "table" then
					local descV;
					pcall(function()
						descV = currEnv["desc"..dir];

						if descV == nil then
							descV = currEnv[dir].desc;
						end
					end)
					descV = descV or "Missing description.";

					outputConsoleNoFormat("zs.help>>  ", "\nFunction:", currDir," \[\[\n   ",descV,"\n\]\]\n");
					
					return;
					
				elseif currEnv[dir] == nil then
					outputConsoleNoFormat("zs.help>>  ", "Unknown library (".. currDir ..").");
					return;
					
				else
					currEnv = currEnv[dir];
				end
			end
			
			outputConsoleNoFormat("zs.help>>  ", "\nLibrary:", currDir,"= {",printTable(currEnv),"\n}\n");

			return;
		end
		
		
		local helpStr = [[<b>Welcome to ZScript. Here you can write scripts with lua.</b>]];
		
		helpStr = helpStr.."\n\n<b>getfenv():</b> -- Available keys in this environment.";
		
		local envStr = printTable(zEnv);
		outputConsoleNoFormat("zs.help>>  ", "\n",helpStr..envStr,"\n\nUse the <b>help</b>(path: <i>string</i>) function to see more. E.g. help(\"Audio.Play\")\n");
	end

	zEnv.hintnotify = "Sends a notification to a player or players.";
	zEnv.descnotify = [[Sends a notification to a player or players.
		<b>notify</b>(player: <i>Player | {Player}</i>, message: <i>string</i>, notifyType: <i>string?</i>)
	]];
	zEnv.notify = function(player, message, type)
		local realPlayer = zScr.UnSandbox(player);
		if realPlayer == nil then return end;
		shared.Notify(realPlayer, message, type);
	end
end

return ZScript;