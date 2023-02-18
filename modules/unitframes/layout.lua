local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Chat = T.Chat

local GetSpecialization, GetSpecializationRole = GetSpecialization, GetSpecializationRole
local GetNumGroupMembers = GetNumGroupMembers

----------------------------------------------------------------
-- Layouts
----------------------------------------------------------------

-- move down raid frame if raid get too big
local function ComputeOffset()
    local _, RaidHeight, Padding = C.Raid.WidthSize, C.Raid.HeightSize, C.Raid.Padding
    local _, Raid40Height, Padding40 = C.Raid.Raid40WidthSize, C.Raid.Raid40HeightSize, C.Raid.Padding40

    local numGroupMembers = GetNumGroupMembers()

    -- 40 man raids
    if (numGroupMembers > 20) then
        return (Raid40Height + Padding40)
    -- 20 man mythic raids
    elseif (numGroupMembers > 10) then
        return (RaidHeight + Padding)
    end
    -- until 10 man raid and 5 man dungeons
    return 2 * (RaidHeight + Padding)
end

function UnitFrames:UpdatePosition()
    local spec = GetSpecialization()
    local specRole = GetSpecializationRole(spec)

    if (C.Lua.HealerLayout and (specRole == "HEALER")) then
        self:RaidHealerPosition()
    else
        self:RaidDefaultPosition()
    end
end

function UnitFrames:RaidHealerPosition()
    if (not C.Raid.Enable) then return end

    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet
    local Raid40 = self.Headers.Raid40
    local Raid40Pet = self.Headers.Raid40Pet

    local yPosition = 281                       -- right above filger cooldowns
    local yOffset = ComputeOffset()

    local Anchor = { "BOTTOM", UIParent, "BOTTOM", 0, yPosition + yOffset }

    if (not yOffset) then
        self:RaidDefaultPosition()
    else
        Raid:ClearAllPoints()
        Raid:SetPoint(unpack(Anchor))

        if (C.Raid.ShowPets) then
            RaidPet:ClearAllPoints()
            RaidPet:SetParent(T.PetHider)
            RaidPet:SetPoint(unpack(Anchor))
        end

        Raid40:ClearAllPoints()
        Raid40:SetPoint(unpack(Anchor))

        if (C.Raid.ShowPets) then
            Raid40Pet:ClearAllPoints()
            Raid40Pet:SetParent(T.PetHider)
            Raid40Pet:SetPoint(unpack(Anchor))
        end
    end
end

UnitFrames:RegisterEvent("PLAYER_LOGIN")
UnitFrames:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrames:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
UnitFrames:RegisterEvent("GROUP_ROSTER_UPDATE")
UnitFrames:SetScript("OnEvent", function(self, event, ...)
    if (not self[event]) then return end
    self[event](self, ...)
end)

function UnitFrames:PLAYER_LOGIN()
    self.unit = "player"
end

function UnitFrames:PLAYER_ENTERING_WORLD()
    self:UpdatePosition()
end

-- update raid frame position when spec changes
function UnitFrames:PLAYER_SPECIALIZATION_CHANGED(unit)
    if (self.unit ~= unit) then return end
    self:UpdatePosition()
end

-- update raid frame position when group size changes
function UnitFrames:GROUP_ROSTER_UPDATE()
    self:UpdatePosition()
end
