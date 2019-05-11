local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.attendanceTracker = {}
local attendanceTracker = addon.attendanceTracker
attendanceTracker.frame = CreateFrame("Frame")
do
    local aceTimer = LibStub("AceTimer-3.0")
    aceTimer:Embed(attendanceTracker)
end

local MAX_UPDATE_RATE = 10 -- seconds

-- Optional log to resume tracking
function attendanceTracker:StartTracking(log)
    self:StopTracking()
    self.logSupervisor = addon.AttendanceLogSupervisor:Create(log)
    self.log = self.logSupervisor.log
    self.prevUpdate = 0
    self:Update()
    self.frame:SetScript("OnEvent", function(_, event)
        local f = self[event]
        if f then f(self) end
    end)
    self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.frame:RegisterEvent("GUILD_ROSTER_UPDATE")
    self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    return self.log
end

function attendanceTracker:StopTracking()
    local log = self.log
    self.logSupervisor = nil
    self.log = nil
    self.frame:SetScript("OnEvent", nil)
    self.frame:UnregisterAllEvents()
    return log
end

function attendanceTracker:Update()
    local t = GetTime()
    if t - self.prevUpdate >= MAX_UPDATE_RATE then
        addon:Debug("Update")
        self.prevUpdate = t
        self:CancelTimer(self.updateTimer)
        self.logSupervisor:UpdateLog()
    elseif self:TimeLeft(self.updateTimer) == 0 then
        addon:Debug("Scheduling update")
        self.updateTimer = self:ScheduleTimer("QueueUpdate", MAX_UPDATE_RATE - (t - self.prevUpdate))
    end
end

function attendanceTracker:QueueUpdate()
    addon:Debug("Update queued")
    if InCombatLockdown() then
        self.updateQueued = true
    else
        self:Update()
    end
end

function attendanceTracker:PLAYER_REGEN_ENABLED()
    if self.updateQueued then
        self:Update()
        self.updateQueued = nil
    end
end

function attendanceTracker:GUILD_ROSTER_UPDATE()
    self:QueueUpdate()
end

function attendanceTracker:GROUP_ROSTER_UPDATE()
    self:QueueUpdate()
end
