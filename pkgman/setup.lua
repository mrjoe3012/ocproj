local exec = os.execute
local internet = require("internet")

local JSON_INSTALL_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/json/install.lua"
local PKGMAN_INSTALL_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/pkgman/install.lua"
local PKGLIST_DIR = "/etc/pkglist"

local function getFile(url)
    local data = internet.request(url)
    local file = ""
    for chunk in data do file = file .. chunk end
    return file
end

local jsonInstallScript = getFile(JSON_INSTALL_URL)
load(jsonInstallScript)

local pkgInstallScript = getFile(PKGMAN_INSTALL_URL)
load(pkgInstallScript)

local json = require("json")

local pkgListNew = {["pkgman"]=true, ["json"]=true}
local pkgListJson = json.encode(pkgListNew)

file = io.open(PKGLIST_DIR, "w")
io.output(file)
io.write(pkgListJson)
io.close(file)