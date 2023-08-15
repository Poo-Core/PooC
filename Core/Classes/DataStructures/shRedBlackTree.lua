-- Define the RedBlackTree class
RedBlackTree = Class()
--[[
    RedBlackTree
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new(key, value)
    local node = {}
    node.key = key
    node.value = value
    node.left = nil
    node.right = nil
    node.color = nil
    return setmetatable(node, Node)
end

-- Color constants
local RED = "red"
local BLACK = "black"

-- Constructor
function RedBlackTree:__init()
    self.root = nil
end

-- Insert a key-value pair into the Red-Black Tree
function RedBlackTree:insert(key, value)
    local newNode = Node.new(key, value)
    if not self.root then
        newNode.color = BLACK
        self.root = newNode
    else
        local currentNode = self.root
        local parentNode = nil
        while currentNode do
            Wait(0)
            parentNode = currentNode
            if newNode.key < currentNode.key then
                currentNode = currentNode.left
            else
                currentNode = currentNode.right
            end
        end
        newNode.parent = parentNode
        if newNode.key < parentNode.key then
            parentNode.left = newNode
        else
            parentNode.right = newNode
        end
        self:_insertFixup(newNode)
    end
end

-- Fix the Red-Black Tree after an insertion
function RedBlackTree:_insertFixup(node)
    while node.parent and node.parent.color == RED do
        Wait(0)
        if node.parent == node.parent.parent.left then
            local uncle = node.parent.parent.right
            if uncle and uncle.color == RED then
                node.parent.color = BLACK
                uncle.color = BLACK
                node.parent.parent.color = RED
                node = node.parent.parent
            else
                if node == node.parent.right then
                    node = node.parent
                    self:_leftRotate(node)
                end
                node.parent.color = BLACK
                node.parent.parent.color = RED
                self:_rightRotate(node.parent.parent)
            end
        else
            local uncle = node.parent.parent.left
            if uncle and uncle.color == RED then
                node.parent.color = BLACK
                uncle.color = BLACK
                node.parent.parent.color = RED
                node = node.parent.parent
            else
                if node == node.parent.left then
                    node = node.parent
                    self:_rightRotate(node)
                end
                node.parent.color = BLACK
                node.parent.parent.color = RED
                self:_leftRotate(node.parent.parent)
            end
        end
    end
    self.root.color = BLACK
end

-- Perform a left rotation on the Red-Black Tree
function RedBlackTree:_leftRotate(node)
    local rightChild = node.right
    node.right = rightChild.left
    if rightChild.left then
        rightChild.left.parent = node
    end
    rightChild.parent = node.parent
    if not node.parent then
        self.root = rightChild
    elseif node == node.parent.left then
        node.parent.left = rightChild
    else
        node.parent.right = rightChild
    end
    rightChild.left = node
    node.parent = rightChild
end

-- Perform a right rotation on the Red-Black Tree
function RedBlackTree:_rightRotate(node)
    local leftChild = node.left
    node.left = leftChild.right
    if leftChild.right then
        leftChild.right.parent = node
    end
    leftChild.parent = node.parent
    if not node.parent then
        self.root = leftChild
    elseif node == node.parent.left then
        node.parent.left = leftChild
    else
        node.parent.right = leftChild
    end
    leftChild.right = node
    node.parent = leftChild
end

-- Search for a key in the Red-Black Tree
function RedBlackTree:search(key)
    local currentNode = self.root
    while currentNode do
        Wait(0)
        if key == currentNode.key then
            return currentNode.value
        elseif key < currentNode.key then
            currentNode = currentNode.left
        else
            currentNode = currentNode.right
        end
    end
    return nil
end

--[[
-- Example usage
local myTree = RedBlackTree()

myTree:insert(5, "Value 5")
myTree:insert(3, "Value 3")
myTree:insert(7, "Value 7")
myTree:insert(2, "Value 2")
myTree:insert(4, "Value 4")
myTree:insert(6, "Value 6")
myTree:insert(8, "Value 8")

print(myTree:search(4))  --> "Value 4"
print(myTree:search(10)) --> nil
]]