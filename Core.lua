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
    local action = self:GetArgs(msg, 1) or ""
    action = action:lower()
    if action == "start" then
        self:StartLog()
        print(L.started_log)
    elseif action == "stop" then
        self:StopLog()
        print(L.stopped_log)
    elseif action == "resume" then
        self:ResumeLog()
        print(L.resumed_log)
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

do
    local version = "@project-version@"
    local git = version:find("@", nil, true)
    local prefix = string.format("WSAttendance (%s): ", version)
    function addon:Debug(...)
        if git then
            local arg1, arg2 = ...
            local t = type(arg1)
            if t == "table" then
                -- luacheck: globals ViragDevTool_AddData
                if ViragDevTool_AddData then
                    local title = type(arg2) == "string" and arg2
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
                self:Print(prefix, "DEBUG", ...)
            end
        end
    end
end
