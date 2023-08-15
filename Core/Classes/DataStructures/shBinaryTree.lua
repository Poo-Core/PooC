-- Define the BinaryTree class
BinaryTree = Class()
--[[
    BinaryTree
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
function BinaryTree:__init()
    self.root = nil
end

-- Insert a value into the tree
function BinaryTree:insert(value)
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
function BinaryTree:contains(value)
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
function BinaryTree:traverseInOrder(callback)
    local function traverse(node)
        if node ~= nil then
            traverse(node.left)
            callback(node.value)
            traverse(node.right)
        end
    end

    traverse(self.root)
end
