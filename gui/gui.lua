local gui = {}
local event = require("event")
local utils = require("utils")
local graphics = require("graphics")
local GUIObject = require("GUIObject")

local function onTouch(screenAddress, x, y, button, player)
    for i=#GUIObject.objects,1,-1 do
        if GUIObject.objects[i].pointCast(x,y) then
            if(GUIObject.objects[i].onClick) then pcall(GUIObject.objects[i].onClick, x, y, button) end
            break
        end
    end
end

function gui.init()
    event.listen("drop", onTouch)
end

function gui.render()
    -- highest layer first, so that lower layers overwrite the previous layer.
    utils.bubbleSort(GUIObject.objects, function(a,b) return a.layer >= b.layer end)

    graphics.clear()

    for i,object in ipairs(GUIObject.objects) do
        object:draw()
    end
end

return gui