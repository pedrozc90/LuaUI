local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupPower()
    local Power = self.Power
    if (not Power) then return end
    
    local Height = C.UnitFrames.PowerHeight or 5
    local Texture = T.GetTexture(C.Textures.UFPowerTexture)
    
    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(Height)
    
    Power.Background:SetAllPoints(Power)
    Power.Background:SetTexture(Texture)
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))
    
    if (Power.Value) then
        Power.Value = nil
        
        Power.Value = Power:CreateFontString(nil, "OVERLAY")
        Power.Value:SetFontObject(T.GetFont(C.UnitFrames.Font))
        Power.Value:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
        Power.Value:SetJustifyH("LEFT")
    end
    -- self.Power.Value:SetPoint("LEFT", self.Health, "LEFT", 4, 0)
    -- if (Power.Value) then
    --     Power.Value:ClearAllPoints()
    --     Power.Value:SetParent(Power)
    --     Power.Value:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
    --     Power.Value:SetJustifyH("LEFT")
    -- else
    --     Power.Value = Power:CreateFontString(nil, "OVERLAY")
    --     Power.Value:SetFontObject(T.GetFont(C.UnitFrames.Font))
    --     Power.Value:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
    --     Power.Value:SetJustifyH("LEFT")
    -- end

    Power.frequentUpdates = true
    Power.colorDisconnected = true
    if (C.Lua.UniColor) then
        Power.colorClass = not C.Lua.ColorPower
        Power.colorPower = C.Lua.ColorPower
        Power.Background.multiplier = 0.1
    else
        Power.colorClass = false
        Power.colorPower = true
    end

    local PowerPrediction = self.PowerPrediction
    if (PowerPrediction) then
        local PowerPredictionMainBar = self.PowerPrediction.mainBar
        -- PowerPredictionMainBar:SetWidth(Width)
        PowerPredictionMainBar:SetPoint("TOPLEFT", Power, "TOPLEFT", 0, 0)
        PowerPredictionMainBar:SetPoint("BOTTOMRIGHT", Power, "BOTTOMRIGHT", 0, 0)
        PowerPredictionMainBar:SetStatusBarTexture(Texture)
        PowerPredictionMainBar:SetStatusBarColor(0, 0, 0, 0.7)
    end
end
