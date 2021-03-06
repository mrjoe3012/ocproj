local GUIObject = require("GUIObject")
local graphics = require("graphics")
local Panel = {}

local function _draw(self)
    graphics.fillRectangle(self.x, self.y, self.width, self.height, self.colour)
end

local function _pointCast(self, x, y)
    return (x>=self.x and x<=self.x+self.width) and (y>=self.y and y<=self.y+self.height)
end

function Panel.new(x,y,width,height,colour,layer,enabled)
    local instance = GUIObject.new(x,y,layer,enabled)
    instance.colour = colour or 0XFFFFFF
    instance.draw = _draw
    instance.pointCast = _pointCast
    instance.width, instance.height = width, height
    return instance
end

return Panel