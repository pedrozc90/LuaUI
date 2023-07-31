local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupTotemBar()
    local Totems = self.Totems
    if (not Totems) then return end

    local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitFrames.ClassBarHeight
    local TotemBarStyle = C.UnitFrames.TotemBarStyle.Value

    if (TotemBarStyle == "On Screen") then
        local point, relativeTo, relativePoint, offsetX, offsetY = unpack(C.UnitFrames.ClassBarAnchor)
        Totems:ClearAllPoints()
        Totems:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY - 10)
    elseif (TotemBarStyle == "On Player") then
        Totems:ClearAllPoints()
        Totems:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
        Totems:SetWidth(Width)
        Totems:SetHeight(Height)

        Totems.Backdrop:SetOutside()

        local Spacing = 1
        local Size, Delta = T.EqualSizes(Width, MAX_TOTEMS, Spacing)

        for i = 1, MAX_TOTEMS do
            Totems[i]:SetHeight(Height)

            if ((Delta > 0) and (i <= Delta)) then
                Totems[i]:SetWidth(Size + 1)
            else
                Totems[i]:SetWidth(Size)
            end

            if i == 1 then
                Totems[i]:SetPoint("TOPLEFT", Totems, "TOPLEFT", 0, 0)
            else
                Totems[i]:SetPoint("TOPLEFT", Totems[i-1], "TOPRIGHT", Spacing, 0)
            end
        end

        if (self.AuraBars) then
            self.AuraBars:ClearAllPoints()
            self.AuraBars:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 15)
        elseif (self.Buffs) then
            self.Buffs:ClearAllPoints()
            self.Buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 15)
        end
    end
end
