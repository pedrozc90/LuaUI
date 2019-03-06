local T, C, L = Tukui:unpack()
local Tooltips = T.Tooltips
local Panels = T.Panels

----------------------------------------------------------------
-- Tooltips
----------------------------------------------------------------
local function UpdatePosition(self)
    local DataTextRight = Panels.DataTextRight
    local RightChatBG = Panels.RightChatBG
    local Focus = oUF_TukuiFocus
    local Pet = oUF_TukuiPet

    self:ClearAllPoints()
    if (Pet and Pet:IsVisible()) then
        self:Point("BOTTOMRIGHT", Pet, "TOPRIGHT", 0, 7)
    elseif (Focus and Focus:IsVisible()) then
        self:Point("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 39)
    elseif (RightChatBG and RightChatBG:IsShown()) then
        self:Point("BOTTOMRIGHT", RightChatBG, "TOPRIGHT", 0, 7)
    else
        self:Point("BOTTOMRIGHT", DataTextRight, "TOPRIGHT", -2, 5)
    end
end

local function CreateAnchor(self)
    local Anchor = self.Anchor

    UpdatePosition(Anchor)
end
hooksecurefunc(Tooltips, "CreateAnchor", CreateAnchor)

--
local function SetTooltipDefaultAnchor(self, parent)
    local Anchor = Tooltips.Anchor
    
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
    HealthBar:Point("BOTTOMLEFT", HealthBar:GetParent(), "TOPLEFT", 2, 5)
    HealthBar:Point("BOTTOMRIGHT", HealthBar:GetParent(), "TOPRIGHT", -2, 5)
    HealthBar:Height(9)

    if (C["Tooltips"].UnitHealthText) then
		HealthBar.Text:ClearAllPoints()
		HealthBar.Text:Point("CENTER", HealthBar, "CENTER", 0, 1)
    end
end
hooksecurefunc(Tooltips, "Enable", Enable)