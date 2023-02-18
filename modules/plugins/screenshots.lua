local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Achievement ScreenShot by Blamdarot
----------------------------------------------------------------
if (not C.ScreenShots.Enable) then return end

local EncounterDifficulty = {
    -- Dungeon
    [1] = false,            -- Normal
    [2] = false,            -- Heroic
    [8] = true,             -- Mythic Keystone
    [23] = true,            -- Muthic (Dungeon)
    -- Raid
    [3] = false,            -- Normal 10-man
    [4] = false,            -- Normal 25-man
    [5] = true,             -- Heroic 10-man
    [6] = true,             -- Heroic 25-man
    [14] = true,            -- Normal
    [15] = true,            -- Heroic
    [16] = true,            -- Mythic
}

local ZoneTypes = {
    ["none"] = false,                           -- when outside an instance
    ["pvp"] = false,                            -- when in a battleground
    ["arena"] = false,                          -- when in an arena
    ["party"]= true,                            -- when in a 5-man instance
    ["raid"] = true,                            -- when in a raid instance
    ["scenario"] = false,                       -- when in a scenario
    -- nil when in an unknown kind of instance
}

----------------------------------------------------------------
-- Wait Function
-- delay: amount of time to wait (in seconds) before the provided function is triggered.
-- func: function to run once the wait delay is over.
-- param: list of any additional parameters.
-- NOT MY CODE. Got it here: http://www.wowwiki.com/Wait on January 20th, 2019
----------------------------------------------------------------
local tremove = table.remove
local tinsert = table.insert

local waitTable = {}
local waitFrame = nil

-- wait a specified amount of time (in seconds) before triggering another function.
local function Wait(delay, func, ...)
    if (type(delay) ~= "number") or (type(func) ~= "function") then
        return false
    end
    if (waitFrame == nil) then
        waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
        waitFrame:SetScript("OnUpdate", function(self, elapse)
            local count = #waitTable
            local i = 1
            while (i <= count) do
                local waitRecord = tremove(waitTable, i)
                local d = tremove(waitRecord, 1)
                local f = tremove(waitRecord, 1)
                local p = tremove(waitRecord, 1)
                if (d > elapse) then
                    tinsert(waitTable, i, { d - elapse, f, p })
                    i = i + 1
                else
                    count = count - 1
                    f(unpack(p))
                end
            end
        end);
    end
    tinsert(waitTable, { delay, func, {...} })
    return true
end

-- return a formatted time string.
local function GetEncounterTime(ElapsedTimer)
    local minutes = math.ceil(ElapsedTimer / 60)
    local seconds = math.ceil(ElapsedTimer % 60)
    return string.format("%d minutes %d seconds", minutes, seconds)
end

----------------------------------------------------------------
-- Event Handlers
----------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers
    if (not self[event]) then return end
    self[event](self, ...)
end)

-- register events defined at configuration file
function f:PLAYER_LOGIN()
    -- enable debug messages
    if (C.ScreenShots.Messages) then
        self:RegisterEvent("SCREENSHOT_FAILED")
        self:RegisterEvent("SCREENSHOT_SUCCEEDED")
    end

    -- achiemente screenshots
    if (C.ScreenShots.Achievements) then
        self:RegisterEvent("ACHIEVEMENT_EARNED")
    end

    if (C.ScreenShots.ChallengeMode) then
        self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    end

    if (C.ScreenShots.LevelUp) then
        self:RegisterEvent("PLAYER_LEVEL_UP")
    end

    -- self.EncounterStartTimer = 0
    -- self.EncounterElapsedTimer = 0
    if (C.ScreenShots.BossKills) then
        self:RegisterEvent("PLAYER_ENTERING_WORLD")
    end
end

function f:PLAYER_ENTERING_WORLD()
    local inInstance, instanceType = IsInInstance()
    local isRegistered = self:IsEventRegistered("BOSS_KILL")

    if (inInstance and ZoneTypes[instanceType]) then
        if (isRegistered) then
            self:UnregisterEvent("BOSS_KILL")
        end
        self:RegisterEvent("ENCOUNTER_START")
        self:RegisterEvent("ENCOUNTER_END")
    else
        self:RegisterEvent("BOSS_KILL")
        self:UnregisterEvent("ENCOUNTER_START")
        self:UnregisterEvent("ENCOUNTER_END")
    end
end

function f:SCREENSHOT_FAILED(...)
    T.Debug("ScreenShot Failed")
end

function f:SCREENSHOT_SUCCEEDED(...)
    T.Print("ScreenShot Taken")
end

function f:ACHIEVEMENT_EARNED(...)
    local achievementID, arg2 = ...
    local id, name, points, completed, month, day, year, description, flags,
    icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

    -- delay 1 sec to wait achievement warning to show.
    Wait(1, Screenshot)
end

function f:BOSS_KILL(...)
    local bossID, bossName = ...

    if (bossName) then
        -- display bos
        if (C.ScreenShots.Messages) then
            T.Print("Boss Killed:", bossName)
        end
        -- delay 1 sec before take screenshot.
        Wait(1, Screenshot)
    end
end

function f:CHALLENGE_MODE_COMPLETED()
    -- delay 1 sec to wait the right moment.
    Wait(1, Screenshot)
end

function f:ENCOUNTER_START(...)
    local encounterID, encounterName, difficultyID, groupSize = ...

    -- record encounter start time
    self.EncounterStartTimer = time()
end

function f:ENCOUNTER_END(...)
    local ecounterID, encounterName, difficultyID, groupSize, sucess = ...
    local difficulty, groupType = GetDifficultyInfo(difficultyID)

    -- calculate total time until encounter wipe/success
    self.EncounterElapsedTimer = time() - self.EncounterStartTimer

    -- check if encounter was a wipe
    if (sucess == 0) then 
        T.Print(encounterName, "Wipe.")
        T.Print("Time:", GetEncounterTime(self.EncounterElapsedTimer))
        return
    end

    -- filter encounters difficulty which we want to take screenshots.
    if (EncounterDifficulty[difficultyID]) then
        -- display encounter info
        T.Print("Defeted", encounterName, difficulty, "(" .. groupSize .. "-man)")
        T.Print("Date:", date("%m/%d/%y %H:%M:%S"))
        T.Print("Time:", GetEncounterTime(self.EncounterElapsedTimer))

        -- take screenshot
        Wait(1, Screenshot)
    end
end

function f:PLAYER_LEVEL_UP()
    -- delay enough for the golden glow ends.
    Wait(2.7, Screenshot)
end
