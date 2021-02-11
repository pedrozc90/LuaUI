local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local DataTexts = T.DataTexts.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

----------------------------------------------------------------
-- Skin ActionBar Buttons
----------------------------------------------------------------
local baseSkinButton = ActionBars.SkinButton
local baseSkinPetAndShiftButton = ActionBars.SkinPetAndShiftButton
local baseMovePetBar = ActionBars.MovePetBar

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
        Count:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", 1, 1)
    end

    -- HotKey
    if (HotKey) then
        HotKey:ClearAllPoints()
        HotKey:SetPoint("TOPRIGHT", Button, "TOPRIGHT", -2, -2)
    end

    if (Btname and C.ActionBars.Macro) then
        Btname:ClearAllPoints()
        Btname:SetPoint("BOTTOM", Button, "BOTTOM", 1, 1)
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

function ActionBars:MovePetBar()
    
    -- first, we call the base function
    baseMovePetBar(self)

    -- second, we edit it
    local PetBar = TukuiPetActionBar
	local ActionBar5 = TukuiActionBar5
	local ActionBar4 = TukuiActionBar4
	local Data1 = TukuiData[T.MyRealm][T.MyName].Move.TukuiActionBar5
    local Data2 = TukuiData[T.MyRealm][T.MyName].Move.TukuiPetActionBar
    
    local ButtonSize = C.ActionBars.NormalButtonSize
    local Spacing = C.ActionBars.ButtonSpacing
    local xOffset = 7

	-- Don't run if player moved bar 5 or pet bar
    -- if (Data1 or Data2) then return end
    
    if (C.ActionBars.VerticalRightBars) then
		local Padding = ButtonSize + (Spacing * 3) + xOffset
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -Padding, 7)
	elseif (C.ActionBars.LeftBar) then
		PetBar:SetPoint("RIGHT", ActionBar5, "LEFT", -Spacing, 0)
	elseif (C.ActionBars.RightBar) then
		PetBar:SetPoint("RIGHT", ActionBar4, "LEFT", -Spacing, 0)
	else
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -xOffset, 7)
	end
end
