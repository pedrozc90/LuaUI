local T, C, L = Tukui:unpack()
local MirrorTimers = T.Miscellaneous.MirrorTimers

----------------------------------------------------------------
-- Mirror Timers (e.g: Breath Timer)
----------------------------------------------------------------
local baseUpdate = MirrorTimers.Update

function MirrorTimers:Update()

    -- first, call the base function
    baseUpdate(self)

    -- second, we edit it
    local Texture = C.Medias.Blank
    local Font, FontSize, FontStyle = C.Medias.Font, 12, nil

    for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
        local Bar = _G["MirrorTimer"..i]
        local Status = _G[Bar:GetName().."StatusBar"]
        local Border = _G[Bar:GetName().."Border"]
        local Text = _G[Bar:GetName().."Text"]
        
        -- Bar:ClearAllPoints()
        Bar:Width(210)
        Bar:Height(16)
        Bar:SetBackdrop(nil)
        Bar:CreateBackdrop()
        Bar.Backdrop:SetBorder()
        Bar.Backdrop:SetOutside(nil, 2, 2)
        Bar.Shadow:Kill()

        Status:ClearAllPoints()
        Status:SetAllPoints()
        Status:SetStatusBarTexture(Texture)

        Text:ClearAllPoints()
        Text:Point("CENTER", Bar, "CENTER", 0, -1)
        Text:SetFont(Font, FontSize, FontStyle)
    end
end
