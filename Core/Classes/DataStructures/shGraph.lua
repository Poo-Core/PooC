-- Define the Graph class
Graph = Class()
--[[
    Graph
]]

-- Constructor
function Graph:__init()
    self._nodes = {}
end

-- Add a node to the graph
function Graph:addNode(node)
    self._nodes[node] = {}
end

-- Remove a node from the graph
function Graph:removeNode(node)
    self._nodes[node] = nil
    for _, adjacentNodes in pairs(self._nodes) do
        adjacentNodes[node] = nil
    end
end

-- Add an edge between two nodes in the graph
function Graph:addEdge(node1, node2)
    self._nodes[node1][node2] = true
    self._nodes[node2][node1] = true
end

-- Remove an edge between two nodes in the graph
function Graph:removeEdge(node1, node2)
    self._nodes[node1][node2] = nil
    self._nodes[node2][node1] = nil
end

-- Check if two nodes are connected in the graph
function Graph:isConnected(node1, node2)
    return self._nodes[node1][node2] == true
end

-- Get the neighbors of a node in the graph
function Graph:getNeighbors(node)
    local neighbors = {}
    for neighbor in pairs(self._nodes[node]) do
        table.insert(neighbors, neighbor)
    end
    return neighbors
end
