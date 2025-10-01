-- Encrypt File
-- Variables
local modalResponse = nil
local truckRentalData = {}

--
RegisterNUICallback('loadLocale', function(_, cb)
    cb(1)
    local JSON = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(spaceconfig.Locale)) or
        LoadResourceFile(GetCurrentResourceName(), 'locales/en.json')

    SendNUIMessage({
        action = 'setLocale',
        data = json.decode(JSON).ui
    })
end)

RegisterNUICallback('loadTruckHandbook', function(_, cb)
    cb(spaceconfig.TruckerHandbook)
end)

RegisterNUICallback('loadTruckRental', function(_, cb)
    if not next(truckRentalData) then
        for _, value in pairs(spaceconfig.VehicleRentLocations) do
            if not value.private then
                truckRentalData[#truckRentalData + 1] = {
                    id = value.id,
                    title = value.title,
                    description = value.description,
                }
            end
        end
        table.sort(truckRentalData, function(a, b)
            return a.id < b.id
        end)
    end

    cb(truckRentalData)
end)

RegisterNUICallback('loadIndustryList', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())

    local listData = {}
    local typeList = Industries:GetIndustryTypeList(data.industryTier)
    local allIndustries = Industries:GetIndustries()

    for key, value in pairs(typeList) do
        local buildData = {
            typeId = value,
            title = GetIndustryTypeLabel(data.industryTier, value),
            locations = {}
        }

        local locations = {}

        ---@param v Industry
        for k, v in pairs(allIndustries) do
            if v.tier == data.industryTier and v.type == value then
                locations[#locations + 1] = {
                    id = v.name,
                    title = v.label,
                    x = v.location.x,
                    y = v.location.y
                }
            end
        end

        buildData.locations = locations

        listData[#listData + 1] = buildData
    end

    table.sort(listData, function(a, b)
        return a.title < b.title
    end)


    local returnData = {
        tier = data.industryTier,
        userCoord = {
            x = coords.x,
            y = coords.y,
        },
        list = listData
    }
    cb(returnData)
end)

RegisterNUICallback('loadIndustryInformation', function(data, cb)
    local information = GetIndustryInformation(data.industryId)
    cb(information)
end)

--- [[ INÍCIO DA CORREÇÃO IMPORTANTE ]] ---
RegisterNUICallback('loadVehicleCapacityList', function(data, cb)
    local vehicle_capacities = {}
    for k, v in pairs(spaceconfig.VehicleTransport) do
        -- Criar uma cópia profunda de 'v.transType' para evitar corromper a tabela original
        local transTypeCopy = {}
        for transKey, transVal in pairs(v.transType) do
            transTypeCopy[transKey] = transVal
        end

        vehicle_capacities[#vehicle_capacities + 1] = {
            image = spaceconfig.VehicleImageUrl:format(v.name),
            name = v.label,
            capacity = v.capacity,
            -- Usar a cópia em vez da original
            transType = GetVehicleTransportTypeLabel(transTypeCopy),
            level = v.level or 1
        }
    end

    table.sort(vehicle_capacities, function(a, b)
        return a.level < b.level
    end)

    cb(vehicle_capacities)
end)
--- [[ FIM DA CORREÇÃO IMPORTANTE ]] ---

RegisterNUICallback('hideFrame', function(data, cb)
    cb(1)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    if data.visibleType == spaceconfig.NUIVisibleType.MODAL then
        OnModalResponse(data)
    elseif data.visibleType == spaceconfig.NUIVisibleType.VEHICLE_STORAGE then
        OnVehicleStorageUnloadResponse(data)
    elseif data.visibleType == spaceconfig.NUIVisibleType.TRUCKER_PDA then
        ToggleTablet(false)
    end
end)

RegisterNUICallback('toggleModalConfirm', function(data, cb)
    cb(1)
    local toggle = data.toggle == true and spaceconfig.ToggleModalConfirmKvp.on or spaceconfig.ToggleModalConfirmKvp.off
    SetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key, toggle)
end)

RegisterNUICallback('navigateIndustryStorage', function(data, cb)
    cb(1)
    local industry = Industries:GetIndustry(data.industryName)
    if not industry then return end
    local location
    if data.tradeType == spaceconfig.Industry.TradeType.FORSALE then
        location = industry.forSaleLocation[data.storageName]
    else
        location = industry.wantedLocation[data.storageName]
    end

    if not location then return end
    SetNewWaypoint(location.x, location.y)
end)

RegisterNUICallback('navigateTruckRental', function(data, cb)
    cb(1)
    -- rentalId
    local rentPoint = spaceconfig.VehicleRentLocations[data.rentalId]
    if not rentPoint then return end
    SetNewWaypoint(rentPoint.location.x, rentPoint.location.y)
end)
-- Events

-- Functions
function ShowVehicleStorage(entity, vehicleStorageData)
    local prepareStorage = {}
    for key, value in pairs(vehicleStorageData.storage) do
        if value and next(value) then
            prepareStorage[#prepareStorage + 1] = value
        end
    end

    local _vehicleStorage = {
        vehEntity = entity,
        maxCapacity = vehicleStorageData.maxCapacity,
        currentCapacity = vehicleStorageData.currentCapacity,
        transType = vehicleStorageData.transType,
        storage = prepareStorage
    }

    SendNUIMessage({
        action = 'sendVehicleStorage',
        data = {
            vehicleStorage = _vehicleStorage
        }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
end

function OnVehicleStorageUnloadResponse(data)
    if not data.confirm then return end
    local _itemName = data.itemName
    local _vehEntity = data.vehEntity
    OnPlayerUnloadFromVehicleStorage(_vehEntity, _itemName)
end

function ShowModal(args)
    if modalResponse then return end

    modalResponse = promise.new();
    SendNUIMessage({
        action = 'sendIndustryModal',
        data = {
            modalData = {
                type = args.type, --0 confirm, 1 dialog
                title = args.title,
                description = args.description,
                extraArgs = args.extraArgs
            }
        }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)

    return Citizen.Await(modalResponse);
end

function OnModalResponse(data)
    local promise = modalResponse
    modalResponse = nil
    if promise then
        promise:resolve(data)
    end
end

-- Adicione este código no final de client/c_nui.lua

RegisterNetEvent('gs_trucker:client:closeCompanyPanel', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closePanel' -- A interface irá ouvir esta ação
    })
end)

-- Adicione este código no final de c_nui.lua

-- [[ CORREÇÃO APLICADA AQUI ]] --
-- Callback para o Painel de Monitoramento da Economia
-- Ouve o pedido 'getIndustryStatus' vindo da interface (IndustryMonitor.tsx)
RegisterNUICallback('getIndustryStatus', function(_, cb)
    -- Pede os dados ao servidor usando o callback que já criámos
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getIndustryStatus', function(statusData)
        -- Envia os dados recebidos do servidor de volta para a interface
        cb(statusData or {})
    end)
end)