-- =================================================================
-- ARQUIVO server/s_main.lua (VERSÃO FINAL E LIMPA)
-- =================================================================

local playersCarryItemData = {}
local vehiclesCarryItemData = {}
local vehiclePropData = {}

-- Funções do Jogador
local function addPlayerCarryItem(source, _itemName, _itemPrice, _industryName, _addTime)
    playersCarryItemData[source] = { itemName = _itemName, industryName = _industryName, buyPrice = _itemPrice, addTime = _addTime }
    TriggerClientEvent('space_trucker:client:addPlayerCarryData', source, { isCarry = true, carryItemName = _itemName, carryItemPrice = _itemPrice, carryItemFromIndustry = _industryName })
end

local function removePlayerCarryItem(source)
    playersCarryItemData[source] = nil
    TriggerClientEvent('space_trucker:client:addPlayerCarryData', source, { isCarry = false, carryItemName = '', carryItemPrice = 0, carryItemFromIndustry = '' })
end

-- Funções do Veículo
local function getVehicleModelMaxCapacity(_vehicleModel) return config.VehicleTransport[_vehicleModel] and config.VehicleTransport[_vehicleModel].capacity or 0 end
local function getCurrentVehicleCarryCapacity(_vehicleCarryItemData)
    local capacity = 0
    if _vehicleCarryItemData then for _, value in pairs(_vehicleCarryItemData) do capacity = capacity + (value.capacity * value.amount) end end
    return capacity
end

local function addVehicleItem(_vehicleModel, _vehiclePlate, _itemData, _amount)
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclesCarryItemData[vehKey] then vehiclesCarryItemData[vehKey] = {} end
    local _itemName = _itemData.itemName
    if not vehiclesCarryItemData[vehKey][_itemName] then
        local _defaultItemData = config.IndustryItems[_itemName]
        vehiclesCarryItemData[vehKey][_itemName] = {
            itemName = _itemName, industryName = _itemData.industryName,
            itemLabel = Lang:t(_defaultItemData.label), industryLabel = Industries:GetIndustryLabel(_itemData.industryName),
            transUnit = Lang:t(config.ItemTransportUnit[_defaultItemData.transType]),
            buyPrice = _itemData.buyPrice, amount = _amount,
            capacity = _defaultItemData.capacity, addTime = _itemData.addTime or os.time()
        }
    else
        vehiclesCarryItemData[vehKey][_itemName].amount = vehiclesCarryItemData[vehKey][_itemName].amount + _amount
        if _itemData.buyPrice < vehiclesCarryItemData[vehKey][_itemName].buyPrice then
            vehiclesCarryItemData[vehKey][_itemName].buyPrice = _itemData.buyPrice
        end
    end
    return true
end

local function removeVehicleItem(_vehicleModel, _vehiclePlate, _itemName, _amount)
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    if not (vehiclesCarryItemData[vehKey] and vehiclesCarryItemData[vehKey][_itemName]) then return false end
    if vehiclesCarryItemData[vehKey][_itemName].amount > _amount then
        vehiclesCarryItemData[vehKey][_itemName].amount = vehiclesCarryItemData[vehKey][_itemName].amount - _amount
    else
        vehiclesCarryItemData[vehKey][_itemName] = nil
    end
    return true
end

local function getVehicleStorageData(_vehicleModel, _vehiclePlate)
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    local data = {
        maxCapacity = getVehicleModelMaxCapacity(_vehicleModel),
        currentCapacity = getCurrentVehicleCarryCapacity(vehiclesCarryItemData[vehKey]),
        storage = vehiclesCarryItemData[vehKey] or {}
    }
    return data
end

local function addVehicleProp(_vehicleModel, _vehiclePlate, _vehCoords, _itemTransType, _itemPropModel)
    if not (config.AddVehicleProps and _itemPropModel and config.VehicleTransport[_vehicleModel].props and config.VehicleTransport[_vehicleModel].props[_itemTransType]) then return false end
    local propVeh = config.VehicleTransport[_vehicleModel].props
    local propSlots = propVeh[_itemTransType]
    local vehPropKey = _vehiclePlate .. '_' .. _vehicleModel
    local currentCapacity = getCurrentVehicleCarryCapacity(vehiclesCarryItemData[vehPropKey])
    if not vehiclePropData[vehPropKey] then vehiclePropData[vehPropKey] = {} end
    for i = 1, currentCapacity, 1 do
        if not vehiclePropData[vehPropKey][i] and propSlots[i] then
            local object = CreateObject(_itemPropModel, _vehCoords - 10.0, true, true, false)
            while not DoesEntityExist(object) do Wait(0) end
            vehiclePropData[vehPropKey][i] = {
                slot = i, position = propSlots[i],
                rot = propSlots[i].rx and vector3(propSlots[i].rx, propSlots[i].ry, propSlots[i].rz) or vector3(0.0, 0.0, 0.0),
                bone = propVeh.bone, boneIndex = propVeh.boneIndex,
                objectNetId = NetworkGetNetworkIdFromEntity(object), model = _itemPropModel
            }
            return vehiclePropData[vehPropKey][i]
        end
    end
    return false
end

local function removeVehicleProp(_vehicleModel, _vehiclePlate, _itemPropModel)
    local vehPropKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclePropData[vehPropKey] then return false end
    local topSlot = 0
    for _, value in pairs(vehiclePropData[vehPropKey]) do
        if value.slot > topSlot and value.model == _itemPropModel then topSlot = value.slot end
    end
    if topSlot ~= 0 then
        DeleteEntity(NetworkGetEntityFromNetworkId(vehiclePropData[vehPropKey][topSlot].objectNetId))
        vehiclePropData[vehPropKey][topSlot] = nil
    end
end

local function checkVehicleCanAddItemToStorage(storageData, _industryTradeItemName)
    if not storageData then return { status = false, msg = Lang:t('error_when_buy_item') } end
    if storageData.currentCapacity > 0 then
        for itemName, _ in pairs(storageData.storage) do
            if not IsItemTransportTypeCanMix(config.IndustryItems[itemName].transType) and itemName ~= _industryTradeItemName then
                return { status = false, msg = Lang:t('currently_another_type_of_cargo') }
            end
        end
    end
    return { status = true }
end

local function checkVehicleAndPlayerDistance(source, vehicleEntity)
    local vehCoords, playerCoords = GetEntityCoords(vehicleEntity), GetEntityCoords(GetPlayerPed(source))
    if #(playerCoords.xy - vehCoords.xy) > config.MaxServerVehicleDistanceCheck then
        return { status = false, msg = Lang:t('distance_too_far') }
    end
    return { status = true }
end

-- Callbacks
CreateCallback('space_trucker:callback:loadIndustriesTradeData', function(source, cb)
    local data = {}
    for _, industry in pairs(Industries:GetIndustries()) do data[industry.name] = industry.tradeData end
    return cb(data)
end)

CreateCallback('space_trucker:callback:buyItem', function(source, cb, _tradeState, _industryName, _industryTradeItemName, _extendArgs)
    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then return cb({ status = false, msg = Lang:t('not_found_industry') }) end
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local industryTradePointCoords = industryData.forSaleLocation[_industryTradeItemName]
    if not industryTradePointCoords or #(playerCoords - industryTradePointCoords) > 5 then
        return cb({ status = false, msg = Lang:t('distance_too_far') })
    end
    local itemTradeData = industryData.tradeData[config.Industry.TradeType.FORSALE][_industryTradeItemName]
    if not itemTradeData then return cb({ status = false, msg = Lang:t('not_found_item') }) end

    if _tradeState == config.Industry.TradeState.onFoot then
        if playersCarryItemData[source] then
            local carryData = playersCarryItemData[source]
            if carryData.industryName == _industryName and carryData.itemName == _industryTradeItemName then
                if industryData:IsStorageFull(config.Industry.TradeType.FORSALE, _industryTradeItemName) then return cb({ status = false, msg = Lang:t('storage_is_full') }) end
                if AddPlayerCash(source, math.floor(carryData.buyPrice * config.ItemBackRate), ('back_item')) then
                    industryData:AddItemAmount(config.Industry.TradeType.FORSALE, _industryTradeItemName, 1, true)
                    removePlayerCarryItem(source)
                    return cb({ status = true, isBackItem = true })
                else
                    return cb({ status = false, msg = Lang:t('can_not_add_cash') })
                end
            else
                return cb({ status = false, msg = Lang:t('not_selling_point') })
            end
        end
        if industryData:GetInStockAmount(config.Industry.TradeType.FORSALE, _industryTradeItemName) <= 0 then return cb({ status = false, msg = Lang:t('industry_out_of_stock') }) end
        if GetPlayerCash(source) < itemTradeData.price then return cb({ status = false, msg = Lang:t('not_enough_money') }) end
        RemovePlayerCash(source, itemTradeData.price, ('buy_item'))
        industryData:RemoveItemAmount(config.Industry.TradeType.FORSALE, _industryTradeItemName, 1, true)
        addPlayerCarryItem(source, _industryTradeItemName, itemTradeData.price, _industryName, os.time())
        return cb({ status = true })
    else
        if not _extendArgs then return cb({ status = false, msg = Lang:t('error_when_buy_item') }) end
        local buyAmount, vehNetId = _extendArgs.buyAmount, _extendArgs.vehNetId
        local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
        if not DoesEntityExist(vehicleEntity) then return cb({ status = false, msg = Lang:t('veh_not_found') }) end
        if GetVehicleDoorLockStatus(vehicleEntity) >= 2 then return cb({ status = false, msg = Lang:t('veh_door_locked') }) end
        local vehModelHash = GetEntityModel(vehicleEntity)
        local defaultItemData = config.IndustryItems[_industryTradeItemName]
        if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') }) end
        local checkDist = checkVehicleAndPlayerDistance(source, vehicleEntity)
        if not checkDist.status then return cb(checkDist) end
        local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
        local storageData = getVehicleStorageData(vehModelHash, vehPlate)
        local checkCanAdd = checkVehicleCanAddItemToStorage(storageData, _industryTradeItemName)
        if not checkCanAdd.status then return cb(checkCanAdd) end
        local availableCapacity = math.floor((storageData.maxCapacity - storageData.currentCapacity) / defaultItemData.capacity)
        if availableCapacity < 1 or buyAmount > availableCapacity then return cb({ status = false, msg = Lang:t('veh_storage_is_full') }) end
        if industryData:GetInStockAmount(config.Industry.TradeType.FORSALE, _industryTradeItemName) < buyAmount then return cb({ status = false, msg = Lang:t('industry_out_of_stock') }) end
        if GetPlayerCash(source) < (itemTradeData.price * buyAmount) then return cb({ status = false, msg = Lang:t('not_enough_money') }) end

        if addVehicleItem(vehModelHash, vehPlate, { buyPrice = itemTradeData.price, industryName = _industryName, itemName = _industryTradeItemName, addTime = os.time() }, buyAmount) then
            RemovePlayerCash(source, (itemTradeData.price * buyAmount), ('buy_item'))
            industryData:RemoveItemAmount(config.Industry.TradeType.FORSALE, _industryTradeItemName, buyAmount, true)
            if defaultItemData.prop and defaultItemData.prop.model and config.VehicleTransport[vehModelHash].props then
                local vehPropsData = {}
                for i = 1, buyAmount do
                    vehPropsData[i] = addVehicleProp(vehModelHash, vehPlate, GetEntityCoords(vehicleEntity), defaultItemData.transType, defaultItemData.prop.model)
                    Wait(50)
                end
                return cb({ status = true, seconds = buyAmount * defaultItemData.capacity, vehPropsData = vehPropsData })
            else
                return cb({ status = true, seconds = buyAmount * defaultItemData.capacity })
            end
        end
        return cb({ status = false, msg = Lang:t('error_when_buy_item') })
    end
end)

CreateCallback('space_trucker:callback:sellItem', function(source, cb, _tradeState, _industryName, _industryTradeItemName, _extendArgs)
    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then return cb({ status = false, msg = Lang:t('not_found_industry') }) end
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local industryTradePointCoords = industryData.wantedLocation[_industryTradeItemName]
    if not industryTradePointCoords or #(playerCoords - industryTradePointCoords) > 5 then return cb({ status = false, msg = Lang:t('distance_too_far') }) end
    if industryData:IsStorageFull(config.Industry.TradeType.WANTED, _industryTradeItemName) then return cb({ status = false, msg = Lang:t('storage_is_full') }) end
    local itemTradeData = industryData.tradeData[config.Industry.TradeType.WANTED][_industryTradeItemName]
    if not itemTradeData then return cb({ status = false, msg = Lang:t('not_found_item') }) end

    if _tradeState == config.Industry.TradeState.onFoot then
        local carryData = playersCarryItemData[source]
        if not carryData or carryData.itemName ~= _industryTradeItemName then return cb({ status = false, msg = Lang:t('you_no_have_goods') }) end
        if AddPlayerCash(source, itemTradeData.price, ('sell_item')) then
            industryData:AddItemAmount(config.Industry.TradeType.WANTED, _industryTradeItemName, 1, true)
            removePlayerCarryItem(source)
            return cb({ status = true })
        else
            return cb({ status = false, msg = Lang:t('can_not_add_cash') })
        end
    else
        if not _extendArgs then return cb({ status = false, msg = Lang:t('error_when_sell_item') }) end
        local sellAmount, vehNetId = _extendArgs.sellAmount, _extendArgs.vehNetId
        local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
        if not DoesEntityExist(vehicleEntity) then return cb({ status = false, msg = Lang:t('veh_not_found') }) end
        if GetVehicleDoorLockStatus(vehicleEntity) >= 2 then return cb({ status = false, msg = Lang:t('veh_door_locked') }) end
        local vehModelHash = GetEntityModel(vehicleEntity)
        local defaultItemData = config.IndustryItems[_industryTradeItemName]
        if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') }) end
        local checkDist = checkVehicleAndPlayerDistance(source, vehicleEntity)
        if not checkDist.status then return cb(checkDist) end
        local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
        local storageData = getVehicleStorageData(vehModelHash, vehPlate)
        if not storageData then return cb({ status = false, msg = Lang:t('error_when_sell_item') }) end
        local vehicleItemData = storageData.storage[_industryTradeItemName]
        if not vehicleItemData then return cb({ status = false, msg = Lang:t('not_selling_point') }) end
        if vehicleItemData.amount < sellAmount then return cb({ status = false, msg = Lang:t('veh_storage_is_not_enought') }) end
        local maxIndustryStorageAmount = itemTradeData.storageSize - itemTradeData.inStock
        if sellAmount > maxIndustryStorageAmount then sellAmount = maxIndustryStorageAmount end

        if removeVehicleItem(vehModelHash, vehPlate, _industryTradeItemName, sellAmount) then
            industryData:AddItemAmount(config.Industry.TradeType.WANTED, _industryTradeItemName, sellAmount, true)
            AddPlayerCash(source, itemTradeData.price * sellAmount, ('sell_item'))
            if defaultItemData.prop and defaultItemData.prop.model and config.VehicleTransport[vehModelHash].props then
                CreateThread(function()
                    for i = 1, sellAmount do
                        removeVehicleProp(vehModelHash, vehPlate, defaultItemData.prop.model)
                        Wait(1000 * defaultItemData.capacity)
                    end
                end)
            end
            return cb({ status = true, seconds = sellAmount * defaultItemData.capacity })
        else
            return cb({ status = false, msg = Lang:t('veh_storage_can_not_remove_item') })
        end
    end
end)

CreateCallback('space_trucker:callback:checkCarryItem', function(source, cb)
    return cb(playersCarryItemData[source] or false)
end)

CreateCallback('space_trucker:callback:onPlayerDeath', function(source, cb)
    removePlayerCarryItem(source)
    return cb(true)
end)

CreateCallback('space_trucker:callback:loadPackageIntoVehicleByHand', function(source, cb, vehNetId)
    local playerCarryItem = playersCarryItemData[source]
    if not playerCarryItem then return cb({ status = false, msg = Lang:t('you_no_have_goods_on_hand') }) end
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    if not DoesEntityExist(vehicleEntity) then return cb({ status = false, msg = Lang:t('veh_error_when_add_item') }) end
    local vehModelHash = GetEntityModel(vehicleEntity)
    local itemTransType = config.IndustryItems[playerCarryItem.itemName].transType
    local itemProp = config.IndustryItems[playerCarryItem.itemName].prop and config.IndustryItems[playerCarryItem.itemName].prop.model or nil
    if not IsVehicleModelCanTransportType(vehModelHash, itemTransType) then return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') }) end
    local checkDist = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkDist.status then return cb(checkDist) end
    if GetVehicleDoorLockStatus(vehicleEntity) >= 2 then return cb({ status = false, msg = Lang:t('veh_door_locked') }) end
    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
    local storageData = getVehicleStorageData(vehModelHash, vehPlate)
    local checkCanAdd = checkVehicleCanAddItemToStorage(storageData, playerCarryItem.itemName)
    if not checkCanAdd.status then return cb(checkCanAdd) end
    local vehKey = vehPlate .. '_' .. vehModelHash
    if isVehicleStorageFull(vehModelHash, vehiclesCarryItemData[vehKey]) or not canVehicleCarryItem(vehModelHash, vehiclesCarryItemData[vehKey], playerCarryItem.itemName, 1) then
        return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
    end
    if addVehicleItem(vehModelHash, vehPlate, playersCarryItemData[source], 1) then
        removePlayerCarryItem(source)
        return cb({ status = true, data = getVehicleStorageData(vehModelHash, vehPlate), vehPropData = addVehicleProp(vehModelHash, vehPlate, GetEntityCoords(vehicleEntity), itemTransType, itemProp) })
    end
    return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
end)

CreateCallback('space_trucker:callback:unloadPackageFromVehicleByHand', function(source, cb, vehNetId, itemName)
    if playersCarryItemData[source] then return cb({ status = false, msg = Lang:t('you_have_other_goods_on_hand') }) end
    local defaultItemData = config.IndustryItems[itemName]
    if not defaultItemData then return cb({ status = false, msg = 'item_undefined' }) end
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    local vehModelHash = GetEntityModel(vehicleEntity)
    if not IsVehicleModelCanDospacetrucker(vehModelHash) then return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') }) end
    local checkDist = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkDist.status then return cb(checkDist) end
    if defaultItemData.transType ~= config.ItemTransportType.CRATE and defaultItemData.transType ~= config.ItemTransportType.STRONGBOX then return cb({ status = false, msg = Lang:t('item_can_not_unload_by_hand') }) end
    if GetVehicleDoorLockStatus(vehicleEntity) >= 2 then return cb({ status = false, msg = Lang:t('veh_door_locked') }) end
    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
    local vehItemData = (vehiclesCarryItemData[vehPlate .. '_' .. vehModelHash] or {})[itemName]
    if vehItemData and removeVehicleItem(vehModelHash, vehPlate, itemName, 1) then
        removeVehicleProp(vehModelHash, vehPlate, defaultItemData.prop.model)
        addPlayerCarryItem(source, itemName, vehItemData.buyPrice, vehItemData.industryName, vehItemData.addTime)
        return cb({ status = true })
    end
    return cb({ status = false, msg = Lang:t('veh_error_when_remove_item') })
end)

CreateCallback('space_trucker:callback:checkVehicleStorage', function(source, cb, vehNetId)
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    local vehModelHash = GetEntityModel(vehicleEntity)
    if not IsVehicleModelCanDospacetrucker(vehModelHash) then return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') }) end
    local checkDist = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkDist.status then return cb(checkDist) end
    if GetVehicleDoorLockStatus(vehicleEntity) >= 2 then return cb({ status = false, msg = Lang:t('veh_door_locked') }) end
    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
    return cb({ status = true, data = getVehicleStorageData(vehModelHash, vehPlate) })
end)

-- Threads de Inicialização
CreateThread(function()
    Wait(5000)
    print('[space_trucker] A registar os callbacks das indústrias...')
    exports.space_trucker:RegisterIndustryCallbacks()
end)

CreateThread(function()
    Wait(5000)
    print('[space_trucker] A verificar o estado dos veículos da frota no reinício...')
    local rowsAffected = MySQL.update.await('UPDATE space_trucker_fleet SET status = ?, last_driver = NULL WHERE status != ?', { 'Na Garagem', 'Na Garagem' })
    if rowsAffected > 0 then
        print(('[space_trucker] Sucesso: %d veículos da frota foram devolvidos para a garagem.'):format(rowsAffected))
    else
        print('[space_trucker] Nenhum veículo da frota precisou ser redefinido.')
    end
end)