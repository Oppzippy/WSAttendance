local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.eventFrame = CreateFrame("frame")
addon.attendanceTracker = {}
local frame = addon.eventFrame

frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("RAID_ROSTER_UPDATE")

local function OnEvent(event, ...)
    local attendanceTracker = addon.attendanceTracker
    local func = attendanceTracker[event]
    func(attendanceTracker, ...)
end

function addon.attendanceTracker:GUILD_ROSTER_UPDATE()

end

function addon.attendanceTracker:RAID_ROSTER_UPDATE()

end
