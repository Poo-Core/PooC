Array = Class()
--[[
    Array: JavaScript implementation of Arrays.
]]

function Array:__init()
    self.data = {}
    self.length = 0
end

function Array:__len()
    return #self.data
end

-- Length method
function Array:length()
    return #self.data
end

-- Push method
function Array:push(value)
    table.insert(self.data, value)
end

-- Pop method
function Array:pop()
    return table.remove(self.data)
end

-- Shift method
function Array:shift()
    return table.remove(self.data, 1)
end

-- Unshift method
function Array:unshift(value)
    table.insert(self.data, 1, value)
end

-- Includes method
function Array:includes(value)
    for _, v in ipairs(self.data) do
        if v == value then
            return true
        end
    end
    return false
end

-- Join method
function Array:join(separator)
    return table.concat(self.data, separator)
end

-- Fill method
function Array:fill(newValue, startIndex, endIndex)
    if (startIndex and startIndex < 1) or (endIndex and endIndex > #self.data) then return false end
    if not startIndex then startIndex = 1 end
    if not endIndex then endIndex = #self.data end
    for i = startIndex, endIndex, 1 do
        self.data[i] = newValue
    end
end

-- Map method
function Array:map(mapCB)
    local resultArray = Array()
    for i, v in ipairs(self.data) do
        resultArray:push(mapCB(v, i, self.data))
    end
    return resultArray
end

-- Filter method
function Array:filter(predicateCB)
    local resultArray = Array()
    for i, v in ipairs(self.data) do
        if predicateCB(v, i, self.data) then
            resultArray:push(v)
        end
    end
    return resultArray
end

-- Find method
function Array:find(predicateCB)
    for i, v in ipairs(self.data) do
        if predicateCB(v, i, self.data) then
            return v
        end
    end
    return false
end

-- Every method
function Array:every(predicateCB)
    for i, v in ipairs(self.data) do
        if not predicateCB(v, i, self.data) then
            return false
        end
    end
    return true
end

-- Some method
function Array:some(predicateCB)
    for i, v in ipairs(self.data) do
        if predicateCB(v, i, self.data) then
            return true
        end
    end
    return false
end

-- FindIndex method
function Array:findIndex(predicateCB)
    for i, v in ipairs(self.data) do
        if predicateCB(v, i, self.data) then
            return i
        end
    end
    return false
end

-- FindLast method
function Array:findLast(predicateCB)
    for i, v in ipairs(self.data) do
        if predicateCB(v, i, self.data) then
            return v
        end
    end
    return false
end

-- FindLastIndex method
function Array:findLastIndex(predicateCB)
    for i = #self.data, 1, -1 do
        if predicateCB(v, i, self.data) then
            return i
        end
    end
    return false
end

-- Reduce method
function Array:reduce(accumulator, initialValue)
    local result = initialValue
    for _, value in ipairs(self.data) do
        result = accumulator(result, value)
    end
    return result
end
