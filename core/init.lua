local T, C, L = Tukui:unpack()

-- Blizzard
local Interface = select(4, GetBuildInfo())

-- reference: https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID
T.Interface = Interface
T.Retail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
T.Classic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
T.TBC = (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
T.WotLK = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
T.Cata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)
