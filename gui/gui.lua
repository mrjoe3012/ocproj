local gui = {}
local event = require("event")
local utils = require("utils")
local graphics = require("graphics")
local GUIObject = require("GUIObject")

local dragOwner = nil

local function onRelease(eventName, screenAddress, x, y, button, player)
    dragOwner = nil
    for i=#GUIObject.objects,1,-1 do
        if GUIObject.objects[i]:pointCast(x,y) then
            if(GUIObject.objects[i].onMouseButtonUp) then pcall(GUIObject.objects[i].onMouseButtonUp, GUIObject.objects[i], x, y, button) end
            break
        end
    end
end

local function onTouch(eventName, screenAddress, x, y, button, player)
    for i=#GUIObject.objects,1,-1 do
        if GUIObject.objects[i]:pointCast(x,y) then
            if(GUIObject.objects[i].onMouseButtonDown) then pcall(GUIObject.objects[i].onMouseButtonDown, GUIObject.objects[i], x, y, button) end
            break
        end
    end
end

local function onDrag(eventName, screenAddress, x, y, button, player)
    if dragOwner == nil then
        for i=#GUIObject.objects,1,-1 do
            if GUIObject.objects[i]:pointCast(x,y) then
                dragOwner = GUIObject.objects[i]
                if(GUIObject.objects[i].onMouseDrag) then pcall(GUIObject.objects[i].onMouseDrag, GUIObject.objects[i], x, y, button) end
                break
            end
        end
    else
        if(GUIObject.objects[i].onMouseDrag) then pcall(GUIObject.objects[i].onMouseDrag, GUIObject.objects[i], x, y, button) end
    end 
end

function gui.init()
    GUIObject.objects = {}
    event.listen("drop", onRelease)
    event.listen("touch", onTouch)
    event.listen("drag", onDrag)
end

function gui.render()
    -- highest layer first, so that lower layers overwrite the previous layer.
    utils.bubbleSort(GUIObject.objects, function(a,b) return a.layer >= b.layer end)

    graphics.clear()

    for i,object in ipairs(GUIObject.objects) do
        if object.enabled then object:draw() end
    end
end

return gui