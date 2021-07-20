local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- FocusTarget
----------------------------------------------------------------
local baseFocusTarget = UnitFrames.FocusTarget

function UnitFrames:FocusTarget()

    -- first, we call the base function
    baseFocusTarget(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local Name = self.Name
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.FocusTarget)
    local PowerHeight = 3

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
	local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local CastTexture = T.GetTexture(C.Textures.UFCastTexture)

    self.Backdrop = nil
    self:CreateBackdrop()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)

    Health.Background:SetAllPoints()
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
        Health.colorTapping = true
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    -- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    -- Power.Value:ClearAllPoints()
    -- Power.Value:SetParent(Health)
    -- Power.Value:SetPoint("LEFT", Health, "LEFT", 5, 1)
    -- Power.Value:SetJustifyH("LEFT")

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

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("LEFT", Health, "LEFT", 5, 1)
    Name:SetJustifyH("LEFT")

    -- self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    if (C.UnitFrames.FocusAuras) then
        local Buffs = self.Buffs
        local Debuffs = self.Debuffs

		Buffs:ClearAllPoints()
		Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -7, 0)
		Buffs.size = FrameHeight
		Buffs.num = 3
		Buffs.spacing = 7
		Buffs.initialAnchor = "RIGHT"
        Buffs["growth-x"] = "LEFT"

        Buffs:SetWidth(Buffs.num * Buffs.size + (Buffs.num - 1) * Buffs.spacing)
        Buffs:SetHeight(Buffs.size)

		Debuffs:ClearAllPoints()
		Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 7, 0)
		Debuffs.size = Buffs.size
		Debuffs.num = 5
		Debuffs.spacing = Buffs.spacing
		Debuffs.initialAnchor = "LEFT"
		Debuffs["growth-x"] = "RIGHT"
        Debuffs:SetWidth(Debuffs.num * Debuffs.size + (Debuffs.num - 1) * Debuffs.spacing)
        Debuffs:SetHeight(Debuffs.size)
	end

	if (C.UnitFrames.FocusAuras) then
		local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
        local AuraSize = FrameHeight
        local AuraSpacing = 1
        local AuraPerRow = 3
        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

		Buffs:ClearAllPoints()
		Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, 1)
		Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(AuraWidth)
        
		Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 3
        Buffs.numRow = ceil(Buffs.num / AuraPerRow)
		Buffs.initialAnchor = "TOPRIGHT"
		Buffs["growth-x"] = "LEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
        -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		Debuffs:ClearAllPoints()
        Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 2, 1)
        Debuffs:SetHeight(AuraSize)
		Debuffs:SetWidth(AuraWidth)
        
		Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 4
        Debuffs.numRow = ceil(Debuffs.num / AuraPerRow)
		Debuffs.initialAnchor = "TOPLEFT"
		Debuffs["growth-x"] = "RIGHT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfDebuffs
        -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
        -- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura
	end

    --[[
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
    ]]
end
