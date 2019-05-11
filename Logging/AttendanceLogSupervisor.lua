local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local AttendanceLogSupervisor = {}
addon.AttendanceLogSupervisor = AttendanceLogSupervisor
AttendanceLogSupervisor.__index = AttendanceLogSupervisor

local UnitName, UnitIsConnected = UnitName, UnitIsConnected
local tconcat = table.concat

function AttendanceLogSupervisor:Create(log)
    local ret = {}
    setmetatable(ret, AttendanceLogSupervisor)
    -- Construct
    if log then
        ret.log = log
        ret:RebuildState()
    else
        ret.log = {}
    end
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
    -- Guild
    for name, _, _, _, _, zone, _, _, online, _, _, _, _, _, _, _, guid in addon.util.IterateGuildMembers() do
        local status = {}
        state[name] = status
        status.online = online
        status.zone = zone
        status.group = IsGUIDInGroup(guid)
    end
    -- Group
    for unit in addon.util.IterateGroupMembers() do
        local name, realm = UnitFullName(unit)
        name = name .. "-" .. realm
        if not state[name] then
            local status = {}
            state[name] = status
            status.online = UnitIsConnected(unit)
            status.group = true -- Iterate group members... obviously
        end
    end
    return state
end

function AttendanceLogSupervisor:AddState(newState)
    -- Remove redundant info by comparing the old state playes with the new
    local updates = {}
    local doUpdates = false -- Don't add to log if there are no updates
    if self.state then
        for player, status in pairs(self.state) do
            local diff = addon.util.TableDiff(self.state[player], newState[player])
            if #diff ~= 0 then
                updates[player] = {}
                doUpdates = true
                for _, key in pairs(diff) do
                    updates[player][key] = newState[player][key]
                end
            end
        end
    else
        doUpdates = true
        updates = newState
    end
    if doUpdates then
        local log = self.log
        log[#log+1] = {
            timestamp = GetServerTime(),
            updates = updates,
        }
    end
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
