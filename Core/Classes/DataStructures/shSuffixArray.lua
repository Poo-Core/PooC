-- Define the SuffixArray class
SuffixArray = Class()
--[[
    SuffixArray
]]

-- Constructor
function SuffixArray:__init(text)
    self._text = text
    self._suffixes = {}
    for i = 1, #text do
        self._suffixes[i] = text:sub(i)
    end
    table.sort(self._suffixes)
end

-- Get the length of the original text
function SuffixArray:length()
    return #self._text
end

-- Get the suffix at a specific index
function SuffixArray:suffixAt(index)
    return self._suffixes[index]
end

-- Search for a pattern in the suffix array using binary search
function SuffixArray:search(pattern)
    local left = 1
    local right = #self._suffixes

    while left <= right do
        Wait(0)
        local mid = math.floor((left + right) / 2)
        local suffix = self._suffixes[mid]
        local match = suffix:sub(1, #pattern)

        if match == pattern then
            return mid -- Pattern found
        elseif match < pattern then
            left = mid + 1
        else
            right = mid - 1
        end
    end

    return -1 -- Pattern not found
end
--[[
-- Example usage
local mySuffixArray = SuffixArray("banana")

print(mySuffixArray:length())      --> 6
print(mySuffixArray:suffixAt(3))   --> "nana"
print(mySuffixArray:search("ana")) --> 2
print(mySuffixArray:search("xyz")) --> -1
]]