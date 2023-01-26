local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ceil = math.ceil

----------------------------------------------------------------
-- TargetOfTarget
----------------------------------------------------------------
local baseTargetOfTarget = UnitFrames.TargetOfTarget

function UnitFrames:TargetOfTarget()
    -- first, we call the base function
    baseTargetOfTarget(self)

    -- second, we edit it
    local Health = self.Health
	local Name =  self.Name
    local RaidIcon = self.RaidTargetIndicator

    local FrameWidth, FrameHeight = unpack(C.Units.TargetOfTarget)
    local PowerHeight = 5

    local HealthTexture = T.GetTexture(C.Textures.UFHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPowerTexture)
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

	self.Shadow:Kill()
    self.Panel:Kill()
    self.Backdrop = nil
    self:CreateBackdrop()

	-- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

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

    local Power = CreateFrame("StatusBar", nil, self)
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
    Power:SetHeight(PowerHeight)
    Power:SetFrameStrata(self:GetFrameStrata())
    Power:SetStatusBarTexture(PowerTexture)

	Power.Background = Power:CreateTexture(nil, "BORDER")
	Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))
	Power.Background.multiplier = 0.3

	Power.frequentUpdates = true
    Power.colorDisconnected = true
    if (C.Lua.UniColor) then
        Power.colorPower = false
        Power.colorClass = true
        Power.Background.multiplier = 0.1
    else
        Power.colorPower = true
        Power.colorClass = false
    end

    self.Power = Power

    -- Name
    Name:ClearAllPoints()
    Name:SetParent(Health)
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    Name:SetJustifyH("CENTER")

    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameMedium] [Tukui:DiffColor][level]")

	-- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", self, "TOP", 0, 3)
    RaidIcon:SetSize(16, 16)

    if (C.UnitFrames.TOTAuras) then
		local Buffs = self.Buffs
        local Debuffs = self.Debuffs
        
        local AuraSize = 21
        local AuraSpacing = 1
        local AuraPerRow = 4

        local AuraWidth = (AuraSize * AuraPerRow) + (AuraSpacing * (AuraPerRow + 1))

        -- Buffs
		Buffs:ClearAllPoints()
		Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
		Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(AuraWidth)
        
		Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 3
        Buffs.numRow = ceil(Buffs.num / AuraPerRow)
		Buffs.initialAnchor = "TOPLEFT"
        Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
        -- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

        -- Debuffs
		Debuffs:ClearAllPoints()
        Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 2)
        Debuffs:SetHeight(AuraSize)
        Debuffs:SetWidth(AuraWidth)
        
        Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 3
        Debuffs.numRow = ceil(Buffs.num / AuraPerRow)
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs["growth-x"] = "LEFT"
        Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfDebuffs
        -- Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
		-- Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		if (C.UnitFrames.AurasBelow) then
			Buffs:ClearAllPoints()
			Buffs:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -2)
			
			Debuffs:ClearAllPoints()
			Debuffs:SetPoint("TOPRIGHT", Power, "BOTTOMRIGHT", 0, -2)
		end
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
end
