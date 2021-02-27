local exec = os.execute

local PKGMAN_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/pkgman/pkgman.lua"
local PKGMAN_INSTALL_DIR = "/bin/pkgman.lua"

exec(string.format("wget %s %s", PKGMAN_LUA_URL, PKGMAN_INSTALL_DIR))
exec("echo pkgman installed.")