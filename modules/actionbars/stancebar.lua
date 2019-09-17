local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS

if (not C.ActionBars.ShapeShift) then return end

----------------------------------------------------------------
-- StanceBar
----------------------------------------------------------------
local baseCreateStanceBar = ActionBars.CreateStanceBar

function ActionBars:CreateStanceBar()

    -- first, call the base function
    baseCreateStanceBar(self)

    -- second, we edit it
	local StanceBar = Panels.StanceBar
	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing

	StanceBar:ClearAllPoints()
    StanceBar:Point("TOPLEFT", UIParent, "TOPLEFT", 1, -1)
    StanceBar:Width((PetSize * 10) + (Spacing * 11))
    StanceBar:Height((PetSize * 1) + (Spacing * 2))
    StanceBar.Backdrop:Kill()

	for i = 1, NUM_STANCE_SLOTS do
		local Button = _G["StanceButton"..i]

        Button:ClearAllPoints()
        Button:Size(PetSize)

        if (i == 1) then
            local Offset = Spacing + 1
            Button:Point("TOPLEFT", StanceBar, "TOPLEFT", Offset, -Offset)
        else
            local PreviousButton = _G["StanceButton"..i-1]
			Button:Point("LEFT", PreviousButton, "RIGHT", Spacing, 0)
		end
	end

	RegisterStateDriver(StanceBar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")
end
