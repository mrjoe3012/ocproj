local exec = os.execute
local internet = require("internet")

local SERVEREXEC_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/serverexec-server/serverexec-server.lua"
local SERVEREXEC_INSTALL_DIR = "/etc/rc.d/serverexec-server.lua"

exec("rc")
exec(string.format("wget -f %s %s", SERVEREXEC_LUA_URL, SERVEREXEC_INSTALL_DIR))
exec("rc serverexec-server enable")
print("serverexec-server has installed.")