local T, C, L = Tukui:unpack()
local class = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

----------------------------------------------------------------
-- LuaUI Settings
----------------------------------------------------------------
C["Lua"] = {
    -- General
    ["Enable"] = false,                             -- variable use to enable/disable files.
    ["UniColor"] = true,                            -- enable unicolor theme.
    ["ColorPower"] = true,                          -- enable power bar color based on power type.

    -- System
    ["Install"] = true,                             -- set console variables preferences on installation.
    ["Sound"] = true,                               -- set system sound (really annoying high volume when we clear WTF folder).
    ["Mute"] = false,                               -- set system master sounds to 0.

    -- Media
    ["Font"] = "Pixel",                             -- default font type.
    ["Texture"] = "Blank",                          -- default texture type.

    -- Layout
    ["HealerLayout"] = {
        ["Enable"] = "auto",                        -- enables healing raid layout.
        ["OnlyInInstance"] = true                   -- enables healing raid layout.
    }
}

-- UnitsFrames Size
C["Units"] = {
    ["Player"]          = { 254, 31 },              -- set player unitframe size.
    ["Target"]          = { 254, 31 },              -- set target unitframe size.
    ["TargetOfTarget"]  = { 193, 25 },              -- set targetoftarget unitframe size.
    ["Pet"]             = { 181, 25 },              -- set pet unitframe size.
    ["Party"]           = { 185, 25 },              -- set party unitframe size.
    ["Raid"]            = {  72, 41 }               -- set raid unitframe size.
}

-- Nameplate
C["NamePlates"].PowerBar = false                    -- enables nameplates powerbar.
C["NamePlates"].DebuffSize = 18                     -- set debuff icon size.
C["NamePlates"].DebuffSpacing = 7                   -- set space between debuffs.
C["NamePlates"].CastHeight = 12                     -- set castbar height.

-- Party
C["Party"].ShowSolo = false                         -- display party frame when playing solo (only player unit).

-- Raid
C["Raid"].ShowSolo = false                          -- display raid frame when playing solo (only player unit).
C["Raid"].TestAuraWatch = false                     -- force to show aurawatch debuff.
C["Raid"].GroupRoles = true                         -- enables group role icon on raid frame.

-- Tooltips
C["Tooltips"].SpellID = true                        -- enables spells, items, quest ids on tooltips.

----------------------------------------------------------------
-- Plugins Settings
----------------------------------------------------------------
-- Disple Announce
C["Dispels"] = {
    ["Enable"] = true,                              -- enables dispel announce plugin.
    ["SpellLink"] = true,                           -- display spell link, else just the spell name.
    ["Chat"] = "SAY"
}

-- Interrupts Announce
C["Interrupts"] = {
    ["Enable"] = true,                              -- enables interrupt annouce plugin.
    ["SpellLink"] = true,                           -- display spell link, else just the spell name.
}

-- Spell Announce
C["SpellAnnounce"] = {
    ["Enable"] = true,                              -- enables spell announce plugin.
    ["GroupChat"] = true,                           -- set announce chat channel to by group type and instance.
    ["SpellLink"] = true,                           -- enable spell link one messages.
}

-- Spell Announce
C["LetMeCast"] = {
    ["Enable"] = true,                              -- enables let me cast plugin.
}

----------------------------------------------------------------
-- Default Tukui Settings
----------------------------------------------------------------

-- General
C["General"].BackdropColor = { 0.05, 0.05, 0.05 }
C["General"].BorderColor = { 0.125, 0.125, 0.125 }
C["General"].UseGlobal = false
C["General"].HideShadows = true
C["General"].UIScale = 0.50                         -- T.PerfectScale
C["General"].MinimapScale = 110
C["General"].WorldMapScale = 59
C["General"].Themes.Value = "Tukui 18"

-- Action Bars
C["ActionBars"].Enable = true
C["ActionBars"].HotKey = true
C["ActionBars"].EquipBorder = true
C["ActionBars"].Macro = true
C["ActionBars"].ShapeShift = true
C["ActionBars"].Pet = true
C["ActionBars"].SwitchBarOnStance = true
C["ActionBars"].NormalButtonSize = 27
C["ActionBars"].PetButtonSize = 25
C["ActionBars"].ButtonSpacing = 3
C["ActionBars"].HideBackdrop = false
C["ActionBars"].Font = C["Lua"].Font

-- Auras
C["Auras"].Enable = true
C["Auras"].Flash = true
C["Auras"].ClassicTimer = true
C["Auras"].HideBuffs = false
C["Auras"].HideDebuffs = false
C["Auras"].Animation = false
C["Auras"].BuffsPerRow = 12
C["Auras"].Spacing = 3                              -- set spacing between auras.
C["Auras"].Font = C["Lua"].Font

-- Bags
C["Bags"].Enable = true
C["Bags"].ButtonSize = 27
C["Bags"].Spacing = 3
C["Bags"].ItemsPerRow = 12

-- Chat
C["Chat"].Enable = true
C["Chat"].LeftWidth = 380
C["Chat"].LeftHeight = 185
C["Chat"].RightWidth = 380
C["Chat"].RightHeight = 185
C["Chat"].RightChatAlignRight = true
C["Chat"].BackgroundAlpha = 80
C["Chat"].WhisperSound = true
C["Chat"].ShortChannelName = true
C["Chat"].LinkColor = { 0.08, 1.00, 0.36 }
C["Chat"].LinkBrackets = true
C["Chat"].ScrollByX = 3
C["Chat"].TextFading = false
C["Chat"].TextFadingTimer = 60
C["Chat"].TabFont = C["Lua"].Font
C["Chat"].ChatFont = "Tukui"

-- Cooldowns
C["Cooldowns"].Font = C["Lua"].Font

-- DataTexts
C["DataTexts"].Battleground = true
C["DataTexts"].HideFriendsNotPlaying = true
C["DataTexts"].NameColor = { class.r, class.g, class.b }
C["DataTexts"].ValueColor = { 1.00, 1.00, 1.00 }
C["DataTexts"].ClassColor = false
C["DataTexts"].HighlightColor = { 1.00, 1.00, 0.00 }
C["DataTexts"].Hour24 = true
C["DataTexts"].Font = C["Lua"].Font

-- Loot
C["Loot"].Enable = true
C["Loot"].Font = C["Lua"].Font

-- Misc.
C["Misc"].ThreatBar = true
C["Misc"].WorldMapEnable = true
C["Misc"].ExperienceEnable = true
C["Misc"].ErrorFilterEnable = true
C["Misc"].AutoSellJunk = true
C["Misc"].AutoRepair = true
C["Misc"].AFKSaver = false
C["Misc"].FadeWorldMapWhileMoving = false
C["Misc"].ObjectiveTrackerFont = "Tukui Outline"

-- NamePlates
C["NamePlates"].Enable = true
C["NamePlates"].Width = 129
C["NamePlates"].Height = 12
C["NamePlates"].NameplateCastBar = true
C["NamePlates"].Font = "Tukui Outline"
C["NamePlates"].OnlySelfDebuffs = true
C["NamePlates"].HighlightColor = { 1.00, 1.00, 0.00 }
C["NamePlates"].HighlightSize = 10

-- Party
C["Party"].Enable = false
C["Party"].ShowPets = false
C["Party"].ShowPlayer = true
C["Party"].ShowHealthText = true
C["Party"].ShowManaText = false
C["Party"].RangeAlpha = 0.30
C["Party"].Font = C["Lua"].Font
C["Party"].HealthFont = C["Lua"].Font
C["Party"].WidthSize = 185
C["Party"].HeightSize = 25
C["Party"].HighlightColor = { 0.00, 1.00, 0.00 }
C["Party"].HighlightSize = 10

-- Raid
C["Raid"].Enable = true
C["Raid"].DebuffWatch = true
C["Raid"].ShowPets = false
C["Raid"].RangeAlpha = 0.30
C["Raid"].VerticalHealth = false
C["Raid"].MaxUnitPerColumn = 5
C["Raid"].Font = C["Lua"].Font
C["Raid"].HealthFont = C["Lua"].Font
C["Raid"].DesaturateNonPlayerBuffs = true
C["Raid"].RaidBuffs.Value = "Self"
C["Raid"].ClassRaidBuffs = true
C["Raid"].WidthSize = 72
C["Raid"].HeightSize = 41
C["Raid"].HighlightColor = { 0.00, 1.00, 0.00 }
C["Raid"].HighlightSize = 10
C["Raid"].GroupBy.Value = "GROUP"

-- Tooltips
C["Tooltips"].Enable = true
C["Tooltips"].HideInCombat = false
C["Tooltips"].AlwaysCompareItems = true
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
C["UnitFrames"].TotemBar = true
C["UnitFrames"].HealComm = true
C["UnitFrames"].PlayerAuraBars = false
C["UnitFrames"].ScrollingCombatText = false
C["UnitFrames"].ScrollingCombatTextFontSize = 32
C["UnitFrames"].ScrollingCombatTextFont = "Tukui Damage"
C["UnitFrames"].PowerTick = true
C["UnitFrames"].Portrait2D = true
C["UnitFrames"].OOCNameLevel = false
C["UnitFrames"].OOCPetNameLevel = false
C["UnitFrames"].Portrait = false
C["UnitFrames"].CastBar = true
C["UnitFrames"].ComboBar = true
C["UnitFrames"].UnlinkCastBar = true
C["UnitFrames"].CastBarIcon = true
C["UnitFrames"].CastBarLatency = true
C["UnitFrames"].Smooth = true
C["UnitFrames"].TargetEnemyHostileColor = true
C["UnitFrames"].ShowTargetManaText = false
C["UnitFrames"].CombatLog = true
C["UnitFrames"].PlayerAuras = true
C["UnitFrames"].TargetAuras = true
C["UnitFrames"].TOTAuras = true
C["UnitFrames"].PetAuras = true
C["UnitFrames"].AurasBelow = false
C["UnitFrames"].OnlySelfDebuffs = false
C["UnitFrames"].OnlySelfBuffs = false
C["UnitFrames"].Font = C["Lua"].Font
C["UnitFrames"].HealCommSelfColor = { class.r, class.g, class.b, 0.30 }--{ 0.29, 1.00, 0.30 }
C["UnitFrames"].HealCommOtherColor = { 1.00, 1.00, 0.36 }
C["UnitFrames"].RaidIconSize = 24
