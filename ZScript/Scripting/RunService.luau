local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local RS = game:GetService("RunService");

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local RunService, RunServiceMeta = zScr.newLib();
	
	
	--==
	function RunService:IsServer()
		return RS:IsServer();
	end	
	RunServiceMeta.hintIsServer = "Is statement running on server.";
	RunServiceMeta.descIsServer = [[Is statement running on server.
		<b>RunService:IsServer</b>(): <i>boolean</i>
	]];


	--==
	function RunService:IsClient()
		return RS:IsClient();
	end
	RunServiceMeta.hintIsClient = "Is statement running on server.";
	RunServiceMeta.descIsClient = [[Is statement running on server.
		<b>RunService:IsClient</b>(): <i>boolean</i>
	]];

	zEnv.RunService = RunService;
end

return ZScript;