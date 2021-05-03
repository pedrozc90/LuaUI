local _, ns = ...
local RaidCooldowns = ns.RaidCooldowns

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
                return unit
            end
        end
    end
    return nil
end

function RaidCooldowns:GetRealm(realm)
    if (string.len(realm or "") == 0) then
        return GetRealmName()
    end
    return realm
end
