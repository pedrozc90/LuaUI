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

	StanceBar:ClearAllPoints()
    StanceBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 7, -7)
    StanceBar:SetWidth((PetSize * 10) + (Spacing * 11))
    StanceBar:SetHeight((PetSize * 1) + (Spacing * 2))
    StanceBar.Backdrop:Kill()

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
            Button:SetPoint("BOTTOMLEFT", StanceBar, "BOTTOMLEFT", Spacing, Spacing)
        else
            local Previous = _G["StanceButton" .. (i-1)]
            
			Button:ClearAllPoints()
			Button:SetPoint("LEFT", Previous, "RIGHT", Spacing, 0)
		end
	end
end
