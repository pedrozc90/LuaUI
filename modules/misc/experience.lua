local T, C, L = Tukui:unpack()
local Experience = T.Miscellaneous.Experience
local Minimap = T.Maps.Minimap

----------------------------------------------------------------
-- Experience / Honor Bar
----------------------------------------------------------------
local baseCreate = Experience.Create

function Experience:Create()
    -- first, we call the base function
    baseCreate(self)

    -- second, we edit it
    local Texture = T.GetTexture(C.Lua.Texture)
    local Height = 3
    local Spacing = 3

    local ExpBar = self.XPBar1
    local HonorBar = self.XPBar2
    local ExpRestedBar = self.RestedBar1
    local HonorRestedBar = self.RestedBar2

    -- Experience
    ExpBar:ClearAllPoints()
    ExpBar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -Spacing)
    ExpBar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -Spacing)
    ExpBar:SetHeight(Height)
    ExpBar:SetStatusBarTexture(Texture)
    
    ExpRestedBar:SetAllPoints(ExpBar)
    ExpRestedBar:SetStatusBarTexture(Texture)

    -- Honor
    HonorBar:ClearAllPoints()
    if (ExpBar:IsShown()) then
        HonorBar:SetPoint("TOPLEFT", ExpBar, "BOTTOMLEFT", 0, -Spacing)
        HonorBar:SetPoint("TOPRIGHT", ExpBar, "BOTTOMRIGHT", 0, -Spacing)
    else
        HonorBar:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -Spacing)
        HonorBar:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -Spacing)
    end
    HonorBar:SetStatusBarTexture(Texture)
    HonorBar:SetHeight(Height)

    HonorRestedBar:SetAllPoints(HonorBar)
    HonorRestedBar:SetStatusBarTexture(Texture)
end
