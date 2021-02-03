local T, C, L = Tukui:unpack()
local Chat = T.Chat
local DataTexts = T.DataTexts

-- local baseAddPanels = Chat.AddPanels

-- local function AddPanels(self)

-- 	-- local BottomLine = self.BottomLine
-- 	-- local LeftVerticalLine = self.LeftVerticalLine
-- 	-- local RightVerticalLine = self.RightVerticalLine
-- 	local DataTextLeft = DataTexts.Panels.Left
-- 	local DataTextRight = DataTexts.Panels.Right
	
-- 	local LeftChatBG = self.Panels.LeftChat
-- 	local RightChatBG = self.Panels.RightChat
-- 	local TabsBGLeft = self.Panels.LeftChatTabs
--     local TabsBGRight = self.Panels.RightChatTabs

-- 	local Padding = 5
--     local xOffset, yOffset = 5, 5
-- 	-- local ChatWidth = 380 + xOffset + yOffset
-- 	local ChatWidth = T.DataTexts.Panels.Left:GetWidth() + (2 * Padding)
-- 	local ChatHeight = (C.General.Themes.Value == "Tukui") and C.Chat.LeftHeight or 177

--     -- Kill Lines
--     -- BottomLine:Kill()
--     -- LeftVerticalLine:Kill()
--     -- RightVerticalLine:Kill()

--     LeftChatBG:ClearAllPoints()
--     LeftChatBG:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", xOffset, yOffset)
--     LeftChatBG:SetSize(ChatWidth, ChatHeight)

--     RightChatBG:ClearAllPoints()
--     RightChatBG:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -xOffset, xOffset)
--     RightChatBG:SetSize(ChatWidth, ChatHeight)

--     TabsBGLeft:ClearAllPoints()
--     TabsBGLeft:SetPoint("TOPLEFT", LeftChatBG, "TOPLEFT", Padding, -Padding)
--     TabsBGLeft:SetPoint("TOPRIGHT", LeftChatBG, "TOPRIGHT", -Padding, -Padding)
--     TabsBGLeft:SetHeight(23)

--     TabsBGRight:ClearAllPoints()
--     TabsBGRight:SetPoint("TOPLEFT", RightChatBG, "TOPLEFT", Padding, -Padding)
--     TabsBGRight:SetPoint("TOPRIGHT", RightChatBG, "TOPRIGHT", -Padding, -Padding)
--     TabsBGRight:SetHeight(23)
-- end
-- hooksecurefunc(Chat, "AddPanels", AddPanels)

if (not C.Lua.Enable) then return end

----------------------------------------------------------------
-- ChatFrames
----------------------------------------------------------------
local function SetDefaultChatFramesPositions()
    -- load saved variables
    local Name = UnitName("player")
    local Realm = GetRealmName()

    local DataTextLeft = Panels.DataTextLeft
    local Width = DataTextLeft:GetWidth() - 2
    local Height = 118

    for i = 1, NUM_CHAT_WINDOWS do
		local Frame = _G["ChatFrame"..i]
        local ID = Frame:GetID()

        -- Set font size and chat frame size
		Frame:SetSize(Width, Height)

		-- Set default chat frame position
		if (ID == 1) then
			Frame:ClearAllPoints()
			Frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 13, 38)
		elseif (ID == 5) then
			if (not Frame.isDocked) then
				Frame:ClearAllPoints()
				Frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -11, 38)
			end
        end

        if (ID == 1) then
			FCF_SetWindowName(Frame, "G, S & W")
		end

		if (ID == 2) then
			FCF_SetWindowName(Frame, "Log")
        end

        if (ID == 3) then
			FCF_SetWindowName(Frame, "Spam")
        end

        if (ID == 4) then
			FCF_SetWindowName(Frame, "Whispers")
		end

		if (ID == 5) then
			FCF_SetWindowName(Frame, "Loot")
		end

		if (not Frame.isLocked) then
			FCF_SetLocked(Frame, 1)
		end

        local Anchor1, Parent, Anchor2, X, Y = Frame:GetPoint()
		TukuiData[Realm][Name].Chat["Frame" .. i] = {Anchor1, Anchor2, X, Y, Width, Height}
    end
end
-- hooksecurefunc(Chat, "SetDefaultChatFramesPositions", SetDefaultChatFramesPositions)

local function Install(self)
	-- Create our custom chatframes
	FCF_ResetChatWindows()
    FCF_SetLocked(ChatFrame1, 1)

	FCF_DockFrame(ChatFrame2)
    FCF_SetLocked(ChatFrame2, 1)

	FCF_OpenNewWindow(SPAM)
	FCF_SetLocked(ChatFrame3, 1)
    FCF_DockFrame(ChatFrame3)

    FCF_OpenNewWindow(WHISPERS)
	FCF_SetLocked(ChatFrame4, 1)
    FCF_DockFrame(ChatFrame4)

	FCF_OpenNewWindow(LOOT)
	FCF_UnDockFrame(ChatFrame5)

	-- Set more chat groups
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, TRADE)
	ChatFrame_RemoveChannel(ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(ChatFrame1, L.ChatFrames.LocalDefense)
	ChatFrame_RemoveChannel(ChatFrame1, L.ChatFrames.GuildRecruitment)
	ChatFrame_RemoveChannel(ChatFrame1, L.ChatFrames.LookingForGroup)
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")

	-- Setup the Genera/Spam chat frame
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
    ChatFrame_AddChannel(ChatFrame3, TRADE)
	ChatFrame_AddChannel(ChatFrame3, GENERAL)
	ChatFrame_AddChannel(ChatFrame3, L.ChatFrames.LocalDefense)
	ChatFrame_AddChannel(ChatFrame3, L.ChatFrames.GuildRecruitment)
	ChatFrame_AddChannel(ChatFrame3, L.ChatFrames.LookingForGroup)

    -- Setup the Whisper chat frame
    ChatFrame_RemoveAllMessageGroups(ChatFrame4)
    ChatFrame_AddMessageGroup(ChatFrame4, "WHISPER")
    ChatFrame_AddMessageGroup(ChatFrame4, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame4, "BN_CONVERSATION")

	-- Setup the right chat
	ChatFrame_RemoveAllMessageGroups(ChatFrame5)
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame5, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame5, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame5, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame5, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame5, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame5, "SKILL")

	-- Enable Classcolor
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")

	-- Setup font size
	FCF_SetChatWindowFontSize(nil, ChatFrame1, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame2, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame3, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame4, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame5, 12)

	DEFAULT_CHAT_FRAME:SetUserPlaced(true)

	self:SetDefaultChatFramesPositions()
end
hooksecurefunc(Chat, "Install", Install)

local function Setup(self)
	local LeftChatBG = Panels.LeftChatBG
	local TabsBGLeft = Panels.TabsBGLeft

	-- QuickJoinToastButton
	QuickJoinToastButton.ClearAllPoints = BNToastFrame.ClearAllPoints
	QuickJoinToastButton.SetPoint = BNToastFrame.SetPoint
	QuickJoinToastButton:ClearAllPoints()
	QuickJoinToastButton:SetPoint("TOPLEFT", TabsBGLeft, "BOTTOMLEFT", 0, -66)
	QuickJoinToastButton:SetAlpha(0)

	QuickJoinToastButton.ClearAllPoints = function() end
	QuickJoinToastButton.SetPoint = function() end

    -- ChatMenu
    ChatMenu:ClearAllPoints()
	ChatMenu:SetPoint("BOTTOMLEFT", LeftChatBG, "TOPLEFT", -2, 5)
end
hooksecurefunc(Chat, "Setup", Setup)
