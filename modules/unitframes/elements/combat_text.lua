local T, C, L = Tukui:unpack()
local UnitFrames = T.UnitFrames

function UnitFrames:SetupCombatFeedbackText()
    local CombatFeedbackText = self.CombatFeedbackText
    if (CombatFeedbackText) then return end

    CombatFeedbackText:ClearAllPoints()
    CombatFeedbackText:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
    CombatFeedbackText:SetFont(Font, 13, FontStyle)
end
