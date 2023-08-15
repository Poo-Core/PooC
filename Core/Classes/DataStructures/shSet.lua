-- Define the Set class
Set = Class()
--[[
    Set
]]

-- Constructor
function Set:__init()
    self._data = {}
end

-- Add an element to the set
function Set:add(element)
    self._data[element] = true
end

-- Remove an element from the set
function Set:remove(element)
    self._data[element] = nil
end

-- Check if the set contains an element
function Set:contains(element)
    return self._data[element] == true
end

-- Get the size of the set
function Set:size()
    local count = 0
    for _ in pairs(self._data) do
        count = count + 1
    end
    return count
end

-- Get all elements of the set as a table
function Set:toTable()
    local elements = {}
    for element in pairs(self._data) do
        table.insert(elements, element)
    end
    return elements
end
