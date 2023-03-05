local _, ns = ...


ns.RaidCooldowns.SpellTable = {
    ["EVOKER"] = {},
    ["DRUID"] = {
        -- Balance
        [786750] = { enabled = true, specs = { [102] = true } },                 -- Solar Beam
        
        -- Guardian / Feral
        [106839] = { enabled = true, specs = { [103] = true, [104] = true } }    -- Skull Bash
    },
    ["DEATHKNIGHT"] = {
        [47528] = { enabled = true }                                             -- Mind Freeze
    },
    ["DEMONHUNTER"] = {
        [183752] = { enabled = true }                                            -- Disrupt
    },
    ["HUNTER"] = {
        [147362] = { enabled = true }                                            -- Counter Shot
    },
    ["MAGE"] = {
        [2139] = { enabled = true }                                              -- Counterspell
    },
    ["PALADIN"] = {
        [96231] = { enabled = true }                                             -- Rebuke (15 sec)
    },
    ["PRIEST"] = {
        -- Shadow
        [15487] = { enabled = true, specs = { [258] = true } }                  -- Silence
    },
    ["ROGUE"] = {
        [1766] = { enabled = true }                                              -- Kick
    },
    ["MONK"] = {
        [116705] = { enabled = true }                                           -- Spear Hand Strike
    },
    ["SHAMAN"] = {
        [57994] = { enabled = true }                                             -- Wind Shear
    },
    ["WARLOCK"] = {},
    ["WARRIOR"] = {
        [6552] = { enabled = true }                                            -- Pummel
    }
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
