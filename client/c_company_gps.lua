-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_company_gps.lua (ATUALIZADO)

local QBCore = exports['qb-core']:GetCoreObject()
local CompanyGPS = {
    blips = {},
    data = {},
    isPlayerInCompany = false,
    updateInterval = 10000 -- 10 segundos
}

-- Evento acionado quando o jogador entra ou sai de uma empresa
RegisterNetEvent('space_trucker:client:updateCompanyStatus', function(inCompany)
    CompanyGPS.isPlayerInCompany = inCompany
    if not inCompany then
        -- Se o jogador saiu da empresa, remove todos os blips
        for _, blip in pairs(CompanyGPS.blips) do
            RemoveBlip(blip)
        end
        CompanyGPS.blips = {}
        CompanyGPS.data = {}
    end
end)

CreateThread(function()
    while true do
        Wait(CompanyGPS.updateInterval)

        if CompanyGPS.isPlayerInCompany then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleName = "A Pé"
            
            if DoesEntityExist(vehicle) then
                local model = GetEntityModel(vehicle)
                vehicleName = GetDisplayNameFromVehicleModel(model)
            end

            local missionData = nil
            if currentMission and type(currentMission) == 'table' then
                missionData = {
                    item = currentMission.itemLabel or "Carga",
                    amount = currentMission.amount or 1
                }
            end

            TriggerServerEvent('space_trucker:server:updatePlayerGPS', {
                coords = { x = coords.x, y = coords.y, z = coords.z },
                vehicle = vehicleName,
                mission = missionData
            })
        end
    end
end)

RegisterNetEvent('space_trucker:client:updateCompanyGPS', function(companyData)
    if not CompanyGPS.isPlayerInCompany then return end

    CompanyGPS.data = companyData
    local myServerId = GetPlayerServerId(PlayerId())
    local currentBlips = {}

    -- Atualiza ou cria blips para cada membro da empresa (exceto o próprio jogador)
    for serverId, data in pairs(companyData) do
        local id = tonumber(serverId)
        if id and id ~= myServerId then
            currentBlips[id] = true
            local player = GetPlayerFromServerId(id)
            
            local blipCoords = vector3(data.coords.x, data.coords.y, data.coords.z)
            if player ~= -1 and player ~= 0 then
                blipCoords = GetEntityCoords(GetPlayerPed(player))
            end

            if CompanyGPS.blips[id] then
                SetBlipCoords(CompanyGPS.blips[id], blipCoords)
            else
                local newBlip = AddBlipForCoord(blipCoords)
                SetBlipSprite(newBlip, 1)
                SetBlipColour(newBlip, 28)
                SetBlipScale(newBlip, 0.8)
                SetBlipAsShortRange(newBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(data.name)
                EndTextCommandSetBlipName(newBlip)
                CompanyGPS.blips[id] = newBlip
            end
        end
    end

    -- Remove blips de jogadores que não estão mais nos dados
    for id, blip in pairs(CompanyGPS.blips) do
        if not currentBlips[id] then
            RemoveBlip(blip)
            CompanyGPS.blips[id] = nil
        end
    end
    
    -- ## ALTERAÇÃO AQUI ##
    -- Envia os dados E o ID do jogador local para a NUI (Tablet)
    SendNUIMessage({
        action = 'updateCompanyGPS',
        payload = {
            members = companyData,
            myServerId = myServerId 
        }
    })
end)