local robot = require("robot")
local component = require("component")
local computer_api = require("computer")
local inventoryController = component.inventory_controller
local utils = require("utils")
local json = require("json")
local modem = component.modem
local thread = require("thread")

local position = {x=242,y=72,z=-223}

local state = {}

function position.__tostring(self)
    return string.format("{%d,%d,%d}", self.x, self.y, self.z)
end
setmetatable(position, position)
-- can only be facing one direction at a time
local facing = {x=1,z=0}

function facing.__tostring(self)
    return string.format("{%d,%d}", self.x, self.z)
end
setmetatable(facing, facing)
local debugFile = nil
local DEBUG_MODE = true

local function openDebugFile()
    if debugFile then return end

    debugFile = io.open("/home/debug.txt", "r")
    if debugFile ~= nil then
        debugFile:close()
        debugFile = io.open("/home/debug.txt", "a")
    else
        debugFile = io.open("/home/debug.txt", "w")
    end
end

if DEBUG_MODE then openDebugFile() end

local function writeDebug(message)
    if not DEBUG_MODE then return end
    debugFile:write(message)
    debugFile:write("\n")
    debugFile:flush()
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
local SERVER_ADDRESS, SERVER_PORT
local STATE_UPDATE_TICK = 2

local function readWaypointFile(filename)

    assert(type(filename)=="string", string.format("Invalid argument #1. string expected got %s", type(filename)))

    local file = io.open(filename,"r")
    assert(file, "Unable to read waypoints from '%s'", filename)
    local waypointDataRaw = file:read("*all")
    file:close()

    local waypointStringArray = utils.stringSplit(waypointDataRaw,"\n")
    local waypointArray = {}

    for i,waypointString in ipairs(waypointStringArray) do
        local arr = utils.stringSplit(waypointString, ",")
        local waypoint = {}
        waypoint.x, waypoint.y, waypoint.z = tonumber(arr[1]), tonumber(arr[2]), tonumber(arr[3])
        table.insert(waypointArray, waypoint)
    end

    return waypointArray

end

local FARM_TO_CHARGER = readWaypointFile("/home/farmtocharger.wp")

local function lookAt(f)

    local function getAngle(x,z)
        if x == 1 then  return 0 end
        if z == 1 then return 90 end
        if x == -1 then  return 180 end
        if z == -1 then return 270 end
    end 

    local facingDelta = getAngle(f.x,f.z)-getAngle(facing.x,facing.z)
    -- this doesn't make sense. it's okay because we only use facingDelta for its sign...
    if facingDelta > 180 then facingDelta = -facingDelta end
    if facingDelta < -180 then facingDelta = -facingDelta
    local turnFunc = (facingDelta > 0) and robot.turnRight or robot.turnLeft

    assert(type(f) == "table" and f.x and f.z, string.format("Invalid argument #1. Expected facing table got %s", type(f)))
    writeDebug(string.format("Turning to face x: %d z: %d", f.x, f.z))
    while facing.x ~= f.x or facing.z ~= f.z do turnFunc() end
end

local function moveTo(p)

    assert(type(p) == "table" and p.x and p.y and p.z, string.format("Invalid argument #1. Expected position table got %s", type(p)))

    local deltaX, deltaZ, deltaY = p.x-position.x, p.z-position.z, p.y-position.y

    writeDebug(string.format("Moving to {%d,%d,%d}. deltaX: %d deltaZ: %d", p.x, p.y, p.z, deltaX, deltaZ))

    if deltaX ~= 0 then
        lookAt({z=0,x=math.floor(deltaX/math.abs(deltaX))})

        for i=1,math.abs(deltaX),1 do
            repeat until robot.forward()
        end

    end

    if deltaZ ~= 0 then

        lookAt({z=math.floor(deltaZ/math.abs(deltaZ)),x=0})

        for i=1,math.abs(deltaZ),1 do
            repeat until robot.forward()
        end

    end

    if deltaY ~= 0 then
        if deltaY > 0 then
            for i=1,math.abs(deltaY),1 do
                repeat until robot.up()
            end
        else
            for i=1,math.abs(deltaY),1 do
                repeat until robot.down()
            end
        end
    end

end

local function doWaypoints(waypoints, startIndex, stopIndex, increment)

    local startIndex = startIndex or 1
    local stopIndex = stopIndex or #waypoints
    local increment = increment or 1

    --add a good debug log

    for i=startIndex,stopIndex,increment do
        moveTo(waypoints[i])
    end

end

local inventorySize = robot.inventorySize()

local function equipItemWithName(name)

    local found, slot = false, nil

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

    writeDebug(string.format("Beginning to harvest and plant a farm of depth: %d and width: %d.", FARM_DEPTH, FARM_WIDTH))

    state.status = "FARMING"
    state.progress = 0.0

    local startPos = {x=position.x, z=position.z}
    local startFacing = {x=facing.x, z=facing.z}

    writeDebug(string.format("Moving to start position."))

    repeat until robot.turnRight()
    repeat until robot.forward()
    repeat until robot.turnLeft()
    repeat until robot.forward()

    writeDebug(string.format("Commencing harvest-plant loop."))
    local counter = 1
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
            counter = counter + 1
            state.progress = (100/(FARM_WIDTH*FARM_DEPTH))*counter
        end
        writeDebug(string.format("Finishing column %d. Respositioning.", i))
        if i ~= FARM_WIDTH then
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

    writeDebug(string.format("Returning to initial rotation. Facing: x: %d z: %d", startFacing.x, startFacing.z))

    while facing.x ~= startFacing.x or facing.z ~= startFacing.z do robot.turnRight() end
    
    writeDebug("Finished planting and harvesting.")

    state.status = nil
    state.progress = nil

end

local function goToChargerFromFarm()

    state.status = "GOING TO CHARGER"

    writeDebug("Going to charger from farm.")

    doWaypoints(FARM_TO_CHARGER)

    writeDebug("Arrived at charger.")

    state.status = nil

end

local function chargeUpAndDeposit()
    writeDebug("Waiting for charge. Energy: %d/%d", computer_api.energy(), computer_api.maxEnergy())

    state.status = "CHARGING AND DEPOSITING"

    local function inventoryEmpty()
        for i=1,inventorySize,1 do
            if robot.count(i) > 0 then return false end
        end
        return true
    end

    while computer_api.energy() < (19/20)*(computer_api.maxEnergy()) or not inventoryEmpty() do os.sleep(1) end
    os.sleep(1)

    writeDebug("Finished charging. Energy: %d/%d", computer_api.energy(), computer_api.maxEnergy())
end

local function goToFarmFromCharger()

    state.status = "GOING TO FARM"

    writeDebug("Going to farm from charger.")

    doWaypoints(FARM_TO_CHARGER, #FARM_TO_CHARGER, 1, -1)

    writeDebug("Arrived at farm.")

end

local function waitForCrops()

    state.status = "WAITING FOR CROPS"
    state.progress = 0

    error("not implemented")

end

local statusThread = thread.create(function()
    while SERVER_ADDRESS and SERVER_PORT do
        os.sleep(STATE_UPDATE_TICK)
        local jsonStatus = json.encode(state)
        modem.send(SERVER_ADDRESS,SERVER_PORT,json.encode(state))
    end
end)

while true do
    --harvestAndPlant()
    --local startFacing = {x=facing.x, z=facing.z}
    goToChargerFromFarm()
    chargeUpAndDeposit()
    goToFarmFromCharger()
    lookAt(startFacing)
    --waitForCrops()
end