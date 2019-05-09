local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.attendanceTracker = {}
local attendanceTracker = addon.attendanceTracker
local frame = CreateFrame("Frame")
--[[
TODO Update on events, but don't update in combat. Instead, queue an update for after
combat. Limit the maximum update rate though to a few seconds. If a second update occurs within
those few seconds, queue one after the three seconds have elapsed.
]]--

-- Optional log to resume tracking
function attendanceTracker:StartTracking(log)
    self:StopTracking()
    self.logSupervisor = addon.AttendanceLogSupervisor:Create(log)
    self.log = self.logSupervisor.log
    self.logSupervisor:UpdateLog()
    self.ticker = C_Timer.NewTicker(60, function()
        self.logSupervisor:UpdateLog()
    end)
end

function attendanceTracker:StopTracking()
    if self.ticker then
        self.ticker:Cancel()
        self.ticker = nil
    end
    self.logSupervisor = nil
    self.log = nil
end
