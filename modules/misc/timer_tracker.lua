local T, C, L = Tukui:unpack()
local TimerTracker = T.Miscellaneous.TimerTracker

----------------------------------------------------------------
-- Timer Tracker (e.g: Battleground Timer)
----------------------------------------------------------------
local baseUpdateBar = TimerTracker.UpdateBar

function TimerTracker:UpdateBar()
    
    -- first, call the base function
    baseUpdateBar(self)

    -- second, we edit it
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    for i = 1, self:GetNumRegions() do
		local Region = select(i, self:GetRegions())

		if Region:GetObjectType() == "Texture" then
			Region:SetTexture(nil)
        elseif Region:GetObjectType() == "FontString" then
            Region:SetPoint("CENTER", self, "CENTER", 0, -1)
			Region:SetFont(Font, FontSize, FontStyle)
			Region:SetShadowColor(.0,.0,.0,.0)
		end
    end
    
    -- self:ClearAllPoints()
    self:Width(210)
    self:Height(16)
    self:SetBackdrop(nil)
    self:CreateBackdrop()
    self.Backdrop:SetTripleBorder()
    self.Backdrop:SetOutside(nil, 2, 2)
    self:SetStatusBarTexture(Texture)
    self.Shadow:Kill()
end
