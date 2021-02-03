local T, C, L = Tukui:unpack()
local Tooltips = T.Tooltips
local DataTexts = T.DataTexts.Panels
local Chat = T.Chat.Panels
local Bags = T.Inventory.Bags

if (not C.Lua.Enable) then return end

----------------------------------------------------------------
-- Tooltips
----------------------------------------------------------------
local function UpdatePosition(self)
    local DataTextRight = DataTexts.Right
    local RightChatBG = Chat.RightChat
    local Focus = oUF_TukuiFocus
    local Pet = oUF_TukuiPet
    local Bag = Bags["Bag"]

    self:ClearAllPoints()
    if (Bag and Bag:IsVisible()) then
        self:SetPoint("BOTTOMRIGHT", Bag.SortButton, "TOPRIGHT", -2, 5)
    elseif (Pet and Pet:IsVisible()) then
        self:SetPoint("BOTTOMRIGHT", Pet, "TOPRIGHT", 0, 7)
    elseif (Focus and Focus:IsVisible()) then
        self:SetPoint("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 39)
    elseif (RightChatBG and RightChatBG:IsShown()) then
        self:SetPoint("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 7)
    else
        self:SetPoint("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", -2, 5)
    end
end

local function CreateAnchor(self)
    local Anchor = self.Anchor

    UpdatePosition(Anchor)
end
hooksecurefunc(Tooltips, "CreateAnchor", CreateAnchor)

--
local function SetTooltipDefaultAnchor(self, parent)
    local Anchor = self.Anchor

    if (C.Tooltips.MouseOver) then
		if (parent ~= UIParent) then
			self:SetAnchorType("ANCHOR_TOPRIGHT", 2, -23)
		else
			self:SetOwner(parent, "ANCHOR_CURSOR")
		end
	else
		self:SetAnchorType("ANCHOR_TOPRIGHT", 2, -23)
	end
end
hooksecurefunc(Tooltips, "SetTooltipDefaultAnchor", SetTooltipDefaultAnchor)

local function OnUpdate(self, elapsed)
    local Owner = self:GetOwner()

    -- update tukui tooltip anchor is pet or chatbackground are visible
    if (Owner) and (Owner:GetName() == "TukuiTooltipAnchor") then
        UpdatePosition(Owner)
    end
end
hooksecurefunc(Tooltips, "OnUpdate", OnUpdate)

local function Enable(self)
    -- tooltip health bar
    local HealthBar = GameTooltipStatusBar

	HealthBar:ClearAllPoints()
    HealthBar:SetPoint("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 2, 5)
    HealthBar:SetPoint("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", -2, 5)
    HealthBar:SetHeight(9)

    if (C.Tooltips.UnitHealthText) then
		HealthBar.Text:ClearAllPoints()
		HealthBar.Text:SetPoint("CENTER", HealthBar, "CENTER", 0, 1)
    end
end
hooksecurefunc(Tooltips, "Enable", Enable)
