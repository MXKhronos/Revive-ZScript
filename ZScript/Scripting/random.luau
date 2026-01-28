local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local ZScript = {};

function ZScript.Load(zSS, zEnv)
	zEnv.Random = Random;
end

return ZScript;