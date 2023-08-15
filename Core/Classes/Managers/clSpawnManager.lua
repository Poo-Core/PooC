--- Local Functions ---

-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end
-----------------------

SpawnManager = Class()

function SpawnManager:__init()
    print("self.instance: ", self.instance)
    if self.instance then
        print"instance found!"
        self = self.instance
    else
        print"instance not found!"
        self.spawnPoints = {}
        self.autoSpawnEnabled = false
        self.autoSpawnCallback = false
        getter_setter(self, "autoSpawnEnabled")
        getter_setter(self, "autoSpawnCallback")
        self.instance = self
    end
end

SpawnManager = SpawnManager()

function SpawnManager:LoadSpawnsFromJSON(spawnPointsString)
    local data = json.decode(spawnPointsString)

    -- do we have a 'spawns' field?
    if not data.spawns then
        error("no 'spawns' in JSON data")
    end

    -- loop through the spawns
    for i, spawn in ipairs(data.spawns) do
        -- and add it to the list (validating as we go)
        self:addSpawnPoint(spawn)
    end
end

---comment
---@param spawnPoint {x: number, y: number, z: number, heading: number, model: number | string}
---@return unknown
function SpawnManager:AddSpawnPoint(spawnPoint)
    -- validate the spawn (position)
    if not tonumber(spawnPoint.x) or not tonumber(spawnPoint.y) or not tonumber(spawnPoint.z) then
        error("invalid spawn position")
    end

    -- heading
    if not tonumber(spawnPoint.heading) then
        error("invalid spawn heading")
    end

    -- model (try integer first, if not, hash it)
    local model = spawnPoint.model

    if type(spawnPoint.model) == 'string' then
        model = GetHashKey(spawnPoint.model)
    end

    -- is the model actually a model?
    if not IsModelInCdimage(model) then
        error("invalid spawn model")
    end

    -- is is even a ped?
    -- not in V?
    --[[if not IsThisModelAPed(model) then
        error("this model ain't a ped!")
    end]]

    -- overwrite the model in case we hashed it
    spawnPoint.model = model

    -- add an index
    spawnPoint.idx = #self.spawnPoints + 1

    -- all OK, add the spawn entry to the list
    table.insert(self.spawnPoints, spawnPoint)

    return spawnPoint.idx
end

function SpawnManager:GetSpawnPoints()
    return self.spawnPoints
end

function SpawnManager:RemoveSpawnPoint(spawnPointIdx)
    table.remove(self.spawnPoints, spawnPointIdx)
end

function SpawnManager:SetAutoSpawn(enabled)
    --print("before ", enabled, " ", self.autoSpawnEnabled)
    self.autoSpawnEnabled = enabled
    --print("after ", enabled, " ", self.autoSpawnEnabled)
end
exports('SetAutoSpawn', function(bool)
    SpawnManager:SetAutoSpawn(bool)
end)

function SpawnManager:GetAutoSpawn()
    return self.autoSpawnEnabled
end

function SpawnManager:SetAutoSpawnCallback(callback)
    self.autoSpawnCallback = callback
    self.autoSpawnEnabled = true
end

function SpawnManager:IsAutoSpawnCallbackSet()
    return self.autoSpawnCallback
end

function SpawnManager:AutoSpawnCallback()
    self.autoSpawnCallback()
end

function SpawnManager:tostring()
    
end

-- UNUSED
function SpawnManager:LoadScene(x, y, z)
	if not NewLoadSceneStart then
		return
	end

    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)

    while IsNewLoadSceneActive() do
        networkTimer = GetNetworkTimer()

        NetworkUpdateLoadScene()
    end
end

-- to prevent trying to spawn multiple times
local spawnLock = false

function SpawnManager:SpawnPlayer(spawnIdx, callback)
    if spawnLock then
        return
    end

    spawnLock = true

    if not IsEntityDead(PlayerPedId()) then return end
    Citizen.CreateThread(function()
        -- if the spawn isn't set, select a random one
        if not spawnIdx then
            spawnIdx = GetRandomIntInRange(1, #self.spawnPoints + 1)
        end

        -- get the spawn from the array
        local spawn

        if type(spawnIdx) == 'table' then
            spawn = spawnIdx

            -- prevent errors when passing spawn table
            spawn.x = spawn.x + 0.00
            spawn.y = spawn.y + 0.00
            spawn.z = spawn.z + 0.00

            spawn.heading = spawn.heading and (spawn.heading + 0.00) or 0
        else
            spawn = self.spawnPoints[spawnIdx]
        end

        if spawn and not spawn.skipFade then
            DoScreenFadeOut(500)

            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
        end

        -- validate the index
        if not spawn then
            Citizen.Trace("tried to spawn at an invalid spawn index\n")

            spawnLock = false

            return
        end

        -- freeze the local player
        freezePlayer(PlayerId(), true)

        -- if the spawn has a model set
        if spawn.model then
            RequestModel(spawn.model)

            -- load the model for this spawn
            while not HasModelLoaded(spawn.model) do
                RequestModel(spawn.model)

                Wait(0)
            end

            -- change the player model
            SetPlayerModel(PlayerId(), spawn.model)

            -- release the player model
            SetModelAsNoLongerNeeded(spawn.model)
            
            -- RDR3 player model bits
            if N_0x283978a15512b2fe then
				N_0x283978a15512b2fe(PlayerPedId(), true)
            end
        end

        -- preload collisions for the spawnpoint
        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

        -- spawn the player
        local ped = PlayerPedId()

        -- V requires setting coords as well
        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

        -- gamelogic-style cleanup stuff
        ClearPedTasksImmediately(ped)
        --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
        RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
        ClearPlayerWantedLevel(PlayerId())

        -- why is this even a flag?
        --SetCharWillFlyThroughWindscreen(ped, false)

        -- set primary camera heading
        --SetGameCamHeading(spawn.heading)
        --CamRestoreJumpcut(GetGameCam())

        -- load the scene; streaming expects us to do it
        --ForceLoadingScreen(true)
        --loadScene(spawn.x, spawn.y, spawn.z)
        --ForceLoadingScreen(false)

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end

        -- and unfreeze the player
        freezePlayer(PlayerId(), false)

        --TriggerEvent('playerSpawned', spawn)
        Events:Fire('LocalPlayerSpawn', spawn)

        if callback then
            callback(spawn)
        end

        spawnLock = false
    end)
end

--
for key, value in pairs(SpawnManager) do
  --print(key)
end

local respawnForced
local diedAt

Citizen.CreateThread(function()
    -- main loop thing
    local playerPed = PlayerPedId()
    while true do
        Citizen.Wait(50)


        if playerPed and playerPed ~= -1 then
            -- check if we want to autospawn
            if SpawnManager.autoSpawnEnabled then
                if NetworkIsPlayerActive(PlayerId()) then
                    if (diedAt and (math.abs(GetTimeDifference(GetGameTimer(), diedAt)) > 2000)) or respawnForced then
                        if SpawnManager:IsAutoSpawnCallbackSet() then
                            SpawnManager:AutoSpawnCallback()
                        else
                            SpawnManager:SpawnPlayer()
                        end

                        respawnForced = false
                    end
                end
            end

            if IsEntityDead(playerPed) then
                if not diedAt then
                    diedAt = GetGameTimer()
                end
            else
                diedAt = nil
            end
        end
    end
end)

-- support for mapmanager maps
AddEventHandler('getMapDirectives', function(add)
    -- call the remote callback
    add('spawnpoint', function(state, model)
        -- return another callback to pass coordinates and so on (as such syntax would be [spawnpoint 'model' { options/coords }])
        return function(opts)
            local x, y, z, heading

            local s, e = pcall(function()
                -- is this a map or an array?
                if opts.x then
                    x = opts.x
                    y = opts.y
                    z = opts.z
                else
                    x = opts[1]
                    y = opts[2]
                    z = opts[3]
                end

                x = x + 0.0001
                y = y + 0.0001
                z = z + 0.0001

                -- get a heading and force it to a float, or just default to null
                heading = opts.heading and (opts.heading + 0.01) or 0

                -- add the spawnpoint
                SpawnManager:AddSpawnPoint({
                    x = x, y = y, z = z,
                    heading = heading,
                    model = model
                })

                -- recalculate the model for storage
                if not tonumber(model) then
                    model = GetHashKey(model, _r)
                end

                -- store the spawn data in the state so we can erase it later on
                state.add('xyz', { x, y, z })
                state.add('model', model)
            end)

            if not s then
                Citizen.Trace(e .. "\n")
            end
        end
        -- delete callback follows on the next line
    end, function(state, arg)
        -- loop through all spawn points to find one with our state
        local spawnPoints = SpawnManager:GetSpawnPoints()
        for i, sp in ipairs(spawnPoints) do
            -- if it matches...
            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then
                -- remove it.
                table.remove(spawnPoints, i)
                return
            end
        end
    end)
end)
