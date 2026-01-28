local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local TS = game:GetService("TweenService");
--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local TweenService, TweenServiceMeta = zScr.newLib();
	
	function TweenService:GetValue(alpha, easingStyle, easingDirection)
		return TS:GetValue(alpha, easingStyle, easingDirection);
	end
	
	zEnv.TweenService = TweenService;
end

return ZScript;