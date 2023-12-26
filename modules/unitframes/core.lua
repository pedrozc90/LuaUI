local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local ActionBars = T.ActionBars
local Chat = T.Chat
local Class = select(2, UnitClass("player"))
local Colors = T.Colors

local match = string.match

----------------------------------------------------------------
-- Health
----------------------------------------------------------------
function UnitFrames:GetSize(unit)
    if (unit == "player") then
        return C.UnitFrames.PlayerWidth, C.UnitFrames.PlayerHeight
    elseif (unit == "target") then
        return C.UnitFrames.TargetWidth, C.UnitFrames.TargetHeight
    elseif (unit == "targettarget") then
        return C.UnitFrames.TargetOfTargetWidth, C.UnitFrames.TargetOfTargetHeight
    elseif (unit == "pet") then
        return C.UnitFrames.PetWidth, C.UnitFrames.PetHeight
    elseif (unit == "focus") then
        return C.UnitFrames.FocusWidth, C.UnitFrames.FocusHeight
    elseif (unit:find("arena%d")) then
        return C.UnitFrames.ArenaWidth, C.UnitFrames.ArenaHeight
    elseif (unit:find("boss%d")) then
        return C.UnitFrames.BossWidth, C.UnitFrames.BossHeight
    end
end

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

local basePostCreateAura = UnitFrames.PostCreateAura
function UnitFrames:PostCreateAura(button, unit)
    basePostCreateAura(self, button, unit)

    if (button and button.Shadow) then
        button.Shadow:Kill()
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
        Raid:SetPoint("BOTTOMLEFT", T.PetHider, "BOTTOMLEFT", xOffset, yOffset)

        if (RaidPet) then
            RaidPet:ClearAllPoints()
            RaidPet:SetParent(T.PetHider)
            RaidPet:SetPoint("TOPLEFT", Raid, "TOPRIGHT", C.Raid.Padding, 0)
        end
    end

    if (Raid40) then
        local xOffset = C.Lua.ScreenMargin or 5
        local yOffset = C.Chat.LeftHeight + xOffset + 3

        Raid40:ClearAllPoints()
        Raid40:SetParent(T.PetHider)
        Raid40:SetPoint("BOTTOMLEFT", T.PetHider, "BOTTOMLEFT", xOffset, yOffset)

        if (Raid40Pet) then
            Raid40Pet:ClearAllPoints()
            Raid40Pet:SetParent(T.PetHider)
            Raid40Pet:SetPoint("TOPLEFT", Raid40, "TOPRIGHT", C.Raid.Padding40, 0)
        end
    end
end

function UnitFrames:CreateUnits()
    -- first, we call the base function
    baseCreateUnits(self)

    -- second, we edit it
    if (not C.UnitFrames.Enable) then return end

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

    do
        local xPos, yPos = 312, 75

        Player:ClearAllPoints()
        Player:SetPoint("BOTTOM", T.PetHider, "BOTTOM", -xPos, yPos)
        Player:SetSize(C.UnitFrames.PlayerWidth, C.UnitFrames.PlayerHeight)

        Target:ClearAllPoints()
        Target:SetPoint("BOTTOM", T.PetHider, "BOTTOM", xPos, yPos)
        Target:SetSize(C.UnitFrames.TargetWidth, C.UnitFrames.TargetHeight)

        TargetOfTarget:ClearAllPoints()
        TargetOfTarget:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, yPos)
        TargetOfTarget:SetSize(C.UnitFrames.TargetOfTargetWidth, C.UnitFrames.TargetOfTargetHeight)
    end

    Pet:ClearAllPoints()
    Pet:SetPoint("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 25)
    Pet:SetSize(C.UnitFrames.PetWidth, C.UnitFrames.PetHeight)

    Focus:ClearAllPoints()
    Focus:SetPoint("BOTTOMLEFT", RightChatBG, "TOPLEFT", 0, 25)
    Focus:SetSize(C.UnitFrames.FocusWidth, C.UnitFrames.FocusHeight)

    FocusTarget:ClearAllPoints()
    FocusTarget:SetPoint("BOTTOM", Focus, "TOP", 0, 26)
    FocusTarget:SetSize(C.UnitFrames.FocusTargetWidth, C.UnitFrames.FocusTargetHeight)

    if (C.UnitFrames.Arena) then
        for i = 1, 5 do
            Arena[i]:ClearAllPoints()
            Arena[i]:SetSize(C.UnitFrames.ArenaWidth, C.UnitFrames.ArenaHeight)
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
            Boss[i]:SetSize(C.UnitFrames.BossWidth, C.UnitFrames.BossHeight)
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
