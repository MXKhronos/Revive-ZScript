---
layout: default
title: Player
parent: Instance
nav_order: 16
---

**Inherits:** [Instance](../Instance.md)
### Description
A sandboxed version of [Player](https://create.roblox.com/docs/reference/engine/classes/Player) and includes additional functions in Revive Engine's PlayerClass.

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |  
| string | ClassName | Signal |
| string | Name | Signal |
| number | UserId | 0 |

### Methods

| Return Type | Name |
| --- | --- |
| CFrame | [GetCFrame](#getcframe) () |
| nil | [SetCFrame](#setcframe) (cframe: CFrame) |

---

### Property Descriptions

`number` **UserId** *= 0*
- `UserId` is the player's UserId.

---


---

### Method Descriptions


<a name="getcframe"></a>
`cframe` **GetCFrame**()
- Get the current CFrame of player character.


<a name="setcframe"></a>
`nil` **SetCFrame**(cframe: CFrame)
- Set the current CFrame of player character.

---
