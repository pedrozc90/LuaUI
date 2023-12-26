local addon, ns = ...
local oUF = ns.oUF or _G.oUF
-- assert(oUF, string.format("%s was unable to locate oUF install.", addon))

local T, C, L = Tukui:unpack()
local Colors = T.Colors

----------------------------------------------------------------
-- Colors
----------------------------------------------------------------
local colorMixin = {
    SetRGBA = function(self, r, g, b, a)
        if(r > 1 or g > 1 or b > 1) then
            r, g, b = r / 255, g / 255, b / 255
        end

        self.r = r
        self[1] = r
        self.g = g
        self[2] = g
        self.b = b
        self[3] = b
        self.a = a

        -- pre-generate the hex color, there's no point to this being generated on the fly
        self.hex = string.format('ff%02x%02x%02x', self:GetRGBAsBytes())
    end,
    SetAtlas = function(self, atlas)
        self.atlas = atlas
    end,
    GetAtlas = function(self)
        return self.atlas
    end,
    GenerateHexColor = function(self)
        return self.hex
    end
}

--[[ Colors: Tukui:CreateColor(r, g, b[, a])
Wrapper for [SharedXML\Color.lua's ColorMixin](https://wowpedia.fandom.com/wiki/ColorMixin), extended to support indexed colors used in Tukui, as
well as extra methods for dealing with atlases.

The rgb values can be either normalized (0-1) or bytes (0-255).

* self - the global Tukui object
* r    - value used as represent the red color (number)
* g    - value used to represent the green color (number)
* b    - value used to represent the blue color (number)
* a    - value used to represent the opacity (number, optional)

## Returns

* color - the ColorMixin-based object
--]]
function Tukui:CreateColor(r, g, b, a)
    local color = Mixin({}, ColorMixin, colorMixin)
    color:SetRGBA(r, g, b, a)
    return color
end

local borderr, borderg, borderb = unpack(C.General.BorderColor)

Colors.assets = {
    ["Highlight"] = {
        ["target"] = Tukui:CreateColor(0.65, 0.65, 0.65, 1),
        ["focus"] = Tukui:CreateColor(0.32, 0.65, 0.32, 1),
        ["none"] = Tukui:CreateColor(borderr, borderg, borderb, 1)
    },
    ["CastBar"] = {
        ["Interruptible"] = Tukui:CreateColor(0.31, 0.45, 0.63, 0.5),
        ["notInterruptible"] = Tukui:CreateColor(0.87, 0.37, 0.37, 0.75)
    }
}

Colors.power["STAGGER"] = {
    [1] = Tukui:CreateColor(0.33, 0.69, 0.33),  -- green
    [2] = Tukui:CreateColor(0.85, 0.77, 0.36),  -- yellow
    [3] = Tukui:CreateColor(0.69, 0.31, 0.31)   -- red
}
