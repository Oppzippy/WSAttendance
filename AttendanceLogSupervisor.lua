local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local AttendanceLogSupervisor = {}
AttendanceLogSupervisor.__index = AttendanceLogSupervisor

function AttendanceLogSupervisor:Create(log)
    local ret = {}
    setmetatable(ret, self)
    -- Construct
    if log then
        ret.log = log
    else
        ret.log = {}
    end
    self:RebuildState()
    return ret
end

-- Rebuilds the current state from the log
function AttendanceLogSupervisor:RebuildState()
    self.state = {}
    for _, updateGroup in ipairs(self.log) do
        for _, update in ipairs(self.log) do
            self.state[update.player] = update.status
        end
    end
end

-- Returns a table containing the current state
function AttendanceLogSupervisor:SnapshotState()
    local state = {}
    for name, _, _, _, _, zone, _, _, online in addon.util.IterateGuildMembers() do
        local status = {}
        state[name] = status
        status.online = online
        if online then
            status.zone = zone
        end
        if UnitInRaid(name) then
            status.group = true
        end
    end
    return state
end

function AttendanceLogSupervisor:AddState(newState)
    -- Remove redundant info by comparing the old state playes with the new
    local updates = {}
    for player, status in pairs(self.state) do
        local diff = addon.util.TableDiff(self.state, newState[player])
        if #diff ~= 0 then
            updates[player] = {}
            for _, key in pairs(diff) do
                updates[player][key] = newState[player][key]
            end
        end
    end
    tinsert(self.log, updates)
    self.state = newState
end

function AttendanceLogSupervisor:AddStateRaw(newState)
    tinsert(self.log, newState)
    self.state = newState
end

function AttendanceLogSupervisor:UpdateLog()
    local newState = self:SnapshotState()
    self:AddState(newState)
end
