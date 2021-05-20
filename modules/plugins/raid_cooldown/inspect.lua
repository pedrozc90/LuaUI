local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns

local UnitGUID = _G.UnitGUID
local UnitIsUnit = _G.UnitIsUnit
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsConnected = _G.UnitIsConnected
local CanInspect = _G.CanInspect
local NotifyInspect = _G.NotifyInspect
local GetRaidRosterInfo = _G.GetRaidRosterInfo
local GetRealZoneText = _G.GetRealZoneText

local TIMEOUT = 10
local THRESHOLD = 0.1
local MAX_ATTEMPTS = 5

local queue, waiting = {}, {}
local last_inspect = 0
local delay = 1.5
local running = false
local current_guid = nil

function RaidCooldowns:InitQueue()
    self:SetScript("OnUpdate", self.ProcessQueue)
    self.elapsed = nil
    running = true
    current_guid = nil
end

function RaidCooldowns:StopQueue()
    self:SetScript("OnUpdate", nil)
    running = false
end

function RaidCooldowns:GetQueueIndex(guid)
    for index, data in ipairs(queue) do
        if (data.guid == guid) then
            return index
        end
    end
    return nil
end

function RaidCooldowns:Queue(unit, guid)
    if (not UnitIsPlayer(unit)) then return end

    local index = self:GetQueueIndex(guid)

    if (UnitIsUnit(unit, "player")) then
        -- print("adding player", unit, guid, "to the inspect queue")
        self:Inspect(guid)
    elseif (not index) then
        table.insert(queue, { guid = guid, attempts = 0, timestamp = GetTime() })
    end

    if (not running) then
        self:InitQueue()
    end
end

function RaidCooldowns:Dequeue(index)
    if (not index) then return end
    table.remove(queue, index)
end

function RaidCooldowns:DequeueByGUID(guid)
    if (not guid) then return end
    local index = self:GetQueueIndex(guid)
    self:Dequeue(index)
    if (current_guid == guid) then
        current_guid = nil
        last_inspect = 0
    end
end

function RaidCooldowns.ProcessQueue(self, elapsed)
    if (InCombatLockdown()) then return end                         -- never inspect while in combat.
    if (UnitIsDead("player")) then return end                       -- you can't inspect while dead, so do not even try.
    if (InspectFrame and InspectFrame:IsShown()) then return end    -- do not mess with UI's inspection.

    self.elapsed = (self.elapsed or 0) + elapsed

    -- run script every 0.1 seconds
    if (self.elapsed < THRESHOLD) then return end

    -- stop loop, if queue is empty
    if (not queue or #queue <= 0) then
        print("QUEUE IS EMPTY")
        self:StopQueue()
        return
    end

    local index = 1
    local entity = queue[index]
    if (not entity) then
        self:Dequeue(index)
        return
    end

    local unit, group_index = self:GuidToUnit(entity.guid)

    -- wait inspect event
    if (current_guid) then
        if (self.elapsed > TIMEOUT) then
            current_guid = nil
            self:Dequeue(index)
            self.elapsed = 0
        end
    else
        if (entity.attempts >= MAX_ATTEMPTS) then
            print("removing", entity.guid, "from queu because max attempts reached");
            self:Dequeue(index)
        else
            local name, _, _, _, _, class, zone, online, isDead, _, _, _ = GetRaidRosterInfo(group_index);
            local current_zone = GetRealZoneText()
            
            -- if (zone ~= GetRealZoneText()) then
            --     print(name .. " is in a differente zone", zone)
            -- else
            if ((not online) or (not UnitIsConnected(unit)) or (not CanInspect(unit))) then
                print(unit, "is offline or unabled to inspect.")
                -- move to the back of the queue
                local tmp = table.remove(queue, index)
                table.insert(queue, tmp)
                -- increment attempts
                entity.attempts = entity.attempts + 1
            else
                print("NOTIFY INSPECT", entity.guid, zone, current_zone, zone == current_zone)
                -- entity.attempts = entity.attempts + 1
                current_guid = entity.guid
                last_inspect = GetTime()
                NotifyInspect(unit)
            end
        end

        -- reset elapsed time
        self.elapsed = 0
    end

    --[[
    for index_2, data in ipairs(waiting) do
        local now = GetTime()
        local tmp = now - (data.timestamp or now)
        if (tmp > 10) then
            table.remove(waiting, index_2)
            
        end
    end
    ]]
end
