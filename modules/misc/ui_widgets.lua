local T, C, L = Tukui:unpack()
local UIWidgets = T.Miscellaneous.UIWidgets

----------------------------------------------------------------
-- UI Widgets
----------------------------------------------------------------
local baseEnable = UIWidgets.Enable

function UIWidgets:Enable()
    -- first, we call the base function
    baseEnable(self)

    -- second, we edit it
    self.Holder:ClearAllPoints()
    self.Holder:SetSize(220, 20)
    self.Holder:SetPoint("TOP", UIParent, "TOP", 3, -96)
end
