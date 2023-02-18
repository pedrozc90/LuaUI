local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local DataTexts = T.DataTexts.Panels

local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local HasAction = HasAction

----------------------------------------------------------------
-- Utilities
----------------------------------------------------------------
ActionBars.GetActionBarSize = function(number, size, spacing, show_bg)
	if (not show_bg) then
		return (size * number) + (spacing * (number - 1))
	end
	return (size * number) + (spacing * (number + 1))
end

ActionBars.GetBackgroundSize = function(rows, cols, size, spacing, show_bg)
	local a = ActionBars.GetActionBarSize(rows, size, spacing, show_bg)
	local b = ActionBars.GetActionBarSize(cols, size, spacing, show_bg)
	return a, b
end

----------------------------------------------------------------
--[[ Skin ActionBar Buttons
----------------------------------------------------------------
local baseSkinButton = ActionBars.SkinButton
local baseSkinPetAndShiftButton = ActionBars.SkinPetAndShiftButton
local baseMovePetBar = ActionBars.MovePetBar
local baseUpdateStanceBar = ActionBars.UpdateStanceBar
local baseEnable = ActionBars.Enable

	function ActionBars:SkinButton(Button)
	-- first, we call the base function
	baseSkinButton(self, Button)

	-- second, we edit it
	local Name = Button:GetName()
	local Action = Button.action
	local KeybindTex = Button.QuickKeybindHighlightTexture
	local Icon = _G[Name.."Icon"]
	local Count = _G[Name.."Count"]
	local Flash	 = _G[Name.."Flash"]
	local HotKey = _G[Name.."HotKey"]
	local Border = _G[Name.."Border"]
	local Btname = _G[Name.."Name"]
	local Normal = _G[Name.."NormalTexture"]
	local BtnBG = _G[Name.."FloatingBG"]
	local Font = T.GetFont(C["ActionBars"].Font)

	-- Button:SetTemplate("Transparent")

	-- Count
	if (Count) then
		Count:ClearAllPoints()
		Count:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", -2, 2)
	end

	-- HotKey
	if (HotKey) then
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", Button, "TOPRIGHT", -2, -2)
		HotKey:SetTextColor(1, 1, 1)
	end

	if (Btname and C.ActionBars.Macro) then
		Btname:ClearAllPoints()
		Btname:SetPoint("BOTTOM", Button, "BOTTOM", 0, 2)
	end
end

function ActionBars:SkinPetAndShiftButton(Normal, Button, Icon, Name, Pet)
	-- first, we call the base function
	baseSkinPetAndShiftButton(self, Normal, Button, Icon, Name, Pet)

	-- second, we edit it
	local PetSize = C.ActionBars.PetButtonSize
	local HotKey = _G[Button:GetName().."HotKey"]
	local Cooldown = _G[Button:GetName().."Cooldown"]
	local Flash = _G[Name.."Flash"]
	local Font = T.GetFont(C["ActionBars"].Font)

	if (C.ActionBars.HotKey) then
		HotKey:ClearAllPoints()
		HotKey:SetPoint("TOPRIGHT", Button, "TOPRIGHT", 0, 0)
	end
end

function ActionBars:UpdateStanceBar()
	-- first, we call the base function
	baseUpdateStanceBar(self)

	-- second, we edit it
	local StanceBar = self.Bars.Stance
	local ActionBar3 = self.Bars.Bar3
	local NumForms = GetNumShapeshiftForms()

	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local Padding = (C.ActionBars.StanceBarBackground) and Spacing or 0

	local Rows = (not C.ActionBars.VerticalStanceBar) and NumForms or 1
	local Columns = (not C.ActionBars.VerticalStanceBar) and 1 or NumForms

	if (NumForms == 0) then
		if (ActionBar3) then
			ActionBar3:ClearAllPoints()
			ActionBar3:SetPoint("TOPLEFT", UIParent, "TOPLEFT", C.Lua.ScreenMargin, -C.Lua.ScreenMargin)
		end
	else
		local Width, Height = ActionBars.GetBackgroundSize(Rows, Columns, PetSize, Spacing, C.ActionBars.StanceBarBackground)

		StanceBar:SetSize(Width, Height)

		if (ActionBar3) then
			ActionBar3:ClearAllPoints()
			ActionBar3:SetPoint("TOPLEFT", StanceBar, "TOPRIGHT", 3, 0)
		end
	end
end]]--

----------------------------------------------------------------
--[[ Action Slots
----------------------------------------------------------------
local ToggleActionButton = function(self, alpha)
	if (not HasAction(self.action)) then
		self:SetAlpha(alpha)
	end
end

function ActionBars.HideActionSlot(self)
	ToggleActionButton(self, 0)
end

function ActionBars.ShowActionSlot(self)
	ToggleActionButton(self, 1)
end

local UpdateActionBarButtonDisplay = function(ActionBar, index)
	if (index < 1) then return end
	local Button = _G[ActionBar .. index]
	if (HasAction(Button.action)) then
		Button:SetAlpha(1)
	else
		Button:SetAlpha(0)
	end
end

local UpdateMultiBarBottomRight = function(index)
	UpdateActionBarButtonDisplay("MultiBarBottomRightButton", index)
end

function ActionBars:PLAYER_TALENT_UPDATE()
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		UpdateMultiBarBottomRight(i)
	end
end

function ActionBars:ACTIONBAR_SLOT_CHANGED(slot)
	if (slot and slot >= 49 and slot <= 60) then
		UpdateMultiBarBottomRight(slot - 48)
	end
end

function ActionBars:Enable()
	-- first, we call the base function
	baseEnable(self)

	-- second, we edit it
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	self:SetScript("OnEvent", function(self, event, ...)
		self[event](...)
	end)
end]]--
