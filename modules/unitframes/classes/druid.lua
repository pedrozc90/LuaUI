local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Druid Class Resources
----------------------------------------------------------------
if (Class ~= "DRUID") then return end

local baseDruid = UnitFrames.AddClassFeatures["DRUID"]

UnitFrames.AddClassFeatures["DRUID"] = function(self)
    
    -- first, call the base function
    baseDruid(self)
    
    -- second, we edit it
    local DruidMana = self.DruidMana
    local Background = self.DruidMana.bg

    local FrameWidth, FrameHeight = unpack(C["Units"].Player or { 254, 31 })
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)

    DruidMana:ClearAllPoints()
    DruidMana:Point("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
    DruidMana:SetSize(FrameWidth, 7)
    DruidMana:SetFrameLevel(self.Health:GetFrameLevel())
    DruidMana:CreateBackdrop()
    DruidMana.Backdrop:SetTripleBorder()
    DruidMana.Backdrop:SetOutside(nil, 2, 2)
end
