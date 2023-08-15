-- Define the BinarySearchTree class
BinarySearchTree = Class()
--[[
    BinarySearchTree
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new(value)
    local node = {}
    node.value = value
    node.left = nil
    node.right = nil
    return setmetatable(node, Node)
end

-- Constructor
function BinarySearchTree:__init()
    self.root = nil
end

-- Insert a value into the tree
function BinarySearchTree:insert(value)
    local newNode = Node.new(value)

    if self.root == nil then
        self.root = newNode
    else
        local current = self.root
        while true do
            Wait(0)
            if value < current.value then
                if current.left == nil then
                    current.left = newNode
                    break
                else
                    current = current.left
                end
            elseif value > current.value then
                if current.right == nil then
                    current.right = newNode
                    break
                else
                    current = current.right
                end
            else -- value already exists in the tree
                break
            end
        end
    end
end

-- Check if the tree contains a value
function BinarySearchTree:contains(value)
    local current = self.root
    while current ~= nil do
        Wait(0)
        if value < current.value then
            current = current.left
        elseif value > current.value then
            current = current.right
        else
            return true -- value found
        end
    end
    return false -- value not found
end

-- Traverse the tree in in-order fashion and apply a function to each node's value
function BinarySearchTree:traverseInOrderRecursively(callback)
    local function traverse(node)
        if node ~= nil then
            traverse(node.left)
            callback(node.value)
            traverse(node.right)
        end
    end

    traverse(self.root)
end

-- Iterative in-order traversal
function BinarySearchTree:traverseInOrderIteratively(callback)
    local stack = {}
    local current = self.root

    while current or #stack > 0 do
        Wait(0)
        while current do
            Wait(0)
            table.insert(stack, current)
            current = current.left
        end

        current = table.remove(stack)
        callback(current.value)

        current = current.right
    end
end
