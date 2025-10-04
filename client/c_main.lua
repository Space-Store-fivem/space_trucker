-- =================================================================
-- ARQUIVO client/c_main.lua (VERSÃO FINAL E LIMPA)
-- =================================================================

-- Variáveis essenciais
local is_industries_loaded = false
local is_player_busy = false
local player_action_hand_buy_time = GetGameTimer()
local playerCarryPropId = nil

---@type PlayerCarryData
PlayerCarryData = {
    isCarry = false,
    carryItemName = '',
    carryItemPrice = 0,
    carryItemFromIndustry = ''
}
-- Funções

local function addTradePoint(_industryName, _forSaleLocation, _wantedLocation)
    for key, value in pairs(_forSaleLocation) do
        if config.ShowTradePointBlipOnMinimap then
            AddTradeBlip(_industryName .. '_' .. key, config.Industry.TradeType.FORSALE, value)
        end

        local point = Point.add({
            coords = value,
            distance = 15,
            industryName = _industryName,
            tradeItem = key,
            tradeType = config.Industry.TradeType.FORSALE
        })

        local marker, rotate = GetMarkerForItemTransType(config.Industry.TradeType.FORSALE, key)

        function point:onPedStanding()
            DrawMarker(marker, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, rotate, 0.0, 1.0, 1.0,
                1.0, 255, 222, 20, 200, true, true, 2, false, nil, nil, false)

            if self.currentDistance < 10 then
                Draw3DText(self.coords.x, self.coords.y, self.coords.z,
                    GetTradePointDescription(self.industryName, config.Industry.TradeType.FORSALE, self.tradeItem), 4,
                    0.1, 0.1)
            end

            local playerPed = PlayerPedId()
            if GetGameTimer() - player_action_hand_buy_time < config.DelayBuyItemByHandTime then return end

            if (self.currentDistance <= 2) or (IsPedInAnyVehicle(playerPed, false) and self.currentDistance <= 5) then
                ShowHelpNotify(Lang:t('help_text_press_e_to_interact'))
            end
            if (self.currentDistance < 2 and IsControlJustReleased(0, 38))
                or (IsPedInAnyVehicle(playerPed, false) and IsControlJustReleased(0, 38) and self.currentDistance <= 5) then
                OnPlayerActiveForSaleLocation(_industryName, self.tradeItem)
            end
        end
    end
    for key, value in pairs(_wantedLocation) do
        if config.ShowTradePointBlipOnMinimap then
            AddTradeBlip(_industryName .. '_' .. key, config.Industry.TradeType.WANTED, value)
        end

        local point = Point.add({
            coords = value,
            distance = 15,
            industryName = _industryName,
            tradeItem = key,
            tradeType = config.Industry.TradeType.WANTED
        })

        local marker, rotate = GetMarkerForItemTransType(config.Industry.TradeType.WANTED, key)

        function point:onPedStanding()
            DrawMarker(marker, self.coords.x, self.coords.y, self.coords.z + 0.5, 0.0, 0.0, 0.0, 0.0, rotate, 0.0, 1.0,
                1.0, 1.0, 20, 255, 20, 200, true, true, 2, false, nil, nil, false)

            if self.currentDistance < 10 then
                Draw3DText(self.coords.x, self.coords.y, self.coords.z,
                    GetTradePointDescription(self.industryName, config.Industry.TradeType.WANTED, self.tradeItem), 4,
                    0.1, 0.1)
            end

            local playerPed = PlayerPedId()
            if (self.currentDistance <= 2) or (IsPedInAnyVehicle(playerPed, false) and self.currentDistance <= 5) then
                ShowHelpNotify(Lang:t('help_text_press_e_to_interact'))
            end
            if (self.currentDistance < 2 and IsControlJustReleased(0, 38))
                or (IsPedInAnyVehicle(playerPed, false) and IsControlJustReleased(0, 38) and self.currentDistance <= 5) then
                OnPlayerActiveWantedLocation(_industryName, self.tradeItem)
            end
        end
    end
end

local function generateIndustriesBlipAndTradePoint()
    local industries = Industries:GetIndustries()
    for k, v in pairs(industries) do
        addTradePoint(k, v.forSaleLocation, v.wantedLocation)
    end
end

local function getAllIndustriesData()
    local industriesTradeData = TriggerCallbackAwait('space_trucker:callback:loadIndustriesTradeData')
    for industryName, industryTradeData in pairs(industriesTradeData) do
        Industries:UpdateTradeData(industryName, industryTradeData)
    end
end

local function addPlayerCarryProp(_prop)
    PlayCarryAnim()
    Wait(100)
    local itemPropData = _prop or {
        model = `prop_cs_cardbox_01`, boneId = 28422,
        x = -0.05, y = 0.0, z = -0.10,
        rx = 0.0, ry = 0.0, rz = 0.0
    }
    playerCarryPropId = AttachProp(PlayerPedId(), itemPropData.model, itemPropData.boneId,
        itemPropData.x, itemPropData.y, itemPropData.z, itemPropData.rx, itemPropData.ry, itemPropData.rz)
end

local function removePlayerCarryProp()
    if playerCarryPropId and DoesEntityExist(playerCarryPropId) then
        DetachEntity(playerCarryPropId, true, true)
        DeleteEntity(playerCarryPropId)
    end
    ClearPedTasks(PlayerPedId())
    playerCarryPropId = nil
end

local function addVehicleProp(entity, vehPropData)
    local object = NetworkGetEntityFromNetworkId(vehPropData.objectNetId)
    if not DoesEntityExist(object) then return end
    local entityModel = GetEntityModel(object)
    local addFixZ = config.FixCratePropPosZ[entityModel]
    local rot = vector3(0.0, 0.0, 0.0)
    if vehPropData.rot then
        rot = vector3(vehPropData.rot.x, vehPropData.rot.y, vehPropData.rot.z)
    end
    AttachEntityToEntity(object, entity,
        vehPropData.boneIndex and vehPropData.boneIndex or GetEntityBoneIndexByName(entity, vehPropData.bone),
        vehPropData.position.x,
        vehPropData.position.y, addFixZ and vehPropData.position.z + addFixZ or vehPropData.position.z,
        rot.x, rot.y, rot.z,
        true, true, false, false, 2, true);
end

function GetIndustryInformation(_industryName)
    local industryData = Industries:GetIndustry(_industryName)
    local _industryDataForSale = {}
    local _industryDataWanted = {}
    if industryData.tradeData[config.Industry.TradeType.FORSALE] and next(industryData.tradeData[config.Industry.TradeType.FORSALE]) then
        for key, value in pairs(industryData.tradeData[config.Industry.TradeType.FORSALE]) do
            local productionStr = industryData.tier == config.Industry.Tier.PRIMARY and "+" .. value.production or Lang:t("production_per_resources", { value = value.production })
            local defaultItemData = config.IndustryItems[key]
            _industryDataForSale[#_industryDataForSale + 1] = {
                name = key,
                label = defaultItemData.label,
                price = value.price,
                production = productionStr,
                inStock = value.inStock,
                storageSize = value.storageSize,
                unit = config.ItemTransportUnit[defaultItemData.transType],
                buyFromInfo = defaultItemData.buyFromInfo,
                sellToInfo = defaultItemData.sellToInfo
            }
        end
    end
    if industryData.tradeData[config.Industry.TradeType.WANTED] and next(industryData.tradeData[config.Industry.TradeType.WANTED]) then
        for key, value in pairs(industryData.tradeData[config.Industry.TradeType.WANTED]) do
            local defaultItemData = config.IndustryItems[key]
            _industryDataWanted[#_industryDataWanted + 1] = {
                name = key,
                label = defaultItemData.label,
                price = value.price,
                consumption = Lang:t("consumption_per_hour", { value = value.consumption }),
                inStock = value.inStock,
                storageSize = value.storageSize,
                unit = config.ItemTransportUnit[defaultItemData.transType],
                buyFromInfo = defaultItemData.buyFromInfo,
                sellToInfo = defaultItemData.sellToInfo
            }
        end
    end
    return {
        industryData = {
            name = industryData.name,
            label = industryData.label,
            status = 1,
            isPrimaryIndustry = industryData.tier == config.Industry.Tier.PRIMARY,
            isBusiness = industryData.tier == config.Industry.Tier.BUSINESS,
        },
        industryDataForSale = _industryDataForSale,
        industryDataWanted = _industryDataWanted
    }
end

local function checkVehicleCanAddItemToStorage(_vehNetId, _industryTradeItemName)
    local checkStorageCB = TriggerCallbackAwait('space_trucker:callback:checkVehicleStorage', _vehNetId)
    if not checkStorageCB.status then
        return checkStorageCB
    end
    local storageData = checkStorageCB.data
    if storageData.currentCapacity > 0 then
        for itemName, value in pairs(storageData.storage) do
            if not itemName then
                return { status = false, msg = Lang:t('error_when_buy_item') }
            end
            if not IsItemTransportTypeCanMix(config.IndustryItems[itemName].transType) then
                if itemName ~= _industryTradeItemName then
                    return { status = false, msg = Lang:t('currently_another_type_of_cargo') }
                end
            end
        end
    end
    return checkStorageCB
end

-- Funções Globais do Jogador
function HasPlayerCarryItem()
    return PlayerCarryData.isCarry
end

function GetPlayerCarryItemName()
    return PlayerCarryData.carryItemName
end

function GetPlayerCarryIndustryLabel()
    return Industries:GetIndustryLabel(PlayerCarryData.carryItemFromIndustry)
end

function GetPlayerCarryItemPrice()
    return PlayerCarryData.carryItemPrice
end

function HasIndustriesLoaded()
    return is_industries_loaded
end

function OnPlayerJoin()
    getAllIndustriesData()
    generateIndustriesBlipAndTradePoint()
    PlayerCarryData = { isCarry = false, carryItemName = '', carryItemPrice = 0, carryItemFromIndustry = '' }
    local toggleModalConfirm = GetResourceKvpInt(config.ToggleModalConfirmKvp.key)
    if toggleModalConfirm == 0 then
        SetResourceKvpInt(config.ToggleModalConfirmKvp.key, config.ToggleModalConfirmKvp.on)
    end
    is_industries_loaded = true
end

function OnPlayerActiveForSaleLocation(_industryName, _industryTradeItemName)
    if is_player_busy then return end
    local defaultItemData = config.IndustryItems[_industryTradeItemName]
    if not defaultItemData then return end
    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then
        Notify(Lang:t('not_found_industry'), 'error')
        return
    end
    local itemTradeData = industryData.tradeData[config.Industry.TradeType.FORSALE][_industryTradeItemName]
    if not itemTradeData then
        Notify(Lang:t('not_found_item'), 'error')
        return
    end

    local playerPed = PlayerPedId()
    if (defaultItemData.transType == config.ItemTransportType.CRATE or defaultItemData.transType == config.ItemTransportType.STRONGBOX) then
        if IsPedInAnyVehicle(playerPed, false) then
            Notify(Lang:t('you_need_to_get_out_car'), 'error')
            return
        end
        if HasPlayerCarryItem() and GetPlayerCarryItemName() ~= _industryTradeItemName then
            Notify(Lang:t('not_selling_point'), 'error')
            return
        end
        local desc = HasPlayerCarryItem() and Lang:t('you_have_goods_on_hand') or
            Lang:t('are_you_sure_want_to_buy', {
                amount = 1, type = GetItemTransportUnit(_industryTradeItemName),
                item = Lang:t(defaultItemData.label), price = math.groupdigits(itemTradeData.price)
            })
        local toggleModalConfirm = GetResourceKvpInt(config.ToggleModalConfirmKvp.key)
        local confirmData = toggleModalConfirm == config.ToggleModalConfirmKvp.on and ShowModal({
            type = config.NUIModalType.CONFIRM,
            title = Lang:t('trade_point_of', { industry = Lang:t(industryData.label) }),
            description = desc, extraArgs = {}
        }) or { confirm = true }
        if confirmData and confirmData.confirm then
            local result = TriggerCallbackAwait('space_trucker:callback:buyItem', config.Industry.TradeState.onFoot, _industryName, _industryTradeItemName)
            if not result.status then
                Notify(result.msg, 'error')
                return
            end
            if result.isBackItem then
                removePlayerCarryProp()
                Notify(Lang:t('return_item_to_industry'), 'success')
                return
            end
            addPlayerCarryProp(defaultItemData.prop)
            player_action_hand_buy_time = GetGameTimer()
        end
    else
        if not IsPedInAnyVehicle(playerPed, false) then
            Notify(Lang:t('you_need_in_a_vehicle_to_buy_this_type'), 'error')
            return
        end
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if IsVehicleAttachedToTrailer(vehicle) then
            local retval, trailer = GetVehicleTrailerVehicle(vehicle)
            if retval then vehicle = trailer end
        end
        local vehModelHash = GetEntityModel(vehicle)

        if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
            Notify(Lang:t('veh_is_not_a_freight'), 'error')
            return false
        end
        local vehNetId = VehToNet(vehicle)
        local checkStorageCB = checkVehicleCanAddItemToStorage(vehNetId, _industryTradeItemName)
        if not checkStorageCB.status then
            Notify(checkStorageCB.msg, 'error')
            return false
        end
        local storageData = checkStorageCB.data
        local availableCapacity = (storageData.maxCapacity - storageData.currentCapacity) / defaultItemData.capacity
        if availableCapacity < 1 then
            Notify(Lang:t('veh_storage_is_full'), 'error')
            return false
        end
        local maxAmount = itemTradeData.inStock
        maxAmount = math.floor((availableCapacity > maxAmount) and maxAmount or availableCapacity)
        if maxAmount <= 0 then
            Notify(Lang:t('industry_out_of_stock'), 'error')
            return false
        end
        local modalData = ShowModal({
            type = config.NUIModalType.DIALOG,
            title = Lang:t('buy_amount_label'),
            description = Lang:t('enter_quantity_you_want', { max = maxAmount }),
            extraArgs = { min = 1, max = maxAmount, default = maxAmount }
        })
        if not modalData or not modalData.confirm then return false end
        local amountInput = modalData.value
        if not amountInput then return false end
        if amountInput > tonumber(availableCapacity) or amountInput < 1 then return false end
        local args = { buyAmount = amountInput, vehNetId = vehNetId }
        is_player_busy = true
        local result = TriggerCallbackAwait('space_trucker:callback:buyItem', config.Industry.TradeState.onVehicle, _industryName, _industryTradeItemName, args)
        if not result.status then
            Notify(result.msg, 'error')
            is_player_busy = false
            return
        end
        if result.seconds then
            Progressbar('truck_loading', Lang:t('progress_loading'), result.seconds * 1000, false, false,
                { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
                {}, {}, {}, function() is_player_busy = false end, function() is_player_busy = false end)
        end
        if result.vehPropsData then
            Citizen.CreateThread(function()
                for key, value in pairs(result.vehPropsData) do
                    if value and value.slot then
                        addVehicleProp(vehicle, value)
                        Wait(1000 * defaultItemData.capacity)
                    end
                end
            end)
        end
    end
end

function OnPlayerActiveWantedLocation(_industryName, _industryTradeItemName)
    if is_player_busy then return end
    local defaultItemData = config.IndustryItems[_industryTradeItemName]
    if not defaultItemData then return end
    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then
        Notify(Lang:t('not_found_industry'), 'error')
        return
    end
    local itemTradeData = industryData.tradeData[config.Industry.TradeType.WANTED][_industryTradeItemName]
    if not itemTradeData then
        Notify(Lang:t('not_found_item'), 'error')
        return
    end
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) and (defaultItemData.transType == config.ItemTransportType.CRATE or defaultItemData.transType == config.ItemTransportType.STRONGBOX) then
        local carryItem = TriggerCallbackAwait('space_trucker:callback:checkCarryItem')
        if not carryItem then
            Notify(Lang:t('you_no_have_goods_on_hand'), 'error')
            return
        end
        if carryItem.itemName ~= _industryTradeItemName then
            Notify(Lang:t('not_selling_point'), 'error')
            return
        end
        local toggleModalConfirm = GetResourceKvpInt(config.ToggleModalConfirmKvp.key)
        local confirmData = toggleModalConfirm == config.ToggleModalConfirmKvp.on and ShowModal({
            type = config.NUIModalType.CONFIRM,
            title = Lang:t('trade_point_of', { industry = Lang:t(industryData.label) }),
            description = Lang:t('are_you_sure_want_to_sell', {
                type = GetItemTransportUnit(_industryTradeItemName),
                item = Lang:t(defaultItemData.label),
                price = math.groupdigits(itemTradeData.price)
            }),
            extraArgs = {}
        }) or { confirm = true }
        if confirmData and confirmData.confirm then
            local result = TriggerCallbackAwait('space_trucker:callback:sellItem', config.Industry.TradeState.onFoot, _industryName, _industryTradeItemName)
            if not result.status then
                Notify(result.msg, 'error')
                return
            end
            removePlayerCarryProp()
        end
    else
        if not IsPedInAnyVehicle(playerPed, false) then
            Notify(Lang:t('you_need_in_a_vehicle_to_sell'), 'error')
            return
        end
        local vehicleEntity = GetVehiclePedIsIn(playerPed, false)
        if IsVehicleAttachedToTrailer(vehicleEntity) then
            local retval, trailer = GetVehicleTrailerVehicle(vehicleEntity)
            if retval then vehicleEntity = trailer end
        end
        local vehModelHash = GetEntityModel(vehicleEntity)
        if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
            Notify(Lang:t('veh_is_not_a_freight'), 'error')
            return false
        end
        local vehNetId = VehToNet(vehicleEntity)
        local checkStorageCB = TriggerCallbackAwait('space_trucker:callback:checkVehicleStorage', vehNetId)
        if not checkStorageCB.status then
            Notify(checkStorageCB.msg, 'error')
            return false
        end
        local storageData = checkStorageCB.data
        if storageData.currentCapacity <= 0 then
            Notify(Lang:t('veh_storage_is_empty'), 'error')
            return false
        end
        local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
        if vehicleLockStatus >= 2 then
            Notify(Lang:t('veh_door_locked'), 'error')
            return false
        end
        local sellItemData = storageData.storage[_industryTradeItemName]
        if not sellItemData then
            Notify(Lang:t('not_selling_point'), 'error')
            return false
        end
        local maxAmount = itemTradeData.storageSize - itemTradeData.inStock
        maxAmount = (maxAmount > sellItemData.amount) and sellItemData.amount or maxAmount
        local modalData = ShowModal({
            type = config.NUIModalType.DIALOG,
            title = Lang:t('sell_amount_label'),
            description = Lang:t('enter_quantity_you_want_sell', { max = maxAmount }),
            extraArgs = { min = 1, max = maxAmount, default = maxAmount }
        })
        if not modalData or not modalData.confirm then return false end
        local amountInput = modalData.value
        if not amountInput then return false end
        if amountInput > sellItemData.amount or amountInput < 1 then return false end
        local args = { sellAmount = amountInput, vehNetId = vehNetId }
        is_player_busy = true
        local result = TriggerCallbackAwait('space_trucker:callback:sellItem', config.Industry.TradeState.onVehicle, _industryName, _industryTradeItemName, args)
        if not result.status then
            Notify(result.msg, 'error')
            is_player_busy = false
            return
        end
        if result.seconds then
            Progressbar('truck_unloading', Lang:t('progress_unloading'), result.seconds * 1000, false, false,
                { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true },
                {}, {}, {}, function() is_player_busy = false end, function() is_player_busy = false end)
        end
    end
end

function OnPlayerLoadPackageIntoVehicle(entity)
    if not IsEntityAVehicle(entity) then return false end
    local vehNetId = VehToNet(entity)
    local vehModelHash = GetEntityModel(entity)
    local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
    if not HasPlayerCarryItem() then
        Notify(Lang:t('you_no_have_goods_on_hand'), 'error')
        return false
    end
    local carryItemName = GetPlayerCarryItemName()
    if not IsVehicleModelCanTransportType(vehModelHash, config.IndustryItems[carryItemName].transType) then
        Notify(Lang:t('veh_is_not_a_freight'), 'error')
        return false
    end
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end
    local checkStorageCB = checkVehicleCanAddItemToStorage(vehNetId, carryItemName)
    if not checkStorageCB.status then
        Notify(checkStorageCB.msg, 'error')
        return false
    end
    local toggleModalConfirm = GetResourceKvpInt(config.ToggleModalConfirmKvp.key)
    local confirmData = toggleModalConfirm == config.ToggleModalConfirmKvp.on and ShowModal({
        type = config.NUIModalType.CONFIRM,
        title = Lang:t('modal_load_package_into_vehicle_title'),
        description = Lang:t('modal_load_package_into_vehicle_desc', {
            item = Lang:t(config.IndustryItems[carryItemName].label),
            plate = GetVehicleNumberPlateText(entity)
        }),
        extraArgs = {}
    }) or { confirm = true }
    if confirmData and confirmData.confirm then
        local result = TriggerCallbackAwait('space_trucker:callback:loadPackageIntoVehicleByHand', vehNetId)
        if not result.status then
            Notify(result.msg, 'error')
            return false
        end
        removePlayerCarryProp()
        if result.data and result.data.currentCapacity then
            Notify(Lang:t('veh_current_storage_capacity_is', { current = result.data.currentCapacity, max = result.data.maxCapacity }), 'success')
        end
        if result.vehPropData and result.vehPropData.slot then
            addVehicleProp(entity, result.vehPropData)
        end
        return true
    end
    return false
end

function OnPlayerCheckVehicleStorage(entity)
    if not IsEntityAVehicle(entity) then return end
    local vehNetId = VehToNet(entity)
    local vehModelHash = GetEntityModel(entity)
    local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end
    if not IsVehicleModelCanDospacetrucker(vehModelHash) then
        Notify(Lang:t('veh_is_not_a_freight'), 'error')
        return false
    end
    local result = TriggerCallbackAwait('space_trucker:callback:checkVehicleStorage', vehNetId)
    if not result then
        Notify(result.msg, 'error')
        return
    end
    ShowVehicleStorage(entity, result.data)
end

function OnPlayerUnloadFromVehicleStorage(_vehEntity, _itemName)
    if not IsEntityAVehicle(_vehEntity) then return end
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        return
    end
    local vehNetId = VehToNet(_vehEntity)
    local vehicleLockStatus = GetVehicleDoorLockStatus(_vehEntity)
    local defaultItemData = config.IndustryItems[_itemName]
    if not defaultItemData then return false end
    if HasPlayerCarryItem() then
        Notify(Lang:t('you_have_other_goods_on_hand'), 'error')
        return false
    end
    if defaultItemData.transType ~= config.ItemTransportType.CRATE and
        defaultItemData.transType ~= config.ItemTransportType.STRONGBOX then
        Notify(Lang:t('item_can_not_unload_by_hand'), 'error')
        return false
    end
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end
    local result = TriggerCallbackAwait('space_trucker:callback:unloadPackageFromVehicleByHand', vehNetId, _itemName)
    if not result.status then
        Notify(result.msg, 'error')
        return
    end
    addPlayerCarryProp(defaultItemData.prop)
end

function OnPlayerDeath()
    if config.DropPackageWhenDie then
        local result = TriggerCallbackAwait('space_trucker:callback:onPlayerDeath')
        if result then
            removePlayerCarryProp()
        end
    end
end

-- Blip Functions
local tradeBlips = {}
function AddTradeBlip(id, _tradeType, _blipCoords)
    if not config.ShowTradePointBlipOnMinimap then return end
    
    if tradeBlips[id] then RemoveBlip(tradeBlips[id]) end

    local blip = AddBlipForCoord(_blipCoords.x, _blipCoords.y, _blipCoords.z)
    SetBlipSprite(blip, _tradeType == config.Industry.TradeType.FORSALE and 120 or 106)
    SetBlipDisplay(blip, 5)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, _tradeType == config.Industry.TradeType.FORSALE and 5 or 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(id) -- Apenas para debug, pode ser alterado para um nome mais amigável
    EndTextCommandSetBlipName(blip)
    tradeBlips[id] = blip
end

function RemoveTradeBlip(id)
    if tradeBlips[id] then
        RemoveBlip(tradeBlips[id])
        tradeBlips[id] = nil
    end
end