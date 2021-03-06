local GUIObject = require("GUIObject")
local utils = require("utils")
local graphics = require("graphics")
local Label = {}

local function _draw(self)
    local lines = utils.stringsplit(self.text, "\n")
    for i,line in ipairs(lines) do
        graphics.write(self.x, self.y+(i-1), self.textColour, self.backgroundColour, line)
    end
end

function Label.new(x,y,backgroundColour,textColour,text,layer,enabled)
    local instance = GUIObject.new(x,y,layer,enabled)
    instance.draw = _draw
    instance.backgroundColour = backgroundColour or 0
    instance.textColour = textColour or 0xFFFFFF
    instance.text = text or ""
    return instance
end

return Label