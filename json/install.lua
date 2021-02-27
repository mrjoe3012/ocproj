local exec = os.execute

local INSTALL_DIR = "/lib/json.lua"
local JSON_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/json/json.lua"

exec(string.format("wget %s %s", JSON_LUA_URL, INSTALL_DIR))
exec("echo json installed.")