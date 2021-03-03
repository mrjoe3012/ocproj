local modem = require("component").modem
local event = require("event")
local ser = require("serialization")

local serverexec = {port, init=false}

function serverexec.start(port)
    assert(not serverexec.init, "serverexec is already initialized")
    assert(type(port)=="number", string.format("invalid argument #1 expected number got %s", type(port)))
    assert(not modem.isOpen(port), string.format("port '%s' is already open.", tostring(port)))
    serverexec.init = true
    serverexec.port = port
    assert(modem.open(serverexec.port), string.format("unable to open port '%d'", port))
end

function serverexec.stop()
    assert(serverexec.init, "serverexec is not initialized.")
    serverexec.init = false
    assert(modem.close(serverexec.port), string.format("unable to close port '%d'", serverexec.port))
end

function serverexec.exec(address, port, execString)
    assert(serverexec.init, "serverexec is not initialized.")

    assert(type(address)=="string", string.format("invalid argument #1 expected string got %s", type(address)))
    assert(type(port)=="number", string.format("invalid argument #2 expected number got %s", type(port)))
    assert(type(execString)=="string", string.format("invalid argument #3 expected string got %s", type(execString)))

    modem.send(address, port, execString, serverexec.port)

    _, localAddress, remoteAddress, port, distance, payload = event.pull("modem_message")

    local data = ser.unserialize(payload)
    if data[1] == false then
        error(data[2])
        return
    else
        local ret = {}
        for i=2,#data,1 do table.insert(ret, data[i]) end
        return table.unpack(ret)
    end

end

return serverexec