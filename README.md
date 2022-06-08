# What is DXLib?
DXLib is an addon library for dx9ware that adds useful features that dx9 by itself lacks. DXLib works by either hooking old dx9 functions and improving them, or by simply making new functions which have the `dxl.` suffix.

### DXLib Features
- A better console which logs dx9, dxl, and vanilla lua errors.
- A replaced `dx9.Get` and `loadstring` function for better optimization and way less lag.
- Makes a lot of old dx9 functions overall better, as well as adds error logging with `dxl.ShowConsole()`


### DXLib Loadstring

Paste this at the top of your code to start using the functions listed below!

```lua
loadstring(dx9.Get("https://raw.githubusercontent.com/soupg/DXLib/main/main.lua"))()
```

---

# Current Functions

### Console Functions

```lua
dxl.ShowConsole() --// Displays DXLib's custom console. This console logs dx9 and dxl's errors as well as support print statements.

dxl.print(v) --// Prints value in console.

dxl.error(v) --// Prints value in console (in red text).
```

![dxLib Console](https://i.imgur.com/Famta4n.png)

### General Functions

```lua
dxl.isMouseInArea({x1, y1, x2, y2}) --// Returns true of mouse is in the area specified.

dxl.GetDistance({x1, y1, z1}, {x2, y2, z2}) --// Gets the distance between 2 objects. Returns a rounded number of studs.

dxl.GetDistanceFromPlayer({x, y, z}) --// Gets distance of an object from Local Player.

dxl.GetClosestPart(model_instance) --// You can pass in a model or a player / npc that contains lots of parts, and this returns the closest part to you. Good for Aimbot.

dxl.GetDescendants(instance) --// Gets all descendants in the instance.

dxl.GetDescendantsOfClass(instance, class) --// Gets all descendants (of a class) in the instance. For example, if you made class var be a part, it only returns descendants that are parts.

dxl.JsonToTable(json_string) --// Input a json (stored as string) and it will return a lua table.

dxl.Game(path) --// Navigates within the game instance | Example: dxl.Game("Workspace", "PlayerFolder", "PlayerName")

dxl.GetLocalPlayerName() --// Returns LocalPlayer name

dxl.GetLocalPlayer() --// Gets LocalPlayer path

dxl.GetLocalPlayerGUI() --// Gets LocalPlayer GUI
```

### GUI Functions (graphic stuff)

```lua
dxl.HealthBar({Location = {x, y}, Size = {x, y}, HP = hp_number, MaxHP = max_hp_number, Offset = {0, 0}}) --// Make sure youre inputting everything that's shown. Only replace the lowercase placeholder vars!


```
