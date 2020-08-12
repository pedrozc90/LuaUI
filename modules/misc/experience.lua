local T, C, L = Tukui:unpack()
local Experience = T.Miscellaneous.Experience
local Minimap = T.Maps.Minimap
local Panels = T.Panels

----------------------------------------------------------------
-- Experience / Honor Bar
----------------------------------------------------------------
local baseCreate = Experience.Create

function Experience:Create()

    -- first, call the base function
    baseCreate(self)

    -- second, we edit it
    local ExpBar = self.XPBar1
    local HonorBar = self.XPBar2
    local ExpRestedBar = self.RestedBar1
    local HonorRestedBar = self.RestedBar2

    -- resources
    local Height = 3
    local Texture = T.GetTexture(C.Lua.Texture or "Blank")

    -- Experience
    ExpBar:ClearAllPoints()
    ExpBar:SetStatusBarTexture(Texture)
    ExpBar:Point("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -7)
    ExpBar:Point("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -7)
    ExpBar:Height(Height)
    ExpBar.Backdrop:SetTripleBorder()
    ExpBar.Backdrop:SetOutside(nil, 2, 2)

    ExpRestedBar:SetAllPoints(ExpBar)
    ExpRestedBar:SetStatusBarTexture(Texture)

    -- Honor
    HonorBar:ClearAllPoints()
    HonorBar:SetStatusBarTexture(Texture)
    HonorBar:Height(Height)
    HonorBar.Backdrop:SetTripleBorder()
    HonorBar.Backdrop:SetOutside(nil, 2, 2)
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
