-- space_trucker/client/c_missions.lua (VERSÃO FINAL COM CORREÇÃO DE DADOS)
local QBCore = exports['qb-core']:GetCoreObject()

currentMission = nil
currentLogisticsOrderId = nil -- Variável global para partilhar o estado da missão
local missionPoints = { collect = nil, deliver = nil, store = nil }
local activeCargoProps = { onVehicle = {}, onPlayer = nil }
local isPlayerCarryingMissionProp = false
local missionCargoLoaded = 0
local missionCargoDelivered = 0

local propOnGround = nil
local isActionInProgress = false
local missionVehicle = nil

local carryingAnimDict = "anim@heists@box_carry@"
local carryingAnimName = "idle"

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35); SetTextFont(4); SetTextProportional(1); SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING"); SetTextCentre(true); AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0); DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75); ClearDrawOrigin()
end

function clearMission()
    for _, point in pairs(missionPoints) do
        if point then point:remove(); if point.blip then RemoveBlip(point.blip) end end
    end
    missionPoints = { collect = nil, deliver = nil, store = nil }

    if activeCargoProps.onPlayer and DoesEntityExist(activeCargoProps.onPlayer) then DeleteEntity(activeCargoProps.onPlayer) end
    for _, prop in ipairs(activeCargoProps.onVehicle) do
        if DoesEntityExist(prop) then DeleteEntity(prop) end
    end
    activeCargoProps = { onVehicle = {}, onPlayer = nil }
    
    if propOnGround and DoesEntityExist(propOnGround.entity) then
        DeleteEntity(propOnGround.entity)
    end
    propOnGround = nil
    missionVehicle = nil

    if currentMission and currentMission.type == 'LOGISTICS_ORDER' then
        TriggerServerEvent('space_trucker:server:cancelLogisticsOrder', currentMission.orderId)
    end

    currentMission = nil
    isPlayerCarryingMissionProp = false
    missionCargoLoaded = 0
    missionCargoDelivered = 0
    isActionInProgress = false
    
    currentLogisticsOrderId = nil 
    SendNUIMessage({ action = 'setActiveLogisticsOrder', payload = nil }) 
    
    ClearPedTasks(PlayerPedId())
    QBCore.Functions.Notify("Missão cancelada.", "error")
end

CreateThread(function()
    while true do
        Wait(5)
        if propOnGround and DoesEntityExist(propOnGround.entity) then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local propCoords = GetEntityCoords(propOnGround.entity)
            local distance = #(playerCoords - propCoords)

            if distance < 2.0 then
                DrawText3D(propCoords.x, propCoords.y, propCoords.z + 0.5, "[E] - Apanhar Carga")
                if IsControlJustReleased(0, 38) and not isActionInProgress then
                    isActionInProgress = true
                    local propEntity = propOnGround.entity
                    local propData = propOnGround.data
                    propOnGround = nil
                    
                    if propData.isUnloading then
                        HandleUnloadingPropCarrying(propEntity, propData.vehicle)
                    else
                        HandlePropCarrying(propEntity, propData.vehicle, propData.config, propData.item)
                    end
                    isActionInProgress = false
                end
            end
        else
            Wait(500)
        end
    end
end)

RegisterNUICallback('getMissions', function(_, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:getMissions', function(missions) cb(missions or {}) end)
end)

RegisterNUICallback('acceptMission', function(data, cb)
    if currentMission then QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error"); return end
    if not data or not data.id then cb({ success = false, message = "ID da missão inválido." }); return end

    QBCore.Functions.TriggerCallback('space_trucker:callback:getMissionDetails', function(missionDetails)
        if missionDetails then
            TriggerEvent('space_trucker:client:startMission', missionDetails)
        else
            QBCore.Functions.Notify("Esta missão já não está mais disponível.", "error")
        end
    end, data)
end)

RegisterNetEvent('space_trucker:client:startMission', function(missionData)
    if currentMission then return end
    local sourceIndustry = Industries:GetIndustry(missionData.sourceIndustry)
    if not sourceIndustry then return end

    currentMission = missionData
    missionCargoLoaded = 0

    QBCore.Functions.Notify("Missão aceita! Verifique o seu mapa para o ponto de coleta.", "success")
    TriggerEvent('space_trucker:client:toggleTablet', false)

    missionPoints.collect = Point.add({
        coords = sourceIndustry.location,
        distance = 5.0,
        onPedStanding = function()
            DrawMarker(2, sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z - 0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z, '[E] - Coletar Carga')
            if IsControlJustReleased(0, 38) then TriggerEvent('space_trucker:client:attemptToLoadCargo') end
        end,
    })
    local blip = AddBlipForCoord(sourceIndustry.location)
    SetBlipSprite(blip, 477); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Coletar Carga (' .. missionData.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    missionPoints.collect.blip = blip
end)

RegisterNetEvent('space_trucker:client:startLogisticsMission', function(orderData)
    if currentMission then
        QBCore.Functions.Notify("Você já está numa missão. Termine-a primeiro.", "error")
        return
    end

    local pickupCoords = json.decode(orderData.pickup_location)
    local dropoffCoords = json.decode(orderData.dropoff_location)
    
    currentMission = {
        pickup = vector3(pickupCoords.x, pickupCoords.y, pickupCoords.z),
        dropoff = vector3(dropoffCoords.x, dropoffCoords.y, dropoffCoords.z),
        item = orderData.item_name,
        amount = orderData.quantity,
        itemLabel = orderData.item_label,
        reward = orderData.reward,
        type = 'LOGISTICS_ORDER',
        orderId = orderData.id,
        -- [[ CORREÇÃO ADICIONADA AQUI ]] --
        sourceIndustry = orderData.source_industry_name,
        destinationBusiness = orderData.destination_industry_name
    }
    missionCargoLoaded = 0
    
    currentLogisticsOrderId = orderData.id 
    SendNUIMessage({ action = 'setActiveLogisticsOrder', payload = currentLogisticsOrderId })
    
    QBCore.Functions.Notify(("Nova encomenda aceite! Recolha %d caixas de %s."):format(currentMission.amount, currentMission.itemLabel), "success")
    TriggerEvent('space_trucker:client:toggleTablet', false)

    missionPoints.collect = Point.add({
        coords = currentMission.pickup,
        distance = 5.0,
        onPedStanding = function()
            DrawMarker(2, currentMission.pickup.x, currentMission.pickup.y, currentMission.pickup.z - 0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(currentMission.pickup.x, currentMission.pickup.y, currentMission.pickup.z, '[E] - Coletar Carga')
            if IsControlJustReleased(0, 38) then TriggerEvent('space_trucker:client:attemptToLoadCargo') end
        end,
    })
    local blip = AddBlipForCoord(currentMission.pickup)
    SetBlipSprite(blip, 477); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Coletar Carga (' .. currentMission.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    missionPoints.collect.blip = blip
end)

RegisterNetEvent('space_trucker:client:attemptToLoadCargo', function()
    if not currentMission or isPlayerCarryingMissionProp or isActionInProgress then return end
    isActionInProgress = true

    local itemInfo = spaceconfig.IndustryItems[currentMission.item]
    local transportType = itemInfo.transType
    local playerPed = PlayerPedId()
    local vehicleToCheck

    if transportType == spaceconfig.ItemTransportType.CRATE or transportType == spaceconfig.ItemTransportType.STRONGBOX then
        vehicleToCheck = GetClosestVehicle(GetEntityCoords(playerPed), 15.0, 0, 70)
        if not DoesEntityExist(vehicleToCheck) then 
            QBCore.Functions.Notify("Você precisa de um veículo de carga por perto.", "error")
            isActionInProgress = false
            return 
        end
    else
        local truckCab = GetVehiclePedIsIn(playerPed, false)
        if not DoesEntityExist(truckCab) then 
            QBCore.Functions.Notify("Você precisa estar dentro do seu veículo de carga.", "error")
            isActionInProgress = false
            return
        end
        if IsVehicleAttachedToTrailer(truckCab) then
            local isTrailer, trailer = GetVehicleTrailerVehicle(truckCab); if isTrailer then vehicleToCheck = trailer else vehicleToCheck = truckCab end
        else
            vehicleToCheck = truckCab
        end
    end

    local vehicleModelHash = GetEntityModel(vehicleToCheck)
    local modelName = GetDisplayNameFromVehicleModel(vehicleModelHash)
    local vehicleConfig

    for spawnName, config in pairs(spaceconfig.VehicleTransport) do
        if GetHashKey(tostring(spawnName)) == vehicleModelHash or (tonumber(spawnName) and tonumber(spawnName) == vehicleModelHash) then
            vehicleConfig = config
            break
        end
    end

    if not vehicleConfig then 
        QBCore.Functions.Notify("Este veículo ("..modelName..") não é compatível.", "error")
        isActionInProgress = false
        return 
    end
    if not vehicleConfig.transType or not vehicleConfig.transType[transportType] then 
        QBCore.Functions.Notify("O seu "..vehicleConfig.label.." não pode transportar este tipo de carga.", "error")
        isActionInProgress = false
        return 
    end

    if transportType == spaceconfig.ItemTransportType.CRATE or transportType == spaceconfig.ItemTransportType.STRONGBOX then
        TriggerEvent('space_trucker:client:startManualLoading', vehicleToCheck, vehicleConfig, itemInfo)
    else
        TriggerEvent('space_trucker:client:startAutomaticLoading', vehicleToCheck, vehicleConfig, itemInfo)
    end
end)

function HandlePropCarrying(prop, vehicle, config, item)
    RequestAnimDict(carryingAnimDict); while not HasAnimDictLoaded(carryingAnimDict) do Wait(100) end
    
    local playerPed = PlayerPedId()
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, item.prop.boneId or 28422), item.prop.x or -0.05, item.prop.y or 0.0, item.prop.z or -0.10, item.prop.rx or 0.0, item.prop.ry or 0.0, item.prop.rz or 0.0, true, true, false, true, 2, true)
    TaskPlayAnim(playerPed, carryingAnimDict, carryingAnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
    isPlayerCarryingMissionProp = true
    activeCargoProps.onPlayer = prop
    isActionInProgress = false

    local trunkOffset = GetOffsetFromEntityInWorldCoords(vehicle, config.trunkOffset or vector3(0.0, -2.5, 0.5))
    missionPoints.store = Point.add({
        coords = trunkOffset, distance = 2.5,
        onPedStanding = function()
            DrawText3D(trunkOffset.x, trunkOffset.y, trunkOffset.z, "[E] Guardar Carga")
            if IsControlJustReleased(0, 38) then
                DetachEntity(prop, false, false)
                local propPos = missionCargoLoaded + 1
                if config.props and config.props[item.transType] and config.props[item.transType][propPos] then
                    local boneName = config.props.bone or 'chassis'
                    local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
                    if boneIndex == -1 then boneIndex = 0 end
                    local pos = config.props[item.transType][propPos]
                    AttachEntityToEntity(prop, vehicle, boneIndex, pos.x, pos.y, pos.z, 0, 0, 0, true, true, false, true, 2, true)
                    table.insert(activeCargoProps.onVehicle, prop)
                else
                    DeleteEntity(prop)
                end
                
                ClearPedTasks(playerPed)
                isPlayerCarryingMissionProp = false
                activeCargoProps.onPlayer = nil
                missionCargoLoaded = missionCargoLoaded + 1
                QBCore.Functions.Notify("Caixa guardada ("..missionCargoLoaded.."/"..currentMission.amount..").", "success")

                if missionPoints.store then missionPoints.store:remove(); missionPoints.store = nil end
                if missionCargoLoaded >= currentMission.amount then
                    TriggerEvent("space_trucker:client:startDeliveryPhase", vehicle)
                else
                    QBCore.Functions.Notify("Volte ao ponto de coleta para pegar a próxima caixa.", "primary")
                end
            end
        end
    })

    CreateThread(function()
        while isPlayerCarryingMissionProp and DoesEntityExist(prop) do
            Wait(0)
            if IsControlJustReleased(0, 47) then -- Tecla G para dropar
                local playerPed = PlayerPedId()
                DetachEntity(prop, true, true)
                PlaceObjectOnGroundProperly(prop)
                propOnGround = {
                    entity = prop,
                    data = { vehicle = vehicle, config = config, item = item, isUnloading = false }
                }
                ClearPedTasks(playerPed)
                isPlayerCarryingMissionProp = false
                activeCargoProps.onPlayer = nil
                if missionPoints.store then missionPoints.store:remove(); missionPoints.store = nil end
                break
            end
        end
    end)
end

function HandleUnloadingPropCarrying(prop, vehicle)
    RequestAnimDict(carryingAnimDict); while not HasAnimDictLoaded(carryingAnimDict) do Wait(100) end
    
    local playerPed = PlayerPedId()
    local item = spaceconfig.IndustryItems[currentMission.item]
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, item.prop.boneId or 28422), item.prop.x or -0.05, item.prop.y or 0.0, item.prop.z or -0.10, item.prop.rx or 0.0, item.prop.ry or 0.0, item.prop.rz or 0.0, true, true, false, true, 2, true)
    TaskPlayAnim(playerPed, carryingAnimDict, carryingAnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
    isPlayerCarryingMissionProp = true
    activeCargoProps.onPlayer = prop
end

RegisterNetEvent('space_trucker:client:startManualLoading', function(vehicle, config, item)
    QBCore.Functions.Progressbar("load_mission_crate", "Apanhando a caixa...", 1500, false, true, {}, {}, {}, {}, function()
        local playerPed = PlayerPedId()
        local propModel = item.prop and item.prop.model or `hei_prop_heist_wooden_box`
        RequestModel(propModel); while not HasModelLoaded(propModel) do Wait(10) end
        
        local prop = CreateObject(propModel, GetEntityCoords(playerPed), true, true, true)
        HandlePropCarrying(prop, vehicle, config, item)
    end, function() 
        QBCore.Functions.Notify("Falhou ao apanhar a caixa.", "error")
        isActionInProgress = false
    end)
end)

RegisterNetEvent('space_trucker:client:startAutomaticLoading', function(vehicle, config, item)
    QBCore.Functions.Progressbar("load_mission_auto", "A carregar o veículo...", 5000, false, true, {}, {}, {}, {}, function()
        if item.transType ~= spaceconfig.ItemTransportType.LIQUIDS and item.transType ~= spaceconfig.ItemTransportType.LOOSE and item.transType ~= spaceconfig.ItemTransportType.CONCRETE then
            if config.props and config.props[item.transType] then
                local propModel = item.prop and item.prop.model or `hei_prop_heist_wooden_box`; RequestModel(propModel)
                while not HasModelLoaded(propModel) do Wait(10) end
                local boneName = config.props.bone or 'chassis'; local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
                if boneIndex == -1 then boneIndex = 0 end
                for _, pos in ipairs(config.props[item.transType]) do
                    local prop = CreateObject(propModel, GetEntityCoords(vehicle), true, true, true)
                    AttachEntityToEntity(prop, vehicle, boneIndex, pos.x, pos.y, pos.z, 0, 0, 0, true, true, false, true, 2, true)
                    table.insert(activeCargoProps.onVehicle, prop)
                end
                SetModelAsNoLongerNeeded(propModel)
            end
        end
        TriggerEvent("space_trucker:client:startDeliveryPhase", vehicle)
        isActionInProgress = false
    end, function() 
        QBCore.Functions.Notify("Carregamento cancelado.", "error")
        isActionInProgress = false
    end)
end)

RegisterNetEvent("space_trucker:client:startDeliveryPhase", function(vehicle)
    missionVehicle = vehicle
    missionCargoDelivered = 0
    QBCore.Functions.Notify("Carga completa! Siga para o ponto de entrega.", "primary")
    if missionPoints.collect then missionPoints.collect:remove(); if missionPoints.collect.blip then RemoveBlip(missionPoints.collect.blip) end; missionPoints.collect = nil end

    local destinationCoords = currentMission.dropoff or (Industries:GetIndustry(currentMission.destinationBusiness) and Industries:GetIndustry(currentMission.destinationBusiness).location)
    if not destinationCoords then
        QBCore.Functions.Notify("Erro: Destino da missão não encontrado.", "error")
        clearMission()
        return
    end

    missionPoints.deliver = Point.add({
        coords = destinationCoords, distance = 7.0,
        onPedStanding = function()
            if not currentMission then return end

            DrawMarker(2, destinationCoords.x, destinationCoords.y, destinationCoords.z-0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
            local itemInfo = spaceconfig.IndustryItems[currentMission.item]
            local isManual = itemInfo.transType == spaceconfig.ItemTransportType.CRATE or itemInfo.transType == spaceconfig.ItemTransportType.STRONGBOX

            if isManual then
                if isPlayerCarryingMissionProp then
                    DrawText3D(destinationCoords.x, destinationCoords.y, destinationCoords.z, '[E] - Entregar Caixa')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('space_trucker:client:deliverManualCrate')
                    end
                else
                    DrawText3D(destinationCoords.x, destinationCoords.y, destinationCoords.z, 'Vá até seu veículo para descarregar a carga.')
                end
            else
                DrawText3D(destinationCoords.x, destinationCoords.y, destinationCoords.z, '[E] - Entregar Carga')
                if IsControlJustReleased(0, 38) then TriggerEvent('space_trucker:client:finishShipping') end
            end
        end,
    })
    local blip = AddBlipForCoord(destinationCoords); SetBlipSprite(blip, 51); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Entregar Carga (' .. currentMission.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    missionPoints.deliver.blip = blip

    local itemInfo = spaceconfig.IndustryItems[currentMission.item]
    if itemInfo.transType == spaceconfig.ItemTransportType.CRATE or itemInfo.transType == spaceconfig.ItemTransportType.STRONGBOX then
        CreateThread(function()
            while missionPoints.deliver do
                Wait(5)
                if DoesEntityExist(missionVehicle) and missionCargoDelivered < currentMission.amount then
                    local vehicleConfig
                    local vehicleModelHash = GetEntityModel(missionVehicle)
                    for spawnName, config in pairs(spaceconfig.VehicleTransport) do
                        if GetHashKey(tostring(spawnName)) == vehicleModelHash or (tonumber(spawnName) and tonumber(spawnName) == vehicleModelHash) then
                            vehicleConfig = config
                            break
                        end
                    end

                    if vehicleConfig then
                        local trunkOffset = GetOffsetFromEntityInWorldCoords(missionVehicle, vehicleConfig.trunkOffset or vector3(0.0, -2.5, 0.5))
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local distance = #(playerCoords - trunkOffset)

                        if distance < 2.5 and not isPlayerCarryingMissionProp then
                            DrawText3D(trunkOffset.x, trunkOffset.y, trunkOffset.z, "[E] - Retirar Caixa")
                            if IsControlJustReleased(0, 38) and not isActionInProgress then
                                isActionInProgress = true
                                QBCore.Functions.Progressbar("unload_crate_from_truck", "Retirando a caixa...", 1500, false, true, {}, {}, {}, {}, function()
                                    local prop
                                    if #activeCargoProps.onVehicle > 0 then
                                        prop = table.remove(activeCargoProps.onVehicle)
                                    else
                                        local propModel = itemInfo.prop and itemInfo.prop.model or `hei_prop_heist_wooden_box`
                                        RequestModel(propModel); while not HasModelLoaded(propModel) do Wait(10) end
                                        prop = CreateObject(propModel, GetEntityCoords(PlayerPedId()), true, true, true)
                                    end

                                    if DoesEntityExist(prop) then
                                        DetachEntity(prop, true, true)
                                        HandleUnloadingPropCarrying(prop, missionVehicle)
                                    end
                                    isActionInProgress = false
                                end, function()
                                    QBCore.Functions.Notify("Falha ao retirar a caixa.", "error")
                                    isActionInProgress = false
                                end)
                            end
                        end
                    end
                else
                    Wait(500)
                end
            end
        end)
    end
end)

RegisterNetEvent('space_trucker:client:deliverManualCrate', function()
    if not isPlayerCarryingMissionProp or not activeCargoProps.onPlayer then return end

    local prop = activeCargoProps.onPlayer
    DeleteEntity(prop)
    ClearPedTasks(PlayerPedId())

    isPlayerCarryingMissionProp = false
    activeCargoProps.onPlayer = nil

    missionCargoDelivered = missionCargoDelivered + 1
    local remaining = currentMission.amount - missionCargoDelivered
    
    QBCore.Functions.Notify("Caixa entregue! Restam " .. remaining .. " caixas.", "success")

    if remaining <= 0 then
        QBCore.Functions.Notify("Todas as caixas foram entregues!", "success")
        
        if currentMission.type == 'LOGISTICS_ORDER' then
            TriggerServerEvent('space_trucker:server:completeLogisticsOrder', currentMission)
        else
            TriggerServerEvent('space_trucker:server:missionCompleted', currentMission)
            QBCore.Functions.Notify("Entrega concluída! Reputação da empresa aumentada.", "success")
        end
        clearMission()
    else
        QBCore.Functions.Notify("Volte ao veículo para pegar a próxima caixa.", "primary")
    end
end)

RegisterNetEvent('space_trucker:client:finishShipping', function()
    if not currentMission or not missionPoints.deliver then return end
    
    local itemInfo = spaceconfig.IndustryItems[currentMission.item]
    local transportType = itemInfo.transType
    if transportType == spaceconfig.ItemTransportType.CRATE or transportType == spaceconfig.ItemTransportType.STRONGBOX then
        QBCore.Functions.Notify("Você precisa entregar as caixas uma a uma no ponto.", "error")
        return
    end
    
    local totalProps = #activeCargoProps.onVehicle
    local unloadTime = totalProps * 300 + 2000

    QBCore.Functions.Progressbar("unload_mission_props", "A descarregar a carga...", unloadTime, false, true, {
        disableMovement = true, disableCarMovement = true,
    }, {}, {}, {}, function()
        if currentMission.type == 'LOGISTICS_ORDER' then
            TriggerServerEvent('space_trucker:server:completeLogisticsOrder', currentMission)
        else
            TriggerServerEvent('space_trucker:server:missionCompleted', currentMission)
            QBCore.Functions.Notify("Entrega concluída! Reputação da empresa aumentada.", "success")
        end
        clearMission()
    end, function()
        QBCore.Functions.Notify("Descarga cancelada.", "error")
    end)

    CreateThread(function()
        if totalProps > 0 then
            local interval = unloadTime / totalProps
            for i = totalProps, 1, -1 do
                local prop = activeCargoProps.onVehicle[i]
                if DoesEntityExist(prop) then
                    DeleteEntity(prop)
                    table.remove(activeCargoProps.onVehicle, i)
                end
                Wait(interval)
            end
        end
    end)
end)

RegisterCommand('cancelarmissao', function()
    if currentMission then clearMission() end
end, false)