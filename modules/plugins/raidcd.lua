local T, C, L = Tukui:unpack()

----------------------------------------------------------------
-- Raid Cooldowns
-- Author: Allez
-- Editor: Luaerror
----------------------------------------------------------------
if (not C.RaidCD.Enable) then return end

local RaidCooldowns = {
    ["DEATHKNIGHT"] = {
        [61999] = true,                         -- Raise Ally
        [48792] = true,                         -- Icebound Foritude
    },
    ["DEMONHUNTER"] = {
        [196718] = true,                        -- Darkness
    },
    ["DRUID"] = {
        [20484] = true,                         -- Rebirth
        
        -- Balance
        [29166] = true,                         -- Innervate

        -- Guardian
        [61336] = true,                         -- Survival Instincts

        -- Restoration
        [740] = true,                           -- Tranquility
        [33891] = true,                         -- Incarnation: Tree of Life
        [102342] = true,                        -- Ironbark
        [197721] = false,                       -- Flourish
    },
    ["HUNTER"] = {
        [264667] = true,                        -- Primal Rage
    },
    ["MAGE"] = {
        [80353] = true,                         -- Time Warp
    },
    ["MONK"] = {
        -- Brewmaster
        [115176] = true,                        -- Zen Meditation
        [120954] = true,                        -- Fortigying Brew
        [122278] = true,                        -- Dampen Harm

        -- Mistweaver
        [115310] = true,                        -- Revival
        [116849] = true,                        -- Life Cocoon
    },
    ["PALADIN"] = {
        [642] = true,                           -- Divine Shield
        [633] = true,                           -- Lay of Hands
        [1022] = true,                          -- Blessing of Protection
        [6940] = true,                          -- Blessing of Sacrifice
        [204018] = true,                        -- Blessing of Spellwarding
        
        -- Holy
        [498] = true,                           -- Divine Protection
        [31821] = true,                         -- Aura Mastery
        
        -- Protection
        [31850] = true,                         -- Ardent Defender
        [86659] = true,                         -- Guardian of Ancient Kings
        [204150] = true,                        -- Aegis of Light
    },
    ["PRIEST"] = {
        -- Discipline
        [33206] = true,                         -- Pain Suppression
        [62618] = true,                         -- Power Word: Barrier
        [271466] = true,                        -- Luminous Barrier

        [47540] = true,                         -- Penance

        -- Holy
        [47788] = true,                         -- Guardian Spirit
        [64843] = true,                         -- Divine Hymn
        [64901] = true,                         -- Symbol of Hope
        [265202] = true,                        -- Holy Word: Salvation

        -- Shadow
        [15286] = true,                         -- Vampiric Embrace
        [47585] = true,                         -- Dispersion
    },
    ["ROGUE"] = {},
    ["SHAMAN"] = {
        [2825] = true,                          -- Bloodlust
        [32182] = true,                         -- Heroism
        [20608] = true,                         -- Reincarnation

        -- Elemental
        [108281] = true,                        -- Ancestral Guidance

        -- Restoration
        -- [98008] = true,                         -- Spirit Link Totem
        [108280] = true,                        -- Healing Tide Totem
        [207399] = true,                        -- Ancestral Protection Totem
    },
    ["WARLOCK"] = {
        [20707] = true,                         -- Soulstone
    },
    ["WARRIOR"] = {
        [97462] = true,                         -- Rallying Cry

        -- Protection
        [871] = true,                           -- Shield Wall
        [12975] = true,                         -- Last Stand
    },
    ["ALL"] = {}
}

local ZoneTypes = {
    ["none"] = true,                           -- when outside an instance
    ["pvp"] = false,                            -- when in a battleground
    ["arena"] = true,                           -- when in an arena
    ["party"]= true,                            -- when in a 5-man instance
    ["raid"] = true,                            -- when in a raid instance
    ["scenario"] = false,                       -- when in a scenario
	-- nil when in an unknown kind of instance
}

local bars = {}
local chatType = nil
local BarWidth, BarHeight = unpack(C.RaidCD.BarSize)
local BarSpacing = C.RaidCD.BarSpacing
local MaxBars = C.RaidCD.MaxBars

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
local bor, band = bit.bor, bit.band
local tinsert, tremove, tsort = table.insert, table.remove, table.sort
local format = string.format
local floor, random = math.floor, math.random

local COMBATLOG_FILTER_GROUP_MEMBER = bor(COMBATLOG_OBJECT_AFFILIATION_RAID,
COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_MINE)

-- update bars position
local function UpdateBarPosition()
    local Spacing = C.RaidCD.BarSpacing
    
    for i = 1, #bars do
        bars[i]:ClearAllPoints()
        if (i == 1) then
            bars[i]:SetPoint(unpack(C.RaidCD.Anchor))
        else
            bars[i]:SetPoint("TOPLEFT", bars[i - 1], "BOTTOMLEFT", 0, -Spacing)
        end
        bars[i].id = i

        if (i >= MaxBars) then
            bars[i]:Hide()
        else
            bars[i]:Show()
        end
    end
end

-- stop cooldown bar, and remove it from table.
local function StopTimer(bar)
    bar:SetScript("OnUpdate", nil)
    bar:Hide()
    tremove(bars, bar.id)
    bar = nil
    UpdateBarPosition()
end

-- display tooltip.
local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.spell, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

-- hide tooltip.
local OnLeave = function(self)
	GameTooltip:Hide()
end

-- send a chat message.
local OnMouseDown = function(self, button)
    if (button == "LeftButton") then
        if (chatType) then
            SendChatMessage(format("Cooldown: %s - %s (%s remaining)!", self.caster, self.name, self.right:GetText()), chatType)
        end
    elseif (button == "RightButton") then
        StopTimer(self);
    end
end

-- creates a new cooldown bar
local function CreateBar()
    local Font, FontSize, FontStyle = C.Medias.PixelFont, 12, "MONOCHROMEOUTLINE"
    local Width, Height = unpack(C.RaidCD.BarSize)
    local Spacing = C.RaidCD.BarSpacing
    local StatusBarTexture = C.Medias.Blank

    local bar = CreateFrame("Frame", nil, UIParent)
    bar:SetSize(Width, Height)
    bar:SetFrameStrata("HIGH")

    local button = CreateFrame("Button", nil, bar)
    button:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    button:SetSize(Height, Height)
    button:CreateBackdrop("Default")

    local icon = button:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(button)
	icon:SetTexCoord(unpack(T.IconCoord))

    local status = CreateFrame("StatusBar", nil, bar)
    status:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
    status:SetWidth(Width - Height - Spacing)
    status:SetHeight(C.RaidCD.StatusBarHeight)
    status:SetStatusBarTexture(StatusBarTexture)
    status:SetMinMaxValues(0, 100)
    status:SetFrameLevel(bar:GetFrameLevel() - 1)
    status:CreateBackdrop("Default")

    local left = bar:CreateFontString(nil, "OVERLAY")
    left:SetPoint("LEFT", status, "LEFT", 5, 12)
    left:SetJustifyH("LEFT")
    left:SetFont(Font, FontSize, FontStyle)

    local right = bar:CreateFontString(nil, "OVERLAY")
    right:SetPoint("RIGHT", status, "RIGHT", -3, 12)
    right:SetJustifyH("RIGHT")
    right:SetFont(Font, FontSize, FontStyle)

    bar.button = button
    bar.icon = icon
    bar.status = status
    bar.left = left
    bar.right = right

    return bar
end

-- update bar cooldown time
local UpdateInterval = 0.1
local function OnUpdate(self, elapsed)
    self.LastUpdate = (self.LastUpdate or 0) + elapsed

    while (self.LastUpdate > UpdateInterval) do
        self.remaining = self.remaining - self.LastUpdate
        
        self.status:SetValue(100 * self.remaining / self.cooldown)
        self.right:SetText(T.FormatTime(self.remaining))

        if (self.remaining <= 0) then
            StopTimer(self)
            return
        end

        self.LastUpdate = self.LastUpdate - UpdateInterval;
    end
end

-- start a new cooldown bar
local function StartTimer(sourceName, class, spellID, cooldown)
    local spellName, spellRank, spellIcon = GetSpellInfo(spellID)

    -- check if spell bar already exists
    for _, v in pairs(bars) do
        if (v.caster == sourceName and v.name == spellName) then
            return
        end
    end

    local color = RAID_CLASS_COLORS[class]
    if (not color) then
        color = { r = 0.30, g = 0.30, b = 0.30 }
    end

    local bar = CreateBar()
    bar.caster = sourceName
    bar.name = spellName
    bar.cooldown = cooldown
    bar.remaining = cooldown

    if (spellIcon) then bar.icon:SetTexture(spellIcon) end
    bar.status:SetStatusBarColor(color.r, color.g, color.b)
    bar.left:SetText(sourceName)
    bar.right:SetText(T.FormatTime(cooldown))

    bar:EnableMouse(true)
	bar:SetScript("OnUpdate", OnUpdate)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
    bar:SetScript("OnMouseDown", OnMouseDown)
    
    -- insert new bar in to the list
    tinsert(bars, bar)

    -- sort cooldwons by remaining timer or spell name
    tsort(bars, function(a, b)
        if (a.remaining == b.remaining) then
            return a.name < b.name
        end
        return a.remaining < b.remaining
    end)

    UpdateBarPosition()
end

----------------------------------------------------------------
-- Frame
----------------------------------------------------------------
local f = CreateFrame("Frame", "RaidCD", UIParent)
f:SetPoint(unpack(C.RaidCD.Anchor))
f:SetWidth(BarWidth)
f:SetHeight((MaxBars * BarHeight) + ((MaxBars - 1) * BarSpacing))
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
    -- call one of the functions below
    self[event](self, ...)
end)

function f:PLAYER_ENTERING_WORLD()
    local inInstance, instanceType = IsInInstance()
    
    if (instanceType and ZoneTypes[instanceType]) then
        if (IsInRaid()) then
            chatType = "RAID"
        elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
            chatType = "INSTANCE_CHAT"
        elseif (IsInGroup()) then
            chatType = "PARTY"
        else
            chatType = "SAY"
        end
        T.Print("RaidCD Enabled.")
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        T.Print("RaidCD Disabled.")
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        -- stop all cooldown bars
        for key, bar in pairs(bars) do
            StopTimer(bar)
        end
    end
end

function f:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
    destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- check if caster is in party/raid member
    if (band(sourceFlags, COMBATLOG_FILTER_GROUP_MEMBER) == 0) then return end

    -- filter combat events type
    if (eventType == "SPELL_CAST_SUCCESS") or (eventType == "SPELL_AURA_APPLIED") or (eventType == "SPELL_RESURRECT") then

        -- spell standard
        local spellID, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

        local class = nil
        if (sourceGUID and sourceGUID:find("Player")) then
            class = select(2, GetPlayerInfoByGUID(sourceGUID))
        else
            class = "ALL"
        end

        -- check if spell is listed
        if (class and RaidCooldowns[class][spellID]) then
            local cooldown = GetSpellBaseCooldown(spellID) / 1000

            if (cooldown and cooldown > 0) then
                StartTimer(sourceName, class, spellID, cooldown)
            end
        end
    end
end

----------------------------------------------------------------
-- Test Mode
----------------------------------------------------------------
SLASH_RAIDCD1 = "/raidcd"
SlashCmdList["RAIDCD"] = function(cmd)
    local name = UnitName("player")
    if (cmd == "test") then
        -- simutate raidcd
        for class, tbl in pairs(RaidCooldowns) do
            for spellID, check in pairs(RaidCooldowns[class]) do
                if (check) then
                    local cooldown = GetSpellBaseCooldown(spellID) / 1000
                    if (cooldown and cooldown < 300) then
                        StartTimer(name, class, spellID, cooldown)
                    end
                end
            end
        end
    elseif (cmd == "reset") then
        repeat
         -- stop all cooldown bars
         for _, bar in ipairs(bars) do
            StopTimer(bar)
        end
        until (#bars == 0)
    end
end