---
layout: default
title: PlayerService
parent: Class
nav_order: 16
---

### Description
PlayerService is a way you can get [Player](Player)(s) in game or connect to Player related signals.

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |
| Player | LocalPlayer | Player |

### Methods

| Return Type | Name |
| --- | --- |
| {[Player](Player)} | [GetPlayers](#getplayers) () |
| [Player](Player)? | [GetPlayerByName](#getplayerbyname) (playerName: *string*) |
| [Player](Player)? | [GetPlayerByUserId](#getplayerbyuserid) (userId: *number*) |

### Signals

**OnPlayerConnected**(player: Player)
Fires when a player is connected. 


**OnPlayerDisconnected**(player: Player)
Fires when a player is disconnected.


---
### Property Descriptions

`Player` **LocalPlayer** *= Player*
- This the same as `game.Players.LocalPlayer`. Only returns player on client side.

---
### Method Descriptions

<a name="getplayers"></a>
`{Player}` **GetPlayers**()
- Get an array of all in-game players.

<a name="getplayerbyname"></a>
`Player?` **GetPlayerByName**(playerName: *string*)
- Find player by user name.

<a name="getplayerbyuserid"></a>
`Player?` **GetPlayerByUserId**(userId: *number*)
- Find player by user id.

---