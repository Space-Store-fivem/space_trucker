local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    OnPlayerJoin()
    AddTruckPDAOption()
    AddTruckRentalPoint()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobData)
    QBCore.PlayerData.job = jobData
    OnPlayerJobUpdate(jobData.name)
end)

function GetPlayerJobName()
    if not QBCore.PlayerData.job then
        local data = TriggerCallbackAwait('gstrucker:callback:getPlayerJob')
        QBCore.PlayerData.job = data
        return data.name
    end
    return QBCore.PlayerData.job.name
end

function TriggerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function TriggerCallbackAwait(name, ...)
    local promise = promise.new()
    TriggerCallback(name, function(response, ...)
        response = { response, ... }
        promise:resolve(response)
    end, ...)

    return table.unpack(Citizen.Await(promise))
end