local service = {}

local function service.initServiceDaemon()

    assert(not service.daemon, "Cannot reinitialize service daemon.")

    service.daemon = {}

end

local function service.getServiceDaemon()

    if not service.daemon then service.initServiceDaemon() end

    return service.daemon

end

print(service.getServiceDaemon())

return service