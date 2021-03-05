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

function utils.sign(number)
    assert(type(number)=="number",string.format("Invalid argument #1. Number expected got %s", type(number)))
    return math.floor(math.abs(number)/number)
end

function utils.bubbleSort(list, condition):
    for i=1,#list-1,1 do
        for j=1,#list-1-i do
            if not condition(list[j],list[j+1]) then
                local temp = list[j]
                list[j] = list[j+1]
                list[j+1] = temp
            end
        end
    end
end

return utils