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
            if t1 == nil or v ~= t1[k] then
                count = count + 1
                diff[count] = k
            end
        end
    end
    return diff
end
