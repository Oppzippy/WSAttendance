local addon = LibStub("AceAddon-3.0"):NewAddon("WSAttendance", "AceConsole-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

-- TODO: Remove this
local dbDefaults = {
    profile = {
        raids = {
            [1] = {
                date = {
                    hour = 4,
                    minute = 30,
                    day = 11,
                    month = 1,
                    year = 2019,
                }
            }
        }
    }
}

function addon:OnInitialize()
    -- DB
    self.db = LibStub("AceDB-3.0"):New("WSAttendanceDB", dbDefaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    -- Options
    AceConfig:RegisterOptionsTable("WSAttendance", function()
        return self:CreateOptionsTable()
    end)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("WSAttendance", L.name)
    -- Chat command
    self:RegisterChatCommand("wsattendance", "OnChatCommand")
    self:RegisterChatCommand("wsa", "OnChatCommand")
end

function addon:RefreshConfig()

end

function addon:OnChatCommand(msg)
    local args = { self:GetArgs(msg, 1) } -- Increase for more args
    local action = args[1]:lower()
    if action == "start" then
        self:StartLog()
    elseif action == "stop" then
        self:StopLog()
    elseif action == "resume" then
        self:ResumeLog()
    end
end

function addon:StartLog()
    local log = self.attendanceTracker:StartTracking()
    -- TODO: Save the log
end

function addon:StopLog()
    self.attendanceTracker:StopTracking()
end

function addon:ResumeLog()
    -- local prevLog = TODO
    -- self.attendanceTracker:ResumeLog(prevLog)
end
