local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames
local Chat = T.Chat
local Talents = T.Talents

local GetSpecialization = _G.GetSpecialization
local GetSpecializationRole = _G.GetSpecializationRole
local GetNumGroupMembers = _G.GetNumGroupMembers

if ((not C.Raid.Enable) or (not C.Lua.HealerLayout)) then return end
----------------------------------------------------------------
-- Layouts
----------------------------------------------------------------
local DEFAULT = "DEFAULT"
local HEALER = "HEALER"

local element_proto = {
    unit = "player",
    position = DEFAULT,
    groupThreshold = 20
}

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

local function IsHealerClassic()
    local specRole = Talents.GetPlayerRole(T.MyClass)
    return (specRole == "HEALER")
end

local function IsHealerRetail()
    local spec = GetSpecialization()
    local specRole = GetSpecializationRole(spec)
    return (specRole == "HEALER")
end

element_proto.IsHealer = ((T.Retail) and IsHealerRetail or IsHealerClassic)

function element_proto:SetDefaultPosition()
    self:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 5, 215)
end

function element_proto:SetHealerPosition()
    self:SetPoint("BOTTOM", parent, "BOTTOM", 0, 300)
end

function element_proto:GetPosition()
    if self:IsHealer() and GetNumGroupMembers() <= self.groupThreshold then
        return HEALER
    end
    return DEFAULT
end

function element_proto:UpdatePosition()
    -- you are not suppose to move stuff while in combat
    if InCombatLockdown() then return end

    -- prevent event spam updates
    local position = self:GetPosition()
    if position ~= self.position then
        self:ClearAllPoints()
        if position == HEALER then
            self:SetHealerPosition()
        else
            self:SetDefaultPosition()
        end
        self.position = position
    end
end

function element_proto:OnEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isLogin, isReload = ...
        if not isLogin and not isReload then return end
    
    -- fires when player enter combat
    -- so we need to disable events to prevent moving stuff while in combat
    elseif event == "PLAYER_REGEN_DISABLED" then
        self:UnregisterEvent("GROUP_ROSTER_UPDATE")
        self:UnregisterEvent("PLAYER_TALENT_UPDATE")
        self:UnregisterEvent("CHARACTER_POINTS_CHANGED")
        self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
        return

    -- fires when player leave combat
    -- we can move stuff now
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:RegisterEvent("GROUP_ROSTER_UPDATE")

        if T.Cata then
            self:RegisterEvent("PLAYER_TALENT_UPDATE")
        elseif T.Classic then
            self:RegisterEvent("CHARACTER_POINTS_CHANGED")
        else
            self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
        end

        return

    elseif event == "CHARACTER_POINTS_CHANGED" then
        local changes = ...
        if changes ~= -1 then return end
    end

    self:UpdatePosition()
end

function UnitFrames:CreateRaidHolder()
    local rows = 4
    local cols = C.Raid.MaxUnitPerColumn
    local colsSpacing = C.Raid.Padding
    local rowsSpacing = C.Raid.Padding
    local width = C.Raid.WidthSize
    local height = C.Raid.HeightSize

    local element = Mixin(CreateFrame("Frame", "TukuiRaidHolder", T.PetHider), element_proto)
    element:SetWidth(cols * width + (cols - 1) * colsSpacing)
    element:SetHeight(rows * height + (rows - 1) * rowsSpacing)
    element:SetDefaultPosition()
    element:RegisterEvent("PLAYER_ENTERING_WORLD")
    element:RegisterEvent("PLAYER_REGEN_ENABLED")
    element:RegisterEvent("PLAYER_REGEN_DISABLED")
    element:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED")
    element:SetScript("OnEvent", element.OnEvent)
    return element
end
