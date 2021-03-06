local exec = os.execute

local BARNCP_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/barn-control-panel/barn-control-panel.lua"
local BARNCP_INSTALL_DIR = "/bin/barn-control-panel.lua"

exec(string.format("wget -f %s %s", BARNCP_LUA_URL, BARNCP_INSTALL_DIR))
exec("echo barn-control-panel installed.")