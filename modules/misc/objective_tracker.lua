local T, C, L = Tukui:unpack()
local ObjectiveTracker = T.Miscellaneous.ObjectiveTracker
local Movers = T.Movers

----------------------------------------------------------------
-- Objective Tracker
----------------------------------------------------------------
local baseSetDefaultPosition = ObjectiveTracker.SetDefaultPosition

local anchor = { "TOPRIGHT", UIParent, "TOPRIGHT", -268, -240 }

function ObjectiveTracker:SetDefaultPosition()
    -- first, we call the base function
    baseSetDefaultPosition(self)

    -- second, we edit it
    local Data = TukuiDatabase.Variables[T.MyRealm][T.MyName]

    if (T.Retail) then
        local ObjectiveFrameHolder = _G["TukuiObjectiveTracker"]
        ObjectiveFrameHolder:SetSize(130, 22)
        ObjectiveFrameHolder:SetPoint(unpack(anchor))

        ObjectiveTrackerFrame:ClearAllPoints()
        ObjectiveTrackerFrame:SetPoint("TOP", ObjectiveFrameHolder, "TOP", 0, 0)
        ObjectiveTrackerFrame:SetHeight(T.ScreenHeight - 520)
        ObjectiveTrackerFrame.IsUserPlaced = function() return true end

        Movers:RegisterFrame(ObjectiveFrameHolder, "Objectives Tracker")

        if (Data and Data.Move and Data.Move.TukuiObjectiveTracker) then
            ObjectiveFrameHolder:ClearAllPoints()
            ObjectiveFrameHolder:SetPoint(unpack(Data.Move.TukuiObjectiveTracker))
        end
    else
        -- local ObjectiveFrameHolder = self.Holder

		-- QuestWatchFrame:SetParent(ObjectiveFrameHolder)
		-- QuestWatchFrame:ClearAllPoints()
		-- QuestWatchFrame:SetPoint("TOPLEFT")

		-- if Data and Data.Move and Data.Move.TukuiObjectiveTracker then
		-- 	ObjectiveFrameHolder:ClearAllPoints()
		-- 	ObjectiveFrameHolder:SetPoint(unpack(Data.Move.TukuiObjectiveTracker))
		-- end

		-- Movers:RegisterFrame(ObjectiveFrameHolder)
    end
end
