local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupComboPoints()
    local ComboPoints = self.ComboPointsBar
    if (not ComboPoints) then return end

    local class = T.MyClass
    if (class == "ROGUE" or class == "DRUID") then

        local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight

        ComboPoints:ClearAllPoints()
        ComboPoints:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
        ComboPoints:SetWidth(Width)
        ComboPoints:SetHeight(Height)
        ComboPoints.Backdrop:Kill()

        local Spacing = 3           -- spacing between combo-points
        local SizeMax5, DeltaMax5 = T.EqualSizes(Width, 5, Spacing)
        local SizeMax6, DeltaMax6 = T.EqualSizes(Width, 6, Spacing)

        for i = 1, 6 do
            ComboPoints[i]:ClearAllPoints()
            ComboPoints[i]:SetHeight(ComboPoints:GetHeight())
            ComboPoints[i]:SetWidth(SizeMax6)
            ComboPoints[i]:CreateBackdrop()
            ComboPoints[i].Backdrop:SetOutside()

            if ((DeltaMax5 > 0) and (i <= DeltaMax5)) then
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs5 = SizeMax5
            end

            if ((DeltaMax6 > 0) and (i <= DeltaMax6)) then
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6 + 1
            else
                ComboPoints[i].BarSizeForMaxComboIs6 = SizeMax6
            end

            if (i == 1) then
                ComboPoints[i]:SetPoint("LEFT", ComboPoints, "LEFT", 0, 0)
            else
                ComboPoints[i]:SetPoint("LEFT", ComboPoints[i - 1], "RIGHT", Spacing, 0)
            end
        end

        -- ComboPoints:SetScript("OnShow", UnitFrames.MoveBuffHeaderUp)
        -- ComboPoints:SetScript("OnHide", UnitFrames.MoveBuffHeaderDown)
    end
end
