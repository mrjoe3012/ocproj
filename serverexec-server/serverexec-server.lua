local component = require("component")
local modem = component.modem
local event = require("event")
local json = require("json")
local internet = require("internet")
local serialization = require("serialization")

local serverexec = {stop=false}

local DEFAULT_PORT = 1000
local argv = {...}

local function listen()
    while serverexec.stop == false do
        localAddress, remoteAddress, port, distance, execString, responsePort = event.pull("modem_message")
        local response = serialization.serialize(table.pack(pcall(load(execString))))
        modem.send(remoteAddress, responsePort, response)
    end
end

function serverexec.start()
    serverexec.port = tonumber(argv[0]) or DEFAULT_PORT
    modem.open(serverexec.port)
    serverexec.stop = false
    listen()
end

function serverexec.stop()
    serverexec.stop = true
    modem.close(serverexec.port)
end

start = serverexec.start
stop = serverexec.stop

return serverexec