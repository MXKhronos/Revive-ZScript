local Debugger = require(game.ReplicatedStorage.Library.Debugger).new(script);
--
local RunService = game:GetService("RunService");
local modEventService = shared.require(game.ReplicatedStorage.Library.EventService);

--
local ZScript = {};

function ZScript.Load(zScr, zEnv)
	local EventService, EventServiceMeta = zScr.newLib();

	EventServiceMeta.hint = "Invoking, listening and handling game events.";
	

	--==
	function EventService:Invoke(key: GAME_EVENT_KEY<string>, players: {Player}?, ...)
		local sbPlayers = zScr.UnSandbox(players);
		if RunService:IsServer() then
			return zScr.Sandbox(modEventService:ServerInvoke(key, {ReplicateTo=sbPlayers}, ...));
		end
	
		if sbPlayers == nil or sbPlayers ~= game.Players.LocalPlayer then
			sbPlayers = game.Players.LocalPlayer;
		end

		if typeof(sbPlayers) == "Instance" and sbPlayers:IsA("Player") then
			return zScr.Sandbox(modEventService:ClientInvoke(key, {SendBy=sbPlayers}, ...));
		else
			error("Arguments players can only be type (Player)?.");
		end
	end
	EventServiceMeta.hintInvoke = "Invokes event listeners.";
	EventServiceMeta.descInvoke = [[
	<b>EventService:Invoke</b>(key: <i>string</i>, invoker: <i>(Player | {Player})?</i>, ...): <i>EventPacket</i>

	@param <b>players</b>:
		[Server]: Can be nil or {Player}, if {Player} then invoke will be replicated to players with permission to listen to event.
		[Client]: Will always be replaced with LocalPlayer.

	<b>EventPacket<b>: {
        Cancelled: boolean;
        Completed: boolean;

		Player: Player?;
        Players: {[number]: Player}?;
	}
	]];


	--==
	function EventService:OnInvoked(key: GAME_EVENT_KEY<string>, func: (event: EventPacket, ...any) -> nil, position: number?): () -> nil
		local function sandboxedFunc(event, ...)
			return func(event, unpack(zScr.Sandbox({...}) or {}));
		end
		local signal = zScr.getOrNewInstance("ScriptSignal", modEventService:OnInvoked(key, sandboxedFunc, position));
		signal.Name = `{key}#{signal.Id}`;
		return signal;
	end
	EventServiceMeta.hintOnInvoked = "Connects a event listener.";
	EventServiceMeta.descOnInvoked = [[
	<b>EventService:OnInvoked</b>(key: <i>string</i>, func: (event: EventPacket, ...any) -> nil, position: <i>number?</i>): <i>ScriptSignal</i>
	]];


	--==
	function EventService:ListHandlers(pattern: string?, search: boolean?)
		local r = {};
		
		local keys = modEventService:GetHandlerKeys();
		for a=1, #keys do
			local key = keys[a];

			local add = false;
			if pattern == nil then
				add = true;
			elseif search == true and string.match(key, pattern) then
				add = true;
			elseif string.lower(key) == string.lower(pattern) then
				add = true;
			end
			
			if add then
				table.insert(r, key);
			end
		end

		table.sort(keys);
		return r;
	end
	EventServiceMeta.hintListHandlers = "List all registered event handler keys.";
	EventServiceMeta.descListHandlers = [[Get a list of instances by name or matching name patterns.
	if search is false, pattern is be used to match instances name. 
	if search is true, pattern will be used in string.match to match instance names.
	<b>EventService:ListHandlers</b>(pattern: <i>string?</i>, search: boolean?): <i>{[number]: key}</i>
	]];
	

	--==
	zEnv.EventService = EventService;
end

return ZScript;