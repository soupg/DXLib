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

dxl.GetDistance(v1, v2) --// Gets the distance between 2 objects. Returns a rounded number of studs.

dxl.JsonToTable(json) --// Input a json (stored as string) and it will return a lua table.
```
