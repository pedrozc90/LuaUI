local T, C, L = Tukui:unpack()
local Reputation = T.Miscellaneous.Reputation
local Experience = T.Miscellaneous.Experience
local Minimap = T.Maps.Minimap

----------------------------------------------------------------
-- Repustation Bar
----------------------------------------------------------------
local function Enable(self)
    local Texture = T.GetTexture(C.Lua.Texture)

    for i = 1, self.NumBars do
        local RepBar = self["RepBar" .. i]
        local ExpBar = Experience.XPBar1
        local HonorBar = Experience.XPBar2
        
        RepBar:ClearAllPoints()
        RepBar:SetStatusBarTexture(Texture)
        RepBar:Height(i == 1 and ExpBar:GetHeight() or i == 2 and HonorBar:GetHeight())
        RepBar:Width(i == 1 and ExpBar:GetWidth() or i == 2 and HonorBar:GetWidth())
        RepBar:SetAllPoints(i == 1 and ExpBar or i == 2 and HonorBar)
        RepBar:SetReverseFill(false)
    end

    -- I don't know why there is 2 reputation bars
    self.RepBar2:Kill()
end
hooksecurefunc(Reputation, "Enable", Enable)
