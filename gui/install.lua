local exec = os.execute

local GUI_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/gui/gui.lua?flush_cache=True"
local GUI_INSTALL_DIR = "/lib/gui.lua"

local GUIOBJECT_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/gui/GUIObject.lua?flush_cache=True"
local GUIOBJECT_INSTALL_DIR = "/lib/GUIObject.lua"

local PANEL_LUA_URL = "https://raw.githubusercontent.com/mrjoe3012/ocproj/master/gui/Panel.lua?flush_cache=True"
local PANEL_INSTALL_DIR = "/lib/Panel.lua"

exec(string.format("wget -f %s %s", GUI_LUA_URL, GUI_INSTALL_DIR))
exec(string.format("wget -f %s %s", GUIOBJECT_LUA_URL, GUIOBJECT_INSTALL_DIR))
exec(string.format("wget -f %s %s", PANEL_LUA_URL, PANEL_INSTALL_DIR))
print("gui installed.")