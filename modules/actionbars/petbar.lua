local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Movers = T.Movers
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

local ceil = math.ceil

----------------------------------------------------------------
-- PetActionBar
----------------------------------------------------------------
local baseCreatePetBar = ActionBars.CreatePetBar

function ActionBars:CreatePetBar()

	-- first, we call the base function
    baseCreatePetBar(self)

    -- second, we edit it
	if (not C.ActionBars.Pet) then return end
	
	local PetBar = ActionBars.Bars.Pet

	local ActionBar4 = ActionBars.Bars.Bar4
	local ActionBar5 = ActionBars.Bars.Bar5

	local PetSize = C.ActionBars.PetButtonSize
	local ButtonSize = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local PetActionBarFrame = PetActionBarFrame
	-- local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local ButtonsPerRow = C.ActionBars.BarPetButtonsPerRow
	local NumRow = ceil(NUM_PET_ACTION_SLOTS / ButtonsPerRow)
	
	local Width = (PetSize * NumRow) + (Spacing * (NumRow + 1)) + 2
	local Height = (PetSize * ButtonsPerRow) + (Spacing * (ButtonsPerRow + 1)) + 2

	PetBar:ClearAllPoints()
    PetBar:SetWidth(Width)
	PetBar:SetHeight(Height)
	if (C.ActionBars.VerticalRightBars) then
		local Padding = ButtonSize + (Spacing * 3) + C.Lua.ScreenMargin
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -Padding, 7)
	elseif (C.ActionBars.LeftBar) then
		PetBar:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (C.ActionBars.RightBar) then
		PetBar:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 7)
	end

	if (C.ActionBars.ShowBackdrop) then
		PetBar:SetBackdropTransparent()
		PetBar.Shadow:Kill()
	end

	local j = 1
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton" .. i]
		local PreviousButton = _G["PetActionButton" .. (i-1)]
		
		-- Button:SetParent(Bar)
		-- Button:ClearAllPoints()
		-- Button:SetSize(PetSize, PetSize)
		-- Button:SetNormalTexture("")
		-- Button:Show()

		if (i == 1) then
			Button:SetPoint("TOPLEFT", PetBar, "TOPLEFT", Spacing + 1, -Spacing - 1)
		elseif  ((i % ButtonsPerRow) == 1) then
			Button:SetPoint("TOPLEFT", _G["PetActionButton" .. j], "TOPRIGHT", Spacing, 0)
			j = j + ButtonsPerRow
		else
			Button:SetPoint("TOPLEFT", PreviousButton, "BOTTOMLEFT", 0, -Spacing)
		end
	end
end
