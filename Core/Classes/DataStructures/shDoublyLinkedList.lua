-- Define the DoublyLinkedList class
DoublyLinkedList = Class()
--[[
    DoublyLinkedList
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new(value)
    local node = {}
    node.value = value
    node.prev = nil
    node.next = nil
    return setmetatable(node, Node)
end

-- Constructor
function DoublyLinkedList:__init()
    self.head = nil
    self.tail = nil
end

-- Check if the list is empty
function DoublyLinkedList:isEmpty()
    return self.head == nil
end

-- Insert at the beginning of the list
function DoublyLinkedList:insertAtBeginning(value)
    local newNode = Node.new(value)

    if self:isEmpty() then
        self.head = newNode
        self.tail = newNode
    else
        newNode.next = self.head
        self.head.prev = newNode
        self.head = newNode
    end
end

-- Insert at the end of the list
function DoublyLinkedList:insertAtEnd(value)
    local newNode = Node.new(value)

    if self:isEmpty() then
        self.head = newNode
        self.tail = newNode
    else
        newNode.prev = self.tail
        self.tail.next = newNode
        self.tail = newNode
    end
end

-- Remove a value from the list
function DoublyLinkedList:remove(value)
    if self:isEmpty() then
        return
    end

    -- Find the node to remove
    local current = self.head
    while current ~= nil do
        Wait(0)
        if current.value == value then
            -- Special case: removing the head
            if current == self.head then
                self.head = current.next
                if self.head ~= nil then
                    self.head.prev = nil
                else
                    self.tail = nil
                end
            else
                current.prev.next = current.next
                if current == self.tail then
                    self.tail = current.prev
                else
                    current.next.prev = current.prev
                end
            end
            return
        end
        current = current.next
    end
end

-- Traverse the list and apply a function to each node's value
function DoublyLinkedList:forEach(callback)
    local current = self.head
    while current ~= nil do
        Wait(0)
        callback(current.value)
        current = current.next
    end
end
