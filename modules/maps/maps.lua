local T, C, L = Tukui:unpack()
local Minimap = T.Maps.Minimap
local Panels = T.Panels
local Experience = T.Miscellaneous.Experience
local Reputation = T.Miscellaneous.Reputation

----------------------------------------------------------------
-- Minimap
----------------------------------------------------------------
local function Enable(self)
    local Ticket = self.Ticket
    local MinimapZone = self.MinimapZone
	local MinimapCoords = self.MinimapCoords
    local MinimapDataText = Panels.MinimapDataText
    local Mail = MiniMapMailFrame
	local MailBorder = MiniMapMailBorder
	local MailIcon = MiniMapMailIcon
	local QueueStatusMinimapButton = QueueStatusMinimapButton
	local QueueStatusFrame = QueueStatusFrame
	local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
	local GuildInstanceDifficulty = GuildInstanceDifficulty
	local HelpOpenTicketButton = HelpOpenTicketButton
    
    -- Minimap
    self:ClearAllPoints()
    self:Point("TOPRIGHT", UIParent, "TOPRIGHT", -7, -7)
    self:Size(152)
    self.Backdrop:SetOutside()

    if (C.Auras.ClassicTimer) then
        self:Size(155)
    end

    -- MinimapZone
    MinimapZone:ClearAllPoints()
    MinimapZone:Point("TOPLEFT", self, "TOPLEFT", 2, -2)
    MinimapZone:Point("TOPRIGHT", self, "TOPRIGHT", -2, -2)
    MinimapZone:Height(20)
    MinimapZone:SetTemplate("Transparent")

    MinimapZone.Text:ClearAllPoints()
    MinimapZone.Text:Point("CENTER", MinimapZone, "CENTER", 0, 0)
    MinimapZone.Text:SetJustifyH("CENTER")

    -- MinimapCoords
    MinimapCoords:ClearAllPoints()
    MinimapCoords:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
    MinimapCoords:Size(40, 20)
    MinimapCoords:SetTemplate("Transparent")

    MinimapCoords.Text:ClearAllPoints()
    MinimapCoords.Text:Point("CENTER", MinimapCoords, "CENTER", 0, 0)
    MinimapCoords.Text:SetJustifyH("CENTER")

    -- Minimap DataText
    MinimapDataText:ClearAllPoints()
    MinimapDataText:Point("BOTTOM", self, "BOTTOM", 0, 2)
    MinimapDataText:Size(55, 19)
    MinimapDataText:StripTextures()

    -- Ticket
    local TicketAnchor = Minimap
    
    if (Experience.XPBar2:IsShown()) then
        TicketAnchor = Experience.XPBar2
    elseif (Experience.XPBar1:IsShown()) then
        TicketAnchor = Experience.XPBar1
    elseif (Reputation.XPBar2:IsShown()) then
        TicketAnchor = Reputation.RepBar2
    elseif (Experience.XPBar1:IsShown()) then
        TicketAnchor = Reputation.RepBar1
    end

    Ticket:ClearAllPoints()
    Ticket:Point("TOPLEFT", TicketAnchor, "BOTTOMLEFT", 0, -7)
    Ticket:Point("TOPRIGHT", TicketAnchor, "BOTTOMRIGHT", 0, -7)
    Ticket:Height(23)
    Ticket:CreateBackdrop()

    Ticket.Text:ClearAllPoints()
    Ticket.Text:Point("CENTER", Ticket, "CENTER", 0, 1)

    -- Mail
    Mail:ClearAllPoints()
    Mail:Point("TOPRIGHT", self, "TOPRIGHT", 5, 5)

    -- QueueStatusMinimapButton
	QueueStatusMinimapButton:ClearAllPoints()
	QueueStatusMinimapButton:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)

    -- MiniMapInstanceDifficulty
    MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Point("TOPLEFT", self, "TOPLEFT", 2, -2)

    -- GuildInstanceDifficulty
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:Point("TOPLEFT", self, "TOPLEFT", 2, -2)
end
hooksecurefunc(Minimap, "Enable", Enable)
