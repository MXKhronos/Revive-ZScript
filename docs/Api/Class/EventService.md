---
layout: default
title: EventService
parent: Class
nav_order: 5
---

### Description
EventService is a ZScript unique library for handling game events. From `OnClockTick` to `WeatherService.OnWeatherSet`, see [event key list](#eventkeys) for a list of event keys that exists.

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |
| No available properties |

### Methods

| Return Type | Name |
| --- | --- |
| [EventPacket](#eventpacket) | [Invoke](#invoke) (key: *string*, playerPacket: *(Player | {Player})?*, ...) |
| [Signal](../Instance/Signal.md) | [OnInvoked](#oninvoked) (key: *string*, func: *(event: EventPacket, ...any) -> nil*, position: *number?*) |
| {string} | [ListHandlers](#listhandlers) (pattern: *string?*, search: *boolean?*) |

### Property Descriptions
No available properties

---
### Method Descriptions

<a name="invoke"></a>
[`EventPacket`](#eventpacket) **Invoke**(key: *string*, playerPacket: *(Player | {Player})?*, ...)
- Invokes an event of `key`. To see list of active event handlers, use [`EventService:ListHandlers()`](#listhandlers).
- `@param` playerPacket:

	- [Server Invoke] `nil` is the same as an empty table.
	- [Server Invoke] `{Player}` a list of players that can event can invoke to.
	- [Client Invoke] playerPacket input doesn't matter, it always default to `LocalPlayer`.

---

<a name="oninvoked"></a>
`Signal` **OnInvoked**(key: *string*, func: *(event: [EventPacket](#eventpacket), ...any) -> nil*, position: *number?*)
- Connects a `function` to handle when a event of `key` is invoked.
- Returns a [`Signal`](../Instance/Signal.md), which disconnects when the instance is destroyed.

Examples:

```lua
-- Listening to `OnClockTick` event.
local disFunc = EventService:OnInvoked("OnClockTick", function(event: EventPacket, ...)
    local osTime = ... -- Based on event key arguments. Check event key list.

    print("Current time", osTime); -- Prints os timestamp every second when the clock ticks.
end)

task.wait(5);
disFunc(); -- Disconnect event listener after 5 seconds.
```

---

<a name="listhandlers"></a>
`{[number]: string}` **ListHandlers**(pattern: *string?*, search: *boolean?*)
- Returns a sorted list of event handler keys.
- `pattern ~= nil`
	- Then it will return every available instance.
- `pattern ~= nil and search ~= true` 
	- Then it will search for instances with names exactly matches the `pattern`.
- `pattern ~= nil and search == true`
	- Then it will `string.match` instances with names matching the pattern.

---
<br>

## Event Packet
<a name="eventpacket"></a>

### Description
Event packets are objects that allow you to cancel events.

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |
| boolean | [Cancelled](#cancelled) | false |
| boolean | [Completed](#completed) | false |
| Player? | [Player](#player) | nil |
| {Player}? | [Players](#players) | nil |


### Methods

| Return Type | Name |
| --- | --- |
| nil | [SetCancelled](#setcancelled) (value: *boolean*) |

---
<br>

### Property Descriptions

<a name="cancelled"></a>
`boolean` **Cancelled** *= false*
- Status of the event, when cancelled, every other proceeding event handlers will not be invoked.
- Use [`EventPacket:SetCancelled(...)`](#setcancelled) to set this value.

<a name="completed"></a>
`boolean` **Completed** *= false*
- When completed, canceling events will have no effect.

<a name="player"></a>
`Player?` **Player** *= nil*
- Returns the first player in `EventPacket.Players` or `nil`.

<a name="players"></a>
`{Player}?` **Players** *= nil*
- Returns the list of players. Server will replicate the event to the list of players in this list. If a player is removed, they will not receive the event signal. 
- Has no replication effect on client side. 

---
<br>

### Method Descriptions

<a name="setcancelled"></a>
`nil` **SetCancelled**(value: *boolean*)
- Cancels an event. E.g. If `WeatherService.OnWeatherSet` is cancelled, the weather will not be set by `WeatherService`.

---
<br>

## Event Key List
<a name="eventkeys"></a>

| Keys | Arguments | Data Type |
| --- | --- | --- |
| `OnClockTick` | serverTime | `number` |
| `WeatherService.OnWeatherSet` | WeatherPacket | `{any}` |

---