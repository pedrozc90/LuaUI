local T, C, L = Tukui:unpack()
local Reputation = T.Miscellaneous.Reputation
local Experience = T.Miscellaneous.Experience
local Minimap = T.Maps.Minimap

----------------------------------------------------------------
-- Reputation Bar
----------------------------------------------------------------
local baseCreate = Reputation.Create

function Reputation:Create()

    -- first, call the base function
    baseCreate(self)

    -- second, we edit it
    local ExpBar = Experience.XPBar1
    local HonorBar = Experience.XPBar2
    
    -- texture
    local Texture = T.GetTexture(C.Lua.Texture or "Blank")

    for i = 1, self.NumBars do
        local RepBar = self["RepBar" .. i]
        
        RepBar:ClearAllPoints()
        RepBar:SetStatusBarTexture(Texture)
        RepBar:Height(i == 1 and ExpBar:GetHeight() or i == 2 and HonorBar:GetHeight())
        RepBar:Width(i == 1 and ExpBar:GetWidth() or i == 2 and HonorBar:GetWidth())
        RepBar:SetAllPoints(i == 1 and ExpBar or i == 2 and HonorBar)
        RepBar:SetReverseFill(false)
        -- RepBar:SetBackdrop(nil)
        RepBar.Backdrop:SetBorder()
        RepBar.Backdrop:SetOutside(nil, 2, 2)
    end

    -- I don't know why there is 2 reputation bars
    self.RepBar2:Kill()
end
