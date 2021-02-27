local utils = {}

function utils.stringSplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function utils.linearSearch(table, condition)
    local index = nil
    for k,v in next, table do
        if condition(k) then
            index = k
            break
        end
    end
    return index
end

return utils