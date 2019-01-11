-- luacheck: globals LibStub

local MAJOR, MINOR = "LibJSON-1.0", 1
local LibJSON = LibStub:NewLibrary(MAJOR, MINOR)
if not LibJSON then return end

-- Constants
local OBJECT_FORMAT = "\"%s\":%s"
local ARRAY_FORMAT = "%s"
local QUOTED = "\"%s\""
local ARRAY_START, ARRAY_END = "[", "]"
local OBJECT_START, OBJECT_END = "{", "}"
local SEPARATOR = ","
local SPECIAL_CHARS, SPECIAL_CHARS_REPLACE = "([\"\r\n\t\\])", "\\%1"

-- Recursively converts a lua table to a JSON object/array
function LibJSON.ToJSON(input)
    local isArray = input[1] ~= nil
    local ret = {}
    table.insert(ret, isArray and ARRAY_START or OBJECT_START) -- Start table
    local iterator = isArray and ipairs or pairs
    for key, value in iterator(input) do
        local currentType = type(value)
        if currentType == "table" then
            table.insert(ret, LibJSON.ToString(value))
            table.insert(ret, SEPARATOR)
        elseif currentType == "string" or currentType == "number" then
            -- Quote it if it's a string
            local formattedValue = value
            if currentType == "string" then
                formattedValue = value:gsub(SPECIAL_CHARS, SPECIAL_CHARS_REPLACE)
                formattedValue = QUOTED:format(formattedValue)
            end
            if isArray then
                table.insert(ret, ARRAY_FORMAT:format(formattedValue))
            else
                table.insert(ret, OBJECT_FORMAT:format(key, formattedValue))
            end
            table.insert(ret, SEPARATOR)
        end
    end
    table.remove(ret) -- Delete trailing comma
    table.insert(ret, isArray and ARRAY_END or OBJECT_END) -- End table
    return table.concat(ret)
end

-- TODO: Recursively convert JSON objects and arrays to Lua tables
function LibJSON.ToTable(input)

end
