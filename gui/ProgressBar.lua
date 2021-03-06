local GUIObject = require("GUIObject")
local graphics = require("graphics")
local ProgressBar = {}

local function _draw(self)
    graphics.fillRectangle(self.x, self.y, self.width*(self.progress/100), self.height, self.fillColour)
    graphics.fillRectangle(self.x, self.y, 1, self.height, 0xFFFFFF)
    graphics.fillRectangle(self.x+self.width-1,self.y,1,self.height, 0xFFFFFF)
end

function ProgressBar.new(x,y,width,height,fillColour,progress,layer,enabled)
    local instance = GUIObject.new(x,y,layer,enabled)
    instance.draw = _draw
    instance.width = width
    instance.height = height
    instance.progress = progress or 100
    instance.fillColour = fillColour or 0xFFFFFF
    return instance
end

return ProgressBar