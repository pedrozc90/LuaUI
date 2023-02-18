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
	local ActionBar6 = ActionBars.Bars.Bar6
	local ActionBar7 = ActionBars.Bars.Bar7
	local ActionBar8 = ActionBars.Bars.Bar8

	local PetSize = C.ActionBars.PetButtonSize
	local ButtonSize = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local PetActionBarFrame = T.Retail and PetActionBar or PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	local ButtonsPerRow = C.ActionBars.BarPetButtonsPerRow
	local NumRows = ceil(NUM_PET_ACTION_SLOTS / ButtonsPerRow)

	local Width, Height = ActionBars.GetBackgroundSize(ButtonsPerRow, NumRows, PetSize, Spacing, C.ActionBars.ShowBackdrop)

	PetBar:ClearAllPoints()
	PetBar:SetWidth(Width)
	PetBar:SetHeight(Height)

	if (ActionBar8 and C.ActionBars.Bar8) then
		PetBar:SetPoint("RIGHT", ActionBar8, "LEFT", -Spacing, 0)
	elseif (ActionBar7 and C.ActionBars.Bar7) then
		PetBar:SetPoint("RIGHT", ActionBar7, "LEFT", -Spacing, 0)
	elseif (ActionBar6 and C.ActionBars.Bar6) then
		PetBar:SetPoint("RIGHT", ActionBar6, "LEFT", -Spacing, 0)
	elseif (ActionBar5 and C.ActionBars.LeftBar) then
		PetBar:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (ActionBar4 and C.ActionBars.RightBar) then
		PetBar:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -C.Lua.ScreenMargin, 0)
	end

	if (C.ActionBars.ShowBackdrop) then
		PetBar:SetBackdropTransparent()
		PetBar.Shadow:Kill()
	end
end
