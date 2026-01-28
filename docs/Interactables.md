---
layout: default
title: Interactables
has_children: true
nav_order: 9
---

### Interactables
ZScript will be usable by interactables to add unique functionalities that does not need to be tied to the engine source or even data model source. E.g. A unique door in the over world that requires a active mission at a specific progression point to be interactable.

ZScript can return a dictionary to the engine to be handled. E.g. This below binds a function into the player interaction, when a interactable is prompted, it sets the message to "Hello "..`playerName`.

```lua
local interactPackage = {};

function interactPackage.BindPrompt(interactable: Interactable)
	interactable.Label = `Hello {PlayerService.LocalPlayer.Name}`;
end

return interactPackage;
```