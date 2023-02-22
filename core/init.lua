local T, C, L = Tukui:unpack()

-- Blizzard
local Interface = select(4, GetBuildInfo())

T.Interface = Interface
T.Retail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
T.Classic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
T.BCC = (Interface >= 20000 and Interface < 30000)
T.WotLK = (Interface >= 30000 and Interface < 40000)
T.Cataclysm = (Interface >= 40000 and Interface < 50000)
T.MoP = (Interface >= 50000 and Interface < 60000)
T.WoD = (Interface >= 60000 and Interface < 70000)
T.Legion = (Interface >= 70000 and Interface < 80000)
T.BFA = (Interface >= 80000 and Interface < 90000)
T.Shadowlands = (Interface >= 90000 and Interface < 100000)
T.Dragonflight = (Interface >= 100000 and Interface < 110000)
