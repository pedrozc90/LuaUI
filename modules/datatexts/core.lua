local T, C, L = Tukui:unpack()
local Chat = T.Chat
local DataTexts = T.DataTexts

----------------------------------------------------------------
-- DataTexts
----------------------------------------------------------------
local baseEnable = DataTexts.Enable

function DataTexts:Enable()
	-- first, we call the base function
    baseEnable(self)

    -- second, we edit it
	local DataTextLeft = self.Panels.Left
	local DataTextRight = self.Panels.Right
	local xOffset, yOffset = 10, 10

	DataTextLeft:ClearAllPoints()
	DataTextLeft:SetWidth(C.General.Themes.Value == "Tukui" and C.Chat.LeftWidth or 370)
	DataTextLeft:SetHeight(23)
	DataTextLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", xOffset, yOffset)
	DataTextRight:CreateBackdrop("Transparent")
	DataTextLeft:SetFrameStrata("BACKGROUND")
	DataTextLeft:SetFrameLevel(2)

	DataTextRight:ClearAllPoints()
	DataTextRight:SetWidth(C.General.Themes.Value == "Tukui" and C.Chat.RightWidth or 370)
	DataTextRight:SetHeight(23)
	DataTextRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -xOffset, yOffset)
	DataTextRight:CreateBackdrop("Transparent")
	DataTextRight:SetFrameStrata("BACKGROUND")
	DataTextRight:SetFrameLevel(2)
end

local RemoveData = function(self)
	if self.Data then
		self.Data.Position = 0
		self.Data:Disable()
	end

	self.Data = nil
end

local SetData = function(self, object)
	-- Disable the old data text in use
	if self.Data then
		RemoveData(self)
	end

	local Panels = T.DataTexts.Panels

	-- Set the new data text
	self.Data = object
	self.Data:Enable()
	if (C.DataTexts.Font == "Pixel") then
		self.Data.Text:SetPoint("RIGHT", self, 0, 0)
		self.Data.Text:SetPoint("LEFT", self, 3, 0)
		self.Data.Text:SetPoint("TOP", self, 0, 0)
		self.Data.Text:SetPoint("BOTTOM", self, 0, 2)
	else
		self.Data.Text:SetPoint("RIGHT", self, 0, 0)
		self.Data.Text:SetPoint("LEFT", self, 0, 0)
		self.Data.Text:SetPoint("TOP", self, 0, -1)
		self.Data.Text:SetPoint("BOTTOM", self, 0, -1)
	end
	self.Data.Position = self.Num
	self.Data:SetAllPoints(self.Data.Text)

	if (Panels.Left and self.Data.Position >= 1 and self.Data.Position <= 3) then
		self.Data:SetParent(Panels.Left)
	elseif (Panels.Right and self.Data.Position >= 4 and self.Data.Position <= 6) then
		self.Data:SetParent(Panels.Right)
	elseif (Panels.Minimap and self.Data.Position == 7) then
		self.Data:SetParent(Panels.Minimap)
	end
end

function DataTexts:CreateAnchors()
	local DataTextLeft = DataTexts.Panels.Left
	local DataTextRight = DataTexts.Panels.Right
	local MinimapDataText = DataTexts.Panels.Minimap

	if (MinimapDataText) then
		self.NumAnchors = self.NumAnchors + 1
	end

    local Spacing = 1					-- space between datatext frames
	local Number = 3					-- number of datatext per panel

	-- calcute frame size which devide a panel into n-equal parts.
	-- delta is the error between new width and referential width.
    local Size, Delta = T.EqualSizes(DataTextRight:GetWidth() - 2, Number, Spacing)

	for i = 1, self.NumAnchors do
		local Frame = CreateFrame("Button", nil, UIParent)
		Frame:SetHeight(DataTextLeft:GetHeight() - 2)
		Frame:SetFrameLevel(DataTextLeft:GetFrameLevel() + 1)
		Frame:SetFrameStrata("HIGH")
		Frame:EnableMouse(false)
		Frame.SetData = SetData
		Frame.RemoveData = RemoveData
        Frame.Num = i

		-- calculate datatext position in the datatext panel
		local pos = ((i > 3) and (i < 7)) and i - 3 or i
		-- if datatext position is less than deviation, increment width by 1 pixel
		if ((i < 7) and (Delta > 0) and (pos <= Delta)) then
			Frame:SetWidth(Size + 1)
		else
			Frame:SetWidth(Size)
		end

		Frame.Tex = Frame:CreateTexture()
		Frame.Tex:SetAllPoints()
		Frame.Tex:SetColorTexture(0.2, 1, 0.2, 0)

		self.Anchors[i] = Frame

		if (i == 1) then
			Frame:SetPoint("LEFT", DataTextLeft, "LEFT", 1, 0)
		elseif (i == 4) then
			Frame:SetPoint("LEFT", DataTextRight, "LEFT", 1, 0)
		elseif (i == 7) then
			Frame:SetPoint("CENTER", MinimapDataText, 0, 0)
			Frame:SetWidth(MinimapDataText:GetWidth() - 2)
			Frame:SetHeight(MinimapDataText:GetHeight() - 2)
		else
			Frame:SetPoint("LEFT", self.Anchors[i-1], "RIGHT", 1, 0)
		end
	end
end

-- local GetTooltipAnchor = function(self)
-- 	local Position = self.Position
-- 	local MinimapDataText = DataTexts.Panels.Minimap
-- 	local From
-- 	local Anchor = "ANCHOR_TOP"
-- 	local X = 0
-- 	local Y = 16

-- 	if ((Position >= 1) and (Position <= 3)) then
-- 		X = -1
-- 		Anchor = "ANCHOR_TOPLEFT"
-- 		From = Chat.Panels.LeftChat
-- 	elseif ((Position >= 4) and (Position <= 6)) then
-- 		X = 1
-- 		Anchor = "ANCHOR_TOPRIGHT"
-- 		From = Chat.Panels.RightChat
-- 	elseif ((Position == 7) and MinimapDataText) then
-- 		Anchor = "ANCHOR_BOTTOMLEFT"
-- 		Y = -5
-- 		From = MinimapDataText
-- 	end

-- 	return From, Anchor, X, Y
-- end

-- -- Update Anchor
-- for Name, DataText in pairs(DataTexts.Texts) do
--     if (DataText.GetTooltipAnchor) then
--         DataText.GetTooltipAnchor = GetTooltipAnchor
--     end
-- end

----------------------------------------------------------------
-- Set Default DataTexts
----------------------------------------------------------------
local function AddDefaults()
	local Name = UnitName("player")
	local Realm = GetRealmName()

	TukuiData[Realm][Name].DataTexts = {}

	TukuiData[Realm][Name].DataTexts["Gold"] = { true, 1 }
	TukuiData[Realm][Name].DataTexts["Character"] = { true, 2}
	TukuiData[Realm][Name].DataTexts["Talents"] = { true, 3 }
	TukuiData[Realm][Name].DataTexts["FPSAndMS"] = { true, 4 }
	TukuiData[Realm][Name].DataTexts["System"] = { true, 5 }
	TukuiData[Realm][Name].DataTexts["MicroMenu"] = { true, 6 }
	TukuiData[Realm][Name].DataTexts["Time"] = { true, 7 }
end
hooksecurefunc(DataTexts, "AddDefaults", AddDefaults)

