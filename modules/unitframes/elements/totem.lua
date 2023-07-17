local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupTotemBar()
    local Totems = self.Totems
    if (not Totems) then return end

    local Width, Height = C.UnitFrames.ClassBarWidth, C.UnitsFrames.ClassBarHeight
    local TotemBarStyle = C.UnitFrames.TotemBarStyle.Value

    if (TotemBarStyle == "On Screen") then
        Totems:ClearAllPoints()
        Totems:SetPoint(unpack(C.UnitFrames.ClassBarAnchor))
        -- Totems:SetWidth((Size * MAX_TOTEMS) + (Spacing * (MAX_TOTEMS + 1)))
        -- Totems:SetHeight(Size)

        -- for i = 1, MAX_TOTEMS do
        --     Totems[i]:ClearAllPoints()
        --     Totems[i]:SetSize(Size, Size)
        --     Totems[i].Backdrop.Shadow:Kill()

        --     -- change cooldown font
        --     Totems[i].Cooldown:ClearAllPoints()
        --     Totems[i].Cooldown:SetPoint("CENTER", Totems[i], "CENTER", 0, 0)

        --     if i == 1 then
        --         Totems[i]:SetPoint("BOTTOMLEFT", Totems, "BOTTOMLEFT", 0, 0)
        --     else
        --         Totems[i]:SetPoint("LEFT", Totems[i - 1], "RIGHT", Spacing, 0)
        --     end
        -- end
    elseif (TotemBarStyle == "On Player") then
        Totems:ClearAllPoints()
        Totems:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 3)
        Totems:SetHeight(10)
        Totems:SetWidth(Width + 2)

        local Size, Delta = T.EqualSizes(Width - 2, MAX_TOTEMS, 0)

        for i = 1, MAX_TOTEMS do
            Totems[i]:SetHeight(8)

            if ((Delta > 0) and (i <= Delta)) then
                Totems[i]:SetWidth(Size + 1)
            else
                Totems[i]:SetWidth(Size)
            end

            if i == 1 then
                Totems[i]:SetPoint("TOPLEFT", Totems, "TOPLEFT", 1, -1)
            else
                Totems[i]:SetPoint("TOPLEFT", Totems[i-1], "TOPRIGHT", 1, 0)
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
