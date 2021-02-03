local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local Chat = T.Chat
local Class = select(2, UnitClass("player"))

----------------------------------------------------------------
-- Health
----------------------------------------------------------------
function UnitFrames:PreUpdateHealth(unit)
    local UniColor = C.Lua.UniColor
	local HostileColor = C["UnitFrames"].TargetEnemyHostileColor

	if ((UniColor == true) or (HostileColor ~= true)) then
		return
	end

	if UnitIsEnemy(unit, "player") then
		self.colorClass = false
	else
		self.colorClass = true
	end
end

----------------------------------------------------------------
-- Auras
----------------------------------------------------------------
function UnitFrames:PostCreateAuraBar(bar)

    -- second, we edit it
    if (not bar.Backdrop) then

        bar.spark:Kill()
        
        bar:CreateBackdrop("Transparent")
        bar.Backdrop:SetOutside()
        bar.icon:ClearAllPoints()
        bar.icon:SetPoint("RIGHT", bar, "LEFT", -(self.gap or 2), 0)
        bar.icon:SetSize(self.height, self.height)
        bar.icon:SetTexCoord(unpack(T.IconCoord))

        bar.button = CreateFrame("Frame", nil, bar)
        bar.button:CreateBackdrop()
        bar.button:SetOutside(bar.icon)
        bar.button:SetFrameLevel(bar:GetFrameLevel() - 3)

	end
end

function UnitFrames:UpdateBuffsHeaderPosition(height)
	local Frame = self:GetParent()
    local Buffs = Frame.Buffs
    local AuraBars = Frame.AuraBars

	if (Buffs) then
        Buffs:ClearAllPoints()
        Buffs:SetPoint("BOTTOMLEFT", Frame, "TOPLEFT", 0, height)
    elseif (AuraBars) then
        AuraBars:ClearAllPoints()
        AuraBars:SetPoint("BOTTOMLEFT", Frame, "TOPLEFT", 0, height)
    end
end

-- local function PostCreateAura(self, button)
-- 	local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

-- 	-- Skin aura button
-- 	button:SetBackdrop(nil)
-- 	button.Shadow:Kill()
-- 	button:CreateBackdrop()

-- 	-- remaining time to aura expire
-- 	button.Remaining:ClearAllPoints()
-- 	button.Remaining:SetPoint("CENTER", button, "CENTER", 2, 1)
-- 	button.Remaining:SetFont(Font, FontSize, FontStyle)

-- 	-- cooldown
-- 	button.cd:ClearAllPoints()
-- 	button.cd:SetInside(button, 0, 0)

-- 	-- artwork
-- 	button.icon:SetInside(button, 0, 0)

-- 	-- count
-- 	button.count:ClearAllPoints()
-- 	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
-- 	button.count:SetFont(Font, FontSize, FontStyle)
-- 	button.count:SetJustifyH("RIGHT")
-- end
-- hooksecurefunc(UnitFrames, "PostCreateAura", PostCreateAura)

-- function UnitFrames:PostUpdateAura(unit, button, index, offset, filter, isDebuff, duration, timeLeft)
-- 	local _, _, _, DType, Duration, ExpirationTime, UnitCaster, IsStealable = UnitAura(unit, index, button.filter)

-- 	if button then
-- 		if(button.filter == "HARMFUL") then
-- 			if(not UnitIsFriend("player", unit) and not button.isPlayer) then
--                 button.icon:SetDesaturated(true)
--                 if (button.Backdrop) then
--                     button.Backdrop:SetBackdropBorderColor(unpack(C["General"].BorderColor))
--                 else
--                     button:SetBackdropBorderColor(unpack(C["General"].BorderColor))
--                 end
-- 			else
-- 				local color = DebuffTypeColor[DType] or DebuffTypeColor.none
--                 button.icon:SetDesaturated(false)
--                 if (button.Backdrop) then
--                     button.Backdrop:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
--                 else
--                     button:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
--                 end
-- 			end
-- 		else
-- 			if button.Animation then
-- 				if (IsStealable or DType == "Magic") and not UnitIsFriend("player", unit) and not button.Animation.Playing then
-- 					button.Animation:Play()
-- 					button.Animation.Playing = true
-- 				else
-- 					button.Animation:Stop()
-- 					button.Animation.Playing = false
-- 				end
-- 			end
-- 		end

-- 		if button.Remaining then
-- 			if Duration and Duration > 0 then
-- 				button.Remaining:Show()
-- 			else
-- 				button.Remaining:Hide()
-- 			end

-- 			button:SetScript("OnUpdate", UnitFrames.CreateAuraTimer)
-- 		end

-- 		button.Duration = Duration
-- 		button.TimeLeft = ExpirationTime
-- 		button.First = true
-- 	end
-- end

-- function UnitFrames:UpdateDebuffsHeaderPosition()
--     local Parent = self:GetParent()
--     local Debuffs = Parent.Debuffs
--     local AltPower = Parent.AlternativePower

--     local NumBuffs = self.visibleBuffs
-- 	local PerRow = self.numRow
--     local Size = self.size
--     local Spacing = self.spacing or 7
--     local Row = math.ceil((NumBuffs / PerRow))
--     local yOffset = Row * (Size + Spacing)

--     Debuffs:ClearAllPoints()
--     if (AltPower and AltPower:IsShown()) then
--         Debuffs:SetPoint("BOTTOMLEFT", AltPower, "TOPLEFT", 0, Spacing)
--     else
--         Debuffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, yOffset)
--     end

-- end

-- ----------------------------------------------------------------
-- -- CastBar
-- ----------------------------------------------------------------
-- function UnitFrames:CheckInterrupt(unit)
-- 	if (unit == "vehicle") then
-- 		unit = "player"
-- 	end

--     if (self.notInterruptible and UnitCanAttack("player", unit)) then
-- 		self:SetStatusBarColor(.87, .37, .37, 0.7)
-- 	else
-- 		self:SetStatusBarColor(.31, .45, .63, 0.5)
-- 	end
-- end

-- ----------------------------------------------------------------
-- -- Threat
-- ----------------------------------------------------------------
-- function UnitFrames:UpdateThreat(event, unit)
-- 	if (not C.UnitFrames.Threat) or (unit ~= self.unit) then return end

--     local Threat = UnitThreatSituation(unit)

--     if ((Threat) and (Threat > 2)) then
--         local r, g, b = .69, .31, .31
--         self.Health:SetBackdropBorderColor(r, g, b)
--         self.Power:SetBackdropBorderColor(r, g, b)
--     else
--         self.Health:SetBackdropBorderColor(unpack(C["General"].BorderColor))
--         self.Power:SetBackdropBorderColor(unpack(C["General"].BorderColor))
--     end
-- end

-- ----------------------------------------------------------------
-- -- Group Role
-- ----------------------------------------------------------------
-- function UnitFrames:UpdateGroupRole(role)
--     self:SetTexCoord(unpack(T.IconCoord))
--     if (role == "TANK") then
--         self:SetTexture(C.Medias.roleTANK)
--         self:Show()
--     elseif (role == "HEALER") then
--         self:SetTexture(C.Medias.roleHEALER)
--         self:Show()
--     else
--         self:Hide()
--     end
-- end

-- ----------------------------------------------------------------
-- -- Name
-- ----------------------------------------------------------------
-- function UnitFrames:UpdateNamePosition()
-- 	if (self.Power.Value:GetText() and UnitIsEnemy("player", "target")) then
--         self.Name:ClearAllPoints()
--         self.Name:SetParent(self.Health)
-- 		self.Name:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
--     else
--         self.Power.Value:SetAlpha(0)

-- 		self.Name:ClearAllPoints()
--         self.Name:SetParent(self.Health)
--         self.Name:SetPoint("LEFT", self.Health, "LEFT", 5, 1)
-- 	end
-- end

----------------------------------------------------------------
-- Highlights
----------------------------------------------------------------
-- change target party/raid units border color.
function UnitFrames:Highlight()
    local Highlight = self.Backdrop

    if (not self.Backdrop) then return end
    
    local colors = T.Colors.assets["Highlight"]

    if UnitIsUnit("focus", self.unit) then
        self.Backdrop:SetBackdropBorderColor(unpack(colors["focus"]))
        -- PowerBackdrop:SetBackdropBorderColor(unpack(colors["focus"]))
    elseif UnitIsUnit("target", self.unit) then
        self.Backdrop:SetBackdropBorderColor(unpack(colors["target"]))
        -- PowerBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
    else
        self.Backdrop:SetBackdropBorderColor(unpack(colors["none"]))
        -- PowerBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
    end
end

-- -- change target nameplate border color.
-- function UnitFrames:HighlightPlate()
--     local HealthBackdrop = self.Health.Backdrop
--     local PowerBackdrop = self.Power.Backdrop
--     local colors = T.Colors.assets["Highlight"]

--     if (HealthBackdrop) then
--         if (UnitIsUnit("target", self.unit)) then
--             HealthBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
--         else
--             HealthBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
--         end
--     end

--     if (PowerBackdrop) then
--         if (UnitIsUnit("target", self.unit)) then
--             PowerBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
--         else
--             PowerBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
--         end
--     end
-- end

----------------------------------------------------------------
-- NamePlates
----------------------------------------------------------------
function UnitFrames:DisplayNameplatePowerAndCastBar(unit, cur, min, max)
	if (not unit) then unit = self:GetParent().unit end
	if (not unit) then return end

	if not cur then
		cur, max = UnitPower(unit), UnitPowerMax(unit)
	end

	local CurrentPower = cur
	local MaxPower = max
	local Nameplate = self:GetParent()
	local PowerBar = Nameplate.Power
	local CastBar = Nameplate.Castbar
	local Health = Nameplate.Health
	local IsPowerHidden = PowerBar.IsHidden

    -- check if unit has a power bar
    if (not CastBar:IsShown()) and (CurrentPower and CurrentPower == 0) and (MaxPower and MaxPower == 0) then
		if (not IsPowerHidden) then
			Health:ClearAllPoints()
            Health:SetPoint("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
            Health:SetPoint("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
            Health:SetHeight(C["NamePlates"].Height)

			PowerBar:Hide()
			PowerBar.IsHidden = true
		end
	else
		if (IsPowerHidden) then
			Health:ClearAllPoints()
            Health:SetPoint("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
            Health:SetPoint("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
            Health:SetHeight(C["NamePlates"].Height - 4)

			PowerBar:Show()
			PowerBar.IsHidden = false
		end
	end
end

----------------------------------------------------------------
-- UnitFrames Anchor
----------------------------------------------------------------
local baseCreateUnits = UnitFrames.CreateUnits

function UnitFrames:CreateUnits()

    -- first, we call the base function
    baseCreateUnits(self)

    -- second, we edit it
    if (not C.UnitFrames.Enable) then return end

    -- local Anchor = UnitFrames.Anchor

    local Player = self.Units.Player
    local Target = self.Units.Target
    local TargetOfTarget = self.Units.TargetOfTarget
    local Pet = self.Units.Pet
    local Focus = self.Units.Focus
    local FocusTarget = self.Units.FocusTarget
    local Arena = self.Units.Arena
    local Boss = self.Units.Boss
    local Party = self.Headers.Party
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet

    local ActionBar1 = ActionBars.Bars.Bar1
    local ActionBar2Left = ActionBars.Bars.Bar2Left
    local ActionBar2Right = ActionBars.Bars.Bar2Right
    local RightChatBG = Chat.Panels.RightChat

    Player:ClearAllPoints()
    Player:SetPoint("BOTTOMLEFT", ActionBar2Left, "TOPLEFT", 1, 31)
    Player:SetSize(unpack(C.Units.Player))

    Target:ClearAllPoints()
    Target:SetPoint("BOTTOMRIGHT",  ActionBar2Right, "TOPRIGHT", -1, 31)
    Target:SetSize(unpack(C.Units.Target))

    TargetOfTarget:ClearAllPoints()
    TargetOfTarget:SetPoint("BOTTOM",  ActionBar1, "TOP", 0, 31)
    TargetOfTarget:SetSize(unpack(C.Units.TargetOfTarget))

    Pet:ClearAllPoints()
    Pet:SetPoint("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", -1, 2)
    Pet:SetSize(unpack(C.Units.Pet))

    Focus:ClearAllPoints()
    Focus:SetPoint("BOTTOMLEFT",  RightChatBG, "TOPLEFT", 1, 2)
    Focus:SetSize(unpack(C.Units.Focus))

    FocusTarget:ClearAllPoints()
    FocusTarget:SetPoint("BOTTOM", Focus, "TOP", 0, 34)
    FocusTarget:SetSize(unpack(C.Units.FocusTarget))

    if (C.UnitFrames.Arena) then
        for i = 1, 5 do
            Arena[i]:ClearAllPoints()
            Arena[i]:SetSize(unpack(C.Units.Arena))
            if (i == 1) then
                Arena[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", -225, 275)
            else
                Arena[i]:SetPoint("TOP", Arena[i - 1], "BOTTOM", 0, -34)
            end
        end
    end

    if (C.UnitFrames.Boss) then
        for i = 1, 5 do
            Boss[i]:ClearAllPoints()
            Boss[i]:SetSize(unpack(C.Units.Boss))
            if (i == 1) then
                Boss[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", -225, 275)
            else
                Boss[i]:SetPoint("TOP", Boss[i - 1], "BOTTOM", 0, -34)
            end
        end
    end

    -- if (C.Party.Enable) then
    --     Party:ClearAllPoints()
    --     Party:SetPoint("LEFT", UIParent, "LEFT", 7, 150)
    -- end

    -- -- frame for raid frame positioning
    -- UnitFrames.GroupHolder = CreateFrame("Frame", "GroupHolder", UIParent)
    -- UnitFrames.GroupHolder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 270)
    -- UnitFrames.GroupHolder:SetSize(250, 20)
    -- UnitFrames.GroupHolder:CreateBackdrop("Transparent")

    -- if (C.Raid.Enable) then
    --     Raid:ClearAllPoints()
    --     Raid:SetPoint("BOTTOMLEFT", Panels.LeftChatBG, "TOPLEFT", 0, 7)

    --     if (C.Raid.ShowPets) then
    --         RaidPet:ClearAllPoints()
    --         RaidPet:SetPoint("BOTTOMLEFT", Raid, "TOPLEFT", 0, 7)
    --     end
    -- end
end

-- T.UnitFrames = UnitFrames
