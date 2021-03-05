local exec = os.execute

local PH_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/planter-harvester/planter-harvester.lua"
local PH_INSTALL_DIR = "/bin/planter-harvester.lua"

local CONFIG_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/planter-harvester/planter-harvester.cfg"
local CONFIG_INSTALL_DIR = "/etc/planter-harvester.cfg"

exec(string.format("wget -f %s %s", PH_LUA_URL, PH_INSTALL_DIR))
exec(string.format("wget -f %s %s", CONFIG_LUA_URL, CONFIG_INSTALL_DIR))
exec("echo planter-harvester installed.")