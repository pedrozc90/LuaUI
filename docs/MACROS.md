# To-Do List:

```lua
/run print(GetCVar("gxMaximize"))                       -- return windowed mode status (1 = fullscreen, 0 = windowed)
/run print(GetCVar("gxFullscreenResolution"))           -- return full screen resolution.
/run print(GetCVar("gxNewResolution"))                  -- set a new resolution (for fullscreen)

/run print(GetCVar("gxWindowedResolution"))             -- return windowed resolution
/run SetCVar("gxWindowedResolution", "3840x1440")
```

```lua
-- macro (change windowed mode)
/run local m = "gxMaximize" SetCVar(m, 1 - GetCVar(m)) RestartGx()

/run RestartGx() -- reset screen

/run SetCVar("gxWindowedResolution", "3820x1800") RestartGx()

/run SetCVar("gxMaximize", 0) SetCVar("gxWindowedResolution", "3820x1800") RestartGx()

```