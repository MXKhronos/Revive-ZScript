---
layout: default
title: Plugin
has_children: true
nav_order: 3
---

### Plugins
The first implementation of ZScript in the Revive Engine will be plugins for custom servers. Just like Minecraft/Rust server plugins, these will allow you to add custom functionalities.

#### Custom Commands
Using the [CommandService](CommandService), you can bind a commands onto the server. e.g. `/hello` prints "World!" into console.

```lua
CommandService:BindCommand("hello", {
	Permission = "All";
	Description = "Hello command.";
	Function = function(player: Player, args)
		-- Handles on command.
		print("World!");
	end;
})
```

#### Home Plugin
Here is an example that allow players to use `/sethome` set a home at a CFrame and `/home` to teleport back to that CFrame. 