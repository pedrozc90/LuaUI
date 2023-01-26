local T, C, L = Tukui:unpack()
local Bags = T.Inventory.Bags
local BankFrame = BankFrame

local BlizzardBags = {
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	CharacterReagentBag0Slot,
}

local BackdropR, BackdropG, BackdropB = unpack(C.General.BackdropColor)
local BackdropA = 0.75

----------------------------------------------------------------
-- Bags
----------------------------------------------------------------
local baseHideBlizzard = Bags.HideBlizzard
local baseCreateContainer = Bags.CreateContainer

function Bags:HideBlizzard()
    -- first, we call the base function
    baseHideBlizzard(self)

    if (T.Retail) then
        local BankFrameTitleText = _G["BankFrameTitleText"]
		local BankFramePortrait = _G["BankFramePortrait"]
		local BankFrameBg = _G["BankFrameBg"]

        BankFrame.NineSlice:Hide()
        BankFrameTitleText:Hide()
		BankFramePortrait:Hide()
		BankFrameBg:Hide()
    end
end

function Bags:CreateContainer(storagetype, ...)
    -- first, we call the base function
    baseCreateContainer(self, storagetype, ...)

    -- second, we edit it
    local Container = self[storagetype]

    local ButtonSize = C.Bags.ButtonSize
	local ButtonSpacing = C.Bags.Spacing
	local ItemsPerRow = C.Bags.ItemsPerRow

    Container.Backdrop:SetBackdropColor(BackdropR, BackdropG, BackdropB, BackdropA)

    if (storagetype == "Bag") then
        local BagsContainer = Container.BagsContainer
		local ToggleBagsContainer = Container.CloseButton
		local Sort = Container.SortButton
		local SearchBox = Container.SearchBox
		local ToggleBags = Container.ToggleBags
		local Keys = Container.Keys

        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 35)

        BagsContainer:ClearAllPoints()
        BagsContainer:SetPoint("TOPRIGHT", Container, "TOPLEFT", -5, 0)

        for _, Button in pairs(BlizzardBags) do
			if Button then
				local Count = _G[Button:GetName().."Count"]
				local Icon = _G[Button:GetName().."IconTexture"]

				Button:ClearAllPoints()
				Button:SetParent(BagsContainer)
				Button:SetWidth(ButtonSize)
				Button:SetHeight(ButtonSize)

				if LastButtonBag then
					Button:SetPoint("RIGHT", LastButtonBag, "LEFT", ButtonSpacing, 0)
				else
					Button:SetPoint("TOPRIGHT", BagsContainer, "TOPRIGHT", ButtonSpacing, -ButtonSpacing)
				end

				LastButtonBag = Button
				
                local NumBags = getn(BlizzardBags)
				BagsContainer:SetWidth((ButtonSize * NumBags) + (ButtonSpacing * (NumBags + 1)))
				BagsContainer:SetHeight(ButtonSize + (ButtonSpacing * 2))
			end
		end

        -- SearchBox
		SearchBox.Backdrop:SetBackdropColor(0.01, 0.01, 0.01, 1)
        SearchBox.Backdrop:SetBorderColor(unpack(C.General.BorderColor))

        SearchBox.Title:SetText("Search")

        SearchBox:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
            self:SetText("")
        end)
		SearchBox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
            self:SetText("")
        end)
		SearchBox:SetScript("OnEditFocusLost", function(self)
            if not self:HasText() then
                self.Title:Show()
            end
            -- self.Backdrop:SetBorderColor(.3, .3, .3, 1)
            self.Backdrop:SetBorderColor(0.01, 0.01, 0.01, 1)
        end)
		SearchBox:SetScript("OnEditFocusGained", function(self)
            self.Title:Hide()
            self.Backdrop:SetBorderColor(1, 1, 1, 1)
        end)
    elseif (storagetype == "BagReagent") then
        local TukuiBag = _G["TukuiBag"]

        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMRIGHT", TukuiBag, "TOPRIGHT", 0, 3)
    elseif (storagetype == "Bank") then
        local PurchaseButton = BankFramePurchaseButton
		local CostText = BankFrameSlotCost
		local TotalCost = BankFrameDetailMoneyFrame
		local Purchase = BankFramePurchaseInfo
        local CloseButton = BankCloseButton
        
        local BankBagsContainer = Container.BagsContainer
		local SwitchReagentButton = Container.ReagentButton
		local SortButton = Container.SortButton

        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 35)
    end
end
