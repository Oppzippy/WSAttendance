local addon = LibStub("AceAddon-3.0"):GetAddon("WSAttendance")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WSAttendance")

function addon:CreateOptionsRaidExport(log)
    return {
        name = L.date_time:format(log.date.year, log.date.month, log.date.day, log.date.hour, log.date.minute),
        type = "group",
        args = {
            export = {
                name = L.export,
                type = "execute",
                func = function()
                    self:ExportRaid(log)
                end,
            },
            delete = {
                name = L.delete,
                type = "execute",
                func = function()
                    self:DeleteRaid(log)
                end,
            },
        }
    }
end

function addon:CreateOptionsRaidExports()
    local options = {}
    for _, raid in ipairs(self.db.profile.raids) do
        local option = self:CreateOptionsRaidExport(raid)
        options[option.name] = option
    end
    return options
end

function addon:CreateOptionsTable()
    return {
        type = "group",
        name = L.name,
        args = {
            savedRaids = {
                name = L.saved_raids,
                desc = L.saved_raids_desc,
                type = "group",
                args = self:CreateOptionsRaidExports(),
            },
            profiles = AceDBOptions:GetOptionsTable(self.db),
        }
    }
end
