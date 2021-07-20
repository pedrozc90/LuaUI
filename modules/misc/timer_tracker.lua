local T, C, L = Tukui:unpack()
local TimerTracker = T.Miscellaneous.TimerTracker

if (true) then return end;

----------------------------------------------------------------
-- Timer Tracker (e.g: Battleground Timer)
----------------------------------------------------------------
local baseUpdateBar = TimerTracker.UpdateBar

function TimerTracker:UpdateBar()
    -- first, we call the base function
    baseUpdateBar(self)

    -- second, we edit it
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    for i = 1, self:GetNumRegions() do
		local Region = select(i, self:GetRegions())

		if (Region:GetObjectType() == "Texture") then
			Region:SetTexture(nil)
        elseif (Region:GetObjectType() == "FontString") then
            Region:SetPoint("CENTER", self, "CENTER", 0, -1)
			Region:SetFont(Font, FontSize, FontStyle)
			Region:SetShadowColor(0,0,0,0)
		end
    end
    
    self:SetWidth(210)
    self:SetHeight(16)
    self:SetStatusBarTexture(Texture)
    self:SetStatusBarColor(170 / 255, 10 / 255, 10 / 255)
    self.Backdrop.Shadow:Kill()
end
