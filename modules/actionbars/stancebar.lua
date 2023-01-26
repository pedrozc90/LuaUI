local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS or 10

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

    -- if (C.ActionBars.ShowBackdrop and (not C.ActionBars.StanceBarBackground)) then
    if (StanceBar.Backdrop) then
        StanceBar.Backdrop:Kill()
    end

	for i = 1, NUM_STANCE_SLOTS do
		local Button = _G["StanceButton"..i]
        local FakeButton = _G["TukuiStanceActionBarButton"..i]

        if (not T.Retail) then
			Button:SetParent(Bar)
		end

        FakeButton:ClearAllPoints()
        FakeButton:SetSize(PetSize, PetSize)

        if (i == 1) then
            FakeButton:ClearAllPoints()
            FakeButton:SetPoint("TOPLEFT", StanceBar, "TOPLEFT", Padding, -Padding)
        else
            local Previous = _G["TukuiStanceActionBarButton"..i-1]

			FakeButton:ClearAllPoints()
            if (C.ActionBars.VerticalStanceBar) then
                FakeButton:SetPoint("TOP", Previous, "BOTTOM", 0, -Spacing)
            else
			    FakeButton:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
            end
		end
	end
end
