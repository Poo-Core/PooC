-- a Player instance represents a single player in the game
zPlayer = Class(ValueStorage)

function zPlayer:__init(source_id, steam_id, server_id, unique_id)
    self.source_id = source_id
    self.steam_id = steam_id
    self.server_id = server_id
    self.unique_id = unique_id
    self.__is_player_instance = true

    -- Wait until player is valid to get player id
    Citizen.CreateThread(function()
        while not self.player_id or self.player_id == -1 do
            self.player_id = GetPlayerFromServerId(self.source_id)
            Wait(500)
        end
    end)

    self:InitializeValueStorage(self)
    self:SetValueStorageNetworkId(self.server_id)
end

function zPlayer:SetControl(enabled)
    SetPlayerControl(self.player_id, enabled, false)
end

--[[
    Changes the model of the player.
    Warning: this function is not a wrapped in a thread

    WARNING: THIS WILL DESTROY THE CURRENT PED AND CREATE A NEW
    ONE FOR THIS PLAYER.
]]
function zPlayer:SetModel(model, cb)
    local hashkey = GetHashKey(model)
    LoadModel(hashkey, function()
        -- change the player model
        SetPlayerModel(self.player_id, hashkey)

        -- release the player model
        SetModelAsNoLongerNeeded(hashkey)

        -- RDR3 player model bits
        --if N_0x283978a15512b2fe then
        --    N_0x283978a15512b2fe(PlayerPedId(), true)
        --end
        cb()
    end)
end

--[[
    Updates the Ped class so that the Ped is still valid for this player.
    Useful for respawning or changing model.
]]
function zPlayer:GetPed()
    if not self.player_id or self.player_id == -1 then
        self.player_id = GetPlayerFromServerId(self.source_id)
    end

    local player_ped_id = GetPlayerPed(self.player_id)

    if not self.ped then
        self.ped = Ped({ped = player_ped_id})
    end

    if self.ped:GetEntityId() ~= player_ped_id then
        self.ped:UpdatePedId(player_ped_id)
    end

    if not self.ped:Exists() then
        self.ped = Ped({ped = player_ped_id})
    end

    return self.ped
end

function zPlayer:GetEntity()
    return self:GetPed()
end

function zPlayer:GetEntityId()
    return GetPlayerPed(self.player_id)
end

function zPlayer:GetPedId()
    return GetPlayerPed(self.player_id)
end

--[[
    Freezes the player, including movement controls.

    Same as original scripts.
]]
function zPlayer:Freeze(freeze)
    self:SetControl(not freeze)

    local ped = self:GetPed()
    local entity = Entity(ped:GetPedId())

    if not freeze then
        if not entity:IsVisible() then
            entity:SetVisible(true)
        end

        if not ped:InVehicle() then
            entity:ToggleCollision(true)
        end

        entity:SetKinematic(false)
        entity:SetInvincible(false)
    else
        if entity:IsVisible() then
            entity:SetVisible(false)
        end

        entity:ToggleCollision(false)
        entity:SetKinematic(true)
        entity:SetInvincible(true)

        if not ped:IsFatallyInjured() then
            ClearPedTasksImmediately(ped.ped_id)
        end
    end
end

function zPlayer:SetWeaponDamageModifier(modifier)
    SetPlayerWeaponDamageModifier(self:GetPlayerId(), tofloat(modifier))
end

function zPlayer:SetMeleeWeaponDamageModifier(modifier)
    SetPlayerMeleeWeaponDamageModifier(self:GetPlayerId(), tofloat(modifier))
end

function zPlayer:SetRunSprintMultiplier(multiplier)
    SetRunSprintMultiplierForPlayer(self:GetPlayerId(), tofloat(multiplier))
end

function zPlayer:ResetStamina()
    ResetPlayerStamina(self.player_id)
end

function zPlayer:SetMinFallDistance(distance)
    SetPlayerFallDistance(self.player_id, tofloat(distance))
end

function zPlayer:DisableFiring(disabled)
    self.firing_disabled = disabled

    Citizen.CreateThread(function()
        while self.firing_disabled do
            DisablePlayerFiring(self.player_id, true)
            Wait(1)
        end
    end)

end

function zPlayer:GetPosition()
    return self:GetPed():GetPosition()
end

function zPlayer:SetName(name)
    self.name = name
end

function zPlayer:GetName()
    return self.name
end

function zPlayer:GetId()
    return self.server_id
end

function zPlayer:GetPlayerId()
    return self.player_id
end

function zPlayer:GetSteamId()
    return self.steam_id
end

function zPlayer:GetUniqueId()
    return self.unique_id
end

-- Populate it however you like it
function zPlayer:Disconnected()

end



function zPlayer:tostring()
    return "Player (" .. self.name .. ")"
end