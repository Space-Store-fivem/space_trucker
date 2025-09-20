spaceconfig.MaxServerVehicleDistanceCheck = 10 --don't tounch

local QBCore = exports['qb-core']:GetCoreObject()

function CreateCallback(_callbackName, _eventCallback)
    return QBCore.Functions.CreateCallback(_callbackName, _eventCallback)
end

function GetPlayerCash(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end

    return Player.Functions.GetMoney('cash')
end

function RemovePlayerCash(source, amount, reason)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.RemoveMoney('cash', amount, reason)
end

function AddPlayerCash(source, amount, reason)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.Functions.AddMoney('cash', amount, reason)
end

function GetPlayerUniqueId(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    return Player.PlayerData.citizenid
end

CreateCallback('gstrucker:callback:getPlayerJob', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    local job = Player.PlayerData.job
    return cb and cb(job) or job
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    LoadPlayerTruckerSkill(Player.PlayerData.source)
end)