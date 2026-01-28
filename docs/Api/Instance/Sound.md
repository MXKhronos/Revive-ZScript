---
layout: default
title: Sound
parent: Instance
nav_order: 19
---

**Inherits:** [Instance](../Instance.md)
### Description
A sandboxed version of [Sound](https://create.roblox.com/docs/reference/engine/classes/Sound).

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |  
| string | ClassName | Sound |  
| string | Name | Sound |  
| number | PlaybackSpeed | 1 |
| string | SoundId | nil |
| number | Volume | 0.5 |

### Methods

| Return Type | Name |
| --- | --- |
| nil | [Play](#play) () |
| nil | [Stop](#stop) () |
| nil | [Destroy](#destroy) () |

---

### Property Descriptions

`number` **PlaybackSpeed** *= 1*
- `PlaybackSpeed` defaults to 1 for new instances but if you use [Audio:Play](Audio#play), the default value may vary.

---

`string` **SoundId** *= ""*
- Changing SoundId will stop the sound.

Example:

```lua
local sound = Audio:Play("Boombox:Stepping Up");
task.wait(3);
sound.SoundId = "rbxassetid://1836846557"; -- "Boombox:Get Up On Your Feet"
sound:Play();
```

Changes the playing sound to *"Boombox:Get Up On Your Feet"* after 3 seconds.

---

`number` **Volume** *= 0.5*
- `Volume` defaults to 0.5 for new instances but if you use `Audio:Play()`, the default value may vary.

---

### Method Descriptions
<a name="play"></a>
`nil` **Play**()
- Plays the sound

---

<a name="stop"></a>
`nil` **Stop**()
- Stops the sound

---

<a name="destroy"></a>
`nil` **Destroy**()
- Destroy the instance.

---