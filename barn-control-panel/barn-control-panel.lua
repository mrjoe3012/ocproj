local graphics = require("graphics")
local event = require("event")
local gui = require("gui")
local json = require("json")

local GUIObject, Panel, Label, ProgressBar = require("GUIObject"), require("Panel"), require("Label"), require("ProgressBar")

gui.init()

local FPS = 20

local botPanels = {}

local layout_botOverview = {
    columns = Label.new(4, 3, 0, 0xFFFFFF, "Name          Status               Progress              Charge", 1, true),
    Elmer_nameLabel = Label.new(4, 5, 0, 0xFFFFFF, "Elmer", 1, true),
    Elmer_statusLabel = Label.new(18,5,0,0xFFFFFF,"GOING TO CHARGER", 1, true),
    Elmer_progressBar = ProgressBar.new(39,5,18,1,0x00FF00, 0, 1, true),
    Elmer_chargeBar = ProgressBar.new(61, 5, 18, 1, 0x00FF00, 100, 1, true)
}

local errorMsg = nil

while not errorMsg do
    layout_botOverview.Elmer_progressBar.progress = layout_botOverview.Elmer_progressBar.progress + 1
    if layout_botOverview.Elmer_progressBar.progress >= 100 then layout_botOverview.Elmer_progressBar.progress = 0 end
    layout_botOverview.Elmer_chargeBar.progress = layout_botOverview.Elmer_progressBar.progress
    res, err = pcall(gui.render)
    if not res then errorMsg = err end
    os.sleep(1/FPS)
end

graphics.clear()
print(errorMsg)