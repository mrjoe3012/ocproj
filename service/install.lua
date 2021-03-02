local exec = os.execute

local SERVICE_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/service/service.lua"
local SERVICE_INSTALL_DIR = "/bin/service.lua"

exec(string.format("wget -f %s %s", SERVICE_LUA_URL, SERVICE_INSTALL_DIR))
print("service has installed.")