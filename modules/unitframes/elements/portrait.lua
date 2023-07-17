local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupPortrait()
    local Health = self.Health
    local Portrait = self.Portrait
    if (not Portrait) then return end

    local PortraitHolder = Portrait:GetParent()

    local Width, Height = T.GetSize(self.unit)

    if (C.UnitFrames.Portrait2D) then
        local PortraitSize = Height + Power:GetHeight() + 1

        PortraitHolder:ClearAllPoints()
        PortraitHolder:SetPoint("TOPRIGHT", Health, "TOPLEFT", -3, 0)
        PortraitHolder:SetSize(PortraitSize, PortraitSize)
    else
        Portrait:SetParent(Health)
        Portrait:SetAllPoints(Health)
        Portrait:SetAlpha(.35)

        PortraitHolder:Kill()
    end

    if (Portrait.Shadow) then
        Portrait.Shadow:Kill()
    end
end
