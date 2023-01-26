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
    ["HealerLayout"] = true                         -- enables healing raid layout.
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
    ["Party"]           = { 185, 25 },              -- set party unitframe size.
    ["Raid"]            = {  60, 38 }               -- set raid unitframe size.
}

-- C["General"].OverDataTextLeft = true                -- display alternativa power bar over data text panel left.

-- Action Bars
-- C["ActionBars"].VerticalRightBars = false           -- enables vertical multi bars (bar 4 and 5).
-- C["ActionBars"].VerticalStanceBar = true            -- enables vertical stance bar.
C["ActionBars"].StanceBarBackground = false         -- enables stance bar background.
-- C["ActionBars"].ActionBar3Background = false        -- enables action bar 3 background.
-- C["ActionBars"].ActionBar3Toggle = true             -- hide button without action.

-- Chat
C["Chat"].Padding = 5                               -- padding between datatext and chat background.

-- Auras
C["Auras"].Spacing = 4                              -- set spacing between auras.

-- -- Nameplate
-- C["NamePlates"].PowerBar = false                    -- enables nameplates powerbar.
-- C["NamePlates"].DebuffSize = 18                     -- set debuff icon size.
-- C["NamePlates"].DebuffSpacing = 7                   -- set space between debuffs.

-- Party
C["Party"].ShowSolo = false                         -- display party frame when playing solo (only player unit).
C["Party"].WidthSize = 193                          -- party frame width
C["Party"].HeightSize = 25                          -- party frame height
C["Party"].Padding = 33 -- 39                       -- distance between party frames

-- Raid
C["Raid"].ShowSolo = true                           -- display raid frame when playing solo (only player unit).
C["Raid"].TestAuraWatch = false                     -- force to show aurawatch debuff. (use for testing)
C["Raid"].GroupRoles = true                         -- enables group role icon on raid frame.

-- -- Tooltips
-- C["Tooltips"].ShowSpellID = true                    -- enables spells, items, quest ids on tooltips.

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
    ["Enable"] = false,                              -- enables raid cooldowns plugin.
    ["Anchor"] = { "TOPLEFT", UIParent, "TOPLEFT", 50, -50 },
    ["BarWidth"] = 256,
    ["BarHeight"] = 25,
    ["BarSpacing"] = 3,                             -- set spacing between bars
    ["ShowPlayer"] = true                           -- show players cooldowns

    -- ["MaxBars"] = 10,                               -- max number of visible bars.
    -- ["BarSize"] = { 230, 23 },                      -- set bar size
    -- ["BarSpacing"] = 7,                             -- set spacing between bars
    -- ["StatusBarHeight"] = 3,                        -- set status bar height
    
}

----------------------------------------------------------------
-- Default Tukui Settings
----------------------------------------------------------------

-- General
C["General"].BackgroundColor = { 0.01, 0.01, 0.01 }
C["General"].BackdropColor = { 0.08, 0.08, 0.08 }
C["General"].BorderColor = { 0.01, 0.01, 0.01 }
C["General"].ClassColorBorder = false
C["General"].UseGlobal = false
C["General"].HideShadows = true
C["General"].UIScale = 0.52
C["General"].MinimapScale = (T.Retail and 75 or 100)
C["General"].WorldMapScale = 60
C["General"].Themes.Value = "Tukui"
C["General"].GlobalFont.Value = "Interface\\AddOns\\Tukui\\Medias\\Fonts\\Expressway.ttf"

-- Action Bars
C["ActionBars"].Enable = true
C["ActionBars"].BottomLeftBar = true
C["ActionBars"].BottomRightBar = true
C["ActionBars"].RightBar = true
C["ActionBars"].LeftBar = true
C["ActionBars"].Bar6 = false
C["ActionBars"].Bar7 = false
C["ActionBars"].Bar8 = false
C["ActionBars"].HotKey = true
C["ActionBars"].EquipBorder = true
C["ActionBars"].Macro = false
C["ActionBars"].ShapeShift = true
C["ActionBars"].Pet = true
C["ActionBars"].SwitchBarOnStance = true
C["ActionBars"].Bar1ButtonsPerRow = 12
C["ActionBars"].Bar2ButtonsPerRow = 6
C["ActionBars"].Bar3ButtonsPerRow = 12
C["ActionBars"].Bar4ButtonsPerRow = 1
C["ActionBars"].Bar5ButtonsPerRow = 1
C["ActionBars"].Bar6ButtonsPerRow = 1
C["ActionBars"].Bar7ButtonsPerRow = 1
C["ActionBars"].Bar8ButtonsPerRow = 1
C["ActionBars"].Bar1NumButtons = 12
C["ActionBars"].Bar2NumButtons = 12
C["ActionBars"].Bar3NumButtons = 12
C["ActionBars"].Bar4NumButtons = 12
C["ActionBars"].Bar5NumButtons = 12
C["ActionBars"].Bar6NumButtons = 12
C["ActionBars"].Bar7NumButtons = 12
C["ActionBars"].Bar8NumButtons = 12
C["ActionBars"].BarPetButtonsPerRow = 1
C["ActionBars"].NormalButtonSize = 32
C["ActionBars"].PetButtonSize = 32
C["ActionBars"].ButtonSpacing = 4
C["ActionBars"].ShowBackdrop = true
C["ActionBars"].AutoAddNewSpell = true
C["ActionBars"].ProcAnim = true
C["ActionBars"].Font = "Tukui Outline"
C["ActionBars"].MultiCastBar = true

-- Auras
C["Auras"].Enable = true
C["Auras"].Flash = true
C["Auras"].ClassicTimer = true
C["Auras"].HideBuffs = false
C["Auras"].HideDebuffs = false
C["Auras"].Animation = false
C["Auras"].BuffsPerRow = 12
C["Auras"].Font = "Tukui Outline"

-- Bags
C["Bags"].Enable = true
C["Bags"].IdentifyQuestItems = true
C["Bags"].FlashNewItems = true
C["Bags"].ItemLevel = true
C["Bags"].SortToBottom = false
C["Bags"].ButtonSize = 32
C["Bags"].Spacing = 4
C["Bags"].ItemsPerRow = 12
C["Bags"].ReagentBagColor = { 0.68, 0.83, 0.51 }
C["Bags"].ReagentInsideBag = false

-- Chat
C["Chat"].Enable = true
C["Chat"].Bubbles.Value = "All"
C["Chat"].BubblesTextSize = 9
C["Chat"].SkinBubbles = true
C["Chat"].LeftWidth = 450
C["Chat"].LeftHeight = 204
C["Chat"].RightWidth = 450
C["Chat"].RightHeight = 204
C["Chat"].RightChatAlignRight = true
C["Chat"].BackgroundAlpha = 70
C["Chat"].WhisperSound = true
C["Chat"].ShortChannelName = true
C["Chat"].LinkColor = { 0.08, 1.00, 0.36 }
C["Chat"].LinkBrackets = true
C["Chat"].ScrollByX = 3
C["Chat"].TextFading = false
C["Chat"].TextFadingTimer = 60
C["Chat"].TabFont = "Tukui"
C["Chat"].ChatFont = "Tukui"
C["Chat"].BubblesNames = true
C["Chat"].LogMax = 250

-- Cooldowns
C["Cooldowns"].Font = "Tukui Outline"

-- DataTexts
C["DataTexts"].Battleground = true
C["DataTexts"].HideFriendsNotPlaying = true
C["DataTexts"].NameColor = { class.r, class.g, class.b }
C["DataTexts"].ValueColor = { 1, 1, 1 }
C["DataTexts"].ClassColor = false
C["DataTexts"].HighlightColor = { 1, 1, 0 }
C["DataTexts"].Font = "Tukui"

-- Loot
C["Loot"].Enable = true
C["Loot"].Font = "Tukui"

-- Misc
C["Misc"].DisplayWidgetPowerBar = true
C["Misc"].BlizzardMicroMenu = false
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
C["Misc"].MicroToggle.Value = "ALT-M"
C["Misc"].MicroStyle.Value = "Game Menu"
C["Misc"].ObjectiveTracker = true

-- Maps
C["Maps"].MinimapTracking = false
C["Maps"].MinimapCoords = false

-- NamePlates
C["NamePlates"].Enable = true
C["NamePlates"].Width = 128
C["NamePlates"].Height = 14
C["NamePlates"].NotSelectedAlpha = 100
C["NamePlates"].SelectedScale = 100
C["NamePlates"].NameplateCastBar = true
C["NamePlates"].Font = "Tukui Outline"
C["NamePlates"].OnlySelfDebuffs = true
C["NamePlates"].QuestIcon = true
C["NamePlates"].ClassIcon = false
C["NamePlates"].HighlightColor = { 1, 1, 0 }
C["NamePlates"].AggroColor1 = { 0.50, 0.50, 0.50 }
C["NamePlates"].AggroColor2 = { 1, 1, 0.5 }
C["NamePlates"].AggroColor3 = { 1.00, 0.50, 0.00 }
C["NamePlates"].AggroColor4 = { 1, 0.2, 0.2 }
C["NamePlates"].HighlightSize = 5
C["NamePlates"].ColorThreat = false
C["NamePlates"].HealthTag.Value = "|cff549654[perhp]%|r"

-- Party
C["Party"].Enable = false
C["Party"].Buffs = true
C["Party"].Debuffs = true
C["Party"].ShowPets = false
C["Party"].ShowPlayer = true
C["Party"].ShowHealthText = true
C["Party"].ShowManaText = false
C["Party"].RangeAlpha = 0.3
C["Party"].Font = "Tukui Outline"
C["Party"].HealthFont = "Tukui Outline"
C["Party"].HighlightColor = { 0, 1, 0 }
C["Party"].HighlightSize = 10
C["Party"].HealthTag.Value = "|cff549654[perhp]%|r"

-- Raid
C["Raid"].Enable = true
C["Raid"].DebuffWatch = true
C["Raid"].DebuffWatchDefault = true
C["Raid"].ShowPets = false
C["Raid"].RangeAlpha = 0.3
C["Raid"].VerticalHealth = false
C["Raid"].MaxUnitPerColumn = 5
C["Raid"].Raid40MaxUnitPerColumn = 10
C["Raid"].Font = "Tukui"
C["Raid"].HealthFont = "Tukui Outline"
C["Raid"].DesaturateBuffs = false
C["Raid"].RaidBuffsStyle.Value = "Aura Track"
C["Raid"].RaidBuffs.Value = "Self"
C["Raid"].WidthSize = 90
C["Raid"].HeightSize = 58
C["Raid"].Raid40WidthSize = 79
C["Raid"].Raid40HeightSize = 55
C["Raid"].Padding = 5
C["Raid"].Padding40 = 5
C["Raid"].HighlightColor = {0, 1, 0}
C["Raid"].HighlightSize = 10
C["Raid"].AuraTrackIcons = true
C["Raid"].AuraTrackSpellTextures = true
C["Raid"].AuraTrackThickness = 5
C["Raid"].GroupBy.Value = "GROUP"
C["Raid"].HealthTag.Value = ""

-- Tooltips
C["Tooltips"].Enable = true
C["Tooltips"].DisplayTitle = false
C["Tooltips"].HideInCombat = false
C["Tooltips"].AlwaysCompareItems = false
C["Tooltips"].UnitHealthText = true
C["Tooltips"].MouseOver = false
C["Tooltips"].ItemBorderColor = true
C["Tooltips"].UnitBorderColor = true
C["Tooltips"].HealthFont = "Tukui Outline"

-- Textures
C["Textures"].QuestProgressTexture = "Tukui"
C["Textures"].TTHealthTexture = "Tukui"
C["Textures"].UFPowerTexture = "Tukui"
C["Textures"].UFHealthTexture = "Tukui"
C["Textures"].UFCastTexture = "Tukui"
C["Textures"].UFPartyPowerTexture = "Tukui"
C["Textures"].UFPartyHealthTexture = "Tukui"
C["Textures"].UFRaidPowerTexture = "Tukui"
C["Textures"].UFRaidHealthTexture = "Tukui"
C["Textures"].NPHealthTexture = "Tukui"
C["Textures"].NPPowerTexture = "Tukui"
C["Textures"].NPCastTexture = "Tukui"

-- UnitFrames
C["UnitFrames"].Enable = true
C["UnitFrames"].TotemBar = T.MyClass == "SHAMAN" and true or false
C["UnitFrames"].TotemBarStyle.Value = "On Screen"
C["UnitFrames"].ClassBar = true
C["UnitFrames"].PlayerAuraBars = false
C["UnitFrames"].ScrollingCombatText = false
C["UnitFrames"].ScrollingCombatTextIcon = true
C["UnitFrames"].ScrollingCombatTextFontSize = 22
C["UnitFrames"].ScrollingCombatTextRadius = 120
C["UnitFrames"].ScrollingCombatTextDisplayTime = 1.5
C["UnitFrames"].ScrollingCombatTextFont = "Tukui Outline"
C["UnitFrames"].ScrollingCombatTextAnim.Value = "fountain"
C["UnitFrames"].StatusBarBackgroundMultiplier = 25
C["UnitFrames"].PowerTick = true
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
C["UnitFrames"].DesaturateDebuffs = true
C["UnitFrames"].FlashRemovableBuffs = true
C["UnitFrames"].FocusAuras = true
C["UnitFrames"].BossAuras = true
C["UnitFrames"].ArenaAuras = true
C["UnitFrames"].TOTAuras = true
C["UnitFrames"].PetAuras = true
C["UnitFrames"].AurasBelow = false
C["UnitFrames"].OnlySelfDebuffs = false
C["UnitFrames"].OnlySelfBuffs = false
C["UnitFrames"].Font = "Tukui Outline"
C["UnitFrames"].CastingColor = { 0.29, 0.77, 0.30 }
C["UnitFrames"].ChannelingColor = { 0.29, 0.77, 0.30 }
C["UnitFrames"].NotInterruptibleColor = { 0.85, 0.09, 0.09 }
C["UnitFrames"].HealComm = true
C["UnitFrames"].HealCommSelfColor = { 0.31, 0.45, 0.63, 0.40 }      -- { 0.29, 1.00, 0.30 }
C["UnitFrames"].HealCommOtherColor = { 0.31, 0.45, 0.63, 0.40 }     -- { 1, 0.72, 0.30 }
C["UnitFrames"].HealCommAbsorbColor = { 0.31, 0.45, 0.63, 0.40 }    -- { 207/255, 181/255, 59/255 }
C["UnitFrames"].RaidIconSize = 24
C["UnitFrames"].Boss = true
C["UnitFrames"].Arena = true
C["UnitFrames"].HighlightSize = 10
C["UnitFrames"].HighlightColor = { 0, 1, 0 }
C["UnitFrames"].RangeAlpha = 0.3
C["UnitFrames"].Smoothing = true
C["UnitFrames"].PlayerHealthTagValue = "|cff549654[Tukui:CurrentHP]|r"
C["UnitFrames"].TargetHealthTag.Value = "|cff549654[Tukui:CurrentHP]|r"
C["UnitFrames"].FocusHealthTag.Value = "|cff549654[perhp]%|r"
C["UnitFrames"].FocusTargetHealthTag.Value = "|cff549654[perhp]%|r"
C["UnitFrames"].BossHealthTag.Value = "|cff549654[perhp]%|r"
