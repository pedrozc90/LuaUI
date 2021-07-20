local T, C, L = Tukui:unpack()
local Ghost = T.Miscellaneous.Ghost
local GhostFrame = GhostFrame
local Minimap = T.Maps.Minimap
local Experience = T.Miscellaneous.Experience

if (true) then return end;

----------------------------------------------------------------
-- Ghost
----------------------------------------------------------------
local baseCreateButton = Ghost.CreateButton

function Ghost:CreateButton()

	-- first, we call the base function
    baseCreateButton(self)

    -- second, we edit it
	local Button = self.Button

	local ExpBar = Experience.XPBar1
    local HonorBar = Experience.XPBar2

	Button:ClearAllPoints()
	-- Button:SetAllPoints(T.DataTexts.Panels.Minimap or T.DataTexts.Panels.Right)
	Button:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -3)
	Button:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -3)
	Button:SetHeight(23)
	Button:SetScript("OnShow", function (element)
        local ExpirenceBar = Experience.XPBar1
        local ReputationBar = Experience.XPBar2

        local Anchor = Minimap
        if (ReputationBar and ReputationBar:IsShown()) then
            Anchor = ReputationBar
        elseif (ExpirenceBar and ExpirenceBar:IsShown()) then
            Anchor = ExpirenceBar
        end
        element:SetPoint("TOPLEFT", Anchor, "BOTTOMLEFT", 0, -3)
        element:SetPoint("TOPRIGHT", Anchor, "BOTTOMRIGHT", 0, -3)
    end)
	Button:Hide()
end
