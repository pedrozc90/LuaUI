local _, ns = ...
local SpellTable = ns.RaidCooldowns.SpellTable

SpellTable["DRUID"] = {
    { spellID = 78675, type = "interrupt", specs = { [102] = true }, enabled = true },                  -- Solar Beam
    { spellID = 106839, type = "interrupt", specs = { [103] = true, [102] = true }, enabled = true }    -- Skull Bash
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
    { spellID = 33206, type = "raid", specs = { [256] = true }, enabled = true },                       -- Pain Suppression
    { spellID = 62618, type = "raid", specs = { [256] = true }, enabled = true },                       -- Power Word: Barrier
    { spellID = 47788, type = "raid", specs = { [257] = true }, enabled = true },                       -- Guardian Spirit
    { spellID = 15487, type = "interrupt", specs = { [258] = true }, enabled = true },                  -- Silence
    { spellID = 15286, type = "raid", specs = { [258] = true }, enabled = true },                       -- Vampiric Embrace
    { spellID = 47585, type = "defense", specs = { [258] = true }, enabled = true },                    -- Dispersion
}

SpellTable["ROGUE"] = {
    { spellID = 1766, type = "interrupt", enabled = true }                                              -- Kick
}

SpellTable["MONK"] = {
    { spellID = 116705, type = "interrupt", enabled = true },                                           -- Spear Hand Strike
    { spellID = 115203, type = "defense", specs = { [268] = true }, enabled = true },                   -- Fortigying Brew
    { spellID = 122278, type = "defense", specs = { [268] = true }, talents = {}, enabled = true },                  -- Dampen Harm
    { spellID = 116849, type = "raid", specs = { [270] = true }, enabled = true },                      -- Life Cocoon
}

SpellTable["SHAMAN"] = {
    { spellID = 57994, type = "interrupt", enabled = true }                                             -- Wind Shear
}

SpellTable["WARLOCK"] = {
    { spellID = 20707 , type = "raid", enabled = true }                                                 -- Soulstone
}

SpellTable["WARRIOR"] = {
    { spellID = 871, type = "defense", specs = { [73] = true }, enabled = true },                           -- Shield Wall
    { spellID = 6552 , type = "interrupt", enabled = true },                                                -- Pummel
    { spellID = 97462, type = "raid", enabled = true },                                                     -- Rallying Cry
    { spellID = 107570, type = "interrupt", specs = { [73] = true }, talent = { 2, 3 }, enabled = true },   -- Storm Bold
}
