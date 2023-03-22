local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Chat = T.Chat
local Talents = T.Talents

local GetSpecialization, GetSpecializationRole = GetSpecialization, GetSpecializationRole
local GetNumGroupMembers = GetNumGroupMembers

if ((not C.Raid.Enable) or (not C.Lua.HealerLayout)) then return end
----------------------------------------------------------------
-- Layouts
----------------------------------------------------------------

-- move down raid frame if raid get too big
local function ComputeOffset(numGroupMembers)
    local _, RaidHeight, Padding = C.Raid.WidthSize, C.Raid.HeightSize, C.Raid.Padding
    local _, Raid40Height, Padding40 = C.Raid.Raid40WidthSize, C.Raid.Raid40HeightSize, C.Raid.Padding40

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

function UnitFrames:IsHealerClassic()
    local specRole = Talents.GetPlayerRole(T.Class)
    return (specRole == "HEALER")
end

function UnitFrames:IsHealerRetail()
    local spec = GetSpecialization()
    local specRole = GetSpecializationRole(spec)
    return (specRole == "HEALER")
end

UnitFrames.IsHealer = ((T.Classic) and UnitFrames.IsHealerClassic or UnitFrames.IsHealerRetail)

function UnitFrames:UpdatePosition()
    if (self:IsHealer()) then
        self:RaidHealerPosition()
    else
        self:RaidDefaultPosition()
    end
end

function UnitFrames:RaidHealerPosition()
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet
    local Raid40 = self.Headers.Raid40
    local Raid40Pet = self.Headers.Raid40Pet

    local numGroupMembers = GetNumGroupMembers() or 0

    if (Raid) then
        Raid:ClearAllPoints()
        Raid:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, 300)

        if (RaidPet) then
            RaidPet:ClearAllPoints()
            RaidPet:SetParent(T.PetHider)
            RaidPet:SetPoint("TOPLEFT", Raid, "TOPRIGHT", C.Raid.Padding, 0)
        end
    end

    if (Raid40) then
        Raid40:ClearAllPoints()
        Raid40:SetPoint("BOTTOM", T.PetHider, "BOTTOM", 0, 300)

        if (Raid40Pet) then
            Raid40Pet:ClearAllPoints()
            Raid40Pet:SetParent(T.PetHider)
            Raid40Pet:SetPoint("TOPLEFT", Raid40, "TOPRIGHT", C.Raid.Padding40, 0)
        end
    end
end

UnitFrames:RegisterEvent("PLAYER_LOGIN")
UnitFrames:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrames:SetScript("OnEvent", function(self, event, ...)
    if (not self[event]) then return end
    self[event](self, ...)
end)

function UnitFrames:PLAYER_LOGIN()
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    if (T.Classic) then
        self:RegisterEvent("SPELLS_CHANGED")
    else
        self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    end
    self.unit = "player"
end

function UnitFrames:PLAYER_ENTERING_WORLD()
    self:UpdatePosition()
end

-- update raid frame position when spec changes
function UnitFrames:PLAYER_SPECIALIZATION_CHANGED(unit)
    if (unit ~= self.unit) then return end
    self:UpdatePosition()
end

if (T.Classic) then
    function UnitFrames:SPELLS_CHANGED(...)
        self:UpdatePosition()
    end
end

-- update raid frame position when group size changes
function UnitFrames:GROUP_ROSTER_UPDATE()
    self:UpdatePosition()
end
