local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local ceil = math.ceil

----------------------------------------------------------------
-- Target
----------------------------------------------------------------
local baseTarget = UnitFrames.Target

function UnitFrames:Target()
    -- first, we call the base function
    baseTarget(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local AltPowerBar = self.AlternativePower
    local RaidIcon = self.RaidTargetIndicator
    local Leader = self.LeaderIndicator
    local MasterLooter = self.MasterLooterIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.Target)
    local PowerHeight = 5

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.UFCastTexture)
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    self.Panel:Kill()
    self.Shadow:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)

    Health.Background:SetAllPoints(Health)
    Health.Background:SetTexture(HealthTexture)
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    Health.Value:ClearAllPoints()
    Health.Value:SetParent(Health)
    Health.Value:SetPoint("RIGHT", Health, "RIGHT", -5, 0)
    Health.Value:SetJustifyH("LEFT")

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

    -- fix target status bar color
    Health.PreUpdate = UnitFrames.PreUpdateHealth

    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    if (Power.Value) then
        Power.Value:ClearAllPoints()
        Power.Value:SetParent(Health)
        Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 0)
        Power.Value:SetJustifyH("LEFT")
    end

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

    -- Alternative Power Bar
    if (T.Retail) then
        AltPowerBar:ClearAllPoints()
        AltPowerBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
        AltPowerBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 7)
        AltPowerBar:SetHeight(5)
        AltPowerBar:SetStatusBarColor(.0, .0, .0)
        AltPowerBar:SetFrameLevel(Health:GetFrameLevel())
        -- AltPowerBar:CreateBackdrop()
        -- AltPowerBar.Backdrop:SetOutside()

        if (AltPowerBar.Value) then
            AltPowerBar.Value:ClearAllPoints()
            AltPowerBar.Value:SetPoint("CENTER", AltPowerBar, "CENTER", 0, 1)
        end
    end

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
    Name:SetPoint("LEFT", Health, "LEFT", 5, 0)
    Name:SetJustifyH("LEFT")

    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar

        CastBar:ClearAllPoints()
        CastBar:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -3)
        CastBar:SetWidth(FrameWidth)
        CastBar:SetHeight(20)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:SetFrameLevel(Health:GetFrameLevel())
        CastBar:CreateBackdrop()
        CastBar.Backdrop:SetOutside()

        CastBar.Background:SetAllPoints()
        CastBar.Background:SetTexture(CastTexture)
        CastBar.Background:SetVertexColor(unpack(C.General.BackgroundColor))

        CastBar.Time:ClearAllPoints()
        CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 0)
        CastBar.Time:SetTextColor(0.84, 0.75, 0.65)
        CastBar.Time:SetJustifyH("RIGHT")

        CastBar.Text:ClearAllPoints()
        CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 0)
        CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
        CastBar.Text:SetWidth(CastBar:GetWidth())
        CastBar.Text:SetJustifyH("LEFT")

        if (C.UnitFrames.CastBarIcon) then
            local IconSize = FrameHeight + Power:GetHeight() + 1

            CastBar.Icon:ClearAllPoints()
            CastBar.Icon:SetPoint("TOPLEFT", Health, "TOPRIGHT", 3, 0)
            CastBar.Icon:SetSize(IconSize, IconSize)
            CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

            CastBar.Button:ClearAllPoints()
            CastBar.Button:SetOutside(CastBar.Icon)
        end

        if (C.UnitFrames.UnlinkCastBar) then
            local ButtonSize = C.ActionBars.NormalButtonSize
            local ButtonSpacing = C.ActionBars.ButtonSpacing
            local ButtonsPerRow = C.ActionBars.Bar1ButtonsPerRow
            local NumRow = ceil(12 / ButtonsPerRow)
            local IconSize = (CastBar.Button) and CastBar.Button:GetWidth() or 0
            local Width = (ButtonsPerRow * ButtonSize) + ((ButtonsPerRow + 1) * ButtonSpacing) - IconSize

            CastBar:ClearAllPoints()
            CastBar:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
            CastBar:SetWidth(Width)
            CastBar:SetHeight(20)
            CastBar.Shadow:Kill()

            if (C.UnitFrames.CastBarIcon) then
                CastBar.Icon:ClearAllPoints()
                CastBar.Icon:SetPoint("LEFT", CastBar, "RIGHT", 3, 0)
                CastBar.Icon:SetSize(CastBar:GetHeight(), CastBar:GetHeight())
            end
        end
    end

    -- Portrait
    if (C.UnitFrames.Portrait) then
        local Portrait = self.Portrait
        local PortraitHolder = Portrait:GetParent()

        if (C.UnitFrames.Portrait2D) then
            local PortraitSize = FrameHeight + Power:GetHeight() + 1

            PortraitHolder:ClearAllPoints()
            PortraitHolder:SetPoint("TOPLEFT", Health, "TOPRIGHT", 3, 0)
            PortraitHolder:SetSize(PortraitSize, PortraitSize)
        else
            Portrait:SetParent(Health)
            Portrait:SetAllPoints(Health)
            Portrait:SetAlpha(.35)

            PortraitHolder:Kill()
        end

        Portrait.Shadow:Kill()
    end

    do
        local AuraSize = 27
        local AuraSpacing = 3
        local AuraPerRow = 9
        local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

        if (C.UnitFrames.TargetBuffs) then
            local Buffs = self.Buffs

            local yOffset = (AlternativePower and AlternativePower.IsEnable) and 10 or 0

            Buffs:ClearAllPoints()
            Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, AuraSpacing)
            Buffs:SetWidth(AuraWidth)
            Buffs:SetHeight(AuraSize)

            Buffs.initialAnchor = "TOPLEFT"
            Buffs["growth-y"] = "UP"
            Buffs["growth-x"] = "RIGHT"
            Buffs.size = AuraSize
            Buffs.spacing = AuraSpacing
            Buffs.num = 32
            Buffs.numRow = ceil(Buffs.num / AuraPerRow)

            Buffs.PostUpdate = C.UnitFrames.TargetDebuffs and UnitFrames.UpdateDebuffsHeaderPosition

            -- if (C.UnitFrames.AurasBelow) then
            --     Buffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
            -- end
        end

        if (C.UnitFrames.TargetDebuffs) then
            local Debuffs = self.Debuffs

            Debuffs:ClearAllPoints()
            Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, AuraSize + (2 * AuraSpacing))
            Debuffs:SetWidth(AuraWidth)
            Debuffs:SetHeight(AuraSize)

            Debuffs.initialAnchor = "TOPRIGHT"
            Debuffs["growth-y"] = "UP"
            Debuffs["growth-x"] = "LEFT"
            Debuffs.size = AuraSize
            Debuffs.spacing = AuraSpacing
            Debuffs.num = 16
            Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
        end
    end

    -- CombatLog
    if (C.UnitFrames.CombatLog) then
        local CombatFeedbackText = self.CombatFeedbackText
        CombatFeedbackText:ClearAllPoints()
        CombatFeedbackText:SetPoint("CENTER", Health, "CENTER", 0, 0)
        CombatFeedbackText:SetFont(Font, 13, FontStyle)
    end

    -- Health Prediction
    if (C.UnitFrames.HealComm) then
        local myBar = self.HealthPrediction.myBar
        local otherBar = self.HealthPrediction.otherBar
        local absorbBar = self.HealthPrediction.absorbBar

        myBar:SetWidth(FrameWidth)
        myBar:SetHeight(Health:GetHeight())
        myBar:SetStatusBarTexture(HealthTexture)

        otherBar:SetWidth(FrameWidth)
        otherBar:SetHeight(Health:GetHeight())
        otherBar:SetStatusBarTexture(HealthTexture)

        absorbBar:SetWidth(FrameWidth)
        absorbBar:SetHeight(Health:GetHeight())
        absorbBar:SetStatusBarTexture(HealthTexture)
    end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    -- Leader Icon
    Leader:ClearAllPoints()
    Leader:SetSize(14, 14)
    Leader:SetPoint("TOPLEFT", 2, 8)

    -- Master Looter Icon
    MasterLooter:ClearAllPoints()
    MasterLooter:SetSize(14, 14)
    MasterLooter:SetPoint("TOPRIGHT", -2, 8)
end
