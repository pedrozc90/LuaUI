local T, C, L = Tukui:unpack()
local Experience = T.Miscellaneous.Experience
local Minimap = T.Maps.Minimap

----------------------------------------------------------------
-- Experience / Honor Bar
----------------------------------------------------------------
local function Enable(self)
    -- resources
    local Texture = T.GetTexture(C.Lua.Texture)

    -- elements
    local ExpBar = self.XPBar1
    local HonorBar = self.XPBar2
    local ExpRestedBar = self.RestedBar1
    local HonorRestedBar = self.RestedBar2

    -- Experience
    ExpBar:ClearAllPoints()
    ExpBar:SetStatusBarTexture(Texture)
    ExpBar:Height(3)
    ExpBar:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -7)
    ExpBar:Point("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)

    ExpRestedBar:SetAllPoints(ExpBar)
    ExpRestedBar:SetStatusBarTexture(Texture)

    -- Honor
    HonorBar:ClearAllPoints()
    HonorBar:SetStatusBarTexture(Texture)
    HonorBar:Height(3)
    if (ExpBar:IsShown()) then
        HonorBar:Point("TOPLEFT", ExpBar, "BOTTOMLEFT", 0, -7)
        HonorBar:Point("TOPRIGHT", ExpBar, "BOTTOMRIGHT", 0, -7)
    else
        HonorBar:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -7)
        HonorBar:Point("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)
    end

    HonorRestedBar:SetAllPoints(HonorBar)
    HonorRestedBar:SetStatusBarTexture(Texture)
end
hooksecurefunc(Experience, "Enable", Enable)
