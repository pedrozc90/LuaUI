local T, C, L = Tukui:unpack()
local Bags = T.Inventory.Bags
local Panels = T.Panels

----------------------------------------------------------------
-- Bags
----------------------------------------------------------------
local function CreateContainer(self, storagetype, ...)
    local Container = self[storagetype]
    local DataTextLeft = Panels.DataTextLeft
    local DataTextRight = Panels.DataTextRight

    local ButtonSize = C.Bags.ButtonSize
	local ButtonSpacing = C.Bags.Spacing
	local ItemsPerRow = C.Bags.ItemsPerRow

    Container:SetWidth((ItemsPerRow * ButtonSize) + (ItemsPerRow - 1) * ButtonSpacing + 23)
    Container.Shadow:Kill()

    if (storagetype == "Bag") then
        local BagsContainer = Container.BagsContainer
        local ToggleBagsContainer = Container.CloseButton
        local Sort = Container.SortButton

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", 0, 3)

        -- sort button
        Sort.ClearAllPoints = Container.ClearAllPoints
		Sort.SetPoint = Container.SetPoint
        Sort:ClearAllPoints()
        Sort:SetPoint("BOTTOMLEFT", Container, "TOPLEFT", 0, 3)
        Sort:SetPoint("BOTTOMRIGHT", Container, "TOPRIGHT", 0, 3)
        Sort.ClearAllPoints = function() end
		Sort.SetPoint = function() end

    elseif (storagetype == "Bank") then
        local Purchase = BankFramePurchaseInfo
        local BankBagsContainer = Container.BagsContainer
        local Reagent = Container.ReagentButton
        local Sort = Container.SortButton

        local Size = (Container:GetWidth() - 3) / 2

        -- container
        Container:ClearAllPoints()
        Container:SetPoint("BOTTOMLEFT", DataTextLeft, "TOPLEFT", 0, 3)

        -- reagents button
        Reagent:ClearAllPoints()
        Reagent:SetPoint("BOTTOMLEFT", Container, "TOPLEFT", 0, 3)
        Reagent:Size(Size, 23)

        -- sort button
        Sort:ClearAllPoints()
        Sort:SetPoint("LEFT", Reagent, "RIGHT", 3, 0)
        Sort:Size(Size - 1, 23)

        -- bank purchase info
        Purchase:ClearAllPoints()
        Purchase:SetPoint("BOTTOMLEFT", Reagent, "TOPLEFT", -50, 3)
        Purchase:SetWidth(Container:GetWidth() + 50)
    end
end
hooksecurefunc(Bags, "CreateContainer", CreateContainer)
