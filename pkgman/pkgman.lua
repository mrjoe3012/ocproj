local internet = require("internet")
local json = require("json")

local PKGLIST_PATH = "/etc/pkglist"
local MASTER_PKGLIST_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/pkglist"
local GITHUB_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/"

local arg = {...}

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

local function readLocalPackageList()
    io.input(PKGLIST_PATH)
    local lines = io.read("*all")
    io.close(file)
    local packageList = json.decode(lines)
    return packageList
end

local function writeLocalPackageList(list)
    local jsonString = json.encode(list)
    local file = io.open(PKGLIST_PATH, "w")
    io.output(file)
    io.write(jsonString)
    io.close(file)
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
    local programName = arg[2]
    local localPkgList = readLocalPackageList()
    local masterPkgList = readMasterPackageList()
    if programName == nil then
        print("Usage: install program_name")
    elseif masterPkgList[programName] == nil then
        print(string.format("'%s' is not a program.", arg[2]))
    else
        local installScript = ""
        local data = internet.request(GITHUB_URL..programName.."/install.lua")
        for chunk in data do installScript = installScript..chunk end
        load(installScript)()
        localPkgList[programName] = true
        writeLocalPackageList(localPkgList)
    end
end

local function func_list()
    local localPkgList = readLocalPackageList()
    local masterPkgList = readMasterPackageList()
    if arg[2] == "-local" or "-installed" then
        print("Installed Packages:")
        for pkgName,_ in pairs(localPkgList) do
            print(pkgName)
        end
    else if arg[2] ~= nil then
        print(string.format("Unknown switch '%s'", arg[2]))
    else
        print("All Packages")
        for pkgName,_ in pairs(masterPkgList) do
            print(pkgName)
        end
    end

end

local commands = {
    install=func_install,
    list=func_list
}

if commands[arg[1]] == nil then
    print(string.format("'%s' is not a recognised command.", arg[1]))
else
    commands[arg[1]]()
end