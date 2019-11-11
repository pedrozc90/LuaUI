local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Toolkit = T00LKIT
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Party
----------------------------------------------------------------
local baseParty = UnitFrames.Party

function UnitFrames:Party()

    -- first, call the base function
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
    Health:Height(C.Party.HeightSize - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()
    Health.Backdrop:SetBorder()
    Health.Backdrop:SetOutside(nil, 2, 2)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    if (C.Party.ShowHealthText) then
		Health.Value.ClearAllPoints()
		Health.Value:SetParent(Health)
		Health.Value:SetPoint("TOPRIGHT", Health, "TOPRIGHT", -4, 6)
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
    Power.Backdrop:SetBorder()
    Power.Backdrop:SetOutside(nil, 2, 2)

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(.05, .05, .05)

    if (C.Party.ShowManaText) then
		Power.Value:ClearAllPoints()
		Power.Value:SetParent(Health)
		Power.Value:SetPoint("BOTTOMRIGHT", Health, "BOTTOMRIGHT", -4, 0)
		Power.PostUpdate = TukuiUnitFrames.PostUpdatePower
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
	Name:SetPoint("CENTER", Health, "CENTER", 0, 1)
    Name:SetJustifyH("CENTER")
    
    self:Tag(Name, "[Tukui:NameShort] [Tukui:Role]")

    -- Auras
	Buffs:ClearAllPoints()
    Buffs:Point("TOPLEFT", Power, "BOTTOMLEFT", 0, -7)
    Buffs.size = C.Party.HeightSize
	Buffs.num = 8
	Buffs.numRow = 1
	Buffs.spacing = 7
	Buffs.initialAnchor = "TOPLEFT"
	Buffs:Height(Buffs.size)
	Buffs:Width(Buffs.num * Buffs.size + (Buffs.num - 1) * Buffs.spacing)

	Debuffs:ClearAllPoints()
	Debuffs:Point("TOPLEFT", self, "TOPRIGHT", 7, 0)
	Debuffs.size = C.Party.HeightSize
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

    if (C.UnitFrames.HealComm) then
        local HealthPrediction = self.HealthPrediction
		local myBar = HealthPrediction.myBar
		local otherBar = HealthPrediction.otherBar

		-- myBar:SetFrameLevel(Health:GetFrameLevel())
		-- myBar:SetStatusBarTexture(HealthTexture)
		-- myBar:SetPoint("TOP")
		-- myBar:SetPoint("BOTTOM")
		-- myBar:SetPoint("LEFT", Health:GetStatusBarTexture(), "RIGHT")
		-- myBar:SetWidth(180)
		-- myBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommSelfColor))

		-- otherBar:SetFrameLevel(Health:GetFrameLevel())
		-- otherBar:SetPoint("TOP")
		-- otherBar:SetPoint("BOTTOM")
		-- otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		-- otherBar:SetWidth(180)
		-- otherBar:SetStatusBarTexture(HealthTexture)
		-- otherBar:SetStatusBarColor(C.UnitFrames.HealCommOtherColor)

		-- local HealthPrediction = {
		-- 	myBar = myBar,
		-- 	otherBar = otherBar,
		-- 	maxOverflow = 1,
		-- }
	end

	-- Highlight:SetBackdrop({edgeFile = C.Medias.Glow, edgeSize = C.Party.HighlightSize})
	-- Highlight:SetOutside(self, C.Party.HighlightSize, C.Party.HighlightSize)
	-- Highlight:SetBackdropBorderColor(unpack(C.Party.HighlightColor))
	-- Highlight:SetFrameLevel(0)
	-- Highlight:Hide()
    
end

----------------------------------------------------------------
-- Party Attributes
----------------------------------------------------------------
function UnitFrames:GetPartyFramesAttributes()
    -- local Width, Height = unpack(C.Units.Party)
	return
		"TukuiParty",
		nil,
		"custom [@raid6,exists] hide;show",
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", C.Party.WidthSize,
		"initial-height", C.Party.HeightSize,
		"showSolo", C["Party"].ShowSolo,
		"showParty", true,
		"showPlayer", C["Party"].ShowPlayer,
		"showRaid", true,
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", Toolkit.Scale(-39)
end
