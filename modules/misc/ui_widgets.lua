local T, C, L = Tukui:unpack()
local UIWidgets = T.Miscellaneous.UIWidgets

----------------------------------------------------------------
-- UI Widgets
----------------------------------------------------------------
-- local baseSkinUIWidgetStatusBar = UIWidgets.SkinUIWidgetStatusBar
local baseEnable = UIWidgets.Enable

-- function UIWidgets:SkinUIWidgetStatusBar(widgetInfo, widgetContainer)
--     -- first, we call the base function
--     baseSkinUIWidgetStatusBar(self, widgetInfo, widgetContainer)

--     -- second, we edit it
--     local Texture = T.GetTexture(C.Lua.Texture)
-- end

function UIWidgets:Enable()
    -- first, we call the base function
    baseEnable(self)

    -- second, we edit it
    self.Holder:ClearAllPoints()
    self.Holder:SetSize(220, 20)
    self.Holder:SetPoint("TOP", UIParent, "TOP", 3, -96)
end
