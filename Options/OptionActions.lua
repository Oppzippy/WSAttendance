local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")
local LibCopyPaste = LibStub("LibCopyPaste-1.0")
local LibJSON = LibStub("LibJSON-1.0")

function addon:ExportLog(log)
    local json = LibJSON.ToJSON({log = log})
    LibCopyPaste:Copy(L.name, json)
end
