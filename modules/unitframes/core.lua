local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Panels = T.Panels
local Class = select(2, UnitClass("player"))

local LibClassicDurations = LibStub("LibClassicDurations")

----------------------------------------------------------------
-- Health
----------------------------------------------------------------
function UnitFrames:PreUpdateHealth(unit)
    local UniColor = C["Lua"].UniColor
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
local basePostCreateAura = UnitFrames.PostCreateAura

function UnitFrames:PostCreateAura(button)

    basePostCreateAura(self, button)

	local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"

    -- Skin aura button
    button:NoTemplate()
    button:CreateBackdrop()
    button.Backdrop:SetTripleBorder()
    button.Backdrop:SetOutside(nil, 2, 2)
	
	-- remaining time to aura expire
	button.Remaining:ClearAllPoints()
	button.Remaining:Point("CENTER", button, "CENTER", 2, 1)
	button.Remaining:SetFont(Font, FontSize, FontStyle)

	-- cooldown
	button.cd:ClearAllPoints()
	button.cd:SetInside(button, 0, 0)
	
    -- artwork
    button.icon:ClearAllPoints()
	button.icon:SetInside(button, 0, 0)
	
	-- count
	button.count:ClearAllPoints()
	button.count:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, 0)
	button.count:SetFont(Font, FontSize, FontStyle)
	button.count:SetJustifyH("RIGHT")
end

function UnitFrames:PostUpdateAura(unit, button, index, offset, filter, isDebuff, duration, timeLeft)
	local Name, _, _, DType, Duration, ExpirationTime, UnitCaster, IsStealable, _, SpellID = UnitAura(unit, index, button.filter)

	if Duration == 0 and ExpirationTime == 0 then
		Duration, ExpirationTime = LibClassicDurations:GetAuraDurationByUnit(unit, SpellID, UnitCaster, Name)
		
		button.IsLibClassicDuration = true
	else
		button.IsLibClassicDuration = false
	end

	if button then
		if(button.filter == "HARMFUL") then
			if (not UnitIsFriend("player", unit) and not button.isPlayer) then
				button.icon:SetDesaturated(true)
				if (button.Backdrop) then
                    button.Backdrop:SetBackdropBorderColor(unpack(C["General"].BorderColor))
                else
                    button:SetBackdropBorderColor(unpack(C["General"].BorderColor))
                end
			else
				local color = DebuffTypeColor[DType] or DebuffTypeColor.none
				button.icon:SetDesaturated(false)
				if (button.Backdrop) then
                    button.Backdrop:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
                else
                    button:SetBackdropBorderColor(color.r * 0.8, color.g * 0.8, color.b * 0.8)
                end
			end
		else
			-- These classes can purge, show them
			if (button.Animation) and (T.MyClass == "PRIEST") or (T.MyClass == "SHAMAN") then
				if (DType == "Magic") and (not UnitIsFriend("player", unit)) and (not button.Animation.Playing) then
					button.Animation:Play()
					button.Animation.Playing = true
				else
					button.Animation:Stop()
					button.Animation.Playing = false
				end
			end
		end

		if button.Remaining then
			if (Duration and Duration > 0) then
				button.Remaining:Show()
			else
				button.Remaining:Hide()
			end

			button:SetScript("OnUpdate", UnitFrames.CreateAuraTimer)
		end

		if (button.cd) and (button.IsLibClassicDuration) then
			if (Duration and Duration > 0) then
				button.cd:SetCooldown(ExpirationTime - Duration, Duration)
				button.cd:Show()
			else
				button.cd:Hide()
			end
		end

		button.Duration = Duration
		button.TimeLeft = ExpirationTime
		button.Elapsed = GetTime()
	end
end

function UnitFrames:UpdateDebuffsHeaderPosition()
    local Parent = self:GetParent()
    local Debuffs = Parent.Debuffs
    local AltPower = Parent.AlternativePower

    local NumBuffs = self.visibleBuffs
	local PerRow = self.numRow
    local Size = self.size
    local Spacing = self.spacing or 7
    local Row = math.ceil((NumBuffs / PerRow))
    local yOffset = Row * (Size + Spacing)

    Debuffs:ClearAllPoints()
    if (AltPower and AltPower:IsShown()) then
        Debuffs:SetPoint("BOTTOMLEFT", AltPower, "TOPLEFT", 0, Spacing)
    else
        Debuffs:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, yOffset)
    end
	
end

----------------------------------------------------------------
-- CastBar
----------------------------------------------------------------
function UnitFrames:CheckInterrupt(unit)
	if (unit == "vehicle") then
		unit = "player"
	end

    if (self.notInterruptible and UnitCanAttack("player", unit)) then
		self:SetStatusBarColor(.87, .37, .37, 0.7)
	else
		self:SetStatusBarColor(.31, .45, .63, 0.5)
	end
end

----------------------------------------------------------------
-- Threat
----------------------------------------------------------------
function UnitFrames:UpdateThreat(event, unit)
	if (not C.UnitFrames.Threat) or (unit ~= self.unit) then return end

    local Threat = UnitThreatSituation(unit)

    if ((Threat) and (Threat > 2)) then
        local r, g, b = .69, .31, .31
        self.Health:SetBackdropBorderColor(r, g, b)
        self.Power:SetBackdropBorderColor(r, g, b)
    else
        self.Health:SetBackdropBorderColor(unpack(C["General"].BorderColor))
        self.Power:SetBackdropBorderColor(unpack(C["General"].BorderColor))
    end
end

----------------------------------------------------------------
-- Group Role
----------------------------------------------------------------
function UnitFrames:UpdateGroupRole(role)
    self:SetTexCoord(unpack(T.IconCoord))
    if (role == "TANK") then
        self:SetTexture(C.Medias.roleTANK)
        self:Show()
    elseif (role == "HEALER") then
        self:SetTexture(C.Medias.roleHEALER)
        self:Show()
    else
        self:Hide()
    end
end

----------------------------------------------------------------
-- Name
----------------------------------------------------------------
function UnitFrames:UpdateNamePosition()
	if (self.Power.Value:GetText() and UnitIsEnemy("player", "target")) then
        self.Name:ClearAllPoints()
        self.Name:SetParent(self.Health)
		self.Name:SetPoint("CENTER", self.Health, "CENTER", 0, 1)
    else
        self.Power.Value:SetAlpha(0)

		self.Name:ClearAllPoints()
        self.Name:SetParent(self.Health)
        self.Name:SetPoint("LEFT", self.Health, "LEFT", 5, 1)
	end
end

----------------------------------------------------------------
-- Highlights
----------------------------------------------------------------
-- change target party/raid units border color.
function UnitFrames:Highlight()
    local HealthBackdrop = self.Health.Backdrop
    local PowerBackdrop = self.Power.Backdrop
    local colors = T.Colors.assets["Highlight"]

    -- if UnitIsUnit("focus", self.unit) then
    --     HealthBackdrop:SetBackdropBorderColor(unpack(colors["focus"]))
    --     PowerBackdrop:SetBackdropBorderColor(unpack(colors["focus"]))
    -- elseif UnitIsUnit("target", self.unit) then
    --     HealthBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
    --     PowerBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
	-- else
    --     HealthBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
    --     PowerBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
	-- end
end

-- change target nameplate border color.
function UnitFrames:HighlightPlate()
    local HealthBackdrop = self.Health.Backdrop
    local PowerBackdrop = self.Power.Backdrop
    local colors = T.Colors.assets["Highlight"]

    if (HealthBackdrop) then
        if (UnitIsUnit("target", self.unit)) then
            HealthBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
        else
            HealthBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
        end
    end

    if (PowerBackdrop) then
        if (UnitIsUnit("target", self.unit)) then
            PowerBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
        else
            PowerBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
        end
    end
end

----------------------------------------------------------------
-- NamePlates
----------------------------------------------------------------
function UnitFrames:DisplayNameplatePowerAndCastBar(unit, cur, min, max)
	if (not unit) then unit = self:GetParent().unit end
	if (not unit) then return end

	if (not cur) then
		cur, max = UnitPower(unit), UnitPowerMax(unit)
	end

	local CurrentPower = cur
	local MaxPower = max
	local Nameplate = self:GetParent()
	local PowerBar = Nameplate.Power
	local CastBar = Nameplate.Castbar
	local Health = Nameplate.Health
    local IsPowerHidden = C.NamePlates.PowerBar and PowerBar.IsHidden or false

    -- check if unit has a power bar
    if (CastBar and (not CastBar:IsShown())) and (CurrentPower and CurrentPower == 0) and (MaxPower and MaxPower == 0) then
		if (not IsPowerHidden) then
			Health:ClearAllPoints()
            Health:Point("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
            Health:Point("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
            Health:Height(C["NamePlates"].Height)

			PowerBar:Hide()
			PowerBar.IsHidden = true
		end
	else
		if (IsPowerHidden) then
			Health:ClearAllPoints()
            Health:Point("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
            Health:Point("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
            Health:Height(C["NamePlates"].Height - 4)

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

    -- first, call the base function
    baseCreateUnits(self)

    -- second, we edit it
    local Anchor = UnitFrames.Anchor

    local Player = UnitFrames.Units.Player
    local Target = UnitFrames.Units.Target
    local TargetOfTarget = UnitFrames.Units.TargetOfTarget
    local Pet = UnitFrames.Units.Pet
    local Focus = UnitFrames.Units.Focus
    local FocusTarget = UnitFrames.Units.FocusTarget
    local Arena = UnitFrames.Units.Arena
    local Boss = UnitFrames.Units.Boss
    local Party = UnitFrames.Headers.Party
    local Raid = UnitFrames.Headers.Raid
    local RaidPet = UnitFrames.Headers.RaidPet

    Player:ClearAllPoints()
    Player:SetPoint("BOTTOMLEFT", Anchor, "TOPLEFT", 0, 34)
    Player:Size(unpack(C.Units.Player))
    Player.Shadow:Kill()
    
    Target:ClearAllPoints()
    Target:SetPoint("BOTTOMRIGHT",  Anchor, "TOPRIGHT", 0, 34)
    Target:Size(unpack(C.Units.Target))
    Target.Shadow:Kill()
    
    TargetOfTarget:ClearAllPoints()
    TargetOfTarget:SetPoint("BOTTOM",  Anchor, "TOP", 0, 37)
    TargetOfTarget:Size(unpack(C.Units.TargetOfTarget))
    TargetOfTarget.Shadow:Kill()
    
    Pet:ClearAllPoints()
    Pet:SetPoint("BOTTOMRIGHT", Panels.RightChatBG, "TOPRIGHT", 0, 7)
    Pet:Size(unpack(C.Units.Pet))
    Pet.Shadow:Kill()

    if (C.Party.Enable) then
        Party:ClearAllPoints()
        Party:Point("LEFT", UIParent, "LEFT", 7, 150)
    end

    -- frame for raid frame positioning
    UnitFrames.GroupHolder = CreateFrame("Frame", "GroupHolder", UIParent)
    UnitFrames.GroupHolder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 270)
    UnitFrames.GroupHolder:SetSize(250, 20)
    UnitFrames.GroupHolder:CreateBackdrop("Transparent")
    UnitFrames.GroupHolder:SetAlpha(0)

    if (C.Raid.Enable) then
        Raid:ClearAllPoints()
        Raid:Point("BOTTOMLEFT", Panels.LeftChatBG, "TOPLEFT", 0, 7)

        if (C.Raid.ShowPets) then
            RaidPet:ClearAllPoints()
            RaidPet:Point("BOTTOMLEFT", Raid, "TOPLEFT", 0, 7)
        end
    end
end
