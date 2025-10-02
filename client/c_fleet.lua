-- space_trucker/client/c_fleet.lua

local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCompanyGarage = nil
local PlayerCompanyId = nil
local BlipGaragem = nil
local hasPlayerLoaded = false -- Variável de controlo

local function checkJobAndGarage()
    QBCore.Functions.TriggerCallback('space_trucker:callback:checkEmployment', function(isEmployed, companyId)
        PlayerCompanyId = isEmployed and companyId or nil
        
        if PlayerCompanyId then
            QBCore.Functions.TriggerCallback('space_trucker:callback:getGarageLocation', function(loc)
                if loc and loc.x then
                    CurrentCompanyGarage = loc
                    updateBlip(PlayerCompanyId, loc)
                else
                    CurrentCompanyGarage = nil
                    updateBlip(nil, nil)
                end
            end, { companyId = PlayerCompanyId })
        else
            CurrentCompanyGarage = nil
            updateBlip(nil, nil)
        end
    end)
end

CreateThread(function()
    while not hasPlayerLoaded do
        if QBCore and QBCore.Functions.GetPlayerData().citizenid then
            hasPlayerLoaded = true
            Wait(2000) 
            checkJobAndGarage()
        end
        Wait(1000)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    checkJobAndGarage()
end)

RegisterCommand('checkgarage', function()
    checkJobAndGarage()
end, false)


function updateBlip(companyId, location)
    if BlipGaragem then RemoveBlip(BlipGaragem) end

    if location and companyId and companyId == PlayerCompanyId then
        BlipGaragem = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(BlipGaragem, 357)
        SetBlipColour(BlipGaragem, 2)
        SetBlipScale(BlipGaragem, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Garagem da Empresa")
        EndTextCommandSetBlipName(BlipGaragem)
    end
end

CreateThread(function()
    while true do
        Wait(1000)
        if CurrentCompanyGarage then
            while CurrentCompanyGarage do
                local pCoords = GetEntityCoords(PlayerPedId())
                local dist = #(pCoords - vec3(CurrentCompanyGarage.x, CurrentCompanyGarage.y, CurrentCompanyGarage.z))

                if dist < 10.0 then
                    local currentVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                    if currentVeh ~= 0 then
                        if dist < 5.0 then
                            DrawText3D(CurrentCompanyGarage.x, CurrentCompanyGarage.y, CurrentCompanyGarage.z + 1.0, "[E] - Guardar Veículo")
                            if IsControlJustReleased(0, 38) then
                                local plate = QBCore.Functions.GetPlate(currentVeh)
                                local damage = { engine = GetVehicleEngineHealth(currentVeh), body = GetVehicleBodyHealth(currentVeh) }
                                QBCore.Functions.TriggerCallback('space_trucker:callback:storeFleetVehicle', function(result)
                                    if result and result.success then
                                        QBCore.Functions.DeleteVehicle(currentVeh)
                                        QBCore.Functions.Notify(result.message, "success")
                                    else
                                        QBCore.Functions.Notify(result.message or "Este veículo não pertence à frota.", "error")
                                    end
                                end, { plate = plate, damage = damage })
                            end
                        end
                    else
                        if dist < 2.5 then
                            DrawText3D(CurrentCompanyGarage.x, CurrentCompanyGarage.y, CurrentCompanyGarage.z + 1.0, "[E] - Aceder à Garagem")
                            if IsControlJustReleased(0, 38) then
                                openGarageMenu()
                            end
                        end
                    end
                end
                Wait(5)
            end
        end
    end
end)

function openGarageMenu()
    QBCore.Functions.TriggerCallback('space_trucker:callback:getFleetVehicles', function(vehicles)
        SendNUIMessage({
            action = "showGarage",
            data = {
                show = true,
                vehicles = vehicles or {}
            }
        })
        SetNuiFocus(true, true)
    end)
end

RegisterNUICallback('space_trucker:garage_selectVehicle', function(data, cb)
    if data and data.vehicleId then
        TriggerServerEvent('space_trucker:server:requestSpawn', { vehicleId = data.vehicleId })
    end
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback('space_trucker:garage_close', function(data, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)



RegisterNUICallback('getCompanyRentableVehicles', function(_, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:getCompanyReputation', function(reputation)
        local rentableTrucks = {}
        for vehicleKey, vehicleData in pairs(spaceconfig.VehicleTransport) do
            -- ## LÓGICA CORRIGIDA AQUI ##
            -- O filtro agora inclui qualquer veículo que tenha um requisito de 'level'.
            -- Isto garante que tanto os camiões rígidos como os que precisam de reboque apareçam.
            if vehicleData.level and vehicleData.level >= 30 then
                local rentPrice = vehicleData.rentPrice or (spaceconfig.VehicleRentBaseCost * vehicleData.capacity)
                table.insert(rentableTrucks, {
                    key = vehicleKey,             -- O identificador para o servidor (pode ser número ou texto)
                    model = vehicleData.name,     -- O nome do modelo para a imagem (é sempre texto)
                    label = vehicleData.label,
                    capacity = vehicleData.capacity,
                    level = vehicleData.level,
                    rentPrice = rentPrice
                })
            end
        end

        table.sort(rentableTrucks, function(a, b) return a.rentPrice < b.rentPrice end)

        cb({ trucks = rentableTrucks, playerLevel = reputation or 0 })
    end)
end)

RegisterNUICallback('rentCompanyVehicle', function(data, cb)
    -- 'data.vehicleName' é a chave que recebemos da UI (pode ser um hash numérico ou um nome de modelo)
    local vehicleKey = data.vehicleName 
    
    -- Apenas verificamos se a chave existe na configuração para evitar erros
    if not spaceconfig.VehicleTransport[vehicleKey] then
        QBCore.Functions.Notify("Erro: Chave do veículo inválida na configuração do cliente.", 'error', 8000)
        return cb({ success = false, message = "Erro de configuração." })
    end

    -- Chamamos o servidor e enviamos a CHAVE (o identificador) diretamente
    QBCore.Functions.TriggerCallback('space_trucker:callback:rentCompanyVehicle', function(result)
        if result and result.success then
            QBCore.Functions.Notify(result.message, 'success', 7500)
        else
            QBCore.Functions.Notify(result.message or "Ocorreu um erro no servidor.", 'error', 7500)
        end
        cb(result)
    end, vehicleKey) -- << ENVIAMOS A CHAVE/IDENTIFICADOR DIRETAMENTE PARA O SERVIDOR
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('space_trucker:client:spawnVehicle', function(vehicleData)
    QBCore.Functions.SpawnVehicle(vehicleData.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicleData.plate)
        SetEntityHeading(veh, CurrentCompanyGarage.h or 0.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        QBCore.Functions.Notify("Veículo retirado da garagem.", "success")
    end, CurrentCompanyGarage, true)
end)

RegisterNetEvent('space_trucker:client:deleteVehicleByPlate', function(plate)
    local vehicles = GetGamePool('CVehicle')
    for _, veh in ipairs(vehicles) do
        if GetVehicleNumberPlateText(veh) == plate then
            QBCore.Functions.DeleteVehicle(veh)
            return
        end
    end
end)

-- Adicione este evento no final do ficheiro client/c_fleet.lua
RegisterNetEvent('space_trucker:client:updateGarageLocation', function(companyId, location)
    -- Verifica se a atualização é para a empresa do jogador atual
    if PlayerCompanyId and companyId == PlayerCompanyId then
        print("[space-trucker] Recebida atualização da localização da garagem em tempo real.")
        CurrentCompanyGarage = location
        updateBlip(companyId, location)
    end
end)