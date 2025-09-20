local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function()
    OnPlayerJoin()
    AddTruckRentalPoint()
end)

RegisterNetEvent('esx:setJob', function(jobData)
    ESX.PlayerData.job = jobData
    OnPlayerJobUpdate(jobData.name)
end)

function GetPlayerJobName()
    if not ESX.PlayerData.job then
        local data = TriggerCallbackAwait('gstrucker:callback:getPlayerJob')
        ESX.PlayerData.job = data
        return data.name
    end
    return ESX.PlayerData.job.name
end

function TriggerCallback(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

function TriggerCallbackAwait(name, ...)
    local promise = promise.new()
    TriggerCallback(name, function(response, ...)
        response = { response, ... }
        promise:resolve(response)
    end, ...)

    return table.unpack(Citizen.Await(promise))
end