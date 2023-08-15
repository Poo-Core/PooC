-- Define the Queue class
Queue = Class()
--[[
    Queue
]]

-- Constructor
function Queue:__init()
    self._data = {}
end

-- Check if the queue is empty
function Queue:isEmpty()
    return #self._data == 0
end

-- Get the size of the queue
function Queue:size()
    return #self._data
end

-- Enqueue an element into the queue
function Queue:enqueue(value)
    table.insert(self._data, value)
end

-- Dequeue the front element from the queue
function Queue:dequeue()
    return table.remove(self._data, 1)
end

-- Peek the front element of the queue without removing it
function Queue:peek()
    return self._data[1]
end
