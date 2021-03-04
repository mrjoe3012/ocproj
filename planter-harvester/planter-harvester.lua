local robot = require("robot")
local component = require("component")
local inventoryController = component.inventory_controller

local position = {x=242,y=72,z=-223}

function position.__tostring(self)
    return string.format("{%d,%d,%d}", self.x, self.y, self.z)
end

-- can only be facing one direction at a time
local facing = {x=1,z=0}

function facing.__tostring(self)
    return string.format("{%d,%d}", self.x, self.z)
end

local debugFile = nil
local DEBUG_MODE = true

local function openFileDebugFile()
    if debugFile then return end

    debugFile = io.open("/home/debug.txt", "r")
    if debugFile ~= nil then
        debugFile:close()
        debugFile = io.open("/home/debug.txt", "a")
    else
        debugFile = io.open("/home/debug.txt", "w")
    end
end

local function writeDebug(message)
    if not debugFile then openDebugFile() end
    if not DEBUG_MODE then return end
    debugFile:write(message)
    debugFile:write("\n")
end

local _forward = robot.forward
robot.forward = function()
    if _forward() then
        position.x = position.x + 1*facing.x
        position.z = position.z + 1*facing.z
        writeDebug(string.format("Successfully moved forward. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to move forward. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _back = robot.back
robot.back = function()
    if _back() then
        position.x = position.x + -1*facing.x
        position.z = position.z + -1*facing.z
        writeDebug(string.format("Successfully moved back. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to move back. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _up = robot.up
robot.up = function()
    if _up() then
        position.y = position.y + 1
        writeDebug(string.format("Successfully moved up. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to move up. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _down = robot.down
robot.down = function()
    if _down() then
        position.y = position.y - 1
        writeDebug(string.format("Successfully moved down. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to move down. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _turnRight = robot.turnRight
robot.turnRight = function()
    if _turnRight() then
        if facing.x == 1 then
            facing.x = 0
            facing.z = 1
        elseif facing.x == -1 then
            facing.x = 0
            facing.z = -1
        elseif facing.z == 1 then
            facing.z = 0
            facing.x = -1
        elseif facing.z == -1 then
            facing.z = 0
            facing.x = 1
        end
        writeDebug(string.format("Sucessfully turned right. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to turn right. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _turnLeft = robot.turnLeft
robot.turnLeft = function()
    if _turnLeft() then
        if facing.x == 1 then
            facing.x = 0
            facing.z = -1
        elseif facing.x == -1 then
            facing.x = 0
            facing.z = 1
        elseif facing.z == 1 then
            facing.z = 0
            facing.x = 1
        elseif facing.z == -1 then
            facing.z = 0
            facing.x = -1
        end
        writeDebug(string.format("Sucessfully turned left. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to turn left. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local _turnAround = robot.turnAround
robot.turnAround = function()
    if _turnAround() then
        facing.x = -facing.x
        facing.z = -facing.z
        writeDebug(string.format("Sucessfully turned around. Position: %s Facing: %s", tostring(position), tostring(facing)))
        return true
    end
    writeDebug(string.format("Failed to turn around. Position: %s Facing: %s", tostring(position), tostring(facing)))
    return false
end

local FARM_DEPTH = 16
local FARM_WIDTH = 15
local SEED_NAME = "minecraft:wheat_seeds"

local inventorySize = robot.inventorySize()

local function equipItemWithName(name)

    local found = false, slot = nil

    for i=1,inventorySize,1 do
        local slotData = inventoryController.getStackInInternalSlot(i) or {}
        if slotData.name == name then
            robot.select(i)
            inventoryController.equip()
            found = true
            slot = i
            break
        end
    end

    local debugString = (found==true) and string.format("Successfully selected item '%s' in inventory slot '%d'", name, slot) or string.format("Unable to select item '%s'", name)
    writeDebug(debugString)
end
local equipSeeds = function() equipItemWithName(SEED_NAME) end

local function harvestAndPlant()

    writeDebug(string.format("Beginning to harvest and plant a farm of depth: %d and width: %d.", FARM_DEPTH, DARM_WIDTH))

    local startPos = {x=position.x, z=position.z}
    local startFacing = {x=facing.x, z=facing.z}

    writeDebug(string.format("Moving to start position."))

    repeat until robot.turnRight()
    repeat until robot.forward()
    repeat until robot.turnLeft()
    repeat until robot.forward()

    writeDebug(string.format("Commencing harvest-plant loop."))

    for i=1,FARM_WIDTH,1 do
        writeDebug(string.format("Beginning column %d", i))
        for j=1,FARM_DEPTH,1 do
            _, blockDesc = robot.detectDown()

            if blockDesc == "passable" then
                writeDebug(string.format("Planting and harvesting cell %d,%d", i,j))
                robot.swingDown()
                equipSeeds()
                robot.useDown()
            else
                writeDebug(string.format("Skipping cell %d,%d (block not passable)", i,j))
            end

            if j ~= FARM_DEPTH then
                repeat until robot.forward()
            end

        end
        writeDebug(string.format("Finishing column %d. Respositioning.", i))
        if i%2 == 1 then
            repeat until robot.turnRight()
            repeat until robot.forward()
            repeat until robot.turnRight()
        else
            repeat until robot.turnLeft()
            repeat until robot.forward()
            repeat until robot.turnLeft()
        end
    end

    writeDebug(string.format("Ending harvest-plant loop."))

    local deltaX, deltaZ = startPos.x-position.x, startPos.z-position.z

    writeDebug(string.format("Returning to start position. deltaX: %d deltaZ: %d", deltaX, deltaZ))

    while facing.x ~= math.floor(deltaX/math.abs(deltaX)) do robot.turnRight() end

    for i=1,math.abs(deltaX),1 do
        repeat until robot.forward()
    end

    while facing.z ~= math.floor(deltaZ/math.abs(deltaZ)) do robot.turnRight() end

    for i=1,math.abs(deltaZ),1 do
        repeat until robot.forward()
    end

    writeDebug(string.format("Returning to initial rotation. Facing: x: %d z: %d", startFacing.x, startFacing.z)

    while facing.x ~= startFacing.x and facing.z ~= startFacing.z do robot.turnRight() end
    
    writeDebug("Finished planting and harvesting.")

end

harvestAndPlant()