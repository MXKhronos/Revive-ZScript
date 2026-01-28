
local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local PlayerService, PlayerServiceMeta = zScr.newLib();
	
    local PlayerList = {};
    PlayerServiceMeta.Players = PlayerList;

    
    --==
    PlayerService.GetPlayerByName = function(name: string)
        for a=1, #PlayerList do
            if PlayerList[a].Name == name then
                return PlayerList[a];
            end
        end
        return nil;
    end
	PlayerServiceMeta.hintGetPlayerByName = "Get a player by name.";
    PlayerServiceMeta.descGetPlayerByName = [[Get a player by name.
		<b>GetPlayerByName</b>(name: <i>string</i>): <i>Player?</i>
	]];


    --==
    PlayerService.GetPlayerByUserId = function(userId: number)
        for a=1, #PlayerList do
            if PlayerList[a].UserId == userId then
                return PlayerList[a];
            end
        end
        return nil;
    end
    PlayerServiceMeta.hintGetPlayerByUserId = "Get a player by user id.";
    PlayerServiceMeta.descGetPlayerByUserId = [[Get a player by user id.
		<b>GetPlayerByUserId</b>(userId: <i>number</i>): <i>Player?</i>
	]];


    --==
    PlayerService.GetPlayers = function()
        local r = {};
        for a=1, #PlayerList do
            table.insert(r, PlayerList[a]);
        end
        return r;
    end
	PlayerServiceMeta.hintGetPlayers = "Get all online players.";
	PlayerServiceMeta.descGetPlayers = [[Get a list of all online players.
		<b>GetPlayers</b>(): <i>{Player}</i>
	]];

    
    --==
    PlayerServiceMeta.OnPlayerConnected = zScr.getOrNewInstance("ScriptSignal", nil, "OnPlayerConnected");

	PlayerServiceMeta.hintOnPlayerConnected = "Fires when a player is connected.";
	PlayerServiceMeta.descOnPlayerConnected = [[A ScriptSignal that fires when a player is connected.
		<b>OnPlayerConnected</b>(player: <i>Player</i>)
	]];


    --==
    PlayerServiceMeta.OnPlayerDisconnected = zScr.getOrNewInstance("ScriptSignal", nil, "OnPlayerDisconnected");

	PlayerServiceMeta.hintOnPlayerDisconnected = "Fires when a player is disconnected.";
	PlayerServiceMeta.descOnPlayerDisconnected = [[A ScriptSignal that fires when a player is disconnected.
		<b>OnPlayerDisconnected</b>(player: <i>Player</i>)
	]];
        
    shared.modEngineCore:ConnectOnPlayerAdded(script, function(playerInstance)
        local exist = false;
        for a=1, #PlayerServiceMeta.Players do
            if PlayerServiceMeta.Players[a].UserId == playerInstance.UserId then
                exist = true;
                break;
            end
        end
        if exist then return end;

        local sndPlayer = zScr.Sandbox(playerInstance);
        PlayerService.OnPlayerConnected:Fire(sndPlayer);

        table.insert(PlayerServiceMeta.Players, sndPlayer);
    end, 9);

    shared.modEngineCore:ConnectOnPlayerRemoved(script, function(playerInstance)
        local sndPlayer = zScr.Sandbox(playerInstance);
        PlayerService.OnPlayerDisconnected:Fire(sndPlayer);

        for a=#PlayerList, 1, -1 do
            if PlayerList[a].UserId == playerInstance.UserId then
                table.remove(PlayerList, a);
            end
        end
    end)

	zEnv.PlayerService = PlayerService;
end

return ZScript;