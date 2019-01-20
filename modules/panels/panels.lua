local T, C, L = Tukui:unpack()
local Panels = T.Panels

----------------------------------------------------------------
-- Panels
----------------------------------------------------------------
local function Enable(self)
    local BottomLine = self.BottomLine
	local LeftVerticalLine = self.LeftVerticalLine
	local RightVerticalLine = self.RightVerticalLine
	local DataTextLeft = self.DataTextLeft
	local DataTextRight = self.DataTextRight
	local Hider = self.Hider
    local PetBattleHider = self.PetBattleHider
    local LeftChatBG = self.LeftChatBG
	local RightChatBG = self.RightChatBG
	local TabsBGLeft = self.TabsBGLeft
    local TabsBGRight = self.TabsBGRight

    local xOffset, yOffset = 7, 7
    
    -- Kill Lines
    BottomLine:Kill()
    LeftVerticalLine:Kill()
    RightVerticalLine:Kill()

    LeftChatBG:ClearAllPoints()
    LeftChatBG:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", xOffset, yOffset)
    LeftChatBG:Size(379 + xOffset + yOffset, 177)

    RightChatBG:ClearAllPoints()
    RightChatBG:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -xOffset, yOffset)
    RightChatBG:Size(379 + xOffset + yOffset, 177)

    TabsBGLeft:ClearAllPoints()
    TabsBGLeft:Point("TOPLEFT", LeftChatBG, "TOPLEFT", xOffset, -yOffset)
    TabsBGLeft:Point("TOPRIGHT", LeftChatBG, "TOPRIGHT", -xOffset, -yOffset)
    TabsBGLeft:Height(23)
    
    TabsBGRight:ClearAllPoints()
    TabsBGRight:Point("TOPLEFT", RightChatBG, "TOPLEFT", xOffset, -yOffset)
    TabsBGRight:Point("TOPRIGHT", RightChatBG, "TOPRIGHT", -xOffset, -yOffset)
    TabsBGRight:Height(23)

    DataTextLeft:ClearAllPoints()
    DataTextLeft:Point("BOTTOMLEFT", LeftChatBG, "BOTTOMLEFT", xOffset, yOffset)
    DataTextLeft:Point("BOTTOMRIGHT", LeftChatBG, "BOTTOMRIGHT", -xOffset, yOffset)
    DataTextLeft:Height(23)

    DataTextRight:ClearAllPoints()
    DataTextRight:Point("BOTTOMLEFT", RightChatBG, "BOTTOMLEFT", xOffset, yOffset)
    DataTextRight:Point("BOTTOMRIGHT", RightChatBG, "BOTTOMRIGHT", -xOffset, yOffset)
    DataTextRight:Height(23)
end
hooksecurefunc(Panels, "Enable", Enable)