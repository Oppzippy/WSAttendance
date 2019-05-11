local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")
local LibCopyPaste = LibStub("LibCopyPaste-1.0")
local LibJSON = LibStub("LibJSON-1.0")

function addon:DeleteLog(log)
    local logs = self.db.profile.logs
    for i, savedLog in ipairs(logs) do
        if savedLog == log then
            table.remove(logs, i)
            return
        end
    end
end

function addon:ExportLog(log)
    local json = LibJSON.ToJSON({log = log})
    LibCopyPaste:Copy(L.name, json)
end
