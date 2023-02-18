local T, C, L = Tukui:unpack()
local Colors = T.Colors

----------------------------------------------------------------
-- Colors
----------------------------------------------------------------
local borderr, borderg, borderb = unpack(C.General.BorderColor)

Colors.assets = {
    ["Highlight"] = {
        ["target"] = { 0.65, 0.65, 0.65, 1 },
        ["focus"] = { 0.32, 0.65, 0.32, 1},
        ["none"] = { borderr, borderg, borderb, 1 }
    },
    ["CastBar"] = {
        ["Interruptible"] = { 0.31, 0.45, 0.63, 0.5 },
        ["notInterruptible"] = { 0.87, 0.37, 0.37, 0.75 }
    }
}

Colors.power["STAGGER"] = {
    [1] = { 0.33, 0.69, 0.33 },    -- green
    [2] = { 0.85, 0.77, 0.36 },    -- yellow
    [3] = { 0.69, 0.31, 0.31 }     -- red
}
