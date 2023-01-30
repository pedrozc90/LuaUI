local T, C, L = Tukui:unpack()
local Colors = T.Colors

----------------------------------------------------------------
-- Colors
----------------------------------------------------------------
local borderr, borderg, borderb = unpack(C.General.BorderColor)

Colors.assets = {
    ["Highlight"] = {
        ["target"] = { .65, .65, .65, 1 },
        ["focus"] = { .32, .65, .32, 1},
        ["none"] = { borderr, borderg, borderb, 1 }
    },
    ["CastBar"] = {
        ["Interruptible"] = { .31, .45, .63, 0.5 },
        ["notInterruptible"] = { .87, .37, .37, 0.75 }
    }
}

Colors.power["STAGGER"] = {
    [1] = { .33, .69, .33 },    -- green
    [2] = { .85, .77, .36 },    -- yellow
    [3] = { .69, .31, .31 },    -- red
}
