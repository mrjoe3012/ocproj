local exec = os.execute

local GRAPHICS_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/graphics/graphics.lua"
local GRAPHICS_INSTALL_DIR = "/lib/graphics.lua"

exec(string.format("wget -f %s %s", GRAPHICS_LUA_URL, GRAPHICS_INSTALL_DIR))
exec("echo graphics installed.")