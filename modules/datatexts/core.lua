local T, C, L = Tukui:unpack()
local DataTexts = T.DataTexts

----------------------------------------------------------------
-- DataTexts
----------------------------------------------------------------

function DataTexts:AddDefaults()
	local Name = UnitName("player")
	local Realm = GetRealmName()

	TukuiDatabase.Variables[Realm][Name].DataTexts = {}

	TukuiDatabase.Variables[Realm][Name].DataTexts["Guild"] = { true, 1 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["Character"] = { true, 2 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["System"] = { true, 3 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["Friends"] = { true, 4 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["MicroMenu"] = { true, 5 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["Gold"] = { true, 6 }
	TukuiDatabase.Variables[Realm][Name].DataTexts["Time"] = { true, 7 }
end

local baseEnable = DataTexts.Enable

function DataTexts:Enable()
	-- first, we call the base function
	baseEnable(self)

	-- second, we edit it
	local DataTextLeft = self.Panels.Left
	local DataTextRight = self.Panels.Right

	local Padding = C.Chat.Padding + C.Lua.ScreenMargin

	DataTextLeft:ClearAllPoints()
	DataTextLeft:SetWidth(C.General.Themes.Value == "Tukui" and C.Chat.LeftWidth or 370)
	DataTextLeft:SetHeight(23)
	DataTextLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", Padding, Padding)
	DataTextLeft:CreateBackdrop("Transparent")
	DataTextLeft:SetFrameStrata("BACKGROUND")
	DataTextLeft:SetFrameLevel(2)

	DataTextRight:ClearAllPoints()
	DataTextRight:SetWidth(C.General.Themes.Value == "Tukui" and C.Chat.RightWidth or 370)
	DataTextRight:SetHeight(23)
	DataTextRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -Padding, Padding)
	DataTextRight:CreateBackdrop("Transparent")
	DataTextRight:SetFrameStrata("BACKGROUND")
	DataTextRight:SetFrameLevel(2)
end
