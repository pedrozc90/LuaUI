local T, C, L = Tukui:unpack()
local Toolkit = T00LKIT
local UnitFrames = T.UnitFrames
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Raid
----------------------------------------------------------------
local baseRaid = UnitFrames.Raid

function UnitFrames:Raid()

    -- first, call the base function
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
    
    local HealthTexture = T.GetTexture(C["Textures"].UFRaidHealthTexture)
    local PowerTexture = T.GetTexture(C["Textures"].UFRaidPowerTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

	self:SetBackdrop(nil)
    self.Shadow:Kill()
    self.Panel:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:Height(C.Raid.HeightSize - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()
    Health.Backdrop:SetBorder()
    Health.Backdrop:SetOutside(nil, 2, 2)

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    Health.Value:ClearAllPoints()
	Health.Value:SetFontObject(HealthFont)
	Health.Value:Point("CENTER", Health, "CENTER", 0, -5)
    
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
	Name:Point("CENTER", Health, "CENTER", 1, 7)
    Name:SetJustifyH("CENTER")

    self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameShort]")
    
    -- ReadyCheck
	ReadyCheck:ClearAllPoints()
	ReadyCheck:Point("CENTER", Power, "CENTER", 0, 0)
	ReadyCheck:Size(12, 12)

	-- Raid Icon
	RaidIcon:ClearAllPoints()
    RaidIcon:Point("CENTER", Health, "TOP", 0, 3)
    RaidIcon:Size(14, 14)
    
    if (C.Raid.MyRaidBuffs) then
        local Buffs = self.Buffs
        
        Buffs:ClearAllPoints()
		Buffs:Point("TOPLEFT", Health, "TOPLEFT", 7, -7)
		Buffs:SetHeight(16)
		Buffs:SetWidth(C.Raid.WidthSize)
		Buffs.size = 16
		Buffs.num = 5
		Buffs.numRow = 1
		Buffs.spacing = 0
		Buffs.initialAnchor = "TOPLEFT"
		Buffs.disableCooldown = true
		Buffs.disableMouse = true
		Buffs.onlyShowPlayer = true
		Buffs.IsRaid = true
		-- Buffs.PostCreateIcon = TukuiUnitFrames.PostCreateAura
	end
	
	if (C.Raid.DebuffWatch) then
        local RaidDebuffs = self.RaidDebuffs
        
        RaidDebuffs:ClearAllPoints()
        RaidDebuffs:Point("CENTER", Health, "CENTER", 0, 0)
        RaidDebuffs:Size(20)
		-- RaidDebuffs:SetTemplate()
        RaidDebuffs.Shadow:Kill()
        
        RaidDebuffs.time:ClearAllPoints()
        RaidDebuffs.time:Point("CENTER", RaidDebuffs, "CENTER", 0, 0)
        RaidDebuffs.time:SetFont(Font, FontSize, FontStyle)

		RaidDebuffs.count:ClearAllPoints()
        RaidDebuffs.count:Point("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 2, 0)
        RaidDebuffs.count:SetFont(Font, FontSize, FontStyle)		
		RaidDebuffs.count:SetTextColor(1, .9, 0)
        
        RaidDebuffs.showDispellableDebuff = true
		RaidDebuffs.onlyMatchSpellID = true
		RaidDebuffs.FilterDispellableDebuff = true
		RaidDebuffs.forceShow = C.Raid.TestAuraWatch
    end
    
    if (C.UnitFrames.HealComm) then
        local HealthPrediction = self.HealthPrediction
		local myBar = HealthPrediction.myBar
		local otherBar = HealthPrediction.otherBar

		-- myBar:SetFrameLevel(Health:GetFrameLevel())
		-- myBar:SetStatusBarTexture(HealthTexture)
		-- myBar:SetPoint("TOP")
		-- myBar:SetPoint("BOTTOM")
		-- myBar:SetPoint("LEFT", Health:GetStatusBarTexture(), "RIGHT")
		-- myBar:SetWidth(C.Raid.WidthSize)
		-- myBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommSelfColor))

		-- otherBar:SetFrameLevel(Health:GetFrameLevel())
		-- otherBar:SetPoint("TOP")
		-- otherBar:SetPoint("BOTTOM")
		-- otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		-- otherBar:SetWidth(C.Raid.WidthSize)
		-- otherBar:SetStatusBarTexture(HealthTexture)
		-- otherBar:SetStatusBarColor(C.UnitFrames.HealCommOtherColor)
		
		-- if (C.Raid.VerticalHealth) then
		-- 	myBar:SetOrientation("VERTICAL")
		-- 	otherBar:SetOrientation("VERTICAL")
			
		-- 	myBar:SetPoint("BOTTOM", Health:GetStatusBarTexture(), "TOP")
		-- 	myBar:SetPoint("LEFT")
		-- 	myBar:SetPoint("RIGHT")
			
		-- 	otherBar:SetPoint("BOTTOM", myBar:GetStatusBarTexture(), "TOP")
		-- 	otherBar:SetPoint("LEFT")
		-- 	otherBar:SetPoint("RIGHT")
		-- end
	end
	
	-- Highlight:SetBackdrop({edgeFile = C.Medias.Glow, edgeSize = C.Raid.HighlightSize})
	-- Highlight:SetOutside(self, C.Raid.HighlightSize, C.Raid.HighlightSize)
	-- Highlight:SetBackdropBorderColor(unpack(C.Raid.HighlightColor))
	-- Highlight:SetFrameLevel(0)
    -- Highlight:Hide()
    
end

----------------------------------------------------------------
-- Raid Attributes
----------------------------------------------------------------
function UnitFrames:GetRaidFramesAttributes()
    local Properties = C.Party.Enable and "custom [@raid6,exists] show;hide" or "solo,party,raid"
	return
		"TukuiRaid",
		nil,
		Properties,
		"oUF-initialConfigFunction", [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("initial-width"))
			self:SetHeight(header:GetAttribute("initial-height"))
		]],
		"initial-width", C.Raid.WidthSize,
		"initial-height", C.Raid.HeightSize,
		"showParty", true,
		"showRaid", true,
		"showPlayer", true,
		"showSolo", C["Raid"].ShowSolo,
		"xoffset", Toolkit.Functions.Scale(7),
		"yOffset", Toolkit.Functions.Scale(-3),
		"point", "LEFT",
		"groupFilter", "1,2,3,4,5,6,7,8",
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", C["Raid"].GroupBy.Value,
		"maxColumns", math.ceil(40 / 5),
		"unitsPerColumn", C["Raid"].MaxUnitPerColumn,
		"columnSpacing", Toolkit.Functions.Scale(7),
		"columnAnchorPoint", "BOTTOM"
end
