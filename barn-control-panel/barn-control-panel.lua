local graphics = require("graphics")
local event = require("event")
local gui = require("gui")
local json = require("json")
local component = require("component")
local modem = component.modem

local GUIObject, Panel, Label, ProgressBar = require("GUIObject"), require("Panel"), require("Label"), require("ProgressBar")

gui.init()

local FPS = 20
local PORT = 1

local layout_botOverview = {
    columns = Label.new(4, 3, 0, 0xFFFFFF, "Name          Status               Progress              Charge", 1, true),
    Elmer_nameLabel = Label.new(4, 5, 0, 0xFFFFFF, "Elmer", 1, true),
    Elmer_statusLabel = Label.new(18,5,0,0xFFFFFF,"GOING TO CHARGER", 1, true),
    Elmer_progressBar = ProgressBar.new(39,5,18,1,0x00FF00, 0, 1, true),
    Elmer_chargeBar = ProgressBar.new(61, 5, 18, 1, 0x00FF00, 0, 1, true),
    Carrot-chan_nameLabel = Label.new(4, 7, 0, 0xFFFFFF, "Carrot-chan", 1, true),
    Carrot-chan_statusLabel = Label.new(18,7,0,0xFFFFFF,"NONE", 1, true),
    Carrot-chan_progressBar = ProgressBar.new(39,7,18,1,0x00FF00, 0, 1, true),
    Carrot-chan_chargeBar = ProgressBar.new(61, 7, 18, 1, 0x00FF00, 0, 1, true),
}

local function onModemMessage(eventName, localAddress, remoteAddress, port, distance, msg)
    local stateTable = json.decode(msg)
    layout_botOverview[stateTable.name.."_statusLabel"].text = stateTable.status or ""
    layout_botOverview[stateTable.name.."_progressBar"].progress = stateTable.progress or 0
    layout_botOverview[stateTable.name.."_chargeBar"].progress = stateTable.charge or 0
end

local errorMsg = nil

modem.open(PORT)
event.listen("modem_message", onModemMessage)

while not errorMsg do
    res, err = pcall(gui.render)
    if not res then errorMsg = err end
    res, err = pcall(os.sleep,1/FPS)
    if not res then break end
end

event.ignore("modem_message", onModemMessage)
modem.close(PORT)

graphics.clear()
print(errorMsg)