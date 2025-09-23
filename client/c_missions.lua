-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_missions.lua

local QBCore = exports['qb-core']:GetCoreObject()
local currentMission = nil
local missionPoints = { collect = nil, deliver = nil }
local activeCargoProps = {}

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35); SetTextFont(4); SetTextProportional(1); SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING"); SetTextCentre(true); AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0); DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75); ClearDrawOrigin()
end

local function clearMission()
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
end

RegisterNUICallback('getMissions', function(_, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissions', function(missions) cb(missions or {}) end)
end)

RegisterNUICallback('acceptMission', function(data, cb)
    if currentMission then QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error"); return end
    if not data or not data.id then cb({ success = false, message = "ID da missão inválido." }); return end

    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissionDetails', function(missionDetails)
        if missionDetails then
            startMission(missionDetails)
            QBCore.Functions.Notify("Missão aceita! Verifique o seu mapa para o ponto de coleta.", "success")
            TriggerEvent('gs_trucker:client:toggleTablet', false) -- << CORREÇÃO DO TABLET
            cb({ success = true })
        else
            QBCore.Functions.Notify("Esta missão já não está mais disponível.", "error")
            cb({ success = false })
        end
    end, data)
end)

function startMission(missionData)
    local sourceIndustry = Industries:GetIndustry(missionData.sourceIndustry)
    local destinationBusiness = Industries:GetIndustry(missionData.destinationBusiness)
    if not sourceIndustry or not destinationBusiness then QBCore.Functions.Notify("Erro ao iniciar a missão. Indústria não encontrada.", "error"); return end
    currentMission = missionData
    
    local collectPoint = Point.add({
        coords = sourceIndustry.location, distance = 5.0,
        onPedStanding = function()
            DrawMarker(2, sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z - 0.98, 0,0,0,0,0,0, 1.0, 1.0, 1.0, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(sourceIndustry.location.x, sourceIndustry.location.y, sourceIndustry.location.z, '[E] - Carregar Carga')
            if IsControlJustReleased(0, 38) then TriggerEvent('gs_trucker:client:startShipping') end
        end,
    })
    local blip = AddBlipForCoord(sourceIndustry.location)
    SetBlipSprite(blip, 477); SetBlipColour(blip, 2); SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString('Coletar Carga (' .. missionData.itemLabel .. ')'); EndTextCommandSetBlipName(blip)
    collectPoint.blip = blip
    missionPoints.collect = collectPoint
end

RegisterNetEvent('gs_trucker:client:startShipping', function()
    if not currentMission or not missionPoints.collect then return end
    local playerPed = PlayerPedId()
    local truck = GetVehiclePedIsIn(playerPed, false)
    if not truck then QBCore.Functions.Notify("Você precisa estar em um veículo para carregar a carga.", "error"); return end

    local vehicleToCheck = truck
    if IsVehicleAttachedToTrailer(truck) then
        local _, trailer = GetVehicleAttachedToTrailer(truck)
        if trailer and trailer ~= 0 then vehicleToCheck = trailer end
    end

    local vehicleModelHash = GetEntityModel(vehicleToCheck)
    local vehicleConfig
    for spawnName, config in pairs(spaceconfig.VehicleTransport) do
        if GetHashKey(spawnName) == vehicleModelHash then
            vehicleConfig = config
            print("[c_missions] Veículo compatível encontrado na config: " .. spawnName)
            break
        end
    end

    if not vehicleConfig then
        local modelName = GetDisplayNameFromVehicleModel(vehicleModelHash)
        QBCore.Functions.Notify("Este veículo ("..modelName..") não é compatível com o sistema de cargas.", "error")
        print("[c_missions] ERRO: O veículo "..modelName.." (hash: "..vehicleModelHash..") não foi encontrado no ficheiro de configuração.")
        return
    end
    
    local itemInfo = spaceconfig.IndustryItems[currentMission.item]
    local transportType = itemInfo.transType
    if not vehicleConfig.transType or not vehicleConfig.transType[transportType] then
        QBCore.Functions.Notify("Este veículo ("..vehicleConfig.label..") não pode transportar este tipo de carga.", "error")
        return
    end

    if transportType ~= spaceconfig.ItemTransportType.LIQUIDS and transportType ~= spaceconfig.ItemTransportType.LOOSE and transportType ~= spaceconfig.ItemTransportType.CONCRETE then
        if vehicleConfig.props and vehicleConfig.props[transportType] then
            local propModel = itemInfo.prop and itemInfo.prop.model or `hei_prop_heist_wooden_box`
            RequestModel(propModel); while not HasModelLoaded(propModel) do Wait(10) end
            local boneName = vehicleConfig.props.bone or 'chassis'
            local boneIndex = GetEntityBoneIndexByName(vehicleToCheck, boneName)
            if boneIndex == -1 then boneIndex = 0 end
            
            for _, pos in ipairs(vehicleConfig.props[transportType]) do
                local prop = CreateObject(propModel, GetEntityCoords(vehicleToCheck), true, true, true)
                AttachEntityToEntity(prop, vehicleToCheck, boneIndex, pos.x, pos.y, pos.z, 0, 0, 0, true, true, false, true, 2, true)
                table.insert(activeCargoProps, prop)
            end
            SetModelAsNoLongerNeeded(propModel)
        end
    end
    
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
    if currentMission then clearMission(); QBCore.Functions.Notify("Missão de transporte cancelada.", "error")
    else QBCore.Functions.Notify("Você não tem nenhuma missão ativa.", "primary") end
end, false)