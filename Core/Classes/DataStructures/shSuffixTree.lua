-- Define the SuffixTree class
SuffixTree = Class()
--[[
    SuffixTree
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new()
    local node = {}
    node.edges = {}
    return setmetatable(node, Node)
end

-- Constructor
function SuffixTree:__init(text)
    self._root = Node.new()
    self._text = text
    self._textLength = #text
    self:_buildTree()
end

-- Build the suffix tree from the given text
function SuffixTree:_buildTree()
    for i = 1, self._textLength do
        local suffix = self._text:sub(i)
        self:_addSuffix(suffix, i)
    end
end

-- Add a suffix to the suffix tree
function SuffixTree:_addSuffix(suffix, startIndex)
    local currentNode = self._root
    local suffixLength = #suffix
    local i = 1

    while i <= suffixLength do
        Wait(0)
        local currentChar = suffix:sub(i, i)
        local edge = currentNode.edges[currentChar]

        if not edge then
            local newNode = Node.new()
            currentNode.edges[currentChar] = { newNode, startIndex + i - 1 }
            return
        end

        local edgeString = self._text:sub(edge[2])
        local j = 1
        local k = i

        while j <= #edgeString do
            Wait(0)
            if suffix:sub(k, k) ~= edgeString:sub(j, j) then
                local splitNode = Node.new()
                local existingNode = edge[1]

                local existingEdgeString = self._text:sub(edge[2])
                local remainingEdgeString = existingEdgeString:sub(j)

                existingNode.edges[existingEdgeString:sub(j, j)] = { existingNode, edge[2] + j - 1 }
                existingNode.edges[remainingEdgeString:sub(1, 1)] = { splitNode, startIndex + i - 1 }

                edge[1] = splitNode
                edge[2] = edge[2] + j - 1

                splitNode.edges[remainingEdgeString:sub(1, 1)] = { existingNode, edge[2] }

                local newSuffix = suffix:sub(k)
                self:_addSuffix(newSuffix, startIndex + i + k - 1)
                return
            end

            j = j + 1
            k = k + 1

            if k > suffixLength then
                break
            end
        end

        currentNode = edge[1]
        i = k
    end
end

-- Find all occurrences of a pattern in the suffix tree
function SuffixTree:findOccurrences(pattern)
    local currentNode = self._root
    local patternLength = #pattern
    local i = 1

    while i <= patternLength do
        Wait(0)
        local currentChar = pattern:sub(i, i)
        local edge = currentNode.edges[currentChar]

        if not edge then
            return {} -- Pattern not found
        end

        local edgeString = self._text:sub(edge[2])
        local j = 1
        local k = i

        while j <= #edgeString do
            Wait(0)
            if pattern:sub(k, k) ~= edgeString:sub(j, j) then
                return {} -- Pattern not found
            end

            j = j + 1
            k = k + 1

            if k > patternLength then
                break
            end
        end

        if k > patternLength then
            return self:_getLeafNodes(edge[1])
        end

        currentNode = edge[1]
        i = k
    end

    return {} -- Pattern not found
end

-- Get all leaf nodes of a subtree
function SuffixTree:_getLeafNodes(node)
    local leafNodes = {}

    local function traverse(node)
        for _, edge in pairs(node.edges) do
            if edge[1] then
                traverse(edge[1])
            else
                table.insert(leafNodes, edge[2])
            end
        end
    end

    traverse(node)

    return leafNodes
end
--[[
-- Example usage
local mySuffixTree = SuffixTree("banana")

local occurrences = mySuffixTree:findOccurrences("an")
for _, index in ipairs(occurrences) do
    print(index)
end
-- Output:
-- 2
-- 4

occurrences = mySuffixTree:findOccurrences("xyz")
for _, index in ipairs(occurrences) do
    print(index)
end
-- Output: (empty)
]]