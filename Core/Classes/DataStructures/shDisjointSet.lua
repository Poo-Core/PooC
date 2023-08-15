-- Define the DisjointSet class
DisjointSet = Class()
--[[
    DisjointSet
]]

-- Constructor
function DisjointSet:__init()
    self._parent = {}
    self._rank = {}
end

-- Make a new set with a single element
function DisjointSet:makeSet(element)
    self._parent[element] = element
    self._rank[element] = 0
end

-- Find the representative of the set that an element belongs to
function DisjointSet:find(element)
    if self._parent[element] ~= element then
        self._parent[element] = self:find(self._parent[element])
    end
    return self._parent[element]
end

-- Union two sets
function DisjointSet:union(element1, element2)
    local root1 = self:find(element1)
    local root2 = self:find(element2)

    if root1 == root2 then
        return -- Elements are already in the same set
    end

    if self._rank[root1] < self._rank[root2] then
        self._parent[root1] = root2
    elseif self._rank[root1] > self._rank[root2] then
        self._parent[root2] = root1
    else
        self._parent[root2] = root1
        self._rank[root1] = self._rank[root1] + 1
    end
end
