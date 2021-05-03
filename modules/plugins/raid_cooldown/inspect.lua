local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns

local UnitGUID = _G.UnitGUID
local UnitIsUnit = _G.UnitIsUnit
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsConnected = _G.UnitIsConnected

local CanInspect = _G.CanInspect
local NotifyInspect = _G.NotifyInspect

local inspect = {
    queue = {},
    last_inspect = 0,
    timeout = 10,
    threshold = 0.1,
    delay = 1.5,
    max_attempts = 5,
    
    idle = true,
    running = false,
    current_guid = nil
}

function RaidCooldowns:InitQueue()
    self:SetScript("OnUpdate", self.ProcessQueue)
    self.elapsed = nil
    inspect.running = true
end

function RaidCooldowns:StopQueue()
    self:SetScript("OnUpdate", nil)
    inspect.running = false
end

function RaidCooldowns:GetQueueIndex(guid)
    for index, data in ipairs(inspect.queue) do
        if (data.guid == guid) then
            return index
        end
    end
    return nil
end

function RaidCooldowns:Queue(unit, guid)
    if (not UnitIsPlayer(unit)) then return end

    if (UnitIsUnit(unit, "player")) then
        print("adding player", unit, guid, "to the inspect queue")
    elseif (not inspect.queue[guid]) then
        table.insert(inspect.queue, { guid = guid, attempts = 0 })
    end

    if (not inspect.running) then
        self:InitQueue()
    end
end

function RaidCooldowns:Dequeue(index)
    if (not index) then return end
    table.remove(inspect.queue, index)
end

function RaidCooldowns:DequeueByGUID(guid)
    if (not guid) then return end
    local index = self:GetQueueIndex(guid)
    self:Dequeue(index)
end

function RaidCooldowns.ProcessQueue(self, elapsed)
    if (InCombatLockdown()) then return end                         -- never inspect while in combat.
    if (UnitIsDead("player")) then return end                       -- you can't inspect while dead, so do not even try.
    if (InspectFrame and InspectFrame:IsShown()) then return end    -- do not mess with UI's inspection.

    local queue = inspect.queue
    local threshold = inspect.threshold or 0.1
    local timeout = inspect.timeout or 10
    local max_attempts = inspect.max_attempts or 5
    local last_inspect = inspect.last_inspect or 0

    self.elapsed = (self.elapsed or 0) + elapsed

    -- run script every 0.1 seconds
    if (self.elapsed < threshold) then return end

    -- stop loop, if queue is empty
    if (#queue <= 0) then
        self:StopQueue()
        return
    end

    -- if we are waiting the INSPECT_READY event, skip it
    -- if the elapsed time since the NotifyInspect is greater then timeout, inspect the next on the queue

    print("QUEUE", self.elapsed, GetTime(), last_inspect, GetTime() - last_inspect)

    local index = 1
    local entity = queue[index]
    if (not entity) then
        self:Dequeue(index)
        return
    end

    local unit = self:GuidToUnit(entity.guid)

    if ((not unit) or (entity.attempts >= max_attempts)) then
        print(unit, "max attempts reached. remove from the queue.")
        self:Dequeue(index)
    elseif ((not CanInspect(unit)) or (not UnitIsConnected(unit))) then
        print(unit, "is offline or unabled to inspect.")
        -- move to the back of the queue
        local tmp = table.remove(queue, index)
        table.insert(queue, tmp)
        -- increment attempts
        entity.attempts = entity.attempts + 1
    else
        print("notify inspect of", unit, entity.guid)
        inspect.current_guid = entity.guid
        inspect.last_inspect = GetTime()
        NotifyInspect(unit)
    end

    -- reset elapsed time
    self.elapsed = 0
end
