local graphics = require("graphics")
local event = require("event")
local gui = require("gui")
local json = require("json")

local GUIObject, Panel, Label = require("GUIObject"), require("Panel"), require("Label")

gui.init()

local FPS = 20

local botPanels = {}

local layout_botOverview = {
    Elmer_nameLabel = Label.new(4, 3, 0, 0xFFFFFF, "Elmer", 1, true),
}

local errorMsg = nil

while not errorMsg do
    res, err = pcall(gui.render)
    if not res then errorMsg = err end
    os.sleep(1/FPS)
end

graphics.clear()
print(errorMsg)