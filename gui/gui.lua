local gui = {}
local event = require("event")
local utils = require("utils")
local graphics = require("graphics")
local GUIObject = require("GUIObject")

local function onTouch(eventName, screenAddress, x, y, button, player)
    for k,v in next,args do io.write(tostring(v).."\n") end
    io.flush()
    for i=#GUIObject.objects,1,-1 do
        if GUIObject.objects[i].pointCast(x,y) then
            if(GUIObject.objects[i].onClick) then pcall(GUIObject.objects[i].onClick, x, y, button) end
            break
        end
    end
end

function gui.init()
    GUIObject.objects = {}
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