local GUIObject = {}

GUIObject.objects = {}

function GUIObject.new(x, y, layer, enabled)
    local instance = {}
    setmetatable(instance, GUIObject)

    -- draws the object on the screen
    instance.draw = function() error("A draw function must be implemented.") end
    -- returns true if the point lies within the object
    -- by default returns false so that the object cannot be clicked on.
    instance.pointCast = function(x,y) return false end
    instance.layer = layer or 0
    instance.x, instance.y = x or 0, y or 0
    instance.enabled = enabled or true
    instance.onClick = {}

    table.insert(GUIObject.objects, instance)

    return instance
end

return GUIObject