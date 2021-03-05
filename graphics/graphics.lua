local graphics = {}
local gpu = require("component").gpu

function graphics.fillRectangle(startX, startY, width, height, colourHex)
    gpu.setBackgroundColour(colourHex)
    gpu.fill(startX,startY,width,height," ")
end

function graphics.clear()
    local resX, resY = gpu.getResolution()
    graphics.fillRectangle(1,1,resX,resY,0)
end

function graphics.write(startX,startY,foregroundColourHex, backgroundColourHex, text)
    gpu.setForegroundColour(foregroundColourHex)
    gpu.setBackgroundColour(backgroundColourHex)
    gpu.set(startX, startY, text)
end

return graphics