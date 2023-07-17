local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupHealth()
    local Health = self.Health
    local HealthPrediction = self.HealthPrediction

    local Spacing = 1
    local Width, Height = T.GetSize(self.unit)
    local PowerHeight = C.UnitFrames.PowerHeight or 5
    local Texture = T.GetTexture(C.Textures.UFHealthTexture)

    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(Height - PowerHeight - Spacing)

    -- Health.Background:SetAllPoints(Health)
    -- Health.Background:SetTexture(Texture)
    -- Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    if (Health.Value) then
        Health.Value:ClearAllPoints()
        Health.Value:SetParent(Health)
        Health.Value:SetPoint("RIGHT", Health, "RIGHT", -5, 0)
        Health.Value:SetJustifyH("LEFT")
    end

    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BackdropColor))
        Health.Background:SetVertexColor(unpack(C.General.BackgroundColor))
    else
        Health.colorTapping = false
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    if (self.unit == "target") then
        -- fix target status bar color
        Health.PreUpdate = UnitFrames.PreUpdateHealth
    end

    if (HealthPrediction) then
        local myBar = HealthPrediction.myBar
        local otherBar = HealthPrediction.otherBar
        local absorbBar = HealthPrediction.absorbBar

        myBar:SetWidth(Width)
        myBar:SetHeight(Health:GetHeight())
        myBar:SetStatusBarTexture(Texture)

        otherBar:SetWidth(Width)
        otherBar:SetHeight(Health:GetHeight())
        otherBar:SetStatusBarTexture(Texture)

        absorbBar:SetWidth(Width)
        absorbBar:SetHeight(Health:GetHeight())
        absorbBar:SetStatusBarTexture(Texture)
    end
end
