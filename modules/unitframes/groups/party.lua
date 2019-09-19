local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Party
----------------------------------------------------------------
local function Party(self)
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
    
    local FrameWidth, FrameHeight = unpack(C["Units"].Party)
    local HealthTexture = T.GetTexture(C["Textures"].UFPartyHealthTexture)
    local PowerTexture = T.GetTexture(C["Textures"].UFPartyPowerTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

	-- self:SetBackdrop(self)
	self:SetBackdropColor(.0, .0, .0, .0)
	self.Shadow:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:Height(FrameHeight - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    if (C.Party.ShowHealthText) then
        Health.Value:ClearAllPoints()
        Health.Value:SetParent(Health)
        Health.Value:Point("CENTER", Health, "CENTER", 1, -7)
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
    Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:Height(3)
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
	Name:SetPoint("CENTER", Health, "CENTER", 0, 1)
    Name:SetJustifyH("CENTER")
    
    self:Tag(Name, "[Tukui:NameShort] [Tukui:Role]")

    -- Auras
	Buffs:ClearAllPoints()
    Buffs:Point("TOPLEFT", Power, "BOTTOMLEFT", 0, -7)
    Buffs.size = FrameHeight
	Buffs.num = 8
	Buffs.numRow = 1
	Buffs.spacing = 7
	Buffs.initialAnchor = "TOPLEFT"
	Buffs:Height(Buffs.size)
	Buffs:Width(Buffs.num * Buffs.size + (Buffs.num - 1) * Buffs.spacing)

	Debuffs:ClearAllPoints()
	Debuffs:Point("TOPLEFT", self, "TOPRIGHT", 7, 0)
	Debuffs.size = FrameHeight
	Debuffs.num = 3
	Debuffs.spacing = 7
	Debuffs.initialAnchor = "TOPLEFT"
	Debuffs:Height(Debuffs.size)
	Debuffs:Width(Debuffs.num * Debuffs.size + (Debuffs.num - 1) * Debuffs.spacing)

    -- Leader
	Leader:ClearAllPoints()
    Leader:Point("CENTER", Health, "TOPLEFT",  0, 3)
    Leader:Size(14, 14)

    -- Master Looter
	MasterLooter:ClearAllPoints()
    MasterLooter:Point("CENTER", Health, "TOPRIGHT", 0, 3)
    MasterLooter:Size(14, 14)

    -- ReadyCheck
	ReadyCheck:ClearAllPoints()
	ReadyCheck:SetPoint("CENTER", Power, "CENTER", 0, 0)
	ReadyCheck:Size(12, 12)

    -- Raid Icon
	RaidIcon:ClearAllPoints()
    RaidIcon:SetPoint("CENTER", Health, "TOP", 0, 3)
    RaidIcon:Size(14, 14)

    -- Phase Icon
	PhaseIcon:ClearAllPoints()
    PhaseIcon:SetPoint("TOPRIGHT", self, "TOPRIGHT", 7, 24)
    PhaseIcon:Size(24, 24)

    -- Health Prediction
	if (C.Party.HealBar) then
		local FirstBar = self.HealthPrediction.myBar
        local SecondBar = self.HealthPrediction.otherBar
        local ThirdBar = self.HealthPrediction.absorbBar

        local HealBarColor = { .31, .45, .63, .4 }
        
        FirstBar:Width(FrameWidth)
        FirstBar:Height(Health:GetHeight())
		FirstBar:SetStatusBarTexture(HealthTexture)
        FirstBar:SetStatusBarColor(unpack(HealBarColor))
		
        SecondBar:Width(FrameWidth)
        SecondBar:Height(Health:GetHeight())
		SecondBar:SetStatusBarTexture(HealthTexture)
		SecondBar:SetStatusBarColor(unpack(HealBarColor))
		
        ThirdBar:Width(FrameWidth)
        ThirdBar:Height(Health:GetHeight())
		ThirdBar:SetStatusBarTexture(HealthTexture)
		ThirdBar:SetStatusBarColor(unpack(HealBarColor))
	end

	-- Threat
	Threat.Override = UnitFrames.UpdateThreat

    -- Highlight
	Highlight:ClearAllPoints()
	Highlight:SetAllPoints(Health)

    -- Atonement
	if (Class == "PRIEST") then
        local Atonement = self.Atonement
        Atonement:SetAllPoints(Power)
		Atonement:SetStatusBarTexture(PowerTexture)
	end

	self:RegisterEvent("PLAYER_TARGET_CHANGED", UnitFrames.Highlight)
	self:RegisterEvent("RAID_ROSTER_UPDATE", UnitFrames.Highlight)
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", UnitFrames.Highlight)
end
hooksecurefunc(UnitFrames, "Party", Party)

----------------------------------------------------------------
-- Party Attributes
----------------------------------------------------------------
function UnitFrames:GetPartyFramesAttributes()
    local Width, Height = unpack(C.Units.Party)
	return
		"TukuiParty",
		nil,
		"custom [@raid6,exists] hide;show",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", T.Scale(Width),
		"initial-height", T.Scale(Height),
		"showSolo", C["Party"].ShowSolo,
		"showParty", true,
		"showPlayer", C["Party"].ShowPlayer,
		"showRaid", true,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", T.Scale(-39)
end
