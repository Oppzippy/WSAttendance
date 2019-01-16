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

function addon.util.TableDiff(t1, t2)
    local diff = {}
    for k, v in pairs(t1) do
        if v ~= t2[k] then
            diff[k] = true
        end
    end
    for k, v in pairs(t2) do
        if v ~= t1[k] then
            diff[k] = true
        end
    end
    return diff
end

-- t1 will be modified
function addon.util.TableAppend(t1, t2)
    local len = #t1
    for i = 1, #t2 do
        t1[len + i] = t2[i]
    end
end
