local T, C, L = Tukui:unpack()
local ObjectiveTracker = T.Miscellaneous.ObjectiveTracker
local Movers = T.Movers

----------------------------------------------------------------
-- Objective Tracker
----------------------------------------------------------------
local baseSetDefaultPosition = ObjectiveTracker.SetDefaultPosition
local baseUpdateProgressBar = ObjectiveTracker.UpdateProgressBar

function ObjectiveTracker:SetDefaultPosition()
    -- first, we call the base function
    baseSetDefaultPosition(self)

    -- second, we edit it
    local Anchor1, Parent, Anchor2, X, Y = "TOPRIGHT", UIParent, "TOPRIGHT", -268, -240
	local Data = TukuiDatabase.Variables[T.MyRealm][T.MyName]

	local ObjectiveFrameHolder = _G["TukuiObjectiveTracker"]
	ObjectiveFrameHolder:SetSize(130, 22)
	ObjectiveFrameHolder:SetPoint(Anchor1, Parent, Anchor2, X, Y)

	ObjectiveTrackerFrame:ClearAllPoints()
	ObjectiveTrackerFrame:SetPoint("TOP", ObjectiveFrameHolder, "TOP", 0, 0)
    ObjectiveTrackerFrame:SetHeight(T.ScreenHeight - 520)
	ObjectiveTrackerFrame.IsUserPlaced = function() return true end

	Movers:RegisterFrame(ObjectiveFrameHolder, "Objectives Tracker")

	if Data and Data.Move and Data.Move.TukuiObjectiveTracker then
		ObjectiveFrameHolder:ClearAllPoints()
		ObjectiveFrameHolder:SetPoint(unpack(Data.Move.TukuiObjectiveTracker))
	end
end

--[[
function ObjectiveTracker:UpdateProgressBar(_, line)
    
    -- first, we call the base function
    baseUpdateProgressBar(self, _, line)

    -- second, we edit it
    local Progress = line.ProgressBar
    local Bar = Progress.Bar

    if (Bar) then
        local Label = Bar.Label
        local Icon = Bar.Icon

        if (Bar.IsSkinned) then
            Bar:SetHeight(16)

            if (Label) then
                Label:ClearAllPoints()
                Label:SetPoint("CENTER", Bar, "CENTER", 0, -1)
                Label:SetFont(C.Medias.Font, 12)
            end

            if (Icon) then
                Icon:ClearAllPoints()
                Icon:SetPoint("LEFT", Bar, "RIGHT", 7, 0)
                Icon:SetSize(Bar:GetHeight(), Bar:GetHeight())
                Icon:SetTexCoord(.08, .92, .08, .92)
                Icon:SetTexCoord(unpack(T.IconCoord))
            end
        end
    end
end --]]
