local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))
local ceil = math.ceil

----------------------------------------------------------------
-- Raid
----------------------------------------------------------------
local baseRaid = UnitFrames.Raid

function UnitFrames:Raid()

    -- first, we call the base function
    baseRaid(self)

    -- second, we edit it
    local Health = self.Health
	local Power = self.Power
	local Name = self.Name
	local ReadyCheck = self.ReadyCheckIndicator
	local Range = self.Range
	local RaidIcon = self.RaidTargetIndicator
	local Threat = self.ThreatIndicator
    local Highlight = self.Highlight

    local PowerHeight = 3

    local HealthTexture = T.GetTexture(C.Textures.UFPartyHealthTexture)
    local PowerTexture = T.GetTexture(C.Textures.UFPartyPowerTexture)

	self.Shadow:Kill()
	self.Panel:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(self:GetHeight() - PowerHeight - 1)
    if (C.Raid.VerticalHealth) then
		Health:SetOrientation("VERTICAL")
	else
        Health:SetOrientation("HORIZONTAL")
    end

	Health.Background:SetAllPoints()
	Health.Background:SetColorTexture(unpack(C.General.BackgroundColor))

	Health.Value:ClearAllPoints()
	Health.Value:SetParent(Health)
	Health.Value:SetPoint("CENTER", Health, "CENTER", 0, -7)
	Health.Value:SetJustifyH("CENTER")

	Health.frequentUpdate = true
	Health.isRaid = true
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

	Power.frequentUpdates = true
	Power.colorDisconnected = true
	Power.isRaid = true
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
	Name:SetPoint("CENTER", Health, "CENTER", 0, 7)
	Name:SetJustifyH("CENTER")

	-- coloring names by class color
	self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameShort]")

	-- ReadyCheck
	ReadyCheck:ClearAllPoints()
	ReadyCheck:SetPoint("CENTER", Power, "CENTER", 0, 0)
	ReadyCheck:SetSize(12, 12)

	-- Raid Icon
	RaidIcon:ClearAllPoints()
	RaidIcon:SetPoint("CENTER", Health, "TOP", 0, 3)
	RaidIcon:SetSize(14, 14)

	-- Health Prediction
	if (C.UnitFrames.HealComm) then
        local myBar = self.HealthPrediction.myBar
        local otherBar = self.HealthPrediction.otherBar
        local absorbBar = self.HealthPrediction.absorbBar

        myBar:SetWidth(self:GetWidth())
        myBar:SetHeight(Health:GetHeight())
		myBar:SetStatusBarTexture(HealthTexture)

        otherBar:SetWidth(self:GetWidth())
        otherBar:SetHeight(Health:GetHeight())
		otherBar:SetStatusBarTexture(HealthTexture)

        absorbBar:SetWidth(self:GetWidth())
        absorbBar:SetHeight(Health:GetHeight())
		absorbBar:SetStatusBarTexture(HealthTexture)
    end

    if (C.Raid.AuraTrack) then
        local AuraTrack = self.AuraTrack
		
		-- AuraTrack:ClearAllPoints()
		-- AuraTrack:SetPoint("TOPLEFT", Health, "TOPLEFT", 1, -1)
		-- AuraTrack:SetWidth(self:GetWidth() - 2)
		-- AuraTrack:SetHeight(self:GetHeight() - 2)
		AuraTrack:SetAllPoints(Health)
		-- AuraTrack.Texture = C.Medias.Normal
		-- AuraTrack.Icons = C.Raid.AuraTrackIcons
		-- AuraTrack.SpellTextures = C.Raid.AuraTrackSpellTextures
		-- AuraTrack.Thickness = C.Raid.AuraTrackThickness
	elseif (C.Raid.RaidBuffs.Value ~= "Hide") then
        local Buffs = self.Buffs

		local onlyShowPlayer = C.Raid.RaidBuffs.Value == "Self"
		local filter = C.Raid.RaidBuffs.Value == "All" and "HELPFUL" or "HELPFUL|RAID"

        local AuraSize = 16
        local AuraSpacing = 1
        local AuraPerRow = 6
        local AuraWidth = (AuraPerRow * AuraSize) + ((AuraPerRow - 1) * AuraSpacing)

        Buffs:ClearAllPoints()
		Buffs:SetPoint("TOPLEFT", Health, "TOPLEFT", 1, -1)
		Buffs:SetHeight(AuraSize)
		Buffs:SetWidth(AuraWidth)
		Buffs.size = AuraSize
        Buffs.spacing = AuraSpacing
        Buffs.num = 5
		Buffs.numRow = ceil(Buffs.num / AuraPerRow)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs.disableCooldown = true
		Buffs.disableMouse = true
		Buffs.onlyShowPlayer = onlyShowPlayer
		Buffs.desaturateNonPlayerBuffs = C.Raid.DesaturateNonPlayerBuffs
		Buffs.filter = filter
        Buffs.IsRaid = true
        
		-- Buffs.PostCreateIcon = UnitFrames.PostCreateAura
	end

	-- AuraWatch (corner and center icon)
    if (C.Raid.DebuffWatch) then
        local RaidDebuffs = self.RaidDebuffs

        RaidDebuffs:ClearAllPoints()
        RaidDebuffs:SetPoint("CENTER", Health, "CENTER", 0, 0)
        RaidDebuffs:SetHeight(Health:GetHeight() - 16)
		RaidDebuffs:SetWidth(Health:GetHeight() - 16)
        
        RaidDebuffs.Shadow:Kill()

        RaidDebuffs.forceShow = C.Raid.TestAuraWatch
		RaidDebuffs.onlyMatchSpellID = true
        RaidDebuffs.showDispellableDebuff = false
        
		RaidDebuffs.time:ClearAllPoints()
        RaidDebuffs.time:SetPoint("CENTER", RaidDebuffs, "CENTER", 1, 0)
        RaidDebuffs.time:SetFont(C.Medias.Font, 12, "OUTLINE")
        
		RaidDebuffs.count:ClearAllPoints()
        RaidDebuffs.count:SetPoint("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 2, 0)
        RaidDebuffs.count:SetFont(C.Medias.Font, 12, "OUTLINE")
		RaidDebuffs.count:SetTextColor(1, .9, 0)
	end

	-- ResurrectIndicator
	local ResurrectIndicator = self.ResurrectIndicator
	ResurrectIndicator:ClearAllPoints()
	ResurrectIndicator:SetPoint("CENTER", Health, "CENTER", 0, 0)
	ResurrectIndicator:SetSize(24, 24)

	-- Threat
	-- Threat.Override = UnitFrames.UpdateThreat

	-- Highlight
	Highlight:Kill()
	self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight)
	self:RegisterEvent("RAID_ROSTER_UPDATE", UnitFrames.Highlight)

    -- Group Role
    if (C.Raid.GroupRoles) then
        local GroupRoleIndicator = Health:CreateTexture(nil, "OVERLAY")
        GroupRoleIndicator:SetSize(12, 12)
        GroupRoleIndicator:SetPoint("CENTER", Health, "CENTER", 0, -7)
        GroupRoleIndicator.PostUpdate = UnitFrames.UpdateGroupRole

        self.GroupRoleIndicator = GroupRoleIndicator
    end

	-- if (Class == "PRIEST") then
    --     local Atonement = CreateFrame("StatusBar", nil, Power)
	-- 	Atonement:SetAllPoints(Power)
	-- 	Atonement:SetStatusBarTexture(PowerTexture)
	-- 	Atonement:SetFrameStrata(Power:GetFrameStrata())
	-- 	Atonement:SetFrameLevel(Power:GetFrameLevel() + 1)

	-- 	self.Atonement = Atonement
	-- end
end

----------------------------------------------------------------
-- Raid Attributes
----------------------------------------------------------------
local point = "LEFT"
local columnAnchorPoint = "BOTTOM"

function UnitFrames:GetRaidFramesAttributes()
	local Properties = C.Party.Enable and
		"custom [@raid21,exists] hide; [@raid6,exists] show; hide" or
		"custom [@raid21,exists] hide; [@raid6,exists] show; [@party1,exists] show; hide"

	return
		"TukuiRaid",
		nil,
		Properties,
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", C.Raid.ShowSolo,
		"point", point,
		"maxColumns", ceil(40 / 5),
		"unitsPerColumn", C.Raid.MaxUnitPerColumn,
		"columnSpacing", C.Raid.Padding,
		"columnAnchorPoint", columnAnchorPoint,
		"xOffset", C.Raid.Padding,
		"yOffset", -C.Raid.Padding,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", C.Raid.GroupBy.Value,
		"initial-width", C.Raid.WidthSize,
		"initial-height", C.Raid.HeightSize,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]]
end

function UnitFrames:GetBigRaidFramesAttributes()
	local Properties = "custom [@raid21,exists] show; hide"

	return
		"TukuiRaid40",
		nil,
		Properties,
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", C.Raid.ShowSolo,
		"maxColumns", ceil(40 / 5),
		"point", point,
		"unitsPerColumn", C.Raid.Raid40MaxUnitPerColumn,
		"columnSpacing", C.Raid.Padding40,
		"columnAnchorPoint", columnAnchorPoint,
		"xOffset", C.Raid.Padding40,
		"yOffset", -C.Raid.Padding40,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", C.Raid.GroupBy.Value,
		"initial-width", C.Raid.Raid40WidthSize,
		"initial-height", C.Raid.Raid40HeightSize,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]]
end

function UnitFrames:GetPetRaidFramesAttributes()
	local Properties = C.Party.Enable and
		"custom [@raid21,exists] hide; [@raid6,exists] show; hide" or
		"custom [@raid21,exists] hide; [@raid6,exists] show; [@party1,exists] show; hide"

	return
		"TukuiRaidPet",
		"SecureGroupPetHeaderTemplate",
		Properties,
		"showParty", C.Raid.ShowPets,
		"showRaid", C.Raid.ShowPets,
		"showPlayer", true,
		"showSolo", C.Raid.ShowSolo,
		"maxColumns", ceil(40 / 5),
		"point", point,
		"unitsPerColumn", C.Raid.MaxUnitPerColumn,
		"columnSpacing", C.Raid.Padding,
		"columnAnchorPoint", columnAnchorPoint,
		"yOffset", -C.Raid.Padding,
		"xOffset", C.Raid.Padding,
		"initial-width", C.Raid.WidthSize,
		"initial-height", C.Raid.HeightSize,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]]
end

function UnitFrames:GetBigPetRaidFramesAttributes()
	local Properties = "custom [@raid21,exists] show; hide"

	return
		"TukuiRaid40Pet",
		"SecureGroupPetHeaderTemplate",
		Properties,
		"showParty", C.Raid.ShowPets,
		"showRaid", C.Raid.ShowPets,
		"showPlayer", true,
		"showSolo", C.Raid.ShowSolo,
		"maxColumns", ceil(40 / 5),
		"point", point,
		"unitsPerColumn", C.Raid.Raid40MaxUnitPerColumn,
		"columnSpacing", C.Raid.Padding40,
		"columnAnchorPoint", columnAnchorPoint,
		"yOffset", -C.Raid.Padding40,
		"xOffset", C.Raid.Padding40,
		"initial-width", C.Raid.Raid40WidthSize,
		"initial-height", C.Raid.Raid40HeightSize,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]]
end
