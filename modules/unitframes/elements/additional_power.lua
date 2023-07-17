local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupAdditionalPower()
    if (not T.Retail) then return end

    local Health = self.Health
    local AdditionalPower = self.AdditionalPower
    if (not AdditionalPower) then return end

    local Height = 3
    local Texture = T.GetTexture(C.Textures.UFPowerTexture)

    print("AdditionalPower")
    -- Additional Power (e.g: Shadow Priest Mana, Druid Mana)
    -- if (T.Retail) then
    AdditionalPower:ClearAllPoints()
    -- AdditionalPower:SetPoint("BOTTOMLEFT", self.Power, "BOTTOMLEFT", 0, -1)
    -- AdditionalPower:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 0, -1)
    AdditionalPower:SetPoint("BOTTOMLEFT", Health, "BOTTOMLEFT", 10, 20)
    AdditionalPower:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", 10, 20)
    AdditionalPower:SetHeight(Height)
    AdditionalPower:SetStatusBarTexture(Texture)
    -- AdditionalPower:SetStatusBarColor(unpack(T.Colors.power["MANA"]))
    -- AdditionalPower:SetFrameLevel(self.Health:GetFrameLevel())
    -- AdditionalPower.Backdrop:Kill()

    -- AdditionalPower.PostVisibility = function (self, visibility)
    --     if (visibility) then
    --         Health:SetHeight(FrameHeight - PowerHeight - AdditionalPowerHeight - 2)

    --         Power:ClearAllPoints()
    --         Power:SetPoint("TOPLEFT", AdditionalPower, "BOTTOMLEFT", 0, -1)
    --         Power:SetPoint("TOPRIGHT", AdditionalPower, "BOTTOMRIGHT", 0, -1)
    --     else
    --         Health:SetHeight(FrameHeight - PowerHeight - 1)

    --         Power:ClearAllPoints()
    --         Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    --         Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    --     end
    -- end

    -- AdditionalPower.Background:SetAllPoints()
    -- AdditionalPower.Background:SetColorTexture(unpack(C.General.BackgroundColor))
end
