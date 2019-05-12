local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
addon.popups = {}
local popups = addon.popups
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

StaticPopupDialogs["WSATTENDANCE_DELETE_LOG"] = {
    text = L.confirm_delete_log,
    button1 = L.yes,
    button2 = L.no,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    OnAccept = function(_, log)
        addon:DeleteLog(log)
    end
}
