local exec = os.execute

local PROGRAM_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/test1/test-program.lua"
local PROGRAM_INSTALL_DIR = "/bin/test-program.lua"

exec(string.format("wget -f %s %s", PROGRAM_LUA_URL, PROGRAM_INSTALL_DIR))