local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.util = {}

function addon.util.IterateGuildMembers()
    local i = 0
    local max = GetNumGuildMembers()
    return function()
        i = i + 1
        if i > max then return end
        return GetGuildRosterInfo(i)
    end
end

do
    local raid = {
        "raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
        "raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
        "raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
        "raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
    }
    local party = {
        "player", "party1", "party2", "party3", "party4"
    }
    function addon.util.IterateGroupMembers()
        local groupMembers = GetNumGroupMembers()
        if groupMembers == 0 then
            groupMembers = 1 -- Party, first element is player
        end
        local group = IsInRaid() and raid or party
        local i = 0
        return function()
            i = i + 1
            if i <= groupMembers then
                return group[i]
            end
        end
    end
end

-- Returns a table containing all keys that are in one table but not the other

function addon.util.TableDiff(t1, t2)
    local diff = {}
    local count = 0
    -- Add all keys if a table is nil
    if t1 ~= nil then
        for k, v in pairs(t1) do
            if t2 == nil or v ~= t2[k] then
                count = count + 1
                diff[count] = k
            end
        end
    end
    if t2 ~= nil then
        for k, v in pairs(t2) do
            if t1 == nil or t1[k] == nil then -- If it's not nil, it was caught in the pass through t1
                count = count + 1
                diff[count] = k
            end
        end
    end
    return diff
end
