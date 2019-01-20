local T, C, L = Tukui:unpack()
local ActionBars = T.ActionBars
local Panels = T.Panels
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

----------------------------------------------------------------
-- ActionBar1
----------------------------------------------------------------
local function CreateBar1()
	local Bar = Panels.ActionBar1
	local Size = C.ActionBars.NormalButtonSize
	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	
    Bar:ClearAllPoints()
    Bar:Point("BOTTOM", UIParent, "BOTTOM", 0, 7)
    Bar:Width((Size * 12) + (Spacing * 13) - 2)
    Bar:Height((Size * 1) + (Spacing * 2) - 2)
    Bar.Backdrop:StripTextures(true)
    Bar.Backdrop = nil
    Bar:CreateBackdrop("Transparent")

	Bar:SetScript("OnEvent", function(self, event, unit, ...)
		if (event == "PLAYER_ENTERING_WORLD") then
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local Button = _G["ActionButton"..i]
				Button:Size(Size)
				Button:ClearAllPoints()
				Button:SetParent(self)
                
                if (i == 1) then
                    local Offset = Spacing - 1
                    Button:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", Offset, Offset)
                else
					local PreviousButton = _G["ActionButton"..i-1]
					Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
				end
			end
		elseif (event == "UPDATE_VEHICLE_ACTIONBAR") or (event == "UPDATE_OVERRIDE_ACTIONBAR") then
			for i = 1, 12 do
				local Button = _G["ActionButton"..i]
				local Action = Button.action
				local Icon = Button.icon

				if Action >= 120 then
					local Texture = GetActionTexture(Action)

					if (Texture) then
						Icon:SetTexture(Texture)
						Icon:Show()
					else
						if Icon:IsShown() then
							Icon:Hide()
						end
					end
				end
			end
		end
	end)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["ActionButton"..i]
		Bar["Button"..i] = Button
	end
end
hooksecurefunc(ActionBars, "CreateBar1", CreateBar1)