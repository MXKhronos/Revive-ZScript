local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local Template, TemplateMeta = zScr.newLib();
	
	TemplateMeta.hintFunc = "Hint of the function.";
	TemplateMeta.descFunc = [[Description of the function.
		<b>Template:Func</b>(soundName: <i>number?</i>): <i>boolean</i>
	]];
	
	function Template:Func(index: number?)
		return true;
	end	
	
	--zEnv.Template = Template;
end

return ZScript;