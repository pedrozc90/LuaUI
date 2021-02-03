local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

if (not C.Lua.Enable) then return end

----------------------------------------------------------------
-- Raid
----------------------------------------------------------------
local function Raid(self)
    local Health = self.Health
	local Power = self.Power
	local Name = self.Name
	local ReadyCheck = self.ReadyCheckIndicator
	local Range = self.Range
	local RaidIcon = self.RaidTargetIndicator
	local Threat = self.ThreatIndicator
    local Highlight = self.Highlight

    local FrameWidth, FrameHeight = unpack(C["Units"].Raid)
    local HealthTexture = T.GetTexture(C["Textures"].UFRaidHealthTexture)
    local PowerTexture = T.GetTexture(C["Textures"].UFRaidPowerTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

	self:SetBackdrop(nil)
    self.Shadow:Kill()
    self.Panel:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:SetHeight(FrameHeight - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()
    Health:SetOrientation("HORIZONTAL")

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    if (C.Raid.ShowHealthText) then
        Health.Value:ClearAllPoints()
        Health.Value:SetParent(Health)
        Health.Value:SetPoint("CENTER", Health, "CENTER", 1, -7)
        Health.Value:SetJustifyH("CENTER")
    end

    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BorderColor))
        Health.Background:SetVertexColor(unpack(C.General.BackdropColor))
    else
        Health.colorTapping = true
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

	-- Power
    Power:ClearAllPoints()
    Power:SetPoint("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:SetPoint("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:SetHeight(3)
    Power:SetFrameLevel(Health:GetFrameLevel())
    Power:CreateBackdrop()

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(.05, .05, .05)

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
	Name:SetPoint("CENTER", Health, "CENTER", 1, 7)
    Name:SetJustifyH("CENTER")

    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameShort]")

    -- ReadyCheck
	ReadyCheck:ClearAllPoints()
	ReadyCheck:SetPoint("CENTER", Power, "CENTER", 0, 0)
	ReadyCheck:SetSize(12, 12)

	-- Raid Icon
	RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", Health, "TOP", 0, 3)
    RaidIcon:SetSize(14, 14)

	if C["Raid"].ShowRessurection then
        local ResurrectIcon = self.ResurrectIndicator

        ResurrectIcon:ClearAllPoints()
        ResurrectIcon:SetPoint("CENTER", Health, "CENTER", 0, 0)
		ResurrectIcon:SetSize(16)
	end

	-- Health Prediction
	if (C.Raid.HealBar) then
		local FirstBar = self.HealthPrediction.myBar
        local SecondBar = self.HealthPrediction.otherBar
        local ThirdBar = self.HealthPrediction.absorbBar

        local HealBarColor = { .31, .45, .63, .4 }

        FirstBar:SetWidth(FrameWidth)
        FirstBar:SetHeight(Health:GetHeight())
		FirstBar:SetStatusBarTexture(HealthTexture)
        FirstBar:SetStatusBarColor(unpack(HealBarColor))

        SecondBar:SetWidth(FrameWidth)
        SecondBar:SetHeight(Health:GetHeight())
		SecondBar:SetStatusBarTexture(HealthTexture)
		SecondBar:SetStatusBarColor(unpack(HealBarColor))

        ThirdBar:SetWidth(FrameWidth)
        ThirdBar:SetHeight(Health:GetHeight())
		ThirdBar:SetStatusBarTexture(HealthTexture)
		ThirdBar:SetStatusBarColor(unpack(HealBarColor))
	end

	-- AuraWatch (corner and center icon)
    if (C.Raid.AuraWatch) then
        local RaidDebuffs = self.RaidDebuffs

        RaidDebuffs:ClearAllPoints()
        RaidDebuffs:SetParent(Health)
        RaidDebuffs:SetPoint("CENTER", Health, "CENTER", 0, 0)
        RaidDebuffs:SetSize(18)
		RaidDebuffs.Shadow:Kill()

		RaidDebuffs.showDispellableDebuff = true
		RaidDebuffs.onlyMatchSpellID = true
		RaidDebuffs.FilterDispellableDebuff = true
		RaidDebuffs.forceShow = C["Raid"].TestAuraWatch -- use for testing

		RaidDebuffs.time:ClearAllPoints()
        RaidDebuffs.time:SetPoint("CENTER", RaidDebuffs, 0, 0)
        RaidDebuffs.time:SetFont(Font, FontSize, FontStyle)

		RaidDebuffs.count:ClearAllPoints()
        RaidDebuffs.count:SetPoint("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 2, 0)
        RaidDebuffs.count:SetFont(Font, FontSize, FontStyle)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
	end

	-- Threat
	Threat.Override = UnitFrames.UpdateThreat

	-- Highlight
	Highlight:ClearAllPoints()
    Highlight:SetAllPoints(Health)

    -- Group Role
    if (C.Raid.GroupRoles) then
        local GroupRoleIndicator = self:CreateTexture(nil, "OVERLAY")
        GroupRoleIndicator:SetSize(12, 12)
        GroupRoleIndicator:SetPoint("CENTER", Health, "CENTER", 0, -7)
        GroupRoleIndicator.PostUpdate = UnitFrames.UpdateGroupRole

        self.GroupRoleIndicator = GroupRoleIndicator
    end

	if (Class == "PRIEST") then
        local Atonement = CreateFrame("StatusBar", nil, Power)
		Atonement:SetAllPoints(Power)
		Atonement:SetStatusBarTexture(PowerTexture)
		Atonement:SetFrameStrata(Power:GetFrameStrata())
		Atonement:SetFrameLevel(Power:GetFrameLevel() + 1)

		self.Atonement = Atonement
	end

	self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight)
	self:RegisterEvent("RAID_ROSTER_UPDATE", UnitFrames.Highlight)
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", UnitFrames.Highlight)
end
hooksecurefunc(UnitFrames, "Raid", Raid)

----------------------------------------------------------------
-- Raid Attributes
----------------------------------------------------------------
function UnitFrames:GetRaidFramesAttributes()
    local Properties = C.Party.Enable and "custom [@raid6,exists] show;hide" or "solo,party,raid"
    local Width, Height = unpack(C.Units.Raid)
	return
		"TukuiRaid",
		nil,
		Properties,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", T.Scale(Width),
		"initial-height", T.Scale(Height),
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", C["Raid"].ShowSolo,
		"xoffset", T.Scale(7),
		"yOffset", T.Scale(-3),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", C["Raid"].GroupBy.Value,
		"maxColumns", math.ceil(40 / 5),
		"unitsPerColumn", C["Raid"].MaxUnitPerColumn,
		"columnSpacing", T.Scale(7),
		"columnAnchorPoint", "BOTTOM"
end
