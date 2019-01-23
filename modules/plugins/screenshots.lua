local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Achievement ScreenShot by Blamdarot
----------------------------------------------------------------
if (not C.ScreenShots.Enable) then return end

local tremove = table.remove
local tinsert = table.insert

local DIFFICULTY_NORMAL_RAID = 14
local DIFFICULTY_HEROIC_RAID = 15
local DIFFICULTY_MYTHIC_RAID = 16

----------------------------------------------------------------
-- Wait Function
    -- delay: amount of time to wait (in seconds) before the provided function is triggered.
    -- func: function to run once the wait delay is over.
    -- param: list of any additional parameters.
-- NOT MY CODE. Got it here: http://www.wowwiki.com/Wait on January 20th, 2019
----------------------------------------------------------------
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

----------------------------------------------------------------
-- Event Handlers
----------------------------------------------------------------
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
    
    -- call one of the functions above
    self[event](self, ...)
end)

-- register events defined at configuration file
function f:PLAYER_LOGIN()
    if (C.ScreenShots.Debug) then
        self:RegisterEvent("SCREENSHOT_FAILED")
        self:RegisterEvent("SCREENSHOT_SUCCEEDED")
    end

    if (C.ScreenShots.Achievements) then
        self:RegisterEvent("ACHIEVEMENT_EARNED")
    end

    if (C.ScreenShots.ChallengeMode) then
        self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
    end

    if (C.ScreenShots.BossKills) then
        self:RegisterEvent("ENCOUNTER_START")
        self:RegisterEvent("ENCOUNTER_END")
    end

    if (C.ScreenShots.LevelUp) then
        self:RegisterEvent("PLAYER_LEVEL_UP")
    end
end

function f:SCREENSHOT_FAILED(...)
    T.Debug("ScreenShot Failed!")
end

function f:SCREENSHOT_SUCCEEDED(...)
    T.Print("ScreenShot Taken Successfully!")
end

function f:ACHIEVEMENT_EARNED()
    -- takes two screen shot to make sure we get the right moment.
    Wait(1, Screenshot)
    Wait(1.5, Screenshot)
end

function f:CHALLENGE_MODE_COMPLETED()
    -- take an instant screenshot.
    Screenshot()
    -- takes two screen shot to make sure we get the right moment.
    Wait(1, Screenshot)
    Wait(1.5, Screenshot)
end

function f:PLAYER_LEVEL_UP()
    -- take an instant screenshot.
    Screenshot()
    -- wait for the golden glow ends.
    Wait(2.7, Screenshot)
end

function f:ENCOUNTER_START(...)
    local encounterID, encounterName, difficultyID, groupSize = ...

    -- record encounter start time
    self.EncounterStartTime = time()
end

function f:ENCOUNTER_END(...)
    local ecounterID, encounterName, difficultyID, groupSize, sucess = ...

    -- calculate total time until encounter wipe/success
    self.EncounterElapsedTimer = time() - self.EncounterStartTimer

    -- check if encounter was a wipe
    if (sucess == 0) then
        T.Print("Wipe in ", T.FormatTime(self.EncounterElapsedTimer))
        return
    end

    -- check encounter difficulty to take screenshot just on raid encounters.
    if (difficultyID == DIFFICULTY_NORMAL_RAID) or
        (difficultyID == DIFFICULTY_HEROIC_RAID) or
        (difficultyID == DIFFICULTY_MYTHIC_RAID) then
        -- display encounter info
        T.Print("Encounter Defeted:", encounterName)
        T.Print("Encounter Date:", date("%m/%d/%y %H:%M:%S"))
        T.Print("Encounter Time:", string.format("%d minutes %d seconds", math.ceil(self.EncounterElapsedTimer / 60), math.ceil(self.EncounterElapsedTimer % 60)))
        -- take screenshot
        Wait(1, Screenshot)
    end
end