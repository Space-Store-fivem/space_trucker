-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_missions.lua (VERSÃO DE DIAGNÓSTICO DE PROPS)

local QBCore = exports['qb-core']:GetCoreObject()
currentMission = nil
local missionPoints = { collect = nil, deliver = nil }
local activeCargoProps = {}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35); SetTextFont(4); SetTextProportional(1); SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING"); SetTextCentre(true); AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0); DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75); ClearDrawOrigin()
end

function clearMission()
    if missionPoints.collect then
        missionPoints.collect:remove()
        if missionPoints.collect.blip then RemoveBlip(missionPoints.collect.blip) end
        missionPoints.collect = nil
    end
    if missionPoints.deliver then
        missionPoints.deliver:remove()
        if missionPoints.deliver.blip then RemoveBlip(missionPoints.deliver.blip) end
        missionPoints.deliver = nil
    end
    for _, prop in ipairs(activeCargoProps) do
        if DoesEntityExist(prop) then DeleteEntity(prop) end
    end
    activeCargoProps = {}
    currentMission = nil
    QBCore.Functions.Notify("Missão cancelada.", "error")
end

RegisterNUICallback('getMissions', function(_, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissions', function(missions) cb(missions or {}) end)
end)

RegisterNUICallback('acceptMission', function(data, cb)
    if currentMission then QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error"); return end
    if not data or not data.id then cb({ success = false, message = "ID da missão inválido." }); return end

    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissionDetails', function(missionDetails)
        if missionDetails then
            TriggerEvent('gs_trucker:client:startMission', missionDetails)
            QBCore.Functions.Notify("Missão aceita! Verifique o seu mapa para o ponto de coleta.", "success")
            TriggerEvent('gs_trucker:client:toggleTablet', false)
            cb({ success = true })
        else
            QBCore.Functions.Notify("Esta missão já não está mais disponível.", "error")
            cb({ success = false })
        end
    end, data)
end)

RegisterNetEvent('gs_trucker:client:startMission', function(missionData)
    if currentMission then return end
    local sourceIndustry = Industries:GetIndustry(missionData.sourceIndustry)
    local destinationBusiness = Industries:GetIndustry(missionData.destinationBusiness)
    if not sourceIndustry or not destinationBusiness then QBCore.Functions.Notify("Erro ao iniciar a missão. Indústria não encontrada.", "error"); return end

    currentMission = missionData
    local collectPoint = Point.add({
        coords = sourceIndustry.location,
        distance = 5.0,
        onPedStanding = function()
            DrawMarker(2, sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z - 0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z, '[E] - Carregar Carga')
            if IsControlJustReleased(0, 38) then TriggerEvent('gs_trucker:client:attemptToLoadCargo') end
        end,
    })
    local blip = AddBlipForCoord(sourceIndustry.location)
    SetBlipSprite(blip, 477); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Coletar Carga (' .. missionData.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    collectPoint.blip = blip
    missionPoints.collect = collectPoint
end)

RegisterNetEvent('gs_trucker:client:attemptToLoadCargo', function()
    if not currentMission or not missionPoints.collect then return end
    local playerPed = PlayerPedId()
    local truck = GetVehiclePedIsIn(playerPed, false)
    if not truck or truck == 0 then QBCore.Functions.Notify("Você precisa estar em um veículo para carregar a carga.", "error"); return end

    local vehicleToCheck = truck
    if IsVehicleAttachedToTrailer(truck) then
        local _, trailer = GetVehicleAttachedToTrailer(truck)
        if trailer and trailer ~= 0 then vehicleToCheck = trailer end
    end

    local vehicleModelHash = GetEntityModel(vehicleToCheck)
    local modelName = GetDisplayNameFromVehicleModel(vehicleModelHash)
    local vehicleConfig

    for spawnName, config in pairs(spaceconfig.VehicleTransport) do
        if GetHashKey(tostring(spawnName)) == vehicleModelHash then
            vehicleConfig = config
            break
        end
        if tonumber(spawnName) and tonumber(spawnName) == vehicleModelHash then
            vehicleConfig = config
            break
        end
    end

    if not vehicleConfig then
        QBCore.Functions.Notify("Este veículo ("..modelName..") não é compatível com o sistema de cargas.", "error")
        return
    end
    
    local itemInfo = spaceconfig.IndustryItems[currentMission.item]
    local transportType = itemInfo.transType
    local transportTypeName = spaceconfig.VehicleTransportTypeLabel[transportType] or "Tipo Desconhecido"

    if not vehicleConfig.transType or not vehicleConfig.transType[transportType] then
        QBCore.Functions.Notify("O seu "..vehicleConfig.label.." não pode transportar este tipo de carga ("..transportTypeName..").", "error")
        return
    end

    TriggerEvent('gs_trucker:client:loadCargo', vehicleToCheck, vehicleConfig, itemInfo)
end)

RegisterNetEvent('gs_trucker:client:loadCargo', function(vehicle, config, item)
    print("--- DIAGNÓSTICO DE PROPS ---")
    local transportType = item.transType
    local transportTypeName = spaceconfig.VehicleTransportTypeLabel[transportType] or "Tipo Desconhecido"
    print("Tipo de transporte da missão: " .. transportTypeName .. " ("..tostring(transportType)..")")

    if transportType == spaceconfig.ItemTransportType.LIQUIDS or transportType == spaceconfig.ItemTransportType.LOOSE or transportType == spaceconfig.ItemTransportType.CONCRETE then
        print("Este tipo de carga não gera props. A ignorar a criação de props.")
    else
        if not config.props then
            print("ERRO DE PROPS: A configuração do veículo '"..config.label.."' não tem uma tabela 'props' definida em gst_config.lua.")
        elseif not config.props[transportType] then
            print("ERRO DE PROPS: A tabela 'props' do veículo '"..config.label.."' não tem uma entrada para o tipo de carga '"..transportTypeName.."'")
        else
            print("SUCESSO DE PROPS: Configuração de props encontrada para este veículo e tipo de carga. A criar os adereços...")
            local propModel = item.prop and item.prop.model or `hei_prop_heist_wooden_box`
            RequestModel(propModel); while not HasModelLoaded(propModel) do Wait(10) end
            local boneName = config.props.bone or 'chassis'
            local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
            if boneIndex == -1 then boneIndex = 0 end
            
            for i, pos in ipairs(config.props[transportType]) do
                print("A criar prop #"..i.." no veículo.")
                local prop = CreateObject(propModel, GetEntityCoords(vehicle), true, true, true)
                AttachEntityToEntity(prop, vehicle, boneIndex, pos.x, pos.y, pos.z, 0, 0, 0, true, true, false, true, 2, true)
                table.insert(activeCargoProps, prop)
            end
            SetModelAsNoLongerNeeded(propModel)
        end
    end
    print("--- FIM DO DIAGNÓSTICO DE PROPS ---")
    
    QBCore.Functions.Notify("Carga coletada! Siga para o ponto de entrega.", "primary")
    missionPoints.collect:remove(); RemoveBlip(missionPoints.collect.blip); missionPoints.collect = nil

    local destinationBusiness = Industries:GetIndustry(currentMission.destinationBusiness)
    local deliverPoint = Point.add({
        coords = destinationBusiness.location, distance = 5.0,
        onPedStanding = function()
            DrawMarker(2, destinationBusiness.location.x, destinationBusiness.location.y, destinationBusiness.location.z-0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(destinationBusiness.location.x, destinationBusiness.location.y, destinationBusiness.location.z, '[E] - Entregar Carga')
            if IsControlJustReleased(0, 38) then TriggerEvent('gs_trucker:client:finishShipping') end
        end,
    })
    local blip = AddBlipForCoord(destinationBusiness.location)
    SetBlipSprite(blip, 51); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Entregar Carga (' .. currentMission.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    deliverPoint.blip = blip
    missionPoints.deliver = deliverPoint
end)

RegisterNetEvent('gs_trucker:client:finishShipping', function()
    if not currentMission or not missionPoints.deliver then return end
    TriggerServerEvent('gs_trucker:server:missionCompleted', currentMission)
    QBCore.Functions.Notify("Entrega concluída! Reputação da empresa aumentada.", "success")
    clearMission()
end)

RegisterCommand('cancelarmissao', function()
    if currentMission then clearMission() end
end, false)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and currentMission then
        clearMission()
    end
end)