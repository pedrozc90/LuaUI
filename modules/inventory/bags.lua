local T, C, L = Tukui:unpack()
local Bags = T.Inventory.Bags
local DataTexts = T.DataTexts

if (true) then return end;

local BackdropR, BackdropG, BackdropB = unpack(C.General.BackdropColor)
local BackdropA = 0.75

----------------------------------------------------------------
-- Bags
----------------------------------------------------------------
local baseCreateContainer = Bags.CreateContainer

function Bags:CreateContainer(storagetype, ...)
    
    -- first, we call the base function
    baseCreateContainer(self, storagetype, ...)

    -- second, we edit it
    local Container = self[storagetype]
    local DataTextLeft = DataTexts.Panels.Left
    local DataTextRight = DataTexts.Panels.Right

    local ButtonSize = C.Bags.ButtonSize
	local ButtonSpacing = C.Bags.Spacing
	local ItemsPerRow = C.Bags.ItemsPerRow

    Container.Backdrop:SetBackdropColor(BackdropR, BackdropG, BackdropB, BackdropA)
    -- Container:SetWidth((ItemsPerRow * ButtonSize) + (ItemsPerRow - 1) * ButtonSpacing + 23)

    if (storagetype == "Bag") then
        local BagsContainer = Container.BagsContainer
		local ToggleBagsContainer = Container.ToggleBagsContainer
		local Sort = Container.Sort
		local SearchBox = Container.SearchBox
		local ToggleBags = Container.ToggleBags

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -11, 35)

        -- -- sort button
        -- Sort.ClearAllPoints = Container.ClearAllPoints
		-- Sort.SetPoint = Container.SetPoint
        -- Sort:ClearAllPoints()
        -- Sort:SetPoint("BOTTOMLEFT", Container, "TOPLEFT", 0, 3)
        -- Sort:SetPoint("BOTTOMRIGHT", Container, "TOPRIGHT", 0, 3)
        -- Sort.ClearAllPoints = function() end
        -- Sort.SetPoint = function() end
        
        SearchBox.Backdrop:SetBackdropColor(unpack(C.General.BackdropColor))

        SearchBox.Title:ClearAllPoints()
        SearchBox.Title:SetPoint("CENTER", SearchBox, "CENTER", 0, 1)
        -- SearchBox.Title:SetFont(C.Medias.Font, 14)

    elseif (storagetype == "Bank") then
        local PurchaseButton = BankFramePurchaseButton
		local CostText = BankFrameSlotCost
		local TotalCost = BankFrameDetailMoneyFrame
		local Purchase = BankFramePurchaseInfo
        local CloseButton = BankCloseButton
        
        local BankBagsContainer = Container.BagsContainer
		local SwitchReagentButton = Container.ReagentButton
		local SortButton = Container.SortButton

        -- local Size = (Container:GetWidth() - 3) / 2

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 11, 35)

        -- -- reagents button
        -- Reagent:ClearAllPoints()
        -- Reagent:SetPoint("BOTTOMLEFT", Container, "TOPLEFT", 0, 3)
        -- Reagent:SetSize(Size, 23)

        -- -- sort button
        -- Sort:ClearAllPoints()
        -- Sort:SetPoint("LEFT", Reagent, "RIGHT", 3, 0)
        -- Sort:SetSize(Size - 1, 23)

        -- -- bank purchase info
        -- Purchase:ClearAllPoints()
        -- Purchase:SetPoint("BOTTOMLEFT", Reagent, "TOPLEFT", -50, 3)
        -- Purchase:SetWidth(Container:GetWidth() + 50)
    end
end
