local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local RaidLog = {}
RaidLog.__index = RaidLog

function RaidLog:Create(log)
    local ret = {}
    setmetatable(ret, self)
    -- Construct
    if log then
        ret.log = log
    else
        ret.log = {}
        ret:UpdateLog()
    end
    self:RebuildState()
    return ret
end

function RaidLog:RebuildState()
    self.state = {}
    for i, update in ipairs(self.log) do
        self.state[update.player] = update.status
    end
end

function RaidLog:SnapshotState()
    local state = {}
    for name, _, _, _, _, zone, _, _, online in addon.util.IterateGuildMembers() do
        if online then
            state[name] = "ONLINE"
            if UnitInRaid(name) then
                state[name] = "RAID"
            end
        end
    end
end

function RaidLog:GenerateDiff(newstate)
    local updates = {}
    local index = 1
    local diff = addon.util.TableDiff(self.state, newstate)
    for player in pairs(diff) do
        local update = {
            time = GetTime(), -- TODO: proper time function
            player = player,
            status = newstate[player],
        }
    end
    return updates
end

function RaidLog:UpdateLog()
    local newstate = self:SnapshotState()
    local updates = self:GenerateDiff(newstate)
    addon.util.TableAppend(self.log, updates)
    self.state = newstate
end
