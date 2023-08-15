-- Pure Lua global utility functions (considered as additions to the vanilla Lua environment)
-- no class instances can be instantiated in this file

IsServer = IsDuplicityVersion() -- true if the machine this code runs on is the (single) server
IsClient = not IsServer -- true if the machine this code runs on is one of the clients / players connected to the server

---------- Citizen ----------
CreateThread = Citizen.CreateThread
Wait = Citizen.Wait
SetTimeout = Citizen.SetTimeout
Await = Citizen.Await
CreateThreadNow = Citizen.CreateThreadNow
Trace = Citizen.Trace
-----------------------------

unpack = table.unpack

----- Additions -----

-- counts an associative Lua table (use #table for sequential tables)
function count_table(table)
    local count = 0

    for k, v in pairs(table) do
        count = count + 1
    end

    return count
end

function tofloat(num)
    return num / 1.0
end

-- general linear interpolation function
-- parameter t should be between 0.0 and 1.0
-- (0.0 is a and 1.0 is b)
function lerp(a, b, t)
    return a * (1 - t) + (b * t)
end

-- splits a string given a seperator
-- returns a sequential table of tokens, which could be empty
function split(input_str, seperator)
    if seperator == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(input_str, "([^" .. seperator .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function math.round(num, decimal_places)
    return tonumber(string.format("%." .. (decimal_places or 0) .. "f", num))
end

function math.clamp(value, lower, upper)
    return math.min(math.max(value, lower), upper)
end

function trim(s)
    return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

-- Allows string indexing with s[0], from http://lua-users.org/wiki/StringIndexing
getmetatable('').__index = function(str,i)
    if type(i) == 'number' then
        return string.sub(str,i,i)
    else
        return string[i]
    end
end

function sequence_contains(t, v)
    for _, _v in pairs(t) do
        if v == _v then return true end
    end
    return false
end

function random_table_value(t)
    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    return t[keys[math.random(#keys)]]
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- does not keep same order
function shallow_copy(t)
    local new_table = {}
    for k, v in pairs(t) do
        new_table[k] = v
    end
    return new_table
end

function output_table(t)
    print("-----", t, "-----")
    for key, value in pairs(t) do
        if type(value) ~= "table" or (type(value) == "table" and value.__class_instance) then
            print("[", key, "]: ", value)
        else
            print(key .. " {")
            for k, v in pairs(value) do
                if type(v) ~= "table" or (type(value) == "table" and value.__class_instance) then
                    print("[", k, "]: ", v)
                else
                    print(k .. " {")
                    for k2, v2 in pairs(v) do
                        print("[", k2, "]: ", v2)
                    end
                    print("}")
                end
            end
            print("}")
        end
    end
    print("------------------------")
end

-- omitted keys is a table where key is index and value can be anything except false or 0
function random_weighted_table_value(weighted_table, omitted_keys)
    if not omitted_keys then
        omitted_keys = {}
    end

    local sum = 0
    for key, weight in pairs(weighted_table) do
        if not omitted_keys[key] then
            sum = sum + weight
        end
    end

    local rand = math.random() * sum
    local found
    for key, weight in pairs(weighted_table) do
        if not omitted_keys[key] then
            rand = rand - weight
            if rand < 0 then
                found = key
                break
            end
        end
    end

    return found
end

---------------------

----- Overloads -----
local _assert = assert
function assert(condition, message)
    return _assert(condition, debug.traceback(tostring(message)))
end

local _error = error
function error(...)
    return _error(debug.traceback(...))
end

local OgMathRandomseed = math.randomseed

local function string_to_number(str)
    local insert = table.insert
    if str:len() < 6 then
        local numeric_representations = {}
        local digits = 0
        for c in str:gmatch('.') do
            insert(numeric_representations, c:byte())
        end
        return tonumber(table.concat(numeric_representations))
    else
        local numeric_representation = 0
        for c in str:gmatch('.') do
            numeric_representation = numeric_representation + c:byte()
        end
        return numeric_representation
    end
end

function math.randomseed(x)
    local number_form = x
    if type(x) == 'string' then
        number_form = string_to_number(x)
    end

    OgMathRandomseed(number_form)
end

local OgLuaPrint = print

-- format time to have a 0 in front if its short
local function f_time(time)
    return time < 10 and "0" .. time or time
end

function print(...)
    local args = {...}
    local output_str = string.format("%s[%s]%s", 
        "^5", tostring(GetCurrentResourceName()), "^7")

    if IsServer then
        local t = os.date("*t", os.time())
        output_str = output_str .. " [" .. f_time(t.hour) .. ":" .. f_time(t.min) .. ":" .. f_time(t.sec) .. "]: "
    elseif IsClient then
        local year, month, day, hour, min, sec = GetPosixTime()
        output_str = output_str .. " [" .. f_time(hour) .. ":" .. f_time(min) .. ":" .. f_time(sec) .. "]: "
    end

    for index, arg in ipairs(args) do
        output_str = output_str .. tostring(arg)
    end

    OgLuaPrint(output_str)
end

function debuglog(debugLevel, ...)
    local debugInfo = debug.getinfo(debugLevel)
    if Config.IsDebug then
        print(debugInfo.short_src, " line:", debugInfo.currentline, " [", debugInfo.name,"]")
        print(...)
    end
end

local OgLuaTostring = tostring
function tostring(variable)
    if type(variable) == "table" and variable.__class_instance then
        return variable:tostring()
    else
        return OgLuaTostring(variable)
    end
end
---------------------