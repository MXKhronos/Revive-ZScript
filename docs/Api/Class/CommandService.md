---
layout: default
title: CommandService
parent: Class
nav_order: 3
---

### Description
A service to bind custom commands into the engine. Used in E.g. [Home Plugin Script]().

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |
| No available properties |

### Methods

| Return Type | Name |
| --- | --- |
| nil | [BindCommand](#bindcommand) (cmdName: *string*, options: *anydict*) |
| nil | [UnbindCommand](#unbindcommand) (cmdName: *string*) |

### Signals

---
### Property Descriptions

---
### Method Descriptions

<a name="bindcommand"></a>
`nil` **BindCommand**(cmdName: *string*, options: *anydict*)
- Binds a commands into the engine.

**options**: A dictionary of parameters.

| Key | Type | Value |
| --- | --- | --- |
| Permission | *string* \| *number* | All\|1 / ServerOwner\|2 / DevBranch\|3 |
| Description | *string* | "A description for this command." |
| UsageInfo | *string* | `/{cmdName} arg1 [optional_arg2]` |
| Function | *function* | (player: Player, args: {string}) -> nil |

<a name="unbindcommand"></a>
`nil` **UnbindCommand**()
- Unbinds a ZScript command from the engine.

---

### Example
This is a example to add a `/sethome` and `/home` command. Using:
- [BindCommand](#bindcommand)
- [Player](Player):[GetCFrame](Player#getcframe)()
- [Player](Player):[SetCFrame](Player#setcframe)()
- [notify](global#notify)()
- [PlayerService.OnPlayerDisconnected](PlayerService)


```luau
local PlayerHomes = {};

CommandService:BindCommand("sethome", {
    Permission = "DevBranch";
    Description = [[Sets your home position. e.g.
        /sethome farm
    ]];
    UsageInfo = "/sethome [homeName]";
    Function = function(player: Player, args)
        local homeName = args[1] and tostring(args[1]) or "default";

        local homesList = PlayerHomes[player];
        if homesList == nil then
            homesList = {};
            PlayerHomes[player] = homesList;
        end

        local newHome = {CFrame=player:GetCFrame();};
		local oldHome = homesList[homeName];
        homesList[homeName] = newHome;

		if oldHome == nil then
        	notify(player, `Set home {homeName} for {player.Name}`, "Inform");
		else
			notify(player, `Updated home {homeName} for {player.Name}`, "Inform");
		end
    end;
});

CommandService:BindCommand("home", {
    Permission = "DevBranch";
    Description = [[Teleport to your home position. e.g.
        /home farm
    ]];
    UsageInfo = "/home [homeName]";
    Function = function(player: Player, args)
        local homeName = args[1] and tostring(args[1]) or "default";

        local homesList = PlayerHomes[player];
        if homesList == nil then
            homesList = {};
            PlayerHomes[player] = homesList;
        end

        local getHome = homesList[homeName];
		if getHome == nil then
			notify(player, `Home {homeName} does not exist.`, "Error");
			return;
		end

		player:SetCFrame(getHome.CFrame);

        notify(player, `Set home {homeName} for {player.Name}`, "Inform");
    end;
});

PlayerService.OnPlayerDisconnected:Connect(function(player: Player)
	PlayerHomes[player] = nil;
end)
```