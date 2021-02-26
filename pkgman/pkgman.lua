local internet = require("internet")

local LIST_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/list.json"

local function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


local function getPackageList()

    local handle = internet.request(LIST_URL)
    local listString = ""
    local lines

    for chunk in handle do listString = listString..chunk end

    lines = split(listString, "\n")

    local tableList = {}

    for i,line in ipairs(lines) do
        local data = split(line, ",")
        table.insert(tableList, {name=data[1],version=data[2]})
    end

    return tableList

end

init()
pkgList = getPackageList()
for k,v in next, pkgList do print(k)print(v.name..":"..v.version) end