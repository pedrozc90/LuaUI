local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Arena
----------------------------------------------------------------
local baseArena = UnitFrames.Arena

function UnitFrames:Arena()
    -- first, we call the base function
    baseArena(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local SpecIcon = self.PVPSpecIcon
    local Trinket = self.Trinket
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.Arena)
    local PowerHeight = 3
    local Spacing = 1

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.UFCastTexture)

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - (PowerHeight + 1))
    Health:SetStatusBarTexture(HealthTexture)

    Health.Background:SetAllPoints(Health)
    Health.Background:SetTexture(HealthTexture)
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    -- Health.Value:ClearAllPoints()
    -- Health.Value:SetParent(Health)
    -- Health.Value:SetPoint("RIGHT", Health, "RIGHT", -5, 1)
    -- Health.Value:SetJustifyH("LEFT")

    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BackdropColor))
        Health.Background:SetVertexColor(unpack(C.General.BackgroundColor))
    else
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

    -- Power.Value:ClearAllPoints()
    -- Power.Value:SetParent(Health)
    -- Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 1)
    -- Power.Value:SetJustifyH("LEFT")

    Power.frequentUpdates = true
    Power.colorDisconnected = true
    if (C.Lua.UniColor) then
        Power.colorClass = true
        Power.colorPower = false
        Power.Background.multiplier = 0.1
    else
        Power.colorClass = false
        Power.colorPower = true
    end

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
    Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    Name:SetJustifyH("CENTER")

    -- self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong]")

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    -- -- Spec Icon
    -- SpecIcon:ClearAllPoints()
    -- SpecIcon:SetPoint("TOPRIGHT", self, "TOPLEFT", -7, 0)
    -- SpecIcon:SetSize(FrameHeight)
    -- SpecIcon.Backdrop.Shadow:Kill()

    -- -- Trinket Icon
    -- Trinket:ClearAllPoints()
    -- Trinket:SetPoint("TOPRIGHT", SpecIcon, "TOPLEFT", -7, 0)
    -- Trinket:SetSize(FrameHeight)
    -- Trinket.Backdrop.Shadow:Kill()

    -- Auras
    if (C.UnitFrames.ArenaAuras) then
        local Buffs = self.Buffs
        local Debuffs = self.Debuffs

        local AuraSize = FrameHeight
        local AuraSpacing = 1
        local AuraPerRow = 3
        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

        Buffs:ClearAllPoints()
        Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 0)
        Buffs:SetWidth(AuraWidth)
        Buffs:SetHeight(AuraSize)

        Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 3
        Buffs.numRow = ceil(Buffs.num / AuraPerRow)
        Buffs.initialAnchor = "RIGHT"
        Buffs["growth-x"] = "LEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs

        Debuffs:ClearAllPoints()
        Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 0)
        Debuffs:SetWidth(AuraWidth)
        Debuffs:SetHeight(AuraSize)

        Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 4
        Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
        Debuffs.initialAnchor = "LEFT"
        Debuffs["growth-x"] = "RIGHT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
    end

    -- CastBar
    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar

        if (C.UnitFrames.UnlinkArenaCastBar) then
            CastBar:ClearAllPoints()
            CastBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
            CastBar:SetWidth(FrameWidth)
            CastBar:SetHeight(20)

            CastBar.Time:ClearAllPoints()
            CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 1)
            CastBar.Time:SetJustifyH("RIGHT")

            CastBar.Text:ClearAllPoints()
            CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 1)
            CastBar.Text:SetJustifyH("LEFT")
            CastBar.Text:SetWidth(CastBar:GetWidth())

            CastBar.Button:ClearAllPoints()
            CastBar.Button:SetSize(CastBar:GetHeight())
            CastBar.Button:SetPoint("TOPLEFT", CastBar, "TOPRIGHT", 7, 0)
        end
    end

    -- Trinket Icon
    if (T.BCC or T.WotLK) then
        local Trinket = self.Trinket

        Trinket:ClearAllPoints()
        Trinket:SetPoint("TOPRIGHT", SpecIcon, "TOPLEFT", -7, 0)
        Trinket:SetSize(FrameHeight)
        Trinket.Backdrop.Shadow:Kill()
    end
end
