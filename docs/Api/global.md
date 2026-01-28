---
layout: default
title: Globals
nav_order: 1
---

These are global values that exists in the **ZScript** environment. 

---

## ZScript globals

### Class & Methods

| Type | Key |
| --- | --- |
| string | ScriptName |
| | |
| table | [Audio](Class/Audio.md) |
| table | [TweenService](Class/TweenService.md)
| table | [Instance](Instance.md) |
| | |
| function | [help](#help) |
| function | [log](#log) |
| function | [new](#new) |
| function | [notify](#notify) |

### Classes

---

### Methods

<a name="help"></a>
`nil` **help**(path: *string*)
- Outputs help hints and descriptions.
- Any tables within ZScript can be explored into with `help`.

Examples:

```lua
help("Audio.Play"); -- Shows you how to use Audio.Play.

help("Instance.Classes"); -- Shows you all available classes

help("Instance.List"); -- Shows you how to use Instance.List.
```

---

<a name="log"></a>
`nil` **log**(...)
- Basically print, but properly formats value.

---

<a name="new"></a>
`Instance` **new**(className: *string*)
- Instantiates a new instance of `ClassName`.

Examples:
- Spawns a new sound with volume set to 1 and assign a `SoundId`.

```lua
local sound = new("Sound"){
	Volume = 1;
	SoundId = "rbxassetid://3430334696"; -- "Collectible"
};

task.wait(3);

sound:Play();
```


<a name="notify"></a>
`nil` **notify**(*player: [Player](Player) | players: {[Player](Player)}*, message: *string*, notifyType: *string*)
- Sends a message into the player's notification (Chat or Toast).

**Notify Types**: *string*
- "Inform"
- "Positive"
- "Negative"
- "Important"

---

## Globals

### Lua

| Type | Key |
| --- | --- |
| function | getfenv |
| function | ipairs |
| table | math |
| function | next |
| function | pairs |
| function | pcall |
| function | print |
| table | string |
| function | select |
| table | table |
| table | task |
| function | tick |
| function | tonumber |
| function | tostring |
| function | typeof |
| function | unpack |

### Roblox

| Type | Key |
| --- | --- |
| Enums | Enum |
| table | CFrame |
| table | Random |
| table | Vector2 |
| table | Vector3 |
