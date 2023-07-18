local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupAdditionalPower()
    if (not T.Retail) then return end

    local Health = self.Health
    local AdditionalPower = self.AdditionalPower
    if (not AdditionalPower) then return end

    local Height = 3
    local Texture = T.GetTexture(C.Textures.UFPowerTexture)

    AdditionalPower.Backdrop = nil
    -- Additional Power (e.g: Shadow Priest Mana, Druid Mana)
    AdditionalPower:ClearAllPoints()
    AdditionalPower:SetPoint("BOTTOMLEFT", Health, "BOTTOMLEFT", 0, -1)
    AdditionalPower:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    AdditionalPower:SetHeight(Height)
    AdditionalPower:SetStatusBarTexture(Texture)

    AdditionalPower.Background:SetAllPoints()
    AdditionalPower.Background:SetColorTexture(unpack(C.General.BackgroundColor))
end
