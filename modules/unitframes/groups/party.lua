local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

local ceil = math.ceil

----------------------------------------------------------------
-- Party
----------------------------------------------------------------
local baseParty = UnitFrames.Party

function UnitFrames:Party()
    -- first, we call the base function
    baseParty(self)

    -- second, we edit it
    local Health = self.Health
	local Power = self.Power
	local Name = self.Name
	local Buffs = self.Buffs
	local Debuffs = self.Debuffs
	local Leader = self.LeaderIndicator
	local MasterLooter = self.MasterLooterIndicator
	local ReadyCheck = self.ReadyCheckIndicator
	local RaidIcon = self.RaidTargetIndicator
	local PhaseIcon = self.PhaseIcon
    local Threat = self.ThreatIndicator
    local Range = self.Range
    local Highlight = self.Highlight
    local ResurrectIndicator = self.ResurrectIndicator

    local FrameWidth = C.Party.WidthSize
    local FrameHeight = C.Party.HeightSize
    local PowerHeight = 3

    local HealthTexture = T.GetTexture(C.Textures.UFPartyHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPartyPowerTexture)
    local Font = T.GetFont(C.Party.Font)
	local HealthFont = T.GetFont(C.Party.HealthFont)

    self.Shadow:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - PowerHeight - 1)
    Health:SetFrameLevel(3)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    if (C.Party.ShowHealthText) then
        Health.Value:ClearAllPoints()
        Health.Value:SetParent(Health)
        Health.Value:SetPoint("TOPRIGHT", Health, "TOPRIGHT", -4, 6)
        Health.Value:SetJustifyH("CENTER")

        -- self:Tag(Health.Value, C.Party.HealthTag.Value)
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
    Power:SetFrameLevel(Health:GetFrameLevel())

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(unpack(C.General.BackgroundColor))

    if (C.Party.ShowManaText) then
		Power.Value:ClearAllPoints()
		Power.Value:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", -4, 0)
		-- Power.PostUpdate = UnitFrames.PostUpdatePower
	end

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
	Name:SetPoint("CENTER", Health, "CENTER", 0, 0)
    Name:SetJustifyH("CENTER")

    -- self:Tag(Name, "[Tukui:NameShort] [Tukui:Role]")

    -- Auras
    if C.Party.Buffs then
        local AuraSize = FrameHeight + 2
        local AuraSpacing = 1
        local AuraPerRow = 7
        local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

        Buffs:ClearAllPoints()
        Buffs:SetPoint("TOPLEFT", Power, "BOTTOMLEFT", 0, -AuraSpacing)
        Buffs:SetHeight(AuraSize)
        Buffs:SetWidth(AuraWidth)

        Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 6
        Buffs.numRow = 1
        Buffs.initialAnchor = "TOPLEFT"
    end
	
    if C.Party.Debuffs then
        local AuraSize = FrameHeight + 2
        local AuraSpacing = 1
        local AuraPerRow = 7
        local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

        Debuffs:ClearAllPoints()
        Debuffs:SetPoint("TOPLEFT", self, "TOPRIGHT", AuraSpacing, 0)
        Debuffs:SetHeight(AuraSize)
        Debuffs:SetWidth(AuraWidth)

        Debuffs.size = AuraSize
        Debuffs.spacing = AuraSpacing
        Debuffs.num = 6
        Debuffs.initialAnchor = "TOPLEFT"
    end

    -- Leader
	Leader:ClearAllPoints()
    Leader:SetPoint("CENTER", Health, "TOPLEFT",  0, 3)
    Leader:SetSize(14, 14)

    -- Master Looter
	MasterLooter:ClearAllPoints()
    MasterLooter:SetPoint("CENTER", Health, "TOPRIGHT", 0, 3)
    MasterLooter:SetSize(14, 14)

    -- ReadyCheck
	ReadyCheck:ClearAllPoints()
	ReadyCheck:SetPoint("CENTER", Power, "CENTER", 0, 0)
	ReadyCheck:SetSize(12, 12)

    -- Raid Icon
	RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", Health, "TOP", 0, 3)
    RaidIcon:SetSize(14, 14)

    -- Phase Icon
	-- PhaseIcon:ClearAllPoints()
    -- PhaseIcon:SetPoint("TOPRIGHT", self, "TOPRIGHT", 7, 24)
    -- PhaseIcon:SetSize(24, 24)
    
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

    ResurrectIndicator:ClearAllPoints()
	ResurrectIndicator:SetSize(24, 24)
	ResurrectIndicator:SetPoint("CENTER", Health, "CENTER", 0, 0)

	-- Threat
	-- Threat.Override = UnitFrames.UpdateThreat

    -- Highlight
	-- Highlight:ClearAllPoints()
	-- Highlight:SetAllPoints(Health)

    -- Atonement
	-- if (Class == "PRIEST") then
    --     local Atonement = self.Atonement
    --     Atonement:SetAllPoints(Power)
	-- 	Atonement:SetStatusBarTexture(PowerTexture)
	-- end

	-- self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight)
	-- self:RegisterEvent("RAID_ROSTER_UPDATE", UnitFrames.Highlight)
    -- self:RegisterEvent("PLAYER_FOCUS_CHANGED", UnitFrames.Highlight)
end

----------------------------------------------------------------
-- Party Attributes
----------------------------------------------------------------
function UnitFrames:GetPartyFramesAttributes()
	return
		"TukuiParty",
		nil,
		"custom [@raid6,exists] hide; [@raid1,exists] show; [@party1,exists] show; hide",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", C.Party.WidthSize,
		"initial-height", C.Party.HeightSize,
		"showSolo", C.Party.ShowSolo,
		"showParty", true,
		"showPlayer", C.Party.ShowPlayer,
		"showRaid", true,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", -C.Party.Padding  -- -39
end

function UnitFrames:GetPetPartyFramesAttributes()
	return
		"TukuiPartyPet",
		"SecureGroupPetHeaderTemplate",
		"custom [@raid6,exists] hide; [@raid1,exists] show; [@party1,exists] show; hide",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", C.Party.WidthSize,
		"initial-height", C.Party.HeightSize,
		"showSolo", C.Party.ShowSolo,
		"showParty", true,
		"showPlayer", C.Party.ShowPlayer,
		"showRaid", true,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", -C.Party.Padding
end
