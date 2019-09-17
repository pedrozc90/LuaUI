local T, C, L = Tukui:unpack()
local Panels = T.Panels
local baseEnable = Panels.Enable

----------------------------------------------------------------
-- Panels
----------------------------------------------------------------
function Panels:Enable()

    -- first, call the base function
    baseEnable(self)

    -- second, we edit it
    local LeftChatBG = self.LeftChatBG
	local RightChatBG = self.RightChatBG
	local TabsBGLeft = self.TabsBGLeft
    local TabsBGRight = self.TabsBGRight

    local BottomLine = self.BottomLine
	local LeftVerticalLine = self.LeftVerticalLine
	local RightVerticalLine = self.RightVerticalLine
	local DataTextLeft = self.DataTextLeft
    local DataTextRight = self.DataTextRight
    
    local xOffset, yOffset = 4, 4
    local Offset = xOffset + yOffset
    local ChatWidth = 380 + xOffset + yOffset
    
    LeftChatBG:ClearAllPoints()
    LeftChatBG:Point("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 7, 7)
    LeftChatBG:Size(C.Chat.LeftWidth + Offset, C.Chat.LeftHeight or 177)
    LeftChatBG.Backdrop:SetBorder("Transparent")
    LeftChatBG.Backdrop:SetOutside(nil, 2, 2)

	RightChatBG:ClearAllPoints()
    RightChatBG:Point("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -7, 7)
    RightChatBG:Size(C.Chat.RightWidth + Offset, C.Chat.RightHeight or 177)
    RightChatBG.Backdrop:SetBorder("Transparent")
    RightChatBG.Backdrop:SetOutside(nil, 2, 2)

	TabsBGLeft:ClearAllPoints()
    TabsBGLeft:Point("TOPLEFT", LeftChatBG, "TOPLEFT", xOffset, -yOffset)
    TabsBGLeft:Point("TOPRIGHT", LeftChatBG, "TOPRIGHT", -xOffset, -yOffset)
    TabsBGLeft:Height(23)
    TabsBGLeft:SetBorder()

	TabsBGRight:ClearAllPoints()
    TabsBGRight:Point("TOPLEFT", RightChatBG, "TOPLEFT", xOffset, -yOffset)
    TabsBGRight:Point("TOPRIGHT", RightChatBG, "TOPRIGHT", -xOffset, -yOffset)
    TabsBGRight:Height(23)
	TabsBGRight:SetBorder()

    -- kill lines
    BottomLine:Kill()
    LeftVerticalLine:Kill()
    RightVerticalLine:Kill()

	DataTextLeft:ClearAllPoints()
    DataTextLeft:Point("BOTTOMLEFT", LeftChatBG, "BOTTOMLEFT", xOffset, yOffset)
    DataTextLeft:Point("BOTTOMRIGHT", LeftChatBG, "BOTTOMRIGHT", -xOffset, yOffset)
    DataTextLeft:Height(23)
    DataTextLeft:SetBorder()

	DataTextRight:ClearAllPoints()
    DataTextRight:Point("BOTTOMLEFT", RightChatBG, "BOTTOMLEFT", xOffset, yOffset)
    DataTextRight:Point("BOTTOMRIGHT", RightChatBG, "BOTTOMRIGHT", -xOffset, yOffset)
    DataTextRight:Height(23)
    DataTextRight:SetBorder()

end
