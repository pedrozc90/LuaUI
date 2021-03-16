local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Panels = T.Panels
local Talents = T.Talents

if (not C.Lua.HealerLayout.Enable) then return end
----------------------------------------------------------------
-- Layouts
----------------------------------------------------------------
function UnitFrames:UpdatePosition()
    local isHealer = (Talents.isHealer() == "HEALER")
    if (isHealer) then
        self:SetHealerLayout()
    else
        self:SetDefaultLayout()
    end
end

function UnitFrames:SetDefaultLayout()
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet

    local LeftChatBG = Panels.LeftChatBG

    if (C.Raid.Enable) then
        Raid:ClearAllPoints()
        Raid:Point("BOTTOMLEFT", LeftChatBG, "TOPLEFT", 0, 7)

        if (C.Raid.ShowPets) then
            RaidPet:ClearAllPoints()
            RaidPet:Point("BOTTOMLEFT", Raid, "TOPLEFT", 0, 7)
        end
    end
end

function UnitFrames:SetHealerLayout()
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet

    local Width, Height = C.Raid.WidthSize, C.Raid.HeightSize
    local yOffset = Height

    -- move down raid frame if raid get too big
    local numGroupMembers = GetNumGroupMembers()
    if (numGroupMembers > 20) then
        self:SetDefaultLayout()
        return
    elseif (numGroupMembers > 10) then
        yOffset = Height
    elseif (numGroupMembers > 5) then
        yOffset = 2 * Height
    end

    if (C.Raid.Enable) then
        Raid:ClearAllPoints()
        Raid:Point("BOTTOM", UIParent, "BOTTOM", 0, 200 + yOffset)

        if (C.Raid.ShowPets) then
            RaidPet:ClearAllPoints()
            Raid:Point("BOTTOM", UIParent, "BOTTOM", 0, 200 + yOffset)
        end
    end
end

UnitFrames:RegisterEvent("PLAYER_LOGIN")
UnitFrames:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function UnitFrames:SPELLS_CHANGED(...)
    self:UpdatePosition()
end

function UnitFrames:PLAYER_LOGIN()
    self.unit = "player"
    if (C.Lua.HealerLayout.Enable == "auto") then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("SPELLS_CHANGED")
    end
end

function UnitFrames:PLAYER_ENTERING_WORLD()
    -- get instance/continent information
    local inInstance = IsInInstance()
    local instanceName, instanceType, difficultyID, difficultyName, maxPlayers,
    dynamicDifficulty, isDynamic, instanceID, instanceGroupSize = GetInstanceInfo()

    if (C.Lua.HealerLayout.OnlyInInstance and not inInstance) then
        return
    end

    self:UpdatePosition()
end

-- update raid frame position when group size changes
function UnitFrames:GROUP_ROSTER_UPDATE()
    self:UpdatePosition()
end
