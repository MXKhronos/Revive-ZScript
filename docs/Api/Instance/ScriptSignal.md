---
layout: default
title: ScriptSignal
parent: Instance
nav_order: 19
---

**Inherits:** [Instance](../Instance.md)
### Description
A Signal is an instance that is created when a function is connected to a signal. When destroyed, the function is disconnected. 

### Properties

| Type | Key | Default Value |  
| --- | --- | --- |  
| string | ClassName | ScriptSignal |
| string | Name | ScriptSignal |

### Methods

| Return Type | Name |
| --- | --- |
| nil | [Destroy](#destroy) () |

---

### Property Descriptions

---

### Method Descriptions

<a name="destroy"></a>
`nil` **Destroy**()
- Destroy the Signal and disconnect the function from the listener.

---
