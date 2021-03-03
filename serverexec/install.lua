local exec = os.execute

local SERVEREXEC_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/serverexec/serverexec.lua"
local SERVEREXEC_INSTALL_DIR = "/lib/serverexec.lua"

exec(string.format("wget -f %s %s", SERVEREXEC_LUA_URL, SERVEREXEC_INSTALL_DIR))
exec("echo serverexec installed.")