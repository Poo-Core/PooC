LinkedList = Class()
--[[
    LinkedList
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new(value)
    local node = {}
    node.value = value
    node.next = nil
    return setmetatable(node, Node)
end

-- Constructor
function LinkedList:__init()
    self.head = nil
    self.tail = nil
end

-- Check if the list is empty
function LinkedList:isEmpty()
    return self.head == nil
end

-- Insert at the end of the list
function LinkedList:insert(value)
    local newNode = Node.new(value)

    if self:isEmpty() then
        self.head = newNode
        self.tail = newNode
    else
        self.tail.next = newNode
        self.tail = newNode
    end
end

-- Remove the first occurrence of a value in the list
function LinkedList:remove(value)
    if self:isEmpty() then
        return
    end

    -- Special case: removing the head
    if self.head.value == value then
        if self.head == self.tail then
            self.tail = nil
        end
        self.head = self.head.next
        return
    end

    -- Find the node to remove
    local current = self.head
    local previous = nil
    while current ~= nil do
        Wait(0)
        if current.value == value then
            previous.next = current.next
            -- Special case: removing the tail
            if current == self.tail then
                self.tail = previous
            end
            return
        end
        previous = current
        current = current.next
    end
end

-- Traverse the list and apply a function to each node's value
function LinkedList:forEach(callback)
    local current = self.head
    while current ~= nil do
        Wait(0)
        callback(current.value)
        current = current.next
    end
end
