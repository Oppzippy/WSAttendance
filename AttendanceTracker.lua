local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.attendanceTracker = {}
local attendanceTracker = addon.attendanceTracker
local frame = CreateFrame("Frame")

-- Optional log to resume tracking
function attendanceTracker:StartTracking(log)
    self:StopTracking()
    self.logSupervisor = addon.AttendanceLogSupervisor:Create(log)
    self.log = self.logSupervisor.log
    self.logSupervisor:UpdateLog()
    -- TODO don't update in combat
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
