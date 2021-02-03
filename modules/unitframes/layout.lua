local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Chat = T.Chat.Panels

if (not C.Lua.Enable) then return end

----------------------------------------------------------------
-- Layouts
----------------------------------------------------------------
function UnitFrames:UpdatePosition()
    local spec = GetSpecialization()
    local specRole = GetSpecializationRole(spec)

    if (C.Lua.HealerLayout and (specRole == "HEALER")) then
        self:SetHealerLayout()
    else
        self:SetDefaultLayout()
    end
end

function UnitFrames:SetDefaultLayout()
    local Anchor = self.Anchor
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet
    local Holder = self.GroupHolder

    local LeftChatBG = Chat.LeftChat

    Holder:ClearAllPoints()
    Holder:SetPoint("TOPLEFT", LeftChatBG, "TOPLEFT", 0, 0)
    Holder:SetSize(LeftChatBG:GetWidth(), 20)
    Holder:SetAlpha(0)

    if (C.Raid.Enable) then
        Raid:ClearAllPoints()
        Raid:SetPoint("BOTTOMLEFT", LeftChatBG, "TOPLEFT", 0, 7)

        if (C.Raid.ShowPets) then
            RaidPet:ClearAllPoints()
            RaidPet:SetPoint("BOTTOMLEFT", Raid, "TOPLEFT", 0, 7)
        end
    end
end

function UnitFrames:SetHealerLayout()
    local Anchor = self.Anchor
    local Raid = self.Headers.Raid
    local RaidPet = self.Headers.RaidPet
    local Holder = self.GroupHolder

    local NumberPerRow = 5
    local Spacing = 7
    local Width, Height = unpack(C.Units.Raid)
    local yOffset = 0

    -- move down raid frame if raid get too big
    local numGroupMembers = GetNumGroupMembers()
    if (numGroupMembers > 5) then
        yOffset = 39
    elseif (numGroupMembers > 10) then
        yOffset = 78
    elseif (numGroupMembers > 20) then
        self:SetDefaultLayout()
        return
    end

    Holder:ClearAllPoints()
    Holder:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 220 - yOffset)
    Holder:SetSize((NumberPerRow * Width) + (NumberPerRow - 1) * Spacing, 20)
    Holder:SetAlpha(0)

    if (C.Raid.Enable) then
        Raid:ClearAllPoints()
        Raid:SetPoint("BOTTOMLEFT", Holder, "TOPLEFT", 0, 7)
    end
end

UnitFrames:RegisterEvent("PLAYER_LOGIN")
UnitFrames:RegisterEvent("PLAYER_ENTERING_WORLD")
UnitFrames:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
UnitFrames:RegisterEvent("GROUP_ROSTER_UPDATE")
UnitFrames:SetScript("OnEvent", function(self, event, ...)
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
