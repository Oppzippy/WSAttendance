local addon = LibStub("AceAddon-3.0"):NewAddon("WSAttendance", "AceConsole-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

-- TODO: Remove this
local dbDefaults = {
    profile = {
        logs = {},
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
    local action = self:GetArgs(msg, 1) or ""
    action = action:lower()
    if action == "start" then
        self:StartLog()
        self:Print(L.start_log)
    elseif action == "stop" then
        self:StopLog()
        self:Print(L.stop_log)
    elseif action == "resume" then
        self:ResumeLog()
        self:Print(L.resume_log)
    elseif action == "clean" then
        local logs = self.db.profile.logs
        local count = 0
        for i = 1, #logs do
            local newIndex = i - count
            if #logs[newIndex] == 0 then
                table.remove(logs, newIndex)
                count = count + 1
            end
        end
        self:Print("Wiped", count, "empty logs")
    end
end

function addon:StartLog()
    local log = self.attendanceTracker:StartTracking()
    local dbLogs = self.db.profile.logs
    dbLogs[#dbLogs+1] = log
    return log
end

function addon:StopLog()
    return self.attendanceTracker:StopTracking()
end

function addon:ResumeLog()
    local dbLogs = self.db.profile.logs
    local prevLog = dbLogs[#dbLogs]
    self.attendanceTracker:ResumeLog(prevLog)
    return prevLog
end

do
    local version = "@project-version@"
    local git = version:find("@", nil, true)
    function addon:Debug(...)
        if git then
            local arg1, arg2 = ...
            local t = type(arg1)
            if t == "table" then
                -- luacheck: globals ViragDevTool_AddData
                if ViragDevTool_AddData then
                    local title = type(arg2) == "string" and arg2 or nil
                    ViragDevTool_AddData(arg1, title)
                else
                    for k, v in pairs(arg1) do
                        local keyType = type(k)
                        if keyType == "string" or keyType == "number" then
                            self:Print(k)
                        end
                    end
                end
            else
                self:Print("[DEBUG]", ...)
            end
        end
    end
end
