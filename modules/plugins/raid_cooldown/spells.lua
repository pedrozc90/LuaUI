local _, ns = ...
local SpellTable = ns.RaidCooldowns.SpellTable

SpellTable["DRUID"] = {
    -- All
    { spellID = 22812, type = "defense", enabled = false },                                             -- Barkskin

    -- Balance
    { spellID = 78675, type = "interrupt", specs = { [102] = true }, enabled = true },                  -- Solar Beam
    { spellID = 102793, type = "interrupt", enabled = true },                                           -- Ursol's Vortex

    -- Guardian / Feral
    { spellID = 106839, type = "interrupt", specs = { [103] = true, [104] = true }, enabled = true },   -- Skull Bash
    { spellID = 61336, type = "defense", specs = { [103] = true, [104] = true }, enabled = false }      -- Survival Instincts
}

SpellTable["DEATHKNIGHT"] = {
    { spellID = 47528, type = "interrupt", enabled = true }                                             -- Mind Freeze
}

SpellTable["DEMONHUNTER"] = {
    { spellID = 183752, type = "interrupt", enabled = true }                                            -- Disrupt
}

SpellTable["HUNTER"] = {
    { spellID = 147362, type = "interrupt", enabled = true }                                            -- Counter Shot
}

SpellTable["MAGE"] = {
    { spellID = 2139, type = "interrupt", enabled = true }                                              -- Counterspell
}

SpellTable["PALADIN"] = {
    { spellID = 642, type = "defense", specs = { [66] = true }, enabled = true },                       -- Divine Shield
    { spellID = 31850, type = "defense", specs = { [66] = true }, enabled = true },                     -- Ardent Defender
    { spellID = 115750, type = "crowdcontrol", specs = { [66] = true }, enabled = true },               -- Bliding Light
    { spellID = 96231, type = "interrupt", specs = { [66] = true, [67] = true }, enabled = true }       -- Rebuke (15 sec)
}

SpellTable["PRIEST"] = {
    -- All
    { spellID = 10060, type = "raid", specs = { [256] = true, [258] = true }, enabled = true },         -- Power Infusion

    -- Discipline
    { spellID = 33206, type = "raid", specs = { [256] = true }, enabled = true },                       -- Pain Suppression
    { spellID = 62618, type = "raid", specs = { [256] = true }, enabled = true },                       -- Power Word: Barrier

    -- Holy
    { spellID = 47788, type = "raid", specs = { [257] = true }, enabled = true },                       -- Guardian Spirit
    { spellID = 64843, type = "raid", specs = { [257] = true }, enabled = true },                       -- Divine Hymn

    -- Shadow
    { spellID = 15487, type = "interrupt", specs = { [258] = true }, enabled = true },                  -- Silence
    { spellID = 15286, type = "raid", specs = { [258] = true }, enabled = true },                       -- Vampiric Embrace
    { spellID = 47585, type = "defense", specs = { [258] = true }, enabled = true }                     -- Dispersion
}

SpellTable["ROGUE"] = {
    { spellID = 1766, type = "interrupt", enabled = true }                                              -- Kick
}

SpellTable["MONK"] = {
    -- Mistweaver
    { spellID = 116849, type = "raid", specs = { [270] = true }, enabled = true },                      -- Life Cocoon

    { spellID = 116844, type = "raid", talentID = 19995, enabled = true },                              -- Ring of Peace

    -- Windwalker
    { spellID = 116844, type = "raid", talentID = 20173, enabled = true },                              -- Diffuse Magic

    -- Brewmaster
    { spellID = 116705, type = "interrupt", enabled = true },                                           -- Spear Hand Strike
    { spellID = 115203, type = "defense", specs = { [268] = true }, enabled = true },                   -- Fortigying Brew
    { spellID = 122278, type = "defense", specs = { [268] = true, [269] = true }, talentID = 20175, enabled = true }  -- Dampen Harm
}

SpellTable["SHAMAN"] = {
    { spellID = 57994, type = "interrupt", enabled = true }                                             -- Wind Shear
}

SpellTable["WARLOCK"] = {
    { spellID = 20707 , type = "raid", enabled = true }                                                 -- Soulstone
}

SpellTable["WARRIOR"] = {
    -- All
    { spellID = 6552 , type = "interrupt", enabled = true },                                            -- Pummel

    -- Protection
    { spellID = 871, type = "defense", specs = { [73] = true }, enabled = true },                       -- Shield Wall
    { spellID = 12975, type = "defense", specs = { [73] = true }, enabled = true },                     -- Last Stand
    { spellID = 97462, type = "raid", enabled = true },                                                 -- Rallying Cry
    { spellID = 107570, type = "cc", specs = { [73] = true }, talentID = 22409, enabled = true }        -- Storm Bold
}

local Specializations = {
    -- Death Knight
    [250] = "Blood",
    [251] = "Frost",
    [252] = "Unholy",
    -- Demon Hunter
    [577] = "Havoc",
    [581] = "Vengeance",
    -- Druid
    [102] = "Balance",
    [103] = "Feral",
    [104] = "Guardian",
    [105] = "Restoration",
    -- Hunter
    [253] = "Beast Mastery",
    [254] = "Marksmanship",
    [255] = "Survival",
    -- Mage
    [62] = "Arcane",
    [63] = "Fire",
    [64] = "Frost",
    -- Monk
    [268] = "Brewmaster",
    [270] = "Mistweaver",
    [269] = "Windwalker",
    -- Paladin
    [65] = "Holy",
    [66] = "Protection",
    [70] = "Retribution",
    -- Priest
    [256] = "Discipline",
    [257] = "Holy",
    [258] = "Shadow",
    -- Rogue
    [259] = "Assassination",
    [260] = "Outlaw",
    [261] = "Subtlety",
    -- Shaman
    [262] = "Elemental",
    [263] = "Enhancement",
    [264] = "Restoration",
    -- Warlock
    [265] = "Affliction",
    [266] = "Demonology",
    [267] = "Destruction",
    -- Warrior
    [71] = "Arms",
    [72] = "Fury",
    [73] = "Protection",
}
