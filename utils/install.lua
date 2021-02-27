local exec = os.execute

local UTILS_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/utils/utils.lua"
local UTILS_INSTALL_DIR = "/lib/utils.lua"

exec(string.format("wget -f %s %s", UTILS_LUA_URL, UTILS_INSTALL_DIR))
print("utils has installed.")