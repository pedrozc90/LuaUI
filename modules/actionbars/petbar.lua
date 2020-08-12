local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

----------------------------------------------------------------
-- PetActionBar
----------------------------------------------------------------
local baseCreatePetBar = ActionBars.CreatePetBar

function ActionBars:CreatePetBar()

	-- first, call the base function
    baseCreatePetBar(self)

    -- second, we edit it
	local Bar = Panels.PetActionBar
	local PetSize = C.ActionBars.PetButtonSize
    local Spacing = C.ActionBars.ButtonSpacing
    
	Bar:ClearAllPoints()
    Bar:Point("RIGHT", Panels.ActionBar5, "LEFT", -7, 0)
    Bar:SetWidth((PetSize * 1) + (Spacing * 2) - 2)
	Bar:SetHeight((PetSize * 10) + (Spacing * 11) - 2)
	Bar.Backdrop:SetTripleBorder("Transparent")
	Bar.Backdrop:SetOutside(nil, 2, 2)

	for i = 1, NUM_PET_ACTION_SLOTS do
        local Button = _G["PetActionButton"..i]
        
		Button:ClearAllPoints()
		Button:Size(PetSize)
		Button:Show()

        if (i == 1) then
            local Offset = Spacing - 1
			Button:SetPoint("TOPLEFT", Bar, "TOPLEFT", Offset, -Offset)
        else
            local PreviousButton = _G["PetActionButton"..(i - 1)]
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		Bar["Button"..i] = Button
	end

	RegisterStateDriver(Bar, "visibility", "[pet,nopetbattle,novehicleui,nooverridebar,nopossessbar,nobonusbar:5] show; hide")
end
