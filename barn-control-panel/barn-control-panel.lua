local graphics = require("graphics")
local event = require("event")
local gui = require("gui")
local json = require("json")

local GUIObject, Panel, Label, ProgressBar = require("GUIObject"), require("Panel"), require("Label"), require("ProgressBar")

gui.init()

local FPS = 20

local botPanels = {}

local layout_botOverview = {
    Elmer_nameLabel = Label.new(4, 3, 0, 0xFFFFFF, "Elmer", 1, true),
    Elmer_progressBar = ProgressBar.new(10,5,0x00FF00, 0, 1, true)
}

local errorMsg = nil

while not errorMsg do
    res, err = pcall(gui.render)
    if not res then errorMsg = err end
    os.sleep(1/FPS)
end

graphics.clear()
print(errorMsg)