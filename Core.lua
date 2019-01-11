local addon = LibStub("AceAddon-3.0"):NewAddon("WSAttendance", "AceConsole-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

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
    self.db = LibStub("AceDB-3.0"):New("WSAttendanceDB", dbDefaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    AceConfig:RegisterOptionsTable("WSAttendance", function()
        return self:CreateOptionsTable()
    end, {
        "wsa", "wsattendance", "wrongstratattendance",
    })
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("WSAttendance", L.name)
end

function addon:RefreshConfig()

end
