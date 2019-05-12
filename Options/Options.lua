local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

function addon:CreateOptionsLogExport(log)
    if #log == 0 then return end
    return {
        name = date(L.date_time, log[1].timestamp),
        type = "group",
        args = {
            export = {
                name = L.export,
                type = "execute",
                func = function()
                    self:ExportLog(log)
                end,
            },
            delete = {
                name = L.delete,
                type = "execute",
                func = function()
                    self:DeleteLog(log)
                end,
            },
        }
    }
end

function addon:CreateOptionsLogExports()
    local options = {}
    local logs = self.db.profile.logs
    local count = #logs
    for i = 1, count do
        local log = logs[i]
        local option = self:CreateOptionsLogExport(log)
        if option then
            option.order = count - i  -- Display logs in reverse order (newest first)
            options[option.name] = option
        end
    end
    return options
end

function addon:CreateOptionsTable()
    return {
        type = "group",
        name = L.name,
        args = {
            savedLogs = {
                name = L.saved_logs,
                desc = L.saved_logs_desc,
                type = "group",
                args = self:CreateOptionsLogExports(),
            },
            profiles = AceDBOptions:GetOptionsTable(self.db),
        }
    }
end
