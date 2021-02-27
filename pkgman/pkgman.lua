local internet = require("internet")
local json = require("json")

local PKGLIST_PATH = "/etc/pkglist"
local MASTER_PKGLIST_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/pkglist"
local GITHUB_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/"

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
    local file = io.open(PKGLIST_PATH, "r")
    local lines = io.read(file, "*a")
    io.close(file)
    local packageList = json.decode(lines)
    return packageList
end

local function writeLocalPackageList(list)
    local jsonString = json.encode(list)
    local file = io.open(PKGLIST_PATH, "w")
    file:write(jsonString)
    file:close()
end

local function readMasterPackageList()
    local data = internet.request(MASTER_PKGLIST_URL)
    local list = ""
    for chunk in data do list = list..chunk end
    local table = strsplit(list, "\n")
    local pkglist = {}
    for i,name in ipairs(table) do
        pkglist[name] = true
    end
    return pkglist
end

local function func_install()
    local programName = arg[3]
    local localPkgList = readLocalPackageList()
    local masterPkgList = readMasterPackageList()
    if programName == nil then
        print("Usage: install program_name")
    elseif masterPkgList[programName] then
        print(string.format("'%s' is not a program.", arg[3]))
    else
        local installScript = ""
        local data = internet.request(GITHUB_URL..programName.."/install.lua")
        for chunk in data do installScript = installScript..chunk end
        load(data)
    end
end

local function func_list()
    --stub
end

local commands = {
    install=func_install,
    list=func_list
}

if commands[arg[2]] == nil then
    print(string.format("'%s' is not a recognised command.", arg[2]))
else
    commands[arg[2]]()
end