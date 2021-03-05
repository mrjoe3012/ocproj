local gui = {}
local utils = require("utils")
local graphics = require("graphics")
local GUIObject = require("GUIObject")

function gui.render()
    -- highest layer first, so that lower layers overwrite the previous layer.
    utils.bubbleSort(GUIObject.objects, function() a.layer >= b.layer end)

    for i,object in ipairs(GUIObject.objects) do
        object:draw()
    end
end

return gui