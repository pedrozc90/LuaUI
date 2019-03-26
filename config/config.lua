local T, C, L = Tukui:unpack()
local class = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

----------------------------------------------------------------
-- LuaUI Settings
----------------------------------------------------------------
C["Lua"] = {
    -- Setup
    -- ["Enable"] = true,                              -- enable LuaUI edit
    ["UniColor"] = true,                            -- enable unicolor theme
    ["ColorPower"] = true,                          -- enable power bar color based on power type.

    -- System
    ["uiScale"] = "auto",                           -- set game uiScale ("auto" or a number, e.g: 0.71 fro 1920x1080).
    ["Setup"] = true,                               -- set console variables preferences.
    ["Mute"] = false,                               -- set system master sounds to 0.

    -- Media
    ["Font"] = "Pixel",                             -- default font type.
    ["Texture"] = "Blank",                          -- default texture type.

    -- Layout
    ["HealerLayout"] = true,                        -- enables healing raid layout.
}

-- UnitsFrames Size
C["Units"] = {
    ["Player"]          = { 254, 31 },              -- set player unitframe size.
    ["Target"]          = { 254, 31 },              -- set target unitframe size.
    ["TargetOfTarget"]  = { 181, 25 },              -- set targetoftarget unitframe size.
    ["Pet"]             = { 181, 25 },              -- set pet unitframe size.
    ["Focus"]           = { 205, 25 },              -- set focus unitframe size.
    ["FocusTarget"]     = { 205, 25 },              -- set focustarget unitframe size.
    ["Arena"]           = { 205, 25 },              -- set arena unitframe size.
    ["Boss"]            = { 205, 25 },              -- set boss unitframe size.
    ["Party"]           = { 185, 25 },              -- set party unitframe size.
    ["Raid"]            = {  72, 41 }               -- set raid unitframe size.
}

-- Auras
C["Auras"].Spacing = 3                              -- set spacing between auras.

-- Nameplate
C["NamePlates"].PowerBar = false                    -- enables nameplates powerbar.
C["NamePlates"].DebuffSize = 18                     -- set debuff icon size.
C["NamePlates"].DebuffSpacing = 7                   -- set space between debuffs.

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
C["Dispels"] = {
    ["Enable"] = true,                              -- enables dispel announce plugin.
    ["SpellLink"] = true,                           -- display spell link, else just the spell name.
}

C["Interrupts"] = {
    ["Enable"] = true,                              -- enables interrupt annouce plugin.
    ["SpellLink"] = true,                           -- display spell link, else just the spell name.
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
    ["Enable"] = true,                              -- enables spell announce plugin.
    ["GroupChat"] = true,                           -- set announce chat channel to by group type and instance.
    ["SpellLink"] = true,                           -- enable spell link one messages.
}

C["PvPAlert"] = {
    ["Enable"] = true,                              -- enables pvp alert plugin.
}

C["RaidCD"] = {
    ["Enable"] = true,                              -- enables raid cooldowns plugin.
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
C["General"].BackdropColor = { .05, .05, .05 }
C["General"].BorderColor = { .125, .125, .125 }
C["General"].HideShadows = true
C["General"].AFKSaver = false
C["General"].Scaling.Value = "Pixel Perfection"
C["General"].Themes.Value = "Tukui"

-- Action Bars
C["ActionBars"].Enable = true
C["ActionBars"].AddNewSpells = true
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
C["Auras"].Font = C["Lua"].Font

-- Bags
C["Bags"].Enable = true
C["Bags"].ButtonSize = 27
C["Bags"].Spacing = 3
C["Bags"].ItemsPerRow = 12
C["Bags"].PulseNewItem = true
C["Bags"].Font = C["Lua"].Font

-- Chat
C["Chat"].Enable = true
C["Chat"].WhisperSound = true
C["Chat"].ShortChannelName = true
C["Chat"].LinkColor = { .08, 1., .36 }
C["Chat"].LinkBrackets = true
C["Chat"].ScrollByX = 3
C["Chat"].TabFont = C["Lua"].Font
C["Chat"].ChatFont = "Tukui"

-- Cooldowns
C["Cooldowns"].Font = C["Lua"].Font

-- DataTexts
C["DataTexts"].Battleground = true
C["DataTexts"].LocalTime = true
C["DataTexts"].Time24HrFormat = true
C["DataTexts"].NameColor = { class.r, class.g, class.b }
C["DataTexts"].ValueColor = { 1, 1, 1 }
C["DataTexts"].Font = C["Lua"].Font

-- Loot
C["Loot"].Enable = true
C["Loot"].StandardLoot = false
C["Loot"].Font = C["Lua"].Font

-- Merchant
C["Merchant"].AutoSellGrays = true
C["Merchant"].AutoRepair = true
C["Merchant"].UseGuildRepair = false

-- Misc.
C["Misc"].ThreatBarEnable = true
C["Misc"].AltPowerBarEnable = true
C["Misc"].ExperienceEnable = true
C["Misc"].ReputationEnable = true
C["Misc"].ErrorFilterEnable = true
C["Misc"].AutoInviteEnable = false
C["Misc"].TalkingHeadEnable = false

-- Nameplates
C["NamePlates"].Enable = true
C["NamePlates"].Width = 153
C["NamePlates"].Height = 12
C["NamePlates"].CastHeight = 12
C["NamePlates"].Font = C["Lua"].Font
C["NamePlates"].OnlySelfDebuffs = true

-- Party
C["Party"].Enable = false
C["Party"].HealBar = true
C["Party"].ShowPlayer = true
C["Party"].ShowHealthText = true
C["Party"].RangeAlpha = 0.3
C["Party"].Font = C["Lua"].Font
C["Party"].HealthFont = C["Lua"].Font

-- Raid
C["Raid"].Enable = true
C["Raid"].HealBar = true
C["Raid"].AuraWatch = true
C["Raid"].AuraWatchTimers = true
C["Raid"].DebuffWatch = true
C["Raid"].RangeAlpha = 0.3
C["Raid"].ShowRessurection = true
C["Raid"].ShowHealthText = true
C["Raid"].ShowPets = false
C["Raid"].VerticalHealth = false
C["Raid"].MaxUnitPerColumn = 5
C["Raid"].Font = C["Lua"].Font
C["Raid"].HealthFont = C["Lua"].Font
C["Raid"].GroupBy.Value = "GROUP"

-- Tooltips
C["Tooltips"].Enable = true
C["Tooltips"].HideOnUnitFrames = false
C["Tooltips"].UnitHealthText = true
C["Tooltips"].ShowSpec = true
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
C["UnitFrames"].Portrait = false
C["UnitFrames"].CastBar = true
C["UnitFrames"].ComboBar = true
C["UnitFrames"].UnlinkCastBar = true
C["UnitFrames"].CastBarIcon = true
C["UnitFrames"].CastBarLatency = true
C["UnitFrames"].Smooth = true
C["UnitFrames"].TargetEnemyHostileColor = true
C["UnitFrames"].CombatLog = false
C["UnitFrames"].HealBar = true
C["UnitFrames"].TotemBar = true
C["UnitFrames"].TargetAuras = true
C["UnitFrames"].FocusAuras = true
C["UnitFrames"].FocusTargetAuras = true
C["UnitFrames"].ArenaAuras = true
C["UnitFrames"].BossAuras = true
C["UnitFrames"].OnlySelfDebuffs = false
C["UnitFrames"].OnlySelfBuffs = false
C["UnitFrames"].Threat = false
C["UnitFrames"].AltPowerText = true
C["UnitFrames"].Arena = true
C["UnitFrames"].Boss = true
C["UnitFrames"].Font = C["Lua"].Font