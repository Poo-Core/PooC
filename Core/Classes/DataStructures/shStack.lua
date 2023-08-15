-- Define the Stack class
Stack = Class()
--[[
    Stack
]]

-- Constructor
function Stack:__init()
    self._data = {}
end

-- Check if the stack is empty
function Stack:isEmpty()
    return #self._data == 0
end

-- Get the size of the stack
function Stack:size()
    return #self._data
end

-- Push an element onto the stack
function Stack:push(value)
    table.insert(self._data, value)
end

-- Pop the top element from the stack
function Stack:pop()
    return table.remove(self._data)
end

-- Peek the top element of the stack without removing it
function Stack:peek()
    return self._data[#self._data]
end