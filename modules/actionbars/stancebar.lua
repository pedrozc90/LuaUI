local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS       -- 10

----------------------------------------------------------------
-- StanceBar
----------------------------------------------------------------
local baseCreateStanceBar = ActionBars.CreateStanceBar

function ActionBars:CreateStanceBar()

    -- first, we call the base function
    baseCreateStanceBar(self)

    -- second, we edit it
    if (not C.ActionBars.ShapeShift) then return end

	local StanceBar = ActionBars.Bars.Stance
	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
    local Padding = (C.ActionBars.StanceBarBackground) and Spacing or 0

	StanceBar:ClearAllPoints()
    StanceBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", C.Lua.ScreenMargin, -C.Lua.ScreenMargin)
    StanceBar:SetWidth((PetSize * NUM_STANCE_SLOTS) + (Spacing * NUM_STANCE_SLOTS))
    StanceBar:SetHeight(PetSize)
    if (not C.ActionBars.StanceBarBackground) then
        StanceBar.Backdrop:Kill()
    end

    if (C.ActionBars.ShowBackdrop) then
		StanceBar:SetBackdropTransparent()
		StanceBar.Shadow:Kill()
	end

	for i = 1, NUM_STANCE_SLOTS do
		local Button = _G["StanceButton"..i]

        Button:ClearAllPoints()
        Button:SetSize(PetSize, PetSize)

        if (i == 1) then
            Button:ClearAllPoints()
            Button:SetPoint("TOPLEFT", StanceBar, "TOPLEFT", Padding, -Padding)
        else
            local Previous = _G["StanceButton" .. (i-1)]
            
			Button:ClearAllPoints()
			Button:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
		end
	end
end
