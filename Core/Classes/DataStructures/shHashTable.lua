-- Define the HashTable class
HashTable = Class()
--[[
    HashTable
]]

-- Constructor
function HashTable:__init()
    self._data = {}
end

-- Get the hash value for a given key
function HashTable:_hash(key)
    -- You can implement your own hash function here
    -- For simplicity, we use the string length as the hash value
    return #key
end

-- Insert a key-value pair into the hash table
function HashTable:insert(key, value)
    local hashValue = self:_hash(key)
    if not self._data[hashValue] then
        self._data[hashValue] = {}
    end
    self._data[hashValue][key] = value
end

-- Remove a key-value pair from the hash table
function HashTable:remove(key)
    local hashValue = self:_hash(key)
    if self._data[hashValue] and self._data[hashValue][key] then
        self._data[hashValue][key] = nil
    end
end

-- Get the value associated with a key in the hash table
function HashTable:get(key)
    local hashValue = self:_hash(key)
    if self._data[hashValue] and self._data[hashValue][key] then
        return self._data[hashValue][key]
    end
    return nil
end