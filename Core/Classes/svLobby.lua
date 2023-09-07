Lobby = Class()

function Lobby:__init(lobbyName, lobbyType, lobbyMap)
    self.name = lobbyName
    self.id = joaat(lobbyName)
    self.type = lobbyType
    self.map = lobbyMap
    self.players = sPlayers()
    
end

function Lobby:AddPlayerToLobby(player)
    player:SetRoutingBucket(self.id)
    self.players:insert(player)
end

function Lobby:RemovePlayerFromLobby()

end