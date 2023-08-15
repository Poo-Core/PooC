MapManager = Class()

function MapManager:__init()
    self.mapFiles = {}
    self.undoCallbacks = {}
end

MapManager = MapManager()

function MapManager:AddMap(file, owningResource)
    print(file, owningResource)
    if not self.mapFiles[owningResource] then
        self.mapFiles[owningResource] = {}
    end

    table.insert(self.mapFiles[owningResource], file)
end

function MapManager:LoadMap(res)
    if self.mapFiles[res] then
        for _, file in ipairs(self.mapFiles[res]) do
            self:ParseMap(file, res)
        end
    end
end

function MapManager:UnloadMap(res)
    if self.undoCallbacks[res] then
        for _, cb in ipairs(self.undoCallbacks[res]) do
            cb()
        end

        self.undoCallbacks[res] = nil
        self.mapFiles[res] = nil
    end
end



function MapManager:ParseMap(file, owningResource)
    if not self.undoCallbacks[owningResource] then
        self.undoCallbacks[owningResource] = {}
    end

    local env = {
        math = math, pairs = pairs, ipairs = ipairs, next = next, tonumber = tonumber, tostring = tostring,
        type = type, table = table, string = string, _G = env,
        vector3 = vector3, quat = quat, vec = vec, vector2 = vector2
    }

    TriggerEvent('getMapDirectives', function(key, cb, undocb)
        env[key] = function(...)
            local state = {}

            state.add = function(k, v)
                state[k] = v
            end

            local result = cb(state, ...)
            local args = table.pack(...)

            table.insert(self.undoCallbacks[owningResource], function()
                undocb(state)
            end)

            return result
        end
    end)

    local mt = {
        __index = function(t, k)
            if rawget(t, k) ~= nil then return rawget(t, k) end

            -- as we're not going to return nothing here (to allow unknown directives to be ignored)
            local f = function()
                return f
            end

            return function() return f end
        end
    }

    setmetatable(env, mt)

    local fileData = LoadResourceFile(owningResource, file)
    local mapFunction, err = load(fileData, file, 't', env)

    if not mapFunction then
        Citizen.Trace("Couldn't load map " .. file .. ": " .. err .. " (type of fileData: " .. type(fileData) .. ")\n")
        return
    end

    mapFunction()
end