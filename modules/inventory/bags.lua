local T, C, L = Tukui:unpack()
local Bags = T.Inventory.Bags
local Panels = T.Panels

local BlizzardBags = {
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot
}

----------------------------------------------------------------
-- Bags
----------------------------------------------------------------
local baseCreateContainer = Bags.CreateContainer

function Bags:CreateContainer(storagetype, ...)

    -- first, call the base function
    baseCreateContainer(self, storagetype, ...)

    -- second, we edit it
    local Container = self[storagetype]
    local DataTextLeft = Panels.DataTextLeft
    local DataTextRight = Panels.DataTextRight

    local ButtonSize = C.Bags.ButtonSize
	local ButtonSpacing = C.Bags.Spacing
	local ItemsPerRow = C.Bags.ItemsPerRow

    Container:SetWidth((ItemsPerRow * ButtonSize) + (ItemsPerRow - 1) * ButtonSpacing + 23)
    Container.Shadow:Kill()
    Container:SetTripleBorder("Transparent")

    if (storagetype == "Bag") then
        local BagsContainer = Container.BagsContainer
        local CloseButton = Container.CloseButton
		local SortButton = Container.SortButton
		local SearchBox = Container.SearchBox
		local ToggleBags = Container.ToggleBags

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", 0, 3)

        -- sort button
        SortButton.ClearAllPoints = Container.ClearAllPoints
		SortButton.SetPoint = Container.SetPoint
        SortButton:ClearAllPoints()
        SortButton:SetSize(16, 16)
		SortButton:SetPoint("RIGHT", ToggleBags, "LEFT", -2, 0)
        SortButton.ClearAllPoints = function() end
        SortButton.SetPoint = function() end
        
        -- bags container
        BagsContainer:ClearAllPoints()
        BagsContainer:Point("BOTTOMRIGHT", Container, "TOPRIGHT", 0, 3)
        BagsContainer:SetTripleBorder("Transparent")
        
        for _, Button in pairs(BlizzardBags) do
			local Count = _G[Button:GetName().."Count"]
			local Icon = _G[Button:GetName().."IconTexture"]
            Button:SetTripleBorder()
		end

        -- toggle button
        ToggleBags:SetScript("OnClick", function(self)
			local Purchase = BankFramePurchaseInfo
			local BanksContainer = Bags.Bank.BagsContainer
			local Purchase = BankFramePurchaseInfo

			if (ReplaceBags == 0) then
				ReplaceBags = 1
				BagsContainer:Show()
				BanksContainer:Show()
				BanksContainer:ClearAllPoints()

				if Purchase:IsShown() then
					BanksContainer:SetPoint("BOTTOMLEFT", Purchase, "TOPLEFT", -2, 5)
				end
					
				self.Texture:SetTexture(C.Medias.ArrowDown)
			else
				ReplaceBags = 0
				BagsContainer:Hide()
				BanksContainer:Hide()
					
				self.Texture:SetTexture(C.Medias.ArrowUp)
			end
		end)

    elseif (storagetype == "Bank") then
        local Purchase = BankFramePurchaseInfo
        local PurchaseButton = BankFramePurchaseButton
        local BankBagsContainer = Container.BagsContainer

        local Size = (Container:GetWidth() - 3) / 2

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMLEFT", DataTextLeft, "TOPLEFT", 0, 3)

        -- bank purchase info
        Purchase:ClearAllPoints()
        Purchase:SetPoint("BOTTOMLEFT", Container, "TOPLEFT", 2, 5)
        Purchase:SetPoint("BOTTOMRIGHT", Container, "TOPRIGHT", -2, 5)
        Purchase.Backdrop:SetTripleBorder("Transparent")
        Purchase.Backdrop:SetOutside(nil, 2, 2)

        -- NEED TO FIX BORDER COLOR ON MOUSEOVER (T00LKIT.SkinButton)
        -- PurchaseButton:NoTemplate()
        -- PurchaseButton:CreateBackdrop()
        -- PurchaseButton.Backdrop:SetTripleBorder()
        -- PurchaseButton.Backdrop:SetOutside(nil, 2, 2)

        -- bank bags container
        BankBagsContainer:ClearAllPoints()
        BankBagsContainer:Point("BOTTOMLEFT", Container, "TOPLEFT", 0, 9)
        BankBagsContainer:SetTripleBorder("Transparent")

        for i = 1, 6 do
			local Bag = BankSlotsFrame["Bag"..i]
            Bag:SetTripleBorder()
		end
    end
end
