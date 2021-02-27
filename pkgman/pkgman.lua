local internet = require("internet")
local json = require("json")

local function strsplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


local function readLocalPacakgeList()

    local packageList = {}

    return packageList

end

local function writeLocalPackageList(list)

    

end

local function readMasterPackageList()

end