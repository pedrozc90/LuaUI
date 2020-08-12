local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

----------------------------------------------------------------
-- Skin ActionBar Buttons
----------------------------------------------------------------
local function SkinButton(self)
    local Button = self
    local Name = self:GetName()
	local Icon = _G[Name.."Icon"]
	local Count = _G[Name.."Count"]
	local Flash	 = _G[Name.."Flash"]
	local HotKey = _G[Name.."HotKey"]
	local Border  = _G[Name.."Border"]
	local Btname = _G[Name.."Name"]
	local Normal  = _G[Name.."NormalTexture"]
	local BtnBG = _G[Name.."FloatingBG"]

    Button:SetTripleBorder()

    -- Count
    if (Count) then
        Count:ClearAllPoints()
        Count:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, 2)
    end

    -- HotKey
    if (HotKey) then
        HotKey.ClearAllPoints = ClearAllPoints
        HotKey.SetPoint = SetPoint
        
        HotKey:ClearAllPoints()
        HotKey:Point("TOPRIGHT", self, "TOPRIGHT", 0, 0)

        HotKey.ClearAllPoints = function() end
        HotKey.SetPoint = function() end
    end

    if (Btname) then
        Btname:ClearAllPoints()
        Btname:Point("BOTTOM", self, "BOTTOM", 2, 2)
    end
end
hooksecurefunc(ActionBars, "SkinButton", SkinButton)

----------------------------------------------------------------
-- Skinning Pet and Shift Buttons
----------------------------------------------------------------
local function SkinPetAndShiftButton(self, Normal, Button, Icon, Name, Pet)
	local HotKey = _G[Button:GetName().."HotKey"]
	local Flash = _G[Name.."Flash"]
    
    local PetSize = C.ActionBars.PetButtonSize

    Button:SetTripleBorder()

	if (HotKey) then
		HotKey:ClearAllPoints()
		HotKey:Point("TOPRIGHT", Button, "TOPRIGHT", 0, 0)
	end
end
hooksecurefunc(ActionBars, "SkinPetAndShiftButton", SkinPetAndShiftButton)

----------------------------------------------------------------
-- PetActionBars Position
----------------------------------------------------------------
function ActionBars:MovePetBar()
	local PetBar = Panels.PetActionBar
    local ActionBar4 = Panels.ActionBar4
    local ActionBar5 = Panels.ActionBar5

    local Spacing = C.ActionBars.ButtonSpacing

	if (ActionBar5:IsVisible()) then
        PetBar:SetPoint("RIGHT", ActionBar5, "LEFT", -7, 0)
    elseif (ActionBar4:IsVisible()) then
        PetBar:SetPoint("RIGHT", ActionBar4, "LEFT", -7, 0)
	else
		PetBar:SetPoint("RIGHT", UIParent, "RIGHT", -7, 35)
	end
end

----------------------------------------------------------------
-- Editing ActionBars Panels Layout and Anchor
----------------------------------------------------------------
local function AddPanels()
    local Bar1 = Panels.ActionBar1
	local Bar2 = Panels.ActionBar2
	local Bar3 = Panels.ActionBar3
	local Bar4 = Panels.ActionBar4
    local Bar5 = Panels.ActionBar5
	local PetBar = Panels.PetActionBar
    local StanceBar = Panels.StanceBar
    
    local Size = C.ActionBars.NormalButtonSize
	local PetSize = C.ActionBars.PetButtonSize
    local Spacing = C.ActionBars.ButtonSpacing

    -- Bar #6
	local Bar6 = CreateFrame("Frame", "TukuiActionBar6", UIParent, "SecureHandlerStateTemplate")
	Bar6:SetPoint("LEFT", UIParent, "LEFT", 28, 8)
	Bar6:SetFrameStrata("LOW")
	Bar6:SetFrameLevel(10)
	Bar6.Backdrop = CreateFrame("Frame", nil, Bar6)
	Bar6.Backdrop:SetAllPoints()
    Bar6.Backdrop:Hide()
    
    T.Panels.ActionBar6 = Bar6
end
hooksecurefunc(ActionBars, "AddPanels", AddPanels)

----------------------------------------------------------------
-- Editing ActionBars Panels Layout and Anchor
----------------------------------------------------------------
local function EnableBlizzardActionBars()
    for _, v in pairs({ "BottomLeft", "BottomRight", "Right", "RightTwo"}) do
        _G["InterfaceOptionsActionBarsPanel" .. v]:Enable()
    end
end

local function Enable(self)
    local Bar1 = Panels.ActionBar1
	local Bar2 = Panels.ActionBar2
	local Bar3 = Panels.ActionBar3
	local Bar4 = Panels.ActionBar4
    local Bar5 = Panels.ActionBar5
	local PetBar = Panels.PetActionBar
    local StanceBar = Panels.StanceBar
    
    local Size = C.ActionBars.NormalButtonSize
	local PetSize = C.ActionBars.PetButtonSize
    local Spacing = C.ActionBars.ButtonSpacing

    -- Move Pet Bar if Bar 5 hidden
	PetBar:SetScript("OnShow", self.MovePetBar)
    PetBar:SetScript("OnHide", self.MovePetBar)

    EnableBlizzardActionBars()
end
hooksecurefunc(ActionBars, "Enable", Enable)