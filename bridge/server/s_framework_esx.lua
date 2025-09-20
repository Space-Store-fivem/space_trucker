spaceconfig.MaxServerVehicleDistanceCheck = 10 --don't tounch

local ESX = exports['es_extended']:getSharedObject()

function CreateCallback(_callbackName, _eventCallback)
    return ESX.RegisterServerCallback(_callbackName, _eventCallback)
end

function GetPlayerCash(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    return xPlayer.getMoney()
end

function RemovePlayerCash(source, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    xPlayer.removeMoney(amount, reason)
    return true
end

function AddPlayerCash(source, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    xPlayer.addMoney(amount, reason)
    return true
end

function GetPlayerUniqueId(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    return xPlayer.identifier
end

CreateCallback('gstrucker:callback:getPlayerJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end
    local job = xPlayer.job
    return cb and cb(job) or job
end)

AddEventHandler('esx:playerLoaded', function(source)
    LoadPlayerTruckerSkill(source)
end)