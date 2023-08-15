-- Define the BKTree class
BKTree = Class()
--[[
    BKTree
]]

-- Node structure
local Node = {}
Node.__index = Node

function Node.new(word)
    local node = {}
    node.word = word
    node.children = {}
    return setmetatable(node, Node)
end

-- Constructor
function BKTree:__init()
    self.root = nil
end

-- Calculate the Levenshtein distance between two words
local function levenshteinDistance(word1, word2)
    local len1, len2 = #word1, #word2
    local matrix = {}

    -- Initialize the matrix
    for i = 0, len1 do
        matrix[i] = { [0] = i }
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    -- Calculate the minimum distance
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = word1:sub(i, i) ~= word2:sub(j, j) and 1 or 0
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )
        end
    end

    return matrix[len1][len2]
end

-- Insert a word into the BK-tree
function BKTree:insert(word)
    if not self.root then
        self.root = Node.new(word)
    else
        local currentNode = self.root
        local distance = levenshteinDistance(word, currentNode.word)
        while currentNode.children[distance] do
            currentNode = currentNode.children[distance]
            distance = levenshteinDistance(word, currentNode.word)
        end
        currentNode.children[distance] = Node.new(word)
    end
end

-- Search for words within a given maximum distance
function BKTree:searchRecursively(word, maxDistance)
    local results = {}

    local function searchRecursively(node, distance)
        local wordDistance = levenshteinDistance(word, node.word)
        if wordDistance <= maxDistance then
            table.insert(results, node.word)
        end

        for d, child in pairs(node.children) do
            if d >= wordDistance - maxDistance and d <= wordDistance + maxDistance then
                searchRecursively(child, d)
            end
        end
    end

    if self.root then
        searchRecursively(self.root, levenshteinDistance(word, self.root.word))
    end

    return results
end

-- Levenshtein distance implementation
local function getEditDistance(str1, str2)
    local len1, len2 = #str1, #str2
    local dp = {}

    for i = 0, len1 do
        dp[i] = {}
        for j = 0, len2 do
            dp[i][j] = 0
        end
    end

    for i = 1, len1 do
        dp[i][0] = i
    end

    for j = 1, len2 do
        dp[0][j] = j
    end

    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (str1:sub(i, i) ~= str2:sub(j, j)) and 1 or 0
            dp[i][j] = math.min(
                dp[i - 1][j] + 1,
                dp[i][j - 1] + 1,
                dp[i - 1][j - 1] + cost
            )
        end
    end

    return dp[len1][len2]
end

-- Iterative search in BKTree
function BKTree:searchIteratively(target, tolerance)
    local stack = {}
    local result = {}

    if not self.root then
        return result
    end

    table.insert(stack, self.root)

    while #stack > 0 do
        Wait(0)
        local current = table.remove(stack)
        local distance = getEditDistance(current.value, target) -- Replace with your edit distance function

        if distance <= tolerance then
            table.insert(result, current.value)
        end

        local lowerBound = distance - tolerance
        local upperBound = distance + tolerance

        for dist, child in pairs(current.children) do
            if dist >= lowerBound and dist <= upperBound then
                table.insert(stack, child)
            end
        end
    end

    return result
end
