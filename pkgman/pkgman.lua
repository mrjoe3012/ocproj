local internet = require("internet")
local json = require("json")

local PKGLIST_PATH = "/etc/pkglist"
local MASTER_PKGLIST_URL = ""

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

local function linearSearch(inputTab, term)
    local index = nil
    for i=1,#inputTab,1 do
        if inputTab[i] == term then
            index = i
            break
        end
    end
    return index
end

local function readLocalPacakgeList()
    local file = io.open(PKGLIST_PATH, "r")
    local lines = io.read(file, "*a")
    io.close(file)
    local packageList = strsplit(lines, "\n")
    return packageList
end

local function writeLocalPackageList(list)
    local jsonString = json.decode(list)
    local file = io.open(PKGLIST_PATH, "w")
    file:write(jsonString)
    file:close()
end

local function readMasterPackageList()

end