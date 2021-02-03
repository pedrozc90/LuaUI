local T, C, L = Tukui:unpack()
local MirrorTimers = T.Miscellaneous.MirrorTimers

----------------------------------------------------------------
-- Mirror Timers (e.g: Breath Timer)
----------------------------------------------------------------
local baseUpdate = MirrorTimers.Update

function MirrorTimers:Update()

    -- first, we call the base function
    baseUpdate(self)

    -- second, we edit it
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
        local Bar = _G["MirrorTimer"..i]
        local Status = _G[Bar:GetName().."StatusBar"]
        local Border = _G[Bar:GetName().."Border"]
        local Text = _G[Bar:GetName().."Text"]
        
        Bar:SetWidth(210)
        Bar:SetHeight(16)
        Bar.Backdrop:SetOutside()

        Status:ClearAllPoints()
        Status:SetAllPoints()
        Status:SetStatusBarTexture(Texture)

        Text:ClearAllPoints()
        Text:SetPoint("CENTER", Bar, "CENTER", 0, 0)
        Text:SetFont(Font, FontSize, FontStyle)
    end
end
