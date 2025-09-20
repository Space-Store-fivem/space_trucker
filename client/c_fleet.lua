-- gs_trucker/client/c_fleet.lua (VERSÃO COM ORDEM CORRIGIDA)

local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCompanyGarage = nil
local PlayerCompanyId = nil
local BlipGaragem = nil
local hasPlayerLoaded = false -- Variável de controlo

-- =============================================================================
-- DEFINIÇÃO DA FUNÇÃO (MOVIDA PARA CIMA PARA CORRIGIR O ERRO)
-- =============================================================================
local function checkJobAndGarage()
    print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: A executar checkJobAndGarage...")
    QBCore.Functions.TriggerCallback('gs_trucker:callback:checkEmployment', function(isEmployed, companyId)
        print(string.format("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: Resposta do Servidor -> Empregado: ^3%s^7, ID da Empresa: ^3%s^7.", tostring(isEmployed), tostring(companyId)))
        
        PlayerCompanyId = isEmployed and companyId or nil
        
        if PlayerCompanyId then
            print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: A pedir localização da garagem ao servidor...")
            QBCore.Functions.TriggerCallback('gs_trucker:callback:getGarageLocation', function(loc)
                if loc and loc.x then
                    print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: ^2SUCESSO!^7 Coordenadas recebidas: ^3" .. json.encode(loc) .. "^7")
                    CurrentCompanyGarage = loc
                    updateBlip(PlayerCompanyId, loc)
                else
                    print("^1[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: ^1FALHA!^7 O servidor respondeu, mas as coordenadas são inválidas ou nulas.")
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

-- =============================================================================
-- LÓGICA DE INICIALIZAÇÃO (AGORA CHAMA A FUNÇÃO QUE JÁ EXISTE)
-- =============================================================================
CreateThread(function()
    -- Este loop espera até que os dados do jogador estejam disponíveis
    while not hasPlayerLoaded do
        if QBCore and QBCore.Functions.GetPlayerData().citizenid then
            print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: Dados do jogador carregados! A iniciar a verificação da garagem pela primeira vez.")
            hasPlayerLoaded = true -- Impede que o loop corra novamente
            Wait(2000) -- Uma pequena espera para garantir que outros scripts carregaram
            checkJobAndGarage()
        end
        Wait(1000) -- Tenta novamente a cada segundo
    end
end)

-- Mantemos o evento de atualização de emprego como um gatilho secundário
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: O emprego do jogador foi atualizado. A verificar novamente a garagem...")
    checkJobAndGarage()
end)

-- COMANDO DE DEBUG MANUAL
RegisterCommand('checkgarage', function()
    print("^3[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: O comando /checkgarage foi executado. A forçar a verificação.")
    checkJobAndGarage()
end, false)


function updateBlip(companyId, location)
    if BlipGaragem then RemoveBlip(BlipGaragem) end

    if location and companyId and companyId == PlayerCompanyId then
        print("^2[GS-TRUCKER DIAGNÓSTICO - CLIENTE]^7: A criar/atualizar o blip no mapa.")
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
                                QBCore.Functions.TriggerCallback('gs_trucker:callback:storeFleetVehicle', function(result)
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
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getFleetVehicles', function(vehicles)
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

RegisterNUICallback('gs_trucker:garage_selectVehicle', function(data, cb)
    if data and data.vehicleId then
        TriggerServerEvent('gs_trucker:server:requestSpawn', { vehicleId = data.vehicleId })
    end
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback('gs_trucker:garage_close', function(data, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
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

RegisterNetEvent('gs_trucker:client:spawnVehicle', function(vehicleData)
    QBCore.Functions.SpawnVehicle(vehicleData.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicleData.plate)
        SetEntityHeading(veh, CurrentCompanyGarage.h or 0.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        QBCore.Functions.Notify("Veículo retirado da garagem.", "success")
    end, CurrentCompanyGarage, true)
end)

RegisterNetEvent('gs_trucker:client:deleteVehicleByPlate', function(plate)
    local vehicles = GetGamePool('CVehicle')
    for _, veh in ipairs(vehicles) do
        if GetVehicleNumberPlateText(veh) == plate then
            QBCore.Functions.DeleteVehicle(veh)
            return
        end
    end
end)