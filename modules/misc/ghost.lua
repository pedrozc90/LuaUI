local T, C, L = Tukui:unpack()
local Ghost = T.Miscellaneous.Ghost
local GhostFrame = GhostFrame
local Experience = T.Miscellaneous.Experience

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
	Button:SetPoint("TOPLEFT", HonorBar, "BOTTOMLEFT", 0, -3)
	Button:SetPoint("TOPRIGHT", HonorBar, "BOTTOMRIGHT", 0, -3)
	Button:Hide()
	
	-- Button.Text:SetFontTemplate(C.Medias.Font, 12)
	-- Button.Text:SetPoint("CENTER")
	-- Button.Text:SetText(T.RGBToHex(unpack(Ghost.Color)) .. RETURN_TO_GRAVEYARD .. "|r")
end

-- function Ghost:AddHooks()
-- 	GhostFrame:HookScript("OnShow", Ghost.OnShow)
-- 	GhostFrame:HookScript("OnHide", Ghost.OnHide)
-- end

-- function Ghost:Enable()
-- 	local DataRight = T.DataTexts.Panels.Right
-- 	local Minimap = T.DataTexts.Panels.Minimap
-- 	local Icon = GhostFrameContentsFrame
-- 	local Text = GhostFrameContentsFrameText

-- 	if Minimap or DataRight then
-- 		self:CreateButton()
-- 		self:AddHooks()

-- 		GhostFrame:StripTextures()
-- 		GhostFrame:ClearAllPoints()
-- 		GhostFrame:SetAllPoints(Minimap or DataRight)
-- 		GhostFrame:SetFrameStrata(self.Button:GetFrameStrata())
-- 		GhostFrame:SetFrameLevel(self.Button:GetFrameLevel() + 1)
-- 		GhostFrame:SetAlpha(0)

-- 		Icon:StripTextures()

-- 		Text:SetText("")
-- 	end
-- end

-- Miscellaneous.Ghost = Ghost
