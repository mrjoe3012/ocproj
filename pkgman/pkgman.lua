local internet = require("internet")
local JSON

local LIST_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/list.json"
local JSON_UTIL_URL = "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"

local function init()
    local handle = internet.request(JSON_UTIL_URL)
    local util = ""
    for chunk in handle do util = util..chunk end
    JSON = load(util)
end

local function getPackageList()

    local handle = internet.request(LIST_URL)
    local jsonList = ""

    for chunk in handle do jsonList = jsonList..chunk end

    local tableList = json.decode(jsonList)

    return tableList

end

init()
pkgList = getPackageList()
for k,v in next, pkgList do print(k)print(v) end