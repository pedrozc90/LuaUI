local T, C, L = Tukui:unpack()
local class = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

----------------------------------------------------------------
-- LuaUI Settings
----------------------------------------------------------------
C["Lua"] = {
    -- Setup
    ["Enable"] = false,                             -- enable LuaUI edit
    ["UniColor"] = true,                            -- enable unicolor theme
    ["ColorPower"] = true,                          -- enable power bar color based on power type.
    ["ScreenMargin"] = 5,                           -- margin from screen border.

    -- System
    ["Setup"] = true,                               -- set console variables preferences.
    ["Mute"] = false,                               -- set system master sounds to 0.

    -- Media
    ["Font"] = "Tukui",                             -- default font type.
    ["Texture"] = "Blank",                          -- default texture type.

    -- Layout
    ["HealerLayout"] = true,                        -- enables healing raid layout.
}

-- UnitsFrames Size
C["Units"] = {
    ["Player"]          = { 258, 30 },              -- set player unitframe size.
    ["Target"]          = { 258, 30 },              -- set target unitframe size.
    ["TargetOfTarget"]  = { 177, 30 },              -- set targetoftarget unitframe size.
    ["Pet"]             = { 181, 25 },              -- set pet unitframe size.
    ["Focus"]           = { 205, 25 },              -- set focus unitframe size.
    ["FocusTarget"]     = { 205, 25 },              -- set focustarget unitframe size.
    ["Arena"]           = { 205, 25 },              -- set arena unitframe size.
    ["Boss"]            = { 205, 25 },              -- set boss unitframe size.
    -- ["Party"]           = { 185, 25 },           -- set party unitframe size.
    -- ["Raid"]            = {  72, 41 }            -- set raid unitframe size.
}

C["General"].OverDataTextLeft = true                -- display alternativa power bar over data text panel left.

-- ActionBars
C["ActionBars"].StanceBarBackground = false         -- enable stance bar background.

-- Chat
C["Chat"].Padding = 6                               -- padding between datatext and chat background.

-- Auras
C["Auras"].Spacing = 3                              -- set spacing between auras.

-- Nameplate
C["NamePlates"].PowerBar = false                    -- enables nameplates powerbar.
C["NamePlates"].DebuffSize = 18                     -- set debuff icon size.
C["NamePlates"].DebuffSpacing = 7                   -- set space between debuffs.

-- Party
C["Party"].ShowSolo = false                         -- display party frame when playing solo (only player unit).
C["Party"].WidthSize = 193                          -- party frame width
C["Party"].HeightSize = 25                          -- party frame height
C["Party"].Padding = 33 -- 39                       -- distance between party frames

-- Raid
C["Raid"].ShowSolo = false                          -- display raid frame when playing solo (only player unit).
C["Raid"].TestAuraWatch = false                     -- force to show aurawatch debuff. (use for testing)
C["Raid"].GroupRoles = true                         -- enables group role icon on raid frame.

-- Tooltips
C["Tooltips"].ShowSpellID = true                    -- enables spells, items, quest ids on tooltips.

C["UnitFrames"].UnlinkPetCastBar = false            -- enable
C["UnitFrames"].UnlinkBossCastBar = false           -- enable
C["UnitFrames"].UnlinkArenaCastBar = false          -- enable

----------------------------------------------------------------
-- Plugins Settings
----------------------------------------------------------------
C["Dispels"] = {
    ["Enable"] = true,                              -- enables dispel announce plugin.
    ["SpellLink"] = true,                           -- display spell link, else just the spell name.
}

C["Interrupts"] = {
    ["Enable"] = true,                              -- enables interrupt annouce plugin.
    ["SpellLink"] = false,                          -- display spell link, else just the spell name.
}

C["ScreenShots"] = {
    ["Enable"] = true,                              -- enables plugin.
    ["Achievements"] = true,                        -- enables screenshots of earned achievements.
    ["BossKills"] = false,                          -- enables screenshots of successful boss encounters.
    ["ChallendeMode"] = false,                      -- enables screenshots of successful challenge modes.
    ["LevelUp"] = false,                            -- enables screenshots when player level up.
    ["Messages"] = false,                           -- enables debug messages.
}

C["SpellAnnounce"] = {
    ["Enable"] = false,                             -- enables spell announce plugin.
    ["GroupChat"] = true,                           -- set announce chat channel to by group type and instance.
    ["SpellLink"] = true,                           -- enable spell link one messages.
}

C["PvPAlert"] = {
    ["Enable"] = false,                             -- enables pvp alert plugin.
}

C["RaidCD"] = {
    ["Enable"] = false,                             -- enables raid cooldowns plugin.
    ["MaxBars"] = 10,                               -- max number of visible bars.
    ["BarSize"] = { 230, 23 },                      -- set bar size
    ["BarSpacing"] = 7,                             -- set spacing between bars
    ["StatusBarHeight"] = 3,                        -- set status bar height
    ["Anchor"] = { "TOPLEFT", UIParent, "TOPLEFT", 7, -35 },
}

----------------------------------------------------------------
-- Default Tukui Settings
----------------------------------------------------------------

-- General
C["General"].BackgroundColor = { 0.01, 0.01, 0.01 }
C["General"].BackdropColor = { 0.09, 0.09, 0.09 }
C["General"].BorderColor = { 0.01, 0.01, 0.01 }
C["General"].ClassColorBorder = false
C["General"].UseGlobal = false
C["General"].HideShadows = true
C["General"].UIScale = 0.50     -- T.PerfectScale
C["General"].MinimapScale = 100
C["General"].WorldMapScale = 50
C["General"].Themes.Value = "Tukui"

-- Action Bars
C["ActionBars"].Enable = true
C["ActionBars"].BottomLeftBar = true
C["ActionBars"].BottomRightBar = true
C["ActionBars"].RightBar = true
C["ActionBars"].LeftBar = true
C["ActionBars"].HotKey = true
C["ActionBars"].EquipBorder = true
C["ActionBars"].Macro = true
C["ActionBars"].ShapeShift = true
C["ActionBars"].Pet = true
C["ActionBars"].SwitchBarOnStance = true
C["ActionBars"].Bar1ButtonsPerRow = 12
C["ActionBars"].Bar2ButtonsPerRow = 6
C["ActionBars"].Bar3ButtonsPerRow = 12
C["ActionBars"].Bar4ButtonsPerRow = 1
C["ActionBars"].Bar5ButtonsPerRow = 1
C["ActionBars"].Bar2NumButtons = 12
C["ActionBars"].Bar3NumButtons = 12
C["ActionBars"].Bar4NumButtons = 12
C["ActionBars"].Bar5NumButtons = 12
C["ActionBars"].BarPetButtonsPerRow = 10
C["ActionBars"].NormalButtonSize = 30       -- 27
C["ActionBars"].PetButtonSize = 32          -- 25
C["ActionBars"].ButtonSpacing = 3           -- 3
C["ActionBars"].ShowBackdrop = true
C["ActionBars"].AutoAddNewSpell = true
C["ActionBars"].ProcAnim = true
C["ActionBars"].Font = C["Lua"].Font

C["ActionBars"].VerticalRightBars = true

-- Auras
C["Auras"].Enable = true
C["Auras"].Flash = true
C["Auras"].ClassicTimer = true
C["Auras"].HideBuffs = false
C["Auras"].HideDebuffs = false
C["Auras"].Animation = false
C["Auras"].BuffsPerRow = 12
C["Auras"].Font = C["Lua"].Font

-- Bags
C["Bags"].Enable = true
C["Bags"].IdentifyQuestItems = true
C["Bags"].FlashNewItems = false
C["Bags"].ItemLevel = true
C["Bags"].ButtonSize = 32           -- 27
C["Bags"].Spacing = 3               -- 3
C["Bags"].ItemsPerRow = 12

-- Chat
C["Chat"].Enable = true
C["Chat"].Bubbles.Value = "All"   -- All | Exclude Party | None
C["Chat"].BubblesTextSize = 9
C["Chat"].SkinBubbles = true
C["Chat"].LeftWidth = 450
C["Chat"].LeftHeight = 200
C["Chat"].RightWidth = 450
C["Chat"].RightHeight = 200
C["Chat"].RightChatAlignRight = true
C["Chat"].BackgroundAlpha = 70
C["Chat"].WhisperSound = true
C["Chat"].ShortChannelName = true
C["Chat"].LinkColor = { 0.08, 1.00, 0.36 }
C["Chat"].LinkBrackets = true
C["Chat"].ScrollByX = 3
C["Chat"].TextFading = true
C["Chat"].TextFadingTimer = 60
C["Chat"].TabFont = C["Lua"].Font
C["Chat"].ChatFont = "Tukui"
C["Chat"].BubblesNames = true
C["Chat"].LogMax = 0

-- Cooldowns
C["Cooldowns"].Font = C["Lua"].Font

-- DataTexts
-- C["DataTexts"].LocalTime = true
-- C["DataTexts"].Time24HrFormat = true
C["DataTexts"].Battleground = true
C["DataTexts"].HideFriendsNotPlaying = true
C["DataTexts"].NameColor = { class.r, class.g, class.b }
C["DataTexts"].ValueColor = { 1, 1, 1 }
C["DataTexts"].ClassColor = false
C["DataTexts"].HighlightColor = { 1, 1, 0 }
C["DataTexts"].Font = C["Lua"].Font

-- Loot
C["Loot"].Enable = true
C["Loot"].Font = C["Lua"].Font

-- Misc.
C["Misc"].MicroMenu = true
C["Misc"].ItemLevel = true
C["Misc"].ThreatBar = true
C["Misc"].WorldMapEnable = true
C["Misc"].FadeWorldMapAlpha = 100
C["Misc"].ExperienceEnable = true
C["Misc"].AutoSellJunk = true
C["Misc"].AutoRepair = true
C["Misc"].AFKSaver = false
C["Misc"].TalkingHeadEnable = true
C["Misc"].UIErrorSize = 16
C["Misc"].UIErrorFont = "Tukui Outline"
C["Misc"].MicroToggle.Value = "ALT-M"       -- None | M | SHIFT-M | CTRL-M | ALT-M

-- Nameplates
C["NamePlates"].Enable = true
C["NamePlates"].Width = 165
C["NamePlates"].Height = 14
C["NamePlates"].NameplateCastBar = true
C["NamePlates"].Font = C["Lua"].Font
C["NamePlates"].OnlySelfDebuffs = true
C["NamePlates"].QuestIcon = true
C["NamePlates"].ClassIcon = false
C["NamePlates"].HighlightColor = {1, 1, 0}
C["NamePlates"].HighlightSize = 4
C["NamePlates"].ColorThreat = false
C["NamePlates"].HealthTag.Value = "|cff549654[Tukui:CurrentHP] - [perhp]%|r"

-- Party
C["Party"].Enable = false
C["Party"].ShowPets = false
C["Party"].ShowPlayer = true
C["Party"].ShowHealthText = true
C["Party"].ShowManaText = false
C["Party"].RangeAlpha = 0.3
C["Party"].Font = C["Lua"].Font
C["Party"].HealthFont = C["Lua"].Font
C["Party"].HighlightColor = { 0, 1, 0 }
C["Party"].HighlightSize = 10
C["Party"].HealthTag.Value = "|cffFF0000[missinghp]|r"

-- Raid
C["Raid"].Enable = true
C["Raid"].DebuffWatch = true
C["Raid"].ShowPets = false
C["Raid"].RangeAlpha = 0.3
C["Raid"].VerticalHealth = false
C["Raid"].MaxUnitPerColumn = 5
C["Raid"].Raid40MaxUnitPerColumn = 10
C["Raid"].Font = C["Lua"].Font
C["Raid"].HealthFont = C["Lua"].Font
C["Raid"].DesaturateNonPlayerBuffs = false
C["Raid"].RaidBuffs.Value = "Self"
C["Raid"].ClassRaidBuffs = true
C["Raid"].WidthSize = 89        -- 99
C["Raid"].HeightSize = 50           -- 69
C["Raid"].Raid40WidthSize = 89
C["Raid"].Raid40HeightSize = 50
C["Raid"].Padding = 4
C["Raid"].Padding40 = 4
C["Raid"].HighlightColor = {0, 1, 0}
C["Raid"].HighlightSize = 10
C["Raid"].AuraTrack = true
C["Raid"].AuraTrackIcons = true
C["Raid"].AuraTrackSpellTextures = true
C["Raid"].AuraTrackThickness = 5
C["Raid"].GroupBy.Value = "GROUP"
C["Raid"].HealthTag.Value = "|cffFF0000[missinghp]|r"

-- Tooltips
C["Tooltips"].Enable = true
C["Tooltips"].DisplayTitle = false
C["Tooltips"].HideInCombat = false
C["Tooltips"].AlwaysCompareItems = false
C["Tooltips"].UnitHealthText = true
C["Tooltips"].MouseOver = false
C["Tooltips"].HealthFont = C["Lua"].Font

-- Textures
C["Textures"].QuestProgressTexture = C["Lua"].Texture
C["Textures"].TTHealthTexture = C["Lua"].Texture
C["Textures"].UFPowerTexture = C["Lua"].Texture
C["Textures"].UFHealthTexture = C["Lua"].Texture
C["Textures"].UFCastTexture = C["Lua"].Texture
C["Textures"].UFPartyPowerTexture = C["Lua"].Texture
C["Textures"].UFPartyHealthTexture = C["Lua"].Texture
C["Textures"].UFRaidPowerTexture = C["Lua"].Texture
C["Textures"].UFRaidHealthTexture = C["Lua"].Texture
C["Textures"].NPHealthTexture = C["Lua"].Texture
C["Textures"].NPPowerTexture = C["Lua"].Texture
C["Textures"].NPCastTexture = C["Lua"].Texture

-- UnitFrames
C["UnitFrames"].Enable = true
C["UnitFrames"].TotemBar = T.MyClass == "SHAMAN" and true or false
C["UnitFrames"].ClassBar = true
C["UnitFrames"].HealComm = true
C["UnitFrames"].PlayerAuraBars = false
C["UnitFrames"].TargetAuraBars = false
C["UnitFrames"].ScrollingCombatText = false
C["UnitFrames"].ScrollingCombatTextIcon = true
C["UnitFrames"].ScrollingCombatTextFontSize = 22
C["UnitFrames"].ScrollingCombatTextRadius = 120
C["UnitFrames"].ScrollingCombatTextDisplayTime = 1.5
C["UnitFrames"].ScrollingCombatTextFont = C["Lua"].Font
C["UnitFrames"].ScrollingCombatTextAnim.Value = "vertical"
C["UnitFrames"].StatusBarBackgroundMultiplier = 25
C["UnitFrames"].Portrait2D = false
C["UnitFrames"].OOCNameLevel = true
C["UnitFrames"].OOCPetNameLevel = false
C["UnitFrames"].Portrait = false
C["UnitFrames"].CastBar = true
C["UnitFrames"].ComboBar = true
C["UnitFrames"].UnlinkCastBar = true
C["UnitFrames"].CastBarIcon = true
C["UnitFrames"].CastBarLatency = true
C["UnitFrames"].Smooth = true
C["UnitFrames"].TargetEnemyHostileColor = true
C["UnitFrames"].CombatLog = true
C["UnitFrames"].PlayerBuffs = true
C["UnitFrames"].PlayerDebuffs = true
C["UnitFrames"].TargetBuffs = true
C["UnitFrames"].TargetDebuffs = true
C["UnitFrames"].FocusAuras = true
C["UnitFrames"].BossAuras = true
C["UnitFrames"].ArenaAuras = true
C["UnitFrames"].TOTAuras = true
C["UnitFrames"].PetAuras = true
C["UnitFrames"].AurasBelow = false
C["UnitFrames"].OnlySelfDebuffs = false
C["UnitFrames"].OnlySelfBuffs = false
C["UnitFrames"].Font = C["Lua"].Font
C["UnitFrames"].CastingColor = { 0.29, 0.77, 0.30 }
C["UnitFrames"].ChannelingColor = { 0.29, 0.77, 0.30 }
C["UnitFrames"].NotInterruptibleColor = { 0.85, 0.09, 0.09 }
C["UnitFrames"].HealCommSelfColor = { 0.31, 0.45, 0.63, 0.40 }      -- { 0.29, 1.00, 0.30 }
C["UnitFrames"].HealCommOtherColor = { 0.31, 0.45, 0.63, 0.40 }     -- { 1, 0.72, 0.30 }
C["UnitFrames"].HealCommAbsorbColor = { 0.31, 0.45, 0.63, 0.40 }    -- { 207/255, 181/255, 59/255 }
C["UnitFrames"].RaidIconSize = 24
C["UnitFrames"].Boss = true
C["UnitFrames"].Arena = true
C["UnitFrames"].HighlightSize = 10
C["UnitFrames"].HighlightColor = {0, 1, 0}
C["UnitFrames"].RangeAlpha = 0.3
C["UnitFrames"].Smoothing = true
C["UnitFrames"].PlayerHealthTag.Value = "|cff549654[Tukui:CurrentHP]|r"
C["UnitFrames"].TargetHealthTag.Value = "|cff549654[Tukui:CurrentHP]|r"
C["UnitFrames"].FocusHealthTag.Value = "|cff549654[perhp]%|r"
C["UnitFrames"].FocusTargetHealthTag.Value = "|cff549654[perhp]%|r"
C["UnitFrames"].BossHealthTag.Value = "|cff549654[perhp]%|r"

C["UnitFrames"].TargetBuffs = (not C["UnitFrames"].TargetAuraBars) -- or C["UnitFrames"].TargetBuffs
C["UnitFrames"].TargetDebuffs = (not C["UnitFrames"].TargetAuraBars) -- or C["UnitFrames"].TargetDebuffs
