local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- Boss
----------------------------------------------------------------
local baseBoss = UnitFrames.Boss

function UnitFrames:Boss()
    -- first, we call the base function
    baseBoss(self)

    -- second, we edit it
    local Health = self.Health
	local Power = self.Power
	local Name = self.Name
	local AltPowerBar = self.AlternativePower
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.Boss)
    local PowerHeight = 3

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

    Health.Value:ClearAllPoints()
    Health.Value:SetParent(Health)
    Health.Value:SetPoint("RIGHT", Health, "RIGHT", -5, 0)
    Health.Value:SetJustifyH("LEFT")

    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BackdropColor))
        Health.Background:SetVertexColor(unpack(C.General.BorderColor))
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
    Power:SetStatusBarTexture(PowerTexture)

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
	Name:SetPoint("CENTER", Health, "CENTER", 0, 1)
    Name:SetJustifyH("CENTER")

    self:Tag(Name, "[Tukui:Classification][Tukui:DiffColor][level] [Tukui:GetNameColor][Tukui:NameMedium]")

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    -- Auras
	if (C.UnitFrames.BossAuras) then
        local Buffs = self.Buffs
        local Debuffs = self.Debuffs

        local AuraSize = FrameHeight
        local AuraSpacing = 1
        local AuraPerRow = 3
        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

		Buffs:ClearAllPoints()
        Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -3, 0)
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
        Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, 0)
        Debuffs:SetWidth(AuraWidth)
        Debuffs:SetHeight(AuraSize)

		Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 5
		Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
		Debuffs.initialAnchor = "LEFT"
        Debuffs["growth-x"] = "RIGHT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
	end

    -- CastBar
	if (C.UnitFrames.CastBar) then
		local CastBar = self.Castbar

        if (C.UnitFrames.UnlinkBossCastBar) then
            CastBar:ClearAllPoints()
            CastBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
            CastBar:SetWidth(FrameWidth)
            CastBar:SetHeight(20)
            CastBar:CreateBackdrop()

            -- CastBar.Time:ClearAllPoints()
            -- CastBar.Time:SetPoint("RIGHT", CastBar, "RIGHT", -5, 1)
            -- CastBar.Time:SetJustifyH("RIGHT")

            CastBar.Text:ClearAllPoints()
            CastBar.Text:SetPoint("LEFT", CastBar, "LEFT", 5, 1)
            CastBar.Text:SetJustifyH("LEFT")
            CastBar.Text:SetWidth(CastBar:GetWidth())

            CastBar.Button:ClearAllPoints()
            CastBar.Button:SetSize(CastBar:GetHeight(), CastBar:GetHeight())
            CastBar.Button:SetPoint("TOPLEFT", CastBar, "TOPRIGHT", 7, 0)
        end
    end

    -- Health Prediction
	if (C.UnitFrames.HealBar) then
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
end
