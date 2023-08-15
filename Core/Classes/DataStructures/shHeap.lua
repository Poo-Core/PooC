-- Define the Heap class
Heap = Class()
--[[
    Heap
]]

-- Constructor
function Heap:__init()
    self._data = {}
end

-- Get the parent index of a node
function Heap:_getParentIndex(index)
    return math.floor(index / 2)
end

-- Get the left child index of a node
function Heap:_getLeftChildIndex(index)
    return index * 2
end

-- Get the right child index of a node
function Heap:_getRightChildIndex(index)
    return index * 2 + 1
end

-- Check if the heap is empty
function Heap:isEmpty()
    return #self._data == 0
end

-- Get the size of the heap
function Heap:size()
    return #self._data
end

-- Get the minimum element in the heap
function Heap:getMin()
    if self:isEmpty() then
        return nil
    else
        return self._data[1]
    end
end

-- Insert an element into the heap
function Heap:insert(value)
    table.insert(self._data, value)
    self:_siftUp(#self._data)
end

-- Remove the minimum element from the heap
function Heap:removeMin()
    if self:isEmpty() then
        return nil
    else
        local minValue = self._data[1]
        local lastValue = table.remove(self._data)
        if #self._data > 0 then
            self._data[1] = lastValue
            self:_siftDown(1)
        end
        return minValue
    end
end

-- Sift up an element to its correct position
function Heap:_siftUp(index)
    local parentIndex = self:_getParentIndex(index)
    while index > 1 and self._data[index] < self._data[parentIndex] do
        Wait(0)
        self._data[index], self._data[parentIndex] = self._data[parentIndex], self._data[index]
        index = parentIndex
        parentIndex = self:_getParentIndex(index)
    end
end

-- Sift down an element to its correct position
function Heap:_siftDown(index)
    local leftChildIndex = self:_getLeftChildIndex(index)
    local rightChildIndex = self:_getRightChildIndex(index)
    local smallestIndex = index

    if leftChildIndex <= #self._data and self._data[leftChildIndex] < self._data[smallestIndex] then
        smallestIndex = leftChildIndex
    end

    if rightChildIndex <= #self._data and self._data[rightChildIndex] < self._data[smallestIndex] then
        smallestIndex = rightChildIndex
    end

    if smallestIndex ~= index then
        self._data[index], self._data[smallestIndex] = self._data[smallestIndex], self._data[index]
        self:_siftDown(smallestIndex)
    end
end
