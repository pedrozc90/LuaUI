local T, C, L = Tukui:unpack()

local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns

local UnitGUID = _G.UnitGUID
local GetRealmName = _G.GetRealmName

local IsInRaid = _G.IsInRaid
local IsInGroup = _G.IsInGroup
local GetNumGroupMembers = _G.GetNumGroupMembers

local GetSpellInfo = _G.GetSpellInfo
local GetSpellBaseCooldown = _G.GetSpellBaseCooldown
local GetTime = _G.GetTime

function RaidCooldowns.UpdateTimer(self, elapsed)
    self.time_left = (self.time_left or (self.expiration - GetTime())) - elapsed
    if (self.time_left > 0) then
        if (self.StatusBar) then
            local percentage = (100 * (self.time_left or 0) / self.cooldown)
            self.StatusBar:SetValue(percentage)
        end

        if (self.Timer) then
            self.Timer:SetText(T.FormatTime(self.time_left))
        end
    else
        RaidCooldowns.CooldownReady(self)
    end
    
end

function RaidCooldowns:GetGroupUnit(index, size, isParty, isRaid)
    if (not index) then index = 0 end
    if (isParty == nil) then isParty = IsInGroup() end
    if (isRaid == nil) then isRaid = IsInRaid() end
    
    if (isRaid and (index > 0)) then
        -- raid1 ... raidN
        -- raid index is between 1 and MAX_RAID_MEMBERS, including player
        return "raid" .. index
    elseif (isParty and (index > 0) and (index < size)) then
        -- party1 ... partyN
        -- party index is between 1 and 4, excluding player
        return "party" .. index
    end
    return "player"
end

function RaidCooldowns:GuidToUnit(guid)
    local isInGroup, isInRaid = IsInGroup(), IsInRaid()
    if (isInGroup or isInRaid) then
        local size = GetNumGroupMembers()
        for index = 1,  size do
            local unit = self:GetGroupUnit(index, size, isInGroup, isInRaid)
            if (guid == UnitGUID(unit)) then
                return unit, index
            end
        end
    end
    return nil, nil
end

function RaidCooldowns:GetRealm(realm)
    if (string.len(realm or "") == 0) then
        return GetRealmName()
    end
    return realm
end

function RaidCooldowns.UpdateBarText(frame, spell_name, member)
    if (not frame.Text or not spell_name) then return end
    local realm = (member.guid ~= self.guid) and member.realm or nil
    local source = (realm) and (member.name .. "-" .. realm) or member.name
    frame.Text:SetText(spell_name .. ": " .. source)
end

function RaidCooldowns.UpdateBarTimer(frame, time)
    if (not frame.Timer) then return end
    frame.Text:SetText(T.FormatTime(time))
end

function RaidCooldowns.CooldownReady(self)
    if (self.StatusBar) then
        self.StatusBar:SetValue(100)
    end

    if (self.Timer) then
        self.Timer:SetText("Ready")
    end

    self.time_left = nil
    self.expiration = nil
    self.start = nil

    self:SetScript("OnUpdate", nil)
end

function RaidCooldowns:SpawnBar(index, name, realm, class, spellName, spellIcon)
    -- local sourceName = (realm) and (name .. "-" .. realm) or name

    local Width, Height = C.RaidCD.BarWidth, C.RaidCD.BarHeight
    local Spacing = C.RaidCD.BarSpacing
    local Texture = C.Medias.Blank
    local Font = T.GetFont(C.UnitFrames.Font)

    local color = RAID_CLASS_COLORS[class]

    local Bar = CreateFrame("Frame", self:GetName() .. index, UIParent)
    Bar:SetSize(Width, Height)
    Bar:SetFrameStrata(self:GetFrameStrata())
    Bar:SetFrameLevel(self:GetFrameLevel() + 1)
    Bar:CreateBackdrop()

    local StatusBar = CreateFrame("StatusBar", Bar:GetName() .. "StatusBar", Bar)
    StatusBar:SetInside(Bar)
    StatusBar:SetFrameStrata(self:GetFrameStrata())
    StatusBar:SetFrameLevel(Bar:GetFrameLevel() + 1)
    StatusBar:SetStatusBarTexture(Texture)
    StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
    StatusBar:SetMinMaxValues(0, 100)
    StatusBar:SetValue(80)
    -- StatusBar:CreateBackdrop()

    StatusBar.Background = StatusBar:CreateTexture(nil, "BORDER")
    StatusBar.Background:SetAllPoints(StatusBar)
    StatusBar.Background:SetTexture(Texture)
    StatusBar.Background:SetVertexColor(0.15, 0.15, 0.15)

    local Button = CreateFrame("Button", Bar:GetName() .. "Button", Bar)
    Button:SetPoint("RIGHT", StatusBar, "LEFT", -Spacing, 0)
    Button:SetSize(Height, Height)
    Button:CreateBackdrop()

    local Icon = Button:CreateTexture(nil, "ARTWORK")
	-- icon:SetAllPoints(button)
    Icon:SetInside(Button)
	Icon:SetTexCoord(unpack(T.IconCoord))
    Icon:SetTexture(spellIcon)

    local Text = StatusBar:CreateFontString(nil, "OVERLAY")
    Text:SetFontObject(Font)
    Text:SetPoint("LEFT", StatusBar, "LEFT", 5, 0)
    Text:SetTextColor(0.84, 0.75, 0.65)
    Text:SetWidth(0.8 * Width)
    Text:SetJustifyH("LEFT")
    Text:SetText(spellName .. ": " .. name)

    local Timer = StatusBar:CreateFontString(nil, "OVERLAY")
    Timer:SetFontObject(Font)
    Timer:SetPoint("RIGHT", StatusBar, "RIGHT", -5, 0)
    Timer:SetTextColor(0.84, 0.75, 0.65)
    Timer:SetJustifyH("RIGHT")
    Timer:SetText("Ready")

    Bar.StatusBar = StatusBar
    Bar.Button = Button
    Bar.Icon = Icon
    Bar.Text = Text
    Bar.Timer = Timer

    return Bar
end

function RaidCooldowns:IsTalentActive(guid, talentID)
    return self.group[guid].talents[talentID].selected
end

-- if spell has cooldown modifier we need to update base cooldown time.
function RaidCooldowns:PostUpdateCooldown(guid, spellID, cooldown_ms)
    local cooldown_s = (cooldown_ms or 0) / 1000
    if (spellID == 15286 and self:IsTalentActive(guid, 23374)) then        -- Vampiric Embrace
        cooldown_s = cooldown_s - 45
    elseif (spellID == 15487 and self:IsTalentActive(guid, 23137)) then            -- Silence
        cooldown_s = cooldown_s - 15
    elseif (spellID == 47585 and self:IsTalentActive(guid, 21976)) then        -- Dispersion
        cooldown_s = cooldown_s - 30
    
    elseif (spellID == 12975 and self:IsTalentActive(guid, 23099)) then        -- Last Stand
        cooldown_s = cooldown_s - 60
    end
    return cooldown_s
end

-- Initialize spell tracker timer when a spell is used by anybody from the group.
function RaidCooldowns:UpdateCooldown(unit, spellID)
    local match = string.match(unit, "%a+")
    if (unit ~= "player" and match ~= "party" and match ~= "raid") then return end

    local guid = UnitGUID(unit)
    
    local index = self:FindCooldownIndex(guid, spellID)
    if (not index) then return end

    local name, _, icon, _, _, _, _ = GetSpellInfo(spellID)
    if (not name) then return end

    local cooldown_ms, _ = GetSpellBaseCooldown(spellID)
    local cooldown = self:PostUpdateCooldown(guid, spellID, cooldown_ms)  

    local frame = self.bars[index]
    frame.expiration = GetTime() + cooldown
    frame.cooldown = cooldown

    print(frame.spellID, frame.spellName, cooldown_ms, cooldown)

    if (frame.Icon) then
        frame.Icon:SetTexture(icon)
    end

    if (frame.StatusBar) then
        frame.StatusBar:SetValue(100)
    end

    if (frame.Timer) then
        frame.Timer:SetText(T.FormatTime(cooldown))
    end

    frame:SetScript("OnUpdate", self.UpdateTimer)
end
