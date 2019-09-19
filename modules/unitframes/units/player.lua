local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Panels = T.Panels
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Player
----------------------------------------------------------------
local function Player(self)
    local Health = self.Health
    local Power = self.Power
    local AdditionalPower = self.AdditionalPower
    local Combat = self.CombatIndicator
    local Status = self.Status
    local Leader = self.LeaderIndicator
    local MasterLooter = self.MasterLooterIndicator
    local RaidIcon = self.RaidTargetIndicator
    local Threat = self.ThreatIndicator

    local FrameWidth, FrameHeight = unpack(C["Units"].Player)
    local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
    local CastTexture = T.GetTexture(C["Textures"].UFCastTexture)
    local Font, FontSize, FontStyle = C["Medias"].PixelFont, 12, "MONOCHROMEOUTLINE"

    self:SetBackdrop(nil)
    self.Shadow:Kill()
    self.Panel:Kill()

    -- Health
    Health:ClearAllPoints()
    Health:Point("TOPLEFT", self, "TOPLEFT", 0, 0)
    Health:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)
    Health:Height(FrameHeight - 6)
    Health:SetFrameLevel(3)
    Health:CreateBackdrop()

    Health.Background:SetAllPoints()
    Health.Background:SetColorTexture(.05, .05, .05)

    Health.Value:ClearAllPoints()
    Health.Value:SetParent(Health)
    Health.Value:Point("RIGHT", Health, "RIGHT", -5, 1)
    Health.Value:SetJustifyH("LEFT")
    
    Health.frequentUpdate = true
    if (C.Lua.UniColor) then
        Health.colorTapping = false
        Health.colorDisconnected = false
        Health.colorClass = false
        Health.colorReaction = false
        Health:SetStatusBarColor(unpack(C.General.BorderColor))
        Health.Background:SetVertexColor(unpack(C.General.BackdropColor))
    else
        Health.colorTapping = false
        Health.colorDisconnected = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    -- Health Prediction
	if (C.UnitFrames.HealBar) then
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

    -- Power
    Power:ClearAllPoints()
    Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:Height(3)
    Power:SetFrameLevel(Health:GetFrameLevel())
    Power:CreateBackdrop()

    Power.Background:SetAllPoints()
    Power.Background:SetColorTexture(.05, .05, .05)

    Power.Value:ClearAllPoints()
    Power.Value:SetParent(Health)
    Power.Value:Point("LEFT", Health, "LEFT", 5, 1)
    Power.Value:SetJustifyH("LEFT")

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

	Power.Prediction:Width(FrameWidth)
	Power.Prediction:SetStatusBarTexture(PowerTexture)
	Power.Prediction:SetStatusBarColor(.0, .0, .0, .7)

    -- Additional Power (e.g: Shadow Priest Mana)
	AdditionalPower:ClearAllPoints()
    AdditionalPower:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
    AdditionalPower:Width(FrameWidth)
    AdditionalPower:Height(3)
	AdditionalPower:SetStatusBarTexture(PowerTexture)
	AdditionalPower:SetStatusBarColor(unpack(T.Colors.power["MANA"]))
	AdditionalPower:SetFrameLevel(Health:GetFrameLevel())
    AdditionalPower:SetBackdrop(nil)
    AdditionalPower:CreateBackdrop()

    AdditionalPower.Background:SetAllPoints()
    AdditionalPower.Background:SetColorTexture(0.05, 0.05, 0.05)

	AdditionalPower.Prediction:Width(FrameWidth)
	AdditionalPower.Prediction:SetStatusBarTexture(PowerTexture)
    AdditionalPower.Prediction:SetStatusBarColor(.0, .0, .0, .7)

    -- Portrait
    if (C.UnitFrames.Portrait) then
        local Portrait = self.Portrait

        Portrait:ClearAllPoints()
        Portrait:SetInside(Health, 1, 1)
        Portrait:SetAlpha(.3)
    end
    
    -- Combat Indocator
	Combat:ClearAllPoints()
	Combat:Point("CENTER", Health, "CENTER", 0, 1)

	-- Status Indicator
	Status:ClearAllPoints()
	Status:Point("CENTER", Health, "CENTER", 0, 1)

    -- Leader Indicator
    Leader:ClearAllPoints()
    Leader:Point("CENTER", Health, "TOPLEFT",  0, 3)
    Leader:Size(14, 14)

	-- MasterLooter Indicator
	MasterLooter:ClearAllPoints()
    MasterLooter:Point("CENTER", Health, "TOPRIGHT", 0, 3)
    MasterLooter:Size(14, 14)

    -- Raid Icon
    RaidIcon:ClearAllPoints()
    RaidIcon:Point("CENTER", self, "TOP", 0, 3)
    RaidIcon:Size(16, 16)

    -- Castbar
    if (C.UnitFrames.CastBar) then
        local CastBar = self.Castbar

        CastBar:ClearAllPoints()
        CastBar:Point("TOPLEFT", Power, "BOTTOMLEFT", 0, -7)
        CastBar:Width(FrameWidth)
        CastBar:Height(20)
        CastBar:SetStatusBarTexture(CastTexture)
        CastBar:SetFrameLevel(Health:GetFrameLevel())
        CastBar:CreateBackdrop()

		CastBar.Background:SetAllPoints()
		CastBar.Background:SetTexture(CastTexture)
		CastBar.Background:SetVertexColor(0.05, 0.05, 0.05)

		CastBar.Time:ClearAllPoints()
		CastBar.Time:Point("RIGHT", CastBar, "RIGHT", -5, 1)
		CastBar.Time:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Time:SetJustifyH("RIGHT")

		CastBar.Text:ClearAllPoints()
		CastBar.Text:Point("LEFT", CastBar, "LEFT", 5, 1)
		CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Text:Width(CastBar:GetWidth())
		CastBar.Text:SetJustifyH("LEFT")

        if (C.UnitFrames.CastBarIcon) then
            CastBar.Icon:ClearAllPoints()
            CastBar.Icon:Point("TOPRIGHT", Health, "TOPLEFT", -7, 0)
            CastBar.Icon:Size(FrameHeight + Power:GetHeight() + 3)
            CastBar.Icon:SetTexCoord(unpack(T.IconCoord))

            CastBar.Button:ClearAllPoints()
            CastBar.Button:SetOutside(CastBar.Icon)
		end

		if (C.UnitFrames.UnlinkCastBar) then
			CastBar:ClearAllPoints()
            CastBar:Point("BOTTOM", Panels.ActionBar1, "TOP", 0, 7)
            CastBar:Width(Panels.ActionBar1:GetWidth())                 -- CastBar:Width(350)
            CastBar:Height(20)
            CastBar.Shadow:Kill()

			if (C.UnitFrames.CastBarIcon) then
				CastBar.Icon:ClearAllPoints()
				CastBar.Icon:Point("RIGHT", CastBar, "LEFT", -7, 0)
				CastBar.Icon:Size(CastBar:GetHeight())
			end
        end
    end

    -- CombatLog
	if (C.UnitFrames.CombatLog) then
        local CombatFeedbackText = self.CombatFeedbackText
        
		CombatFeedbackText:ClearAllPoints()
        CombatFeedbackText:Point("CENTER", Health, "CENTER", 0, 1)
        CombatFeedbackText:SetFont(Font, 13, FontStyle)
    end
    
    -- ComboPoints
	if (C.UnitFrames.ComboBar) and (Class == "ROGUE" or Class == "DRUID") then
        local ComboPoints = self.ComboPointsBar
        
        ComboPoints:ClearAllPoints()
		ComboPoints:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
        ComboPoints:Point("BOTTOMRIGHT", self, "TOPRIGHT", 0, 7)
        ComboPoints:Height(5)
        ComboPoints:SetBackdrop(nil)
        
        local Spacing = 7           -- spacing between combo-points
        local SizeMax5, DeltaMax5 = T.EqualSizes(FrameWidth, 5, Spacing)
        local SizeMax6, DeltaMax6 = T.EqualSizes(FrameWidth, 6, Spacing)
        
        for i = 1, 6 do
            ComboPoints[i]:ClearAllPoints()
            ComboPoints[i]:Height(ComboPoints:GetHeight())
            ComboPoints[i]:Width(SizeMax6)
            ComboPoints[i]:CreateBackdrop()

            if ((DeltaMax5 > 0) and (i <= DeltaMax5)) then
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5
            end

            if ((DeltaMax6 > 0) and (i <= DeltaMax6)) then
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6
            end

			if (i == 1) then
                ComboPoints[i]:Point("LEFT", ComboPoints, "LEFT", 0, 0)
			else
                ComboPoints[i]:Point("LEFT", ComboPoints[i - 1], "RIGHT", Spacing, 0)
            end
        end

		ComboPoints:SetScript("OnShow", function(self)
			UnitFrames.UpdateShadow(self, 12)
			UnitFrames.UpdateBuffsHeaderPosition(self, 14)
		end)

		ComboPoints:SetScript("OnHide", function(self)
			UnitFrames.UpdateShadow(self, 4)
			UnitFrames.UpdateBuffsHeaderPosition(self, 4)
        end)
    end
    
    -- TotemBar
    if (C.UnitFrames.TotemBar) and (Class == "SHAMAN" or Class == "MONK") then
        local Totems = self.Totems

        local Size = 27
        local Spacing = 3

		Totems:ClearAllPoints()
        Totems:Point("BOTTOMLEFT", AdditionalPower or self, "TOPLEFT", -2, 5)
        Totems:Width((Size * MAX_TOTEMS) + (Spacing * (MAX_TOTEMS - 1)))
        Totems:Height(Size)

		for i = 1, MAX_TOTEMS do
			Totems[i]:ClearAllPoints()
			Totems[i]:Size(Totems:GetHeight())
            Totems[i].Shadow:Kill()
            
            -- change cooldown font
            local cooldown = Totems[i].Cooldown
            local timer = cooldown:GetRegions()
            timer:ClearAllPoints()
            timer:SetPoint("CENTER", cooldown, "CENTER", 2, 1)
            timer:SetFont(Font, 14, FontStyle)
            timer:SetTextColor(0.84, 0.75, 0.65)

            timer.ClearAllPoints = function() end
            timer.SetPoint = function() end
            timer.SetFontObject = function() end
            timer.SetFont = function() end

			if i == 1 then
				Totems[i]:Point("BOTTOMLEFT", Totems, "BOTTOMLEFT", 0, 0)
			else
				Totems[i]:Point("LEFT", Totems[i - 1], "RIGHT", Spacing, 0)
			end
		end
	end
end
hooksecurefunc(UnitFrames, "Player", Player)
