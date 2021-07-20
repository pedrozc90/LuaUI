local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS

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
    local Offset = (C.ActionBars.StanceBarBackground) and (Spacing + 1) or 0

    local Columns = (not C.ActionBars.VerticalStanceBar) and NUM_STANCE_SLOTS or 1
    local Rows = (not C.ActionBars.VerticalStanceBar) and 1 or NUM_STANCE_SLOTS

    local Width, Height = ActionBars.GetBackgroundSize(Rows, Columns, PetSize, Spacing, C.ActionBars.StanceBarBackground)

	StanceBar:ClearAllPoints()
    StanceBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", C.Lua.ScreenMargin, -C.Lua.ScreenMargin)
    StanceBar:SetWidth(Width)
    StanceBar:SetHeight(Height)

    if (C.ActionBars.ShowBackdrop) then
		StanceBar:SetBackdropTransparent()
		StanceBar.Shadow:Kill() 
	end

    if (C.ActionBars.ShowBackdrop and (not C.ActionBars.StanceBarBackground)) then
        StanceBar.Backdrop:Kill()
    end

	for i = 1, NUM_STANCE_SLOTS do
		local Button = _G["StanceButton"..i]

        Button:ClearAllPoints()
        Button:SetSize(PetSize, PetSize)

        if (i == 1) then
            Button:ClearAllPoints()
            Button:SetPoint("TOPLEFT", StanceBar, "TOPLEFT", Offset, -Offset)
        else
            local Previous = _G["StanceButton" .. (i-1)]

			Button:ClearAllPoints()
            if (C.ActionBars.VerticalStanceBar) then
                Button:SetPoint("TOP", Previous, "BOTTOM", 0, -Spacing)
            else
			    Button:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
            end
		end
	end
end
