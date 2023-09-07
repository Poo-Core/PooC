-- a Player instance represents a single player in the game
zPlayer = Class(ValueStorage)

--- local functions
local function getRandomIndex(max)
    return math.floor(math.random() * max) + 1
end

local function generateRandomNumbers(length)
    local numbers = "0123456789"
    local result = ""

    for i = 1, length do
        local randomIndex = getRandomIndex(numbers:len())
        result = result .. numbers:sub(randomIndex, randomIndex)
    end

    return result
end

local function generateRandomLetters(length)
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = ""

    for i = 1, length do
        local randomIndex = getRandomIndex(letters:len())
        result = result .. letters:sub(randomIndex, randomIndex)
    end

    return result
end

local function generateCitizenNumber()
    -- Define the prefix
    local prefix = "LS"

    -- Define the length of the random numbers
    local randomNumberLength = 6 -- You can adjust this based on your needs

    -- Generate random numbers
    local randomNumbers = generateRandomNumbers(randomNumberLength)

    -- Generate two random letters
    local randomLetters = generateRandomLetters(2)

    -- Combine prefix, random numbers, and random letters
    local citizenNumber = prefix .. randomNumbers .. randomLetters

    return citizenNumber
end

local function generateUniqueCitizenNumber()
    local cn = ''
    repeat
        cn = generateCitizenNumber()
        --print(cn)
        Wait(100)
        local result = MySQL.prepare.await('SELECT * FROM characters WHERE citizennumber = ?', {cn})
    until not result
    return cn
end

-------------------



function zPlayer:__init(player_id, ids)
    self.player_id = tonumber(player_id)
    self.ids = ids -- steamid, discord, license, live (xbox live), fivem, ip
    self.name = GetPlayerName(player_id)
    --self.citizenNumber = generateUniqueCitizenNumber()
    self.ep = GetPlayerEndpoint(player_id)
    self.__is_player_instance = true
    math.randomseed(self:GetUniqueId())
    self.color = Color:FromHSV(
        math.random(),
        0.7 + (math.random() * 0.3),
        0.8 + (math.random() * 0.2)
    )

    -- Reset randomseed
    math.randomseed(GetGameTimer())

    self:InitializeValueStorage(self)
    self:SetValueStorageNetworkId(self.player_id)

    getter_setter(self, 'citizenNumber')
end

function zPlayer:IsValid()
    return GetPlayerEndpoint(self.player_id) ~= nil
end

function zPlayer:GetInvincible()
    return GetPlayerInvincible(self.player_id)
end

function zPlayer:GetRoutingBucket()
    return GetPlayerRoutingBucket(self.player_id)
end

function zPlayer:SetRoutingBucket(bucket)
    return SetPlayerRoutingBucket(self.player_id, bucket)
end

function zPlayer:GetPed()
    return Ped(GetPlayerPed(self.player_id))
end

function zPlayer:GetPosition()
    return self:GetPed():GetPosition()
end

function zPlayer:GetNumTokens()
    return GetNumPlayerTokens(self.player_id)
end

function zPlayer:GetToken(index)
    return GetPlayerToken(self.player_id, index)
end

function zPlayer:Kick(reason)
    DropPlayer(self.player_id, reason or "You have been kicked from the server")
end

--[[
    Returns player endpoint
]]
function zPlayer:GetEP()
    return self.ep
end

function zPlayer:GetIP()
    return self.ids.ip
end

function zPlayer:GetXBoxLiveId()
    return self.ids.live
end

function zPlayer:GetDiscordId()
    return self.ids.discord
end

function zPlayer:GetLicense()
    return self.ids.license
end

function zPlayer:GetName()
    return self.name
end

function zPlayer:GetId()
    return self.player_id
end

function zPlayer:GetUniqueId()
    return self:GetLicense()
end

function zPlayer:GetSteamId()
    return self.ids.steam_id
end

function zPlayer:GetColor()
    return self.color
end

function zPlayer:Disconnected()
    -- handle disconnect stuff here
    -- do not delete data yet as this instance is being passed with Events:Fire("PlayerQuit")
end

function zPlayer:StoreValue(args)
    assert(type(args) == "table", "zPlayer:StoreValue requires a table of arguments")
    assert(type(args.key) == "string", "zPlayer:StoreValue 'key' argument must be a string")
    assert(not (args.synchronous and args.callback), "zPlayer:StoreValue does not accept a 'callback' argument if the 'synchronous' argument is true")

    if args.synchronous then
        return KeyValueStore:Set({key = "Player_" .. tostring(self:GetUniqueId()) .. args.key, value = args.value, synchronous = true})
    else
        KeyValueStore:Set({key = "Player_" .. tostring(self:GetUniqueId()) .. args.key, value = args.value, callback = args.callback})
    end
end

function zPlayer:GetStoredValue(args)
    assert(type(args) == "table", "zPlayer:GetStoredValue requires a table of arguments")
    assert((type(args.key) == "string" or type(args.keys) == "table") and not (args.key and args.keys), "zPlayer:GetStoredValue requires either a 'key' parameter of type string, or a 'keys' parameter of type table")
    assert(args.synchronous or args.callback, "zPlayer:GetStoredValue requires a 'callback' parameter of type function when the 'synchronous' parameter is nil or false")
    local kvs_args = {}

    if args.key then
        kvs_args.key = "Player_" .. tostring(self:GetUniqueId()) .. args.key
    end

    if args.keys then
        kvs_args.keys = {}
        for _, key in ipairs(args.keys) do
            table.insert(kvs_args.keys, "Player_" .. tostring(self:GetUniqueId()) .. key)
        end
    end

    if args.synchronous then
        kvs_args.synchronous = true

        return KeyValueStore:Get(kvs_args)
    else
        kvs_args.callback = function(value)
            args.callback(value)
        end

        KeyValueStore:Get(kvs_args)
    end
end

function zPlayer:tostring()
    return "Player (" .. self.name .. ")"
end