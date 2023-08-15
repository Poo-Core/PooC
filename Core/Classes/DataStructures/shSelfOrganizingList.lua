-- Define the SelfOrganizingList class
SelfOrganizingList = Class()
--[[
    SelfOrganizingList
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
function SelfOrganizingList:__init()
    self.head = nil
end

-- Insert a value at the beginning of the list
function SelfOrganizingList:insert(value)
    local newNode = Node.new(value)
    newNode.next = self.head
    self.head = newNode
end

-- Search for a value in the list and move it to the front if found
function SelfOrganizingList:search(value)
    local currentNode = self.head
    local previousNode = nil

    while currentNode do
        Wait(0)
        if currentNode.value == value then
            if previousNode then
                previousNode.next = currentNode.next
                currentNode.next = self.head
                self.head = currentNode
            end
            return true -- Value found
        end

        previousNode = currentNode
        currentNode = currentNode.next
    end

    return false -- Value not found
end

-- Get the values in the list as a table
function SelfOrganizingList:getValues()
    local values = {}
    local currentNode = self.head

    while currentNode do
        Wait(0)
        table.insert(values, currentNode.value)
        currentNode = currentNode.next
    end

    return values
end

--[[
-- Example usage
local myList = SelfOrganizingList()

myList:insert(3)
myList:insert(7)
myList:insert(2)
myList:insert(5)
myList:insert(4)

print(myList:search(2))  --> true
print(myList:search(7))  --> true
print(myList:search(10)) --> false

local values = myList:getValues()
for _, value in ipairs(values) do
    print(value)
end
-- Output:
-- 4
-- 5
-- 2
-- 7
-- 3
]]