local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Panels = T.Panels
local Class = select(2, UnitClass("player"))

local LastTickTime = GetTime()

----------------------------------------------------------------
-- Player
----------------------------------------------------------------
local basePlayer = UnitFrames.Player

function UnitFrames:Player()

    -- first, call the base function
    basePlayer(self)

    -- second, we edit it
    local Health = self.Health
    local Power = self.Power
    local AdditionalPower = self.AdditionalPower
    local Combat = self.CombatIndicator
    local Status = self.Status
    local Leader = self.LeaderIndicator
    local MasterLooter = self.MasterLooterIndicator
    local RaidIcon = self.RaidTargetIndicator
    local RestingIndicator = self.RestingIndicator
    local Threat = self.ThreatIndicator

    local FrameWidth, FrameHeight = unpack(C["Units"].Player or { 254, 31 })
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
    Health.Backdrop:SetTripleBorder()
    Health.Backdrop:SetOutside(nil, 2, 2)

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

    -- Power
    Power:ClearAllPoints()
    Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -3)
    Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -3)
    Power:Height(3)
    Power:SetFrameLevel(Health:GetFrameLevel())
    Power:CreateBackdrop()
    Power.Backdrop:SetTripleBorder()
    Power.Backdrop:SetOutside(nil, 2, 2)

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

    -- Portrait
    if (C.UnitFrames.Portrait) then
        local Portrait = self.Portrait

        Portrait:ClearAllPoints()
        Portrait:SetInside(Health, 1, 1)
        Portrait:SetAlpha(.3)
    end

    -- Auras
    if (C.UnitFrames.PlayerAuras and C.UnitFrames.PlayerAuraBars) then
        local AuraBars = self.AuraBars

        local Gap = (T.MyClass == "ROGUE" or T.MyClass == "DRUID") and 8 or 0
        
        AuraBars:ClearAllPoints()
		AuraBars:SetHeight(10)
		AuraBars:SetWidth(FrameWidth)
		AuraBars:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 12 + Gap)
		AuraBars.auraBarTexture = HealthTexture
		-- AuraBars.PostCreateBar = TukuiUnitFrames.PostCreateAuraBar
		AuraBars.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs
		AuraBars.gap = 2
		AuraBars.width = 231
		AuraBars.height = 17
		AuraBars.spellNameObject = Font
		AuraBars.spellTimeObject = Font
		
	elseif (C.UnitFrames.PlayerAuras) then
		local Buffs = self.Buffs
		local Debuffs = self.Debuffs

        local Offset = 0

		Buffs:ClearAllPoints()
        Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", 0, 7 + Offset)
        Buffs.initialAnchor = "TOPLEFT"
        Buffs["growth-y"] = "UP"
        Buffs["growth-x"] = "RIGHT"
        Buffs.size = 22
        Buffs.spacing = 7
        Buffs.num = 9
        Buffs.numRow = 9
        Buffs:Width(Buffs.numRow * Buffs.size + (Buffs.numRow - 1) * Buffs.spacing)
        Buffs:Height(Buffs.size)

        Buffs.PostCreateIcon = UnitFrames.PostCreateAura
		Buffs.PostUpdateIcon = UnitFrames.PostUpdateAura

		Debuffs:ClearAllPoints()
        Debuffs:Point("BOTTOMRIGHT", self, "TOPRIGHT", 0, Buffs.size + 2 * Buffs.spacing)
        Debuffs.initialAnchor = "TOPRIGHT"
        Debuffs["growth-y"] = "UP"
        Debuffs["growth-x"] = "LEFT"
        Debuffs.size = Buffs.size
        Debuffs.spacing = Buffs.spacing
        Debuffs.num = Buffs.num
        Debuffs.numRow = Buffs.numRow
        Debuffs:Width(Debuffs.numRow * Debuffs.size + (Debuffs.numRow - 1) * Debuffs.spacing)
        Debuffs:Height(Debuffs.size)

        Debuffs.PostCreateIcon = UnitFrames.PostCreateAura
        Debuffs.PostUpdateIcon = UnitFrames.PostUpdateAura
        
        if (C.UnitFrames.AurasBelow) then
            Buffs:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -7)
			Debuffs["growth-y"] = "DOWN"
		end
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
    
    -- Resting Indicator
	RestingIndicator:ClearAllPoints()
    RestingIndicator:SetPoint("CENTER", self, "CENTER", 0, 3)
    RestingIndicator:SetSize(16, 16)

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
        CastBar.Backdrop:SetTripleBorder()
        CastBar.Backdrop:SetOutside(nil, 2, 2)

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
            CastBar.Button:SetTripleBorder()
            CastBar.Button:SetOutside(CastBar.Icon, 2, 2)
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
            ComboPoints[i].Backdrop:SetTripleBorder()
            ComboPoints[i].Backdrop:SetOutside(nil, 2, 2)

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

    

    -- Melee Ticks
    if (C.UnitFrames.PowerTick) then
        local EnergyManaRegen = self.EnergyManaRegen

		EnergyManaRegen:ClearAllPoints()
        EnergyManaRegen:SetAllPoints()
        EnergyManaRegen:SetFrameLevel(Power:GetFrameLevel() + 3)

        -- EnergyManaRegen.Spark = CreateFrame("StatusBar", nil, EnergyManaRegen)
        -- EnergyManaRegen.Spark:SetStatusBarColor(1, 1, 0)

        -- EnergyManaRegen.Override  = function(self, elapsed)
        --     local element = self.EnergyManaRegen
        
        --     element.sinceLastUpdate = (element.sinceLastUpdate or 0) + (tonumber(elapsed) or 0)
        
        --     if element.sinceLastUpdate > 0.01 then
        --         local powerType = UnitPowerType("player")
        
        --         if powerType ~= "Energy" and powerType ~= "Mana" then
        --             element.Spark:Hide()
        --             return
        --         end
        
        --         CurrentValue = UnitPower('player', powerType)
        
        --         if powerType == "Mana" and (not CurrentValue or CurrentValue >= UnitPowerMax('player', "Mana")) then
        --             element:SetValue(0)
        --             element.Spark:Hide()
        --             return
        --         end
        
        --         local Now = GetTime() or 0
        --         if not (Now == nil) then
        --             local Timer = Now - LastTickTime
        
        --             if (CurrentValue > LastValue) or powerType == "Energy" and (Now >= LastTickTime + 2) then
        --                 LastTickTime = Now
        --             end
        
        --             if Timer > 0 then
        --                 element.Spark:Show()
        --                 element:SetMinMaxValues(0, 2)
        --                 -- element.Spark:SetVertexColor(1, 1, 1, 1)
        --                 element:SetValue(Timer)
        --                 allowPowerEvent = true
        
        --                 LastValue = CurrentValue
        --             elseif Timer < 0 then
        --                 -- if negative, it's mp5delay
        --                 element.Spark:Show()
        --                 element:SetMinMaxValues(0, Mp5Delay)
        --                 -- element.Spark:SetVertexColor(1, 1, 0, 1)
        
        --                 element:SetValue(math.abs(Timer))
        --             end
        
        --             element.sinceLastUpdate = 0
        --         end
        --     end
        -- end
    end
    
    -- Heal Prediction
    if (C.UnitFrames.HealComm) then
        local HealthPrediction = self.HealthPrediction
        local myBar = HealthPrediction.myBar
		local otherBar = HealthPrediction.otherBar

		-- myBar:SetFrameLevel(Health:GetFrameLevel())
		-- myBar:SetStatusBarTexture(HealthTexture)
		-- myBar:SetPoint("TOP")
		-- myBar:SetPoint("BOTTOM")
		-- myBar:SetPoint("LEFT", Health:GetStatusBarTexture(), "RIGHT")
		-- myBar:SetWidth(250)
		-- myBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommSelfColor))

		-- otherBar:SetFrameLevel(Health:GetFrameLevel())
		-- otherBar:SetPoint("TOP")
		-- otherBar:SetPoint("BOTTOM")
		-- otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		-- otherBar:SetWidth(250)
		-- otherBar:SetStatusBarTexture(HealthTexture)
		-- otherBar:SetStatusBarColor(C.UnitFrames.HealCommOtherColor)
	end
end
