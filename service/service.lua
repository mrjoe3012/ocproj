local service = {}

local function initServiceDaemon()

    assert(not service.daemon, "Cannot reinitialize service daemon.")

    service.daemon = {}

end

local function getServiceDaemon()

    if not service.daemon then initServiceDaemon() end

    return service.daemon

end

print(getServiceDaemon())

return service