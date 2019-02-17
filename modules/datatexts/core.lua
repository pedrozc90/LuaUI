local T, C, L = Tukui:unpack()
local DataTexts = T.DataTexts
local Panels = T.Panels

----------------------------------------------------------------
-- DataTexts
----------------------------------------------------------------
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

	-- Set the new data text
	self.Data = object
	self.Data:Enable()
	self.Data.Text:Point("RIGHT", self, 0, 0)
	self.Data.Text:Point("LEFT", self, 3, 0)
	self.Data.Text:Point("TOP", self, 0, 0)
	self.Data.Text:Point("BOTTOM", self, 0, 2)
	self.Data.Position = self.Num
	self.Data:SetAllPoints(self.Data.Text)

	if (Panels.DataTextLeft and self.Data.Position >= 1 and self.Data.Position <= 3) then
		self.Data:SetParent(Panels.DataTextLeft)
	elseif (Panels.DataTextRight and self.Data.Position >= 4 and self.Data.Position <= 6) then
		self.Data:SetParent(Panels.DataTextRight)
	elseif (Panels.MinimapDataText and self.Data.Position == 7) then
		self.Data:SetParent(Panels.MinimapDataText)
	end
end

function DataTexts:CreateAnchors()
	local DataTextLeft = Panels.DataTextLeft
	local DataTextRight = Panels.DataTextRight
	local MinimapDataText = Panels.MinimapDataText

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
		Frame:Height(DataTextLeft:GetHeight() - 2)
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
			Frame:Width(Size + 1)
		else
			Frame:Width(Size)
		end

		Frame.Tex = Frame:CreateTexture()
		Frame.Tex:SetAllPoints()
		Frame.Tex:SetColorTexture(0.2, 1, 0.2, 0)

		self.Anchors[i] = Frame

		if (i == 1) then
			Frame:Point("LEFT", DataTextLeft, "LEFT", 1, 0)
		elseif (i == 4) then
			Frame:Point("LEFT", DataTextRight, "LEFT", 1, 0)
		elseif (i == 7) then
			Frame:Point("CENTER", MinimapDataText, 0, 0)
			Frame:Width(MinimapDataText:GetWidth() - 2)
			Frame:Height(MinimapDataText:GetHeight() - 2)
		else
			Frame:Point("LEFT", self.Anchors[i-1], "RIGHT", 1, 0)
		end
	end
end

local GetTooltipAnchor = function(self)
	local Position = self.Position
	local From
	local Anchor = "ANCHOR_TOP"
	local X = 0
	local Y = T.Scale(16)

	if ((Position >= 1) and (Position <= 3)) then
		X = T.Scale(-1)
		Anchor = "ANCHOR_TOPLEFT"
		From = Panels.LeftChatBG
	elseif ((Position >= 4) and (Position <= 6)) then
		X = T.Scale(1)
		Anchor = "ANCHOR_TOPRIGHT"
		From = Panels.RightChatBG
	elseif ((Position == 7) and Panels.MinimapDataText) then
		Anchor = "ANCHOR_BOTTOMLEFT"
		Y = T.Scale(-5)
		From = Panels.MinimapDataText
	end

	return From, Anchor, X, Y
end

-- Update Anchor
for Name, DataText in pairs(DataTexts.Texts) do
    if (DataText.GetTooltipAnchor) then
        DataText.GetTooltipAnchor = GetTooltipAnchor
    end
end

----------------------------------------------------------------
-- Set Default DataTexts
----------------------------------------------------------------
hooksecurefunc(DataTexts, "AddDefaults", function()
	local Name = UnitName("player")
	local Realm = GetRealmName()

    TukuiData[Realm][Name].Texts = {}
	TukuiData[Realm][Name].Texts[L.DataText.Durability] = {true, 1}
	TukuiData[Realm][Name].Texts[L.DataText.Gold] = {true, 2}
	TukuiData[Realm][Name].Texts[L.DataText.Talents] = {true, 3}
	TukuiData[Realm][Name].Texts[L.DataText.FPSAndMS] = {true, 4}
	TukuiData[Realm][Name].Texts[L.DataText.Memory] = {true, 5}
	TukuiData[Realm][Name].Texts[L.DataText.BagSlots] = {true, 6}
	TukuiData[Realm][Name].Texts[L.DataText.Time] = {true, 7}
end)