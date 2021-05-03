local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns
local SpellTable = ns.RaidCooldowns.SpellTable

-- WoW API
local UnitGUID = _G.UnitGUID
local UnitClass = _G.UnitClass
local UnitIsUnit = _G.UnitIsUnit

local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMembers

local GetPlayerInfoByGUID = _G.GetPlayerInfoByGUID
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetInspectSpecialization = _G.GetInspectSpecialization
local GetSpecializationInfoByID = _G.GetSpecializationInfoByID
local GetActiveSpecGroup = _G.GetActiveSpecGroup
local GetTalentInfo = _G.GetTalentInfo

----------------------------------------------------------------
-- Raid Cooldowns
----------------------------------------------------------------
if (not C.RaidCD.Enable) then return end

local cache = {}
function RaidCooldowns:ScanGroup()
    local isGrupo, isRaid = IsInGroup(), IsInRaid()
    local size = GetNumGroupMembers()

    -- look for new group members
    for index = 1, size do
        local unit = self:GetGroupUnit(index, size, isGrupo, isRaid)
        local guid = UnitGUID(unit)
        
        if (guid) then
            cache[guid] = true
            if (not self.group[guid]) then
                -- insert guid into inspect queue
                self.group[guid] = { unit = unit, name = UnitName(unit) }
                self:Queue(unit, guid)
            end
        end
    end

    -- look for members who left
    for guid, _ in pairs(self.group) do
        if (not cache[guid]) then
            -- remove guid from inspect queue
            self:Dequeue(guid)
            self.group[guid] = nil
        end
    end

    table.wipe(cache)
end

RaidCooldowns:RegisterEvent("PLAYER_LOGIN")
RaidCooldowns:RegisterEvent("PLAYER_ENTERING_WORLD")
-- RaidCooldowns:RegisterEvent("GROUP_JOINED")
-- RaidCooldowns:RegisterEvent("GROUP_LEFT")
RaidCooldowns:RegisterEvent("INSPECT_READY")
RaidCooldowns:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers.
    self[event](self, ...)
end)

function RaidCooldowns:PLAYER_LOGIN()
    self:SetPoint(unpack(C.RaidCD.Anchor))
    self:SetSize(C.RaidCD.BarWidth, C.RaidCD.BarHeight)
    -- -- self:CreateBackdrop()
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.class = select(2, UnitClass(self.unit))
    self.group = {}

    -- self:SetScript("OnUpdate", self.ProcessQueue)
end

function RaidCooldowns:PLAYER_ENTERING_WORLD(isLogin, isReload)
    if (isLogin or isReload) then
        -- loading ui
        print("login")
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        -- self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        -- self:RegisterEvent("UNIT_SPELLCAST_FAILED")
    else
        -- zoned between map instances
        print("zone changed")
    end
    self:ScanGroup()
end

function RaidCooldowns:GROUP_ROSTER_UPDATE()
    self:ScanGroup()
end

function RaidCooldowns:GROUP_JOINED(category, partyGUID)
    print("GROUP_JOINED", category, partyGUID)
end

function RaidCooldowns:GROUP_LEFT(category, partyGUID)
    print("GROUP_LEFT", category, partyGUID)
end

function RaidCooldowns:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
    local guid = UnitGUID(unit)
    if (spellID == 200749) then -- Activating Specialization
        -- if a unit changes specialization, we need to inspect it again
        -- and update its cooldowns
        self:Queue(unit, guid)
    else
        -- self:UpdateCooldown(unit, spellID)
    end
end

function RaidCooldowns:UNIT_SPELLCAST_FAILED(unit, _, spellID)
    -- self:UpdateCooldown(unit, spellID)
end

function RaidCooldowns:INSPECT_READY(guid)
    local unit = self:GuidToUnit(guid) or self.unit
    local _, class, _, _, _, name, realm = GetPlayerInfoByGUID(guid)
    local isInspect = UnitIsUnit(unit, self.unit)

    realm = self:GetRealm(realm)
    
    local spec = (guid == self.guid) and GetSpecialization() or nil
    local specID = (guid == self.guid) and GetSpecializationInfo(spec) or GetInspectSpecialization(unit)
    if ((not specID) or (specID == 0)) then return end

    local member = self.group[guid]
    member.spec = spec
    member.specID = specID
    
    if (not member.talents) then
        member.talents = {}
    end

    local _, specName, _, _, _, _ = GetSpecializationInfoByID(specID)
    local activeSpec = GetActiveSpecGroup(isInspect)

    for row = 1, MAX_TALENT_TIERS do
        if (not member.talents[row]) then
            member.talents[row] = {}
        end

        for col = 1, NUM_TALENT_COLUMNS do
            local talentID, talentName, _, selected, available, spellID, unknown, _, _, known, grantedByAura = GetTalentInfo(row, col, activeSpec, isInspect, unit)
            print(row, col, talentID, talentName, selected)
            member.talents[row][col] = selected
        end
    end

    self:DequeueByGUID(guid)
end
