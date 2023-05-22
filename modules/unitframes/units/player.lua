local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local Class = select(2, UnitClass("player"))
local MAX_TOTEMS = MAX_TOTEMS
local ceil = math.ceil

----------------------------------------------------------------
-- Player
----------------------------------------------------------------
local basePlayer = UnitFrames.Player

function UnitFrames:Player()
    -- first, we call the base function
    basePlayer(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local PowerPrediction = self.PowerPrediction.mainBar
    local AdditionalPower = self.AdditionalPower
    local Name = self.Name

    local Combat = self.CombatIndicator
    local Status = self.Status
    local Leader = self.LeaderIndicator
    local MasterLooter = self.MasterLooterIndicator
    local RaidIcon = self.RaidTargetIndicator
    local RestingIndicator = self.RestingIndicator
    local Threat = self.ThreatIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.Player)
    local PowerHeight, AdditionalPowerHeight = 5, 2

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
    Health:SetHeight(FrameHeight)

    -- Health.Background:Kill()
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

    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints(Power)
    Power.Background:SetTexture(PowerTexture)
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    Power.Value = Power:CreateFontString(nil, "OVERLAY")
    Power.Value:SetFontObject(T.GetFont(C.UnitFrames.Font))
    Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 0)
    Power.Value:SetJustifyH("LEFT")

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

    -- Power Prediction
    PowerPrediction:SetWidth(FrameWidth)
    PowerPrediction:SetStatusBarTexture(PowerTexture)
    PowerPrediction:SetStatusBarColor(0, 0, 0, 0.7)

    -- Additional Power (e.g: Shadow Priest Mana)
    if (T.Retail) then
        AdditionalPower:ClearAllPoints()
        AdditionalPower:SetPoint("BOTTOMLEFT", Health, "BOTTOMLEFT", 0, -1)
		AdditionalPower:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", 0, -1)
        AdditionalPower:SetHeight(AdditionalPowerHeight)
        AdditionalPower:SetStatusBarTexture(PowerTexture)
        AdditionalPower:SetStatusBarColor(unpack(T.Colors.power["MANA"]))
        AdditionalPower:SetFrameLevel(Health:GetFrameLevel())
        AdditionalPower.Backdrop:Kill()

        AdditionalPower.PostVisibility = function (self, visibility)
            if (visibility) then
                Health:SetHeight(FrameHeight - PowerHeight - AdditionalPowerHeight - 2)

                Power:ClearAllPoints()
                Power:SetPoint("TOPLEFT", AdditionalPower, "BOTTOMLEFT", 0, -1)
                Power:SetPoint("TOPRIGHT", AdditionalPower, "BOTTOMRIGHT", 0, -1)
            else
                Health:SetHeight(FrameHeight - PowerHeight - 1)

                Power:ClearAllPoints()
                Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
                Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
            end
        end

        AdditionalPower.Background:SetAllPoints()
        AdditionalPower.Background:SetColorTexture(unpack(C.General.BackgroundColor))
    end

    Name:ClearAllPoints()
    Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    Name:SetJustifyH("CENTER")
    Name:SetAlpha(0)

    -- local Gap = (
    --     (T.MyClass == "ROGUE") or
    --     (T.MyClass == "DRUID") or
    --     (T.MyClass == "MAGE") or
    --     (T.MyClass == "PALADIN") or
    --     (T.MyClass == "WARLOCK") or
    --     (T.MyClass == "DEATHKNIGHT")
    -- ) and 8 or 0

    if (C.UnitFrames.PlayerAuraBars) then
        local AuraBars = self.AuraBars

        AuraBars:ClearAllPoints()
        AuraBars:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
        AuraBars:SetHeight(10)
        AuraBars:SetWidth(250)

        AuraBars.gap = 3
        AuraBars.height = 17
        AuraBars.width = FrameWidth - AuraBars.height - AuraBars.gap
        AuraBars.growth = "UP"
        AuraBars.initialAnchor = "BOTTOMLEFT"
        AuraBars.auraBarTexture = PowerTexture
        AuraBars.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
    else
        local AuraSize = 27
        local AuraSpacing = 3
        local AuraPerRow = 9
        local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

        if (C.UnitFrames.PlayerBuffs) then
            local Buffs = self.Buffs

            Buffs:ClearAllPoints()
            Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, AuraSpacing)
            Buffs:SetHeight(AuraSize)
            Buffs:SetWidth(AuraWidth)

            Buffs.size = AuraSize
            Buffs.spacing = AuraSpacing
            Buffs.num = 32
            Buffs.numRow = ceil(Buffs.num / AuraPerRow)
            Buffs.initialAnchor = "TOPLEFT"
            Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
            Buffs.isCancellable = true

            -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
            -- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura
            -- Buffs.PostUpdate = C.UnitFrames.PlayerDebuffs and UnitFrames.UpdateDebuffsHeaderPosition

            if (C.UnitFrames.AurasBelow) then
                Buffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
            end
        end

        if (C.UnitFrames.PlayerDebuffs) then
            local Debuffs = self.Debuffs

            Debuffs:ClearAllPoints()
            Debuffs:SetHeight(AuraSize)
            Debuffs:SetWidth(AuraWidth)

            if (self.Buffs) then
                Debuffs:SetPoint("BOTTOMLEFT", self.Buffs, "TOPLEFT", 0, 18)
            else
                Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, AuraSpacing)
            end

            Debuffs.size = AuraSize
            Debuffs.spacing = AuraSpacing
            Debuffs.num = 16
            Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
            Debuffs.initialAnchor = "TOPRIGHT"
            Debuffs["growth-y"] = "UP"
            Debuffs["growth-x"] = "LEFT"
            -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
            -- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

            if (C.UnitFrames.AurasBelow) then
                if (not C.UnitFrames.PlayerBuffs) then
                    Debuffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
                end
                Debuffs["growth-y"] = "DOWN"
            end
        end
    end

    -- Combat Indocator
    Combat:ClearAllPoints()
    Combat:SetPoint("CENTER", Health, "CENTER", 0, 1)

    -- Status Indicator
    Status:ClearAllPoints()
    Status:SetPoint("CENTER", Health, "CENTER", 0, 1)
    Status:Hide()

    -- Leader Indicator
    Leader:ClearAllPoints()
    Leader:SetPoint("CENTER", Health, "TOPLEFT",  0, 3)
    Leader:SetSize(14, 14)

    -- MasterLooter Indicator
    MasterLooter:ClearAllPoints()
    MasterLooter:SetPoint("CENTER", Health, "TOPRIGHT", 0, 3)
    MasterLooter:SetSize(14, 14)

    -- Castbar
    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar

        CastBar:ClearAllPoints()
        CastBar:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -3)
        CastBar:SetWidth(FrameWidth)
        CastBar:SetHeight(20)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:SetStatusBarColor(1, 1, 1)
        CastBar:SetFrameLevel(Health:GetFrameLevel())
        CastBar:CreateBackdrop()
        CastBar.Backdrop:SetOutside()

        CastBar.Background:SetAllPoints(CastBar)
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

        -- CastBar.Spark:ClearAllPoints()
        -- CastBar.Spark:SetSize(8, CastBar:GetHeight())
        -- CastBar.Spark:SetBlendMode("ADD")
        -- CastBar.Spark:SetPoint("CENTER", CastBar:GetStatusBarTexture(), "RIGHT", 0, 0)

        if (C.UnitFrames.CastBarIcon) then
            local IconSize = FrameHeight + Power:GetHeight() + 1
            CastBar.Icon:ClearAllPoints()
            CastBar.Icon:SetPoint("TOPRIGHT", Health, "TOPLEFT", -4, 0)
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
            CastBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 12, 50)
            CastBar:SetWidth(Width)
            CastBar:SetHeight(20)
            CastBar.Shadow:Kill()

            if (C.UnitFrames.CastBarIcon) then
                CastBar.Icon:ClearAllPoints()
                CastBar.Icon:SetPoint("RIGHT", CastBar, "LEFT", -3, 0)
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
            PortraitHolder:SetPoint("TOPRIGHT", Health, "TOPLEFT", -3, 0)
            PortraitHolder:SetSize(PortraitSize, PortraitSize)
        else
            Portrait:SetParent(Health)
            Portrait:SetAllPoints(Health)
            Portrait:SetAlpha(.35)

            PortraitHolder:Kill()
        end

        Portrait.Shadow:Kill()
    end

    -- CombatLog
    if (C.UnitFrames.CombatLog) then
        local CombatFeedbackText = self.CombatFeedbackText

        CombatFeedbackText:ClearAllPoints()
        CombatFeedbackText:SetPoint("CENTER", Health, "CENTER", 0, 0)
        CombatFeedbackText:SetFont(Font, FontSize, FontStyle)
    end

    -- ComboPoints
    if (C.UnitFrames.ComboBar) and (Class == "ROGUE" or Class == "DRUID") then
        local ComboPoints = self.ComboPointsBar

        local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight

        ComboPoints:ClearAllPoints()
        -- ComboPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
        -- ComboPoints:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
        -- ComboPoints:SetHeight(5)
        ComboPoints:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
        ComboPoints:SetWidth(Width)
        ComboPoints:SetHeight(Height)
        ComboPoints.Backdrop:Kill()

        local Spacing = 3           -- spacing between combo-points
        local SizeMax5, DeltaMax5 = T.EqualSizes(FrameWidth, 5, Spacing)
        local SizeMax6, DeltaMax6 = T.EqualSizes(FrameWidth, 6, Spacing)

        for i = 1, 6 do
            ComboPoints[i]:ClearAllPoints()
            ComboPoints[i]:SetHeight(ComboPoints:GetHeight())
            ComboPoints[i]:SetWidth(SizeMax6)
            ComboPoints[i]:CreateBackdrop()
            ComboPoints[i].Backdrop:SetOutside()

            if ((DeltaMax5 > 0) and (i <= DeltaMax5)) then
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5
            end

            if ((DeltaMax6 > 0) and (i <= DeltaMax6)) then
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6
            end

            if (i == 1) then
                ComboPoints[i]:SetPoint("LEFT", ComboPoints, "LEFT", 0, 0)
            else
                ComboPoints[i]:SetPoint("LEFT", ComboPoints[i - 1], "RIGHT", Spacing, 0)
            end
        end

        -- ComboPoints:SetScript("OnShow", UnitFrames.MoveBuffHeaderUp)
        -- ComboPoints:SetScript("OnHide", UnitFrames.MoveBuffHeaderDown)
    end

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    -- Rested Icon
    RestingIndicator:ClearAllPoints()
    RestingIndicator:SetPoint("CENTER", Health, "CENTER", 0, 0)
    RestingIndicator:SetSize(16, 16)
    RestingIndicator:Hide()

    if ((T.Classic or T.BCC) and C.UnitFrames.PowerTick) then
        local EnergyManaRegen = self.EnergyManaRegen
        -- EnergyManaRegen:SetFrameLevel(Power:GetFrameLevel() + 3)
        -- EnergyManaRegen:SetAllPoints()
        -- EnergyManaRegen.Spark = EnergyManaRegen:CreateTexture(nil, "OVERLAY")
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

    -- TotemBar
    if (C.UnitFrames.TotemBar) then
        local Totems = self.Totems

        if (C.UnitFrames.TotemBarStyle.Value == "On Screen") then
            -- Totems:SetPoint("CENTER", UIParent, "BOTTOM", 0, 300)
            -- Totems:SetWidth((Size * MAX_TOTEMS) + (Spacing * (MAX_TOTEMS + 1)))
            -- Totems:SetHeight(Size)

            -- for i = 1, MAX_TOTEMS do
            --     Totems[i]:ClearAllPoints()
            --     Totems[i]:SetSize(Size, Size)
            --     Totems[i].Backdrop.Shadow:Kill()

            --     -- change cooldown font
            --     Totems[i].Cooldown:ClearAllPoints()
            --     Totems[i].Cooldown:SetPoint("CENTER", Totems[i], "CENTER", 0, 0)

            --     if i == 1 then
            --         Totems[i]:SetPoint("BOTTOMLEFT", Totems, "BOTTOMLEFT", 0, 0)
            --     else
            --         Totems[i]:SetPoint("LEFT", Totems[i - 1], "RIGHT", Spacing, 0)
            --     end
            -- end
        elseif (C.UnitFrames.TotemBarStyle.Value == "On Player") then
            Totems:ClearAllPoints()
            Totems:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 3)
            Totems:SetHeight(10)
            Totems:SetWidth(FrameWidth + 2)

            local Width, Delta = T.EqualSizes(FrameWidth - 2, MAX_TOTEMS, 0)

            for i = 1, MAX_TOTEMS do
                Totems[i]:SetHeight(8)

                if ((Delta > 0) and (i <= Delta)) then
                    Totems[i]:SetWidth(Width + 1)
                else
                    Totems[i]:SetWidth(Width)
                end

                if i == 1 then
                    Totems[i]:SetPoint("TOPLEFT", Totems, "TOPLEFT", 1, -1)
                else
                    Totems[i]:SetPoint("TOPLEFT", Totems[i-1], "TOPRIGHT", 1, 0)
                end
            end

            if (self.AuraBars) then
                self.AuraBars:ClearAllPoints()
                self.AuraBars:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
            elseif (self.Buffs) then
                self.Buffs:ClearAllPoints()
                self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 15)
            end
        end
    end
end
