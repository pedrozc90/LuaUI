local T, C, L = Tukui:unpack()
local Bags = T.Inventory.Bags

----------------------------------------------------------------
-- Bags
----------------------------------------------------------------
local function Enable(self)
    local ContainerBag = self["Bag"]
    local ContainerBank = self["Bank"]
    local DataTextLeft = T.Panels.DataTextLeft
    local DataTextRight = T.Panels.DataTextRight
    
    ContainerBag:ClearAllPoints()
    ContainerBag:Point("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", 0, 3)

    ContainerBank:ClearAllPoints()
    ContainerBank:Point("BOTTOMLEFT", DataTextLeft, "TOPLEFT", 0, 3)
end
hooksecurefunc(Bags, "Enable", Enable)