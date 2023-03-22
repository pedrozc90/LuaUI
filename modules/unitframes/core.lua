local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local Chat = T.Chat
local Class = select(2, UnitClass("player"))

local match = string.match

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
        bar.icon:SetPoint("RIGHT", bar, "LEFT", -(self.gap or 3), 0)
        bar.icon:SetSize(self.height, self.height)
        bar.icon:SetTexCoord(unpack(T.IconCoord))

        bar.button = CreateFrame("Frame", nil, bar)
        bar.button:CreateBackdrop()
        bar.button:SetOutside(bar.icon)
        bar.button:SetFrameLevel(bar:GetFrameLevel() - 3)
    end
end

-- local UpdateBuffsHeaderPosition = function(self, height)
--     local Parent = self:GetParent()
--     local Buffs = Parent.Buffs
--     local AuraBars = Parent.AuraBars

-- 	if (Buffs) then
--         Buffs:ClearAllPoints()
--         Buffs:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", -1, height)
--     elseif (AuraBars) then
--         AuraBars:ClearAllPoints()
--         AuraBars:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", -1, height)
--     end
-- end

-- function UnitFrames:MoveBuffHeaderUp()
--     UpdateBuffsHeaderPosition(self, self:GetHeight() + 5)
-- end

-- function UnitFrames:MoveBuffHeaderDown()
--     UpdateBuffsHeaderPosition(self, 3)
-- end

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

-- ----------------------------------------------------------------
-- -- Highlights
-- ----------------------------------------------------------------
-- local SelectHighlightColor = function(unit)
--     if UnitIsUnit("focus", unit) then
--         return { 0.65, 0.65, 0.65, 1 }
--     elseif UnitIsUnit("target", unit) then
--         return { 0.32, 0.65, 0.32, 1 }
--     end
--     return C.General.BorderColor
-- end

-- -- change target party/raid units border color.
-- -- function UnitFrames:Highlight()
-- --     print(self:GetName())
-- --     if (not self.Backdrop) then return end

-- --     local r, g, b, a = unpack(SelectHighlightColor(self.unit))

-- --     print(self:GetName(), self.Backdrop ~= nil, self.Backdrop.BorderTop ~= nil, "color", r, g, b, a)

-- --     if (self.Backdrop.BorderTop) then
-- --         self.Backdrop:SetBorderColor(r, g, b, a or 1)
-- --     else
-- --         self.Backdrop:SetBackdropColor(r, g, b, a or 1)
-- --     end
-- -- end

-- -- -- change target nameplate border color.
-- -- function UnitFrames:HighlightPlate()
-- --     local HealthBackdrop = self.Health.Backdrop
-- --     local PowerBackdrop = self.Power.Backdrop
-- --     local colors = T.Colors.assets["Highlight"]

-- --     if (HealthBackdrop) then
-- --         if (UnitIsUnit("target", self.unit)) then
-- --             HealthBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
-- --         else
-- --             HealthBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
-- --         end
-- --     end

-- --     if (PowerBackdrop) then
-- --         if (UnitIsUnit("target", self.unit)) then
-- --             PowerBackdrop:SetBackdropBorderColor(unpack(colors["target"]))
-- --         else
-- --             PowerBackdrop:SetBackdropBorderColor(unpack(colors["none"]))
-- --         end
-- --     end
-- -- end

-- ----------------------------------------------------------------
-- -- NamePlates
-- ----------------------------------------------------------------
-- function UnitFrames:DisplayNameplatePowerAndCastBar(unit, cur, min, max)
-- 	if (not unit) then unit = self:GetParent().unit end
-- 	if (not unit) then return end

-- 	if not cur then
-- 		cur, max = UnitPower(unit), UnitPowerMax(unit)
-- 	end

-- 	local CurrentPower = cur
-- 	local MaxPower = max
-- 	local Nameplate = self:GetParent()
-- 	local PowerBar = Nameplate.Power
-- 	local CastBar = Nameplate.Castbar
-- 	local Health = Nameplate.Health
-- 	local IsPowerHidden = PowerBar.IsHidden

--     -- check if unit has a power bar
--     if (not CastBar:IsShown()) and (CurrentPower and CurrentPower == 0) and (MaxPower and MaxPower == 0) then
-- 		if (not IsPowerHidden) then
-- 			Health:ClearAllPoints()
--             Health:SetPoint("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
--             Health:SetPoint("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
--             Health:SetHeight(C["NamePlates"].Height)

-- 			PowerBar:Hide()
-- 			PowerBar.IsHidden = true
-- 		end
-- 	else
-- 		if (IsPowerHidden) then
-- 			Health:ClearAllPoints()
--             Health:SetPoint("TOPLEFT", Nameplate, "TOPLEFT", 0, 0)
--             Health:SetPoint("TOPRIGHT", Nameplate, "TOPRIGHT", 0, 0)
--             Health:SetHeight(C["NamePlates"].Height - 4)

-- 			PowerBar:Show()
-- 			PowerBar.IsHidden = false
-- 		end
-- 	end
-- end

----------------------------------------------------------------
-- UnitFrames Anchor
----------------------------------------------------------------
local baseCreateUnits = UnitFrames.CreateUnits

function UnitFrames:RaidDefaultPosition()
    local LeftChatBG = Chat.Panels.LeftChat

    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet
    local Raid40 = self.Headers.Raid40
    local Raid40Pet = self.Headers.Raid40Pet

    if (Raid) then
        local xOffset = C.Lua.ScreenMargin or 5
        local yOffset = C.Chat.LeftHeight + xOffset + 3
        
        Raid:ClearAllPoints()
        Raid:SetParent(T.PetHider)
        -- Raid:SetPoint("BOTTOMLEFT", LeftChatBG, "TOPLEFT", 1, 3)
        Raid:SetPoint("BOTTOMLEFT", T.PetHider, "BOTTOMLEFT", xOffset, yOffset)
        -- Raid:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, 300)

        if (RaidPet) then
            RaidPet:ClearAllPoints()
            RaidPet:SetParent(T.PetHider)
            -- RaidPet:SetPoint("TOPLEFT", Raid, "TOPRIGHT", C.Raid.Padding, 0)
            RaidPet:SetPoint("TOPLEFT", Raid, "TOPRIGHT", C.Raid.Padding, 0)
        end
    end

    if (Raid40) then
        local xOffset = C.Lua.ScreenMargin or 5
        local yOffset = C.Chat.LeftHeight + xOffset + 3

        Raid40:ClearAllPoints()
        Raid40:SetParent(T.PetHider)
        -- Raid40:SetPoint("BOTTOMLEFT", LeftChatBG, "TOPLEFT", 1, 3)
        Raid40:SetPoint("BOTTOMLEFT", T.PetHider, "BOTTOMLEFT", xOffset, yOffset)
        -- Raid40:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, 300)

        if (Raid40Pet) then
            Raid40Pet:ClearAllPoints()
            Raid40Pet:SetParent(T.PetHider)
            -- Raid40Pet:SetPoint("TOPLEFT", Raid40, "TOPRIGHT", C.Raid.Padding40, 0)
            Raid40Pet:SetPoint("TOPLEFT", Raid40, "TOPRIGHT", C.Raid.Padding40, 0)
        end
    end
end

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

    local ActionBar1 = _G["TukuiActionBar1"]            -- ActionBars.Bars.Bar1
    local ActionBar2Left = _G["TukuiActionBar2Left"]    -- ActionBars.Bars.Bar2Left
    local ActionBar2Right = _G["TukuiActionBar2Right"]  -- ActionBars.Bars.Bar2Right
    local RightChatBG = Chat.Panels.RightChat
    local LeftChatBG = Chat.Panels.LeftChat

    Player:ClearAllPoints()
    Player:SetPoint("BOTTOM", T.PetHider, "BOTTOM", -312, 75)
    Player:SetSize(unpack(C.Units.Player))

    Target:ClearAllPoints()
    Target:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 312, 75)
    Target:SetSize(unpack(C.Units.Target))

    TargetOfTarget:ClearAllPoints()
    TargetOfTarget:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, 75)
    TargetOfTarget:SetSize(unpack(C.Units.TargetOfTarget))

    Pet:ClearAllPoints()
    Pet:SetPoint("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 4)
    Pet:SetSize(unpack(C.Units.Pet))

    Focus:ClearAllPoints()
    Focus:SetPoint("BOTTOMLEFT", RightChatBG, "TOPLEFT", 0, 4)
    Focus:SetSize(unpack(C.Units.Focus))

    FocusTarget:ClearAllPoints()
    FocusTarget:SetPoint("BOTTOM", Focus, "TOP", 0, 34)
    FocusTarget:SetSize(unpack(C.Units.FocusTarget))

    if (C.UnitFrames.Arena) then
        for i = 1, 5 do
            Arena[i]:ClearAllPoints()
            Arena[i]:SetSize(unpack(C.Units.Arena))
            if (i == 1) then
                Arena[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", -525, 275)
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
                Boss[i]:SetPoint("TOPRIGHT", UIParent, "RIGHT", -525, 275)
            else
                Boss[i]:SetPoint("TOP", Boss[i - 1], "BOTTOM", 0, -34)
            end
        end
    end

    if (C.Party.Enable) then
        local Party = self.Headers.Party
        local Pet = self.Headers.RaidPet

        Party:ClearAllPoints()
        Party:SetParent(T.PetHider)
        Party:SetPoint("LEFT", T.PetHider, "LEFT", 7, 150)

        if (C.Party.ShowPets) then
            Pet:ClearAllPoints()
            Pet:SetParent(T.PetHider)
            Pet:SetPoint("TOPLEFT", T.PetHider, "TOPLEFT", 7, -28)
        end
    end

    if (C.Raid.Enable) then
        self:RaidDefaultPosition()
    end
end
