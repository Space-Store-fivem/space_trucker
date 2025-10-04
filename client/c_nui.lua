-- =================================================================
-- ARQUIVO client/c_nui.lua (VERSÃO FINAL E LIMPA)
-- =================================================================

local modalResponse = nil

-- Carrega o ficheiro de tradução para a interface
RegisterNUICallback('loadLocale', function(_, cb)
    cb(1)
    local JSON = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(spaceconfig.Locale)) or LoadResourceFile(GetCurrentResourceName(), 'locales/en.json')
    SendNUIMessage({
        action = 'setLocale',
        data = json.decode(JSON).ui
    })
end)

-- Pede ao servidor informações detalhadas de uma indústria
RegisterNUICallback('loadIndustryInformation', function(data, cb)
    local information = GetIndustryInformation(data.industryId)
    cb(information)
end)

-- Callback geral para fechar qualquer painel NUI
RegisterNUICallback('hideFrame', function(data, cb)
    cb(1)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    if data.visibleType == spaceconfig.NUIVisibleType.MODAL then
        OnModalResponse(data)
    elseif data.visibleType == spaceconfig.NUIVisibleType.VEHICLE_STORAGE then
        OnVehicleStorageUnloadResponse(data)
    end
end)

-- Ouve o pedido do "Monitor da Economia" no tablet e pede os dados ao servidor
RegisterNUICallback('getIndustryStatus', function(_, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:getIndustryStatus', function(statusData)
        cb(statusData or {})
    end)
end)

-- Evento para fechar o painel da empresa
RegisterNetEvent('space_trucker:client:closeCompanyPanel', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closePanel' })
end)


-- Funções para mostrar os painéis NUI

function ShowVehicleStorage(entity, vehicleStorageData)
    local prepareStorage = {}
    for key, value in pairs(vehicleStorageData.storage) do
        if value and next(value) then
            table.insert(prepareStorage, value)
        end
    end

    local _vehicleStorage = {
        vehEntity = entity,
        maxCapacity = vehicleStorageData.maxCapacity,
        currentCapacity = vehicleStorageData.currentCapacity,
        storage = prepareStorage
    }

    SendNUIMessage({
        action = 'sendVehicleStorage',
        data = { vehicleStorage = _vehicleStorage }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
end

function OnVehicleStorageUnloadResponse(data)
    if not data.confirm then return end
    OnPlayerUnloadFromVehicleStorage(data.vehEntity, data.itemName)
end

function ShowModal(args)
    if modalResponse then return end
    modalResponse = promise.new()
    SendNUIMessage({
        action = 'sendIndustryModal',
        data = {
            modalData = {
                type = args.type,
                title = args.title,
                description = args.description,
                extraArgs = args.extraArgs
            }
        }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    return Citizen.Await(modalResponse)
end

function OnModalResponse(data)
    local promise = modalResponse
    modalResponse = nil
    if promise then
        promise:resolve(data)
    end
end