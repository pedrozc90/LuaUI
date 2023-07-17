local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupAlternativePower()
    if (not T.Retail) then return end

    local AlternativePower = self.AlternativePower
    if (not AlternativePower) then return end

    local Height = 3
    local Texture = T.GetTexture(C.Textures.UFPowerTexture)

    
end
