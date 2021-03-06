local graphics = require("graphics")
local event = require("event")
local gui = require("gui")
local json = require("json")

local GUIObject, Panel, Label, ProgressBar = require("GUIObject"), require("Panel"), require("Label"), require("ProgressBar")

gui.init()

local FPS = 20

local botPanels = {}

local layout_botOverview = {
    columns = Label.new(4, 3, 0, 0xFFFFFF, "Name          Status          Progress          Charge", 1, true),
    Elmer_nameLabel = Label.new(4, 5, 0, 0xFFFFFF, "Elmer", 1, true),
    Elmer_statusLabel = Label.new(18,5,0,0xFFFFFF,"HARVESTING", 1, true),
    Elmer_progressBar = ProgressBar.new(34,5,23,1,0x00FF00, 0, 1, true),
    Elmer_chargeBar = ProgressBar.new(57, 5, 23, 1, 0x00FF00, 100, 1, true)
}

local errorMsg = nil

while not errorMsg do
    layout_botOverview.Elmer_progressBar.progress = layout_botOverview.Elmer_progressBar.progress + 1
    if layout_botOverview.Elmer_progressBar.progress >= 100 then layout_botOverview.Elmer_progressBar.progress = 0 end
    res, err = pcall(gui.render)
    if not res then errorMsg = err end
    os.sleep(1/FPS)
end

graphics.clear()
print(errorMsg)