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

# Docs

For functions and additional info, please visit our [docs](https://supg.gitbook.io/dxlib/)
