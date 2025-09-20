-- Variables

---@class PlayerCarryItemData
---@field itemName string
---@field industryName string Industry Sell Item
---@field buyPrice number
---@field addTime number

---@type PlayerCarryItemData[]
local playersCarryItemData = {}

---@class VehicleCarryItemData
---@field itemName string
---@field industryName string Industry Sell Item
---@field itemLabel string
---@field industryLabel string Industry Sell Item
---@field transUnit string
---@field buyPrice number
---@field amount number
---@field capacity number
---@field addTime number


---@class table<string, VehicleCarryItemData>: { [string]: VehicleCarryItemData }
local vehiclesCarryItemData = {}

---@class VehicleStorageData
---@field maxCapacity number
---@field currentCapacity number
---@field transType string
---@field storage table

---@class VehiclePropData
---@field position vector3
---@field rot? vector3
---@field slot number
---@field bone? string
---@field boneIndex? number
---@field objectNetId number
---@field model number

---@class table<string, VehiclePropData>: { [string]: VehiclePropData }
local vehiclePropData = {}

-- Player Functions
-- ----------------------------------------------- Player Functions
-- Player Functions
local function addPlayerCarryItem(source, _itemName, _itemPrice, _industryName, _addTime)
    playersCarryItemData[source] = {
        itemName = _itemName,
        industryName = _industryName,
        buyPrice = _itemPrice,
        addTime = _addTime
    }

    TriggerClientEvent('gs_trucker:client:addPlayerCarryData', source, {
        isCarry = true,
        carryItemName = _itemName,
        carryItemPrice = _itemPrice,
        carryItemFromIndustry = _industryName
    })
end

local function removePlayerCarryItem(source)
    playersCarryItemData[source] = nil
    TriggerClientEvent('gs_trucker:client:addPlayerCarryData', source, {
        isCarry = false,
        carryItemName = '',
        carryItemPrice = 0,
        carryItemFromIndustry = ''
    })
end

-- Item Functions
-- ----------------------------------------------- Item Functions
-- Item Functions

local function getItemCapacity(_itemName)
    if not spaceconfig.IndustryItems[_itemName] then return 0 end
    return spaceconfig.IndustryItems[_itemName].capacity
end

local function getItemLabel(_itemName)
    if not spaceconfig.IndustryItems[_itemName] then return 'undefined' end
    return spaceconfig.IndustryItems[_itemName].label
end
-- Vehicle Functions
-- ----------------------------------------------- Vehicle Functions
-- Vehicle Functions

local function getVehicleTransportTypeText(_vehicleModel)
    local transTypeText = ''
    if not spaceconfig.VehicleTransport[_vehicleModel] then return '' end
    for key, value in pairs(spaceconfig.VehicleTransport[_vehicleModel].transType) do
        if transTypeText ~= '' then transTypeText = transTypeText .. ', ' end
        transTypeText = transTypeText .. spaceconfig.VehicleTransportTypeLabel[key]
    end

    return transTypeText
end

---isVehicleStorageFull
---@param _vehicleModel any
---@param _vehicleCarryItemData VehicleCarryItemData
---@return boolean
local function isVehicleStorageFull(_vehicleModel, _vehicleCarryItemData)
    if not spaceconfig.VehicleTransport[_vehicleModel] then return false end
    local vehicleMaxCapacity = spaceconfig.VehicleTransport[_vehicleModel].capacity

    if _vehicleCarryItemData and next(_vehicleCarryItemData) then
        ---@param value VehicleCarryItemData
        for key, value in pairs(_vehicleCarryItemData) do
            vehicleMaxCapacity = vehicleMaxCapacity - (value.capacity * value.amount)
        end
    end

    if vehicleMaxCapacity <= 0 then
        return true
    end

    return false
end

---getCurrentVehicleCarryCapacity
---@param _vehicleCarryItemData VehicleCarryItemData
---@return number
local function getCurrentVehicleCarryCapacity(_vehicleCarryItemData)
    local vehicleCapacity = 0

    if _vehicleCarryItemData and next(_vehicleCarryItemData) then
        ---@param value VehicleCarryItemData
        for key, value in pairs(_vehicleCarryItemData) do
            vehicleCapacity = vehicleCapacity + (value.capacity * value.amount)
        end
    end

    return vehicleCapacity
end

---getVehicleModelMaxCapacity
---@param _vehicleModel any
---@return integer
local function getVehicleModelMaxCapacity(_vehicleModel)
    if not spaceconfig.VehicleTransport[_vehicleModel] then return 0 end
    return spaceconfig.VehicleTransport[_vehicleModel].capacity
end

---canVehicleCarryItem
---@param _vehicleModel any
---@param _vehicleCarryItemData VehicleCarryItemData
---@param _itemName string
---@param _amount number
---@return boolean
local function canVehicleCarryItem(_vehicleModel, _vehicleCarryItemData, _itemName, _amount)
    if not spaceconfig.VehicleTransport[_vehicleModel] then return false end
    if not spaceconfig.IndustryItems[_itemName] then return false end

    local vehicleMaxCapacity = getVehicleModelMaxCapacity(_vehicleModel)

    local vehicleCurrentCapacity = getCurrentVehicleCarryCapacity(_vehicleCarryItemData)
    local itemCapacity = (spaceconfig.IndustryItems[_itemName].capacity * _amount)

    if vehicleCurrentCapacity + itemCapacity <= vehicleMaxCapacity then
        return true
    end

    return false
    --
end

---addVehicleItem
---@param _vehicleModel any
---@param _vehiclePlate string
---@param _itemData PlayerCarryItemData
---@param _amount number
local function addVehicleItem(_vehicleModel, _vehiclePlate, _itemData, _amount)
    -- Nếu xe này chưa có hàng thì tạo mới
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclesCarryItemData[vehKey] then
        vehiclesCarryItemData[vehKey] = {}
    end

    -- Nếu thùng xe chưa có item này thì sẽ tạo một object mới
    local _itemName = _itemData.itemName
    local _industryName = _itemData.industryName
    local _buyPrice = _itemData.buyPrice
    local _addTime = _itemData.addTime and _itemData.addTime or os.time()
    local _industryLabel = Industries:GetIndustryLabel(_industryName)
    local _defaultItemData = spaceconfig.IndustryItems[_itemName]
    local _itemLabel = _defaultItemData.label
    if not vehiclesCarryItemData[vehKey][_itemName] then
        vehiclesCarryItemData[vehKey][_itemName] = {
            itemName = _itemName,
            industryName = _industryName,
            itemLabel = _itemLabel,
            industryLabel = _industryLabel,
            transUnit = spaceconfig.ItemTransportUnit[_defaultItemData.transType],
            buyPrice = _buyPrice,
            amount = _amount,
            capacity = getItemCapacity(_itemName),
            addTime = _addTime

        } --[[@as VehicleCarryItemData]]
    else
        -- Nếu đã có thì sẽ + thêm amount vào
        -- Tính lại giá trung bình buyPrice và thay đổi industryName ban đầu
        vehiclesCarryItemData[vehKey][_itemName].amount = vehiclesCarryItemData[vehKey][_itemName].amount + _amount
        vehiclesCarryItemData[vehKey][_itemName].industryName = _industryName
        vehiclesCarryItemData[vehKey][_itemName].industryLabel = _industryLabel
        if _buyPrice < vehiclesCarryItemData[vehKey][_itemName].buyPrice then
            vehiclesCarryItemData[vehKey][_itemName].buyPrice = _buyPrice
        end
    end
    return true
end

local function getVehicleItemData(_vehicleModel, _vehiclePlate, _itemName)
    -- Nếu xe này chưa có hàng thì tạo mới
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclesCarryItemData[vehKey] or not vehiclesCarryItemData[vehKey][_itemName] then
        return nil
    end

    return vehiclesCarryItemData[vehKey][_itemName]
end

local function removeVehicleItem(_vehicleModel, _vehiclePlate, _itemName, _amount)
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclesCarryItemData[vehKey] or not vehiclesCarryItemData[vehKey][_itemName] then
        return false
    end

    if vehiclesCarryItemData[vehKey][_itemName].amount > _amount then
        vehiclesCarryItemData[vehKey][_itemName].amount = vehiclesCarryItemData[vehKey][_itemName].amount - _amount
    elseif vehiclesCarryItemData[vehKey][_itemName].amount < _amount then
        return false
    else
        vehiclesCarryItemData[vehKey][_itemName] = nil
    end
    return true
end
---getVehicleStorageData
---@param _vehicleModel any
---@param _vehiclePlate string
---@return VehicleStorageData
local function getVehicleStorageData(_vehicleModel, _vehiclePlate)
    local vehKey = _vehiclePlate .. '_' .. _vehicleModel

    ---@type VehicleStorageData
    local data = {
        maxCapacity = getVehicleModelMaxCapacity(_vehicleModel),
        currentCapacity = getCurrentVehicleCarryCapacity(vehiclesCarryItemData[vehKey]),
        transType = getVehicleTransportTypeText(_vehicleModel),
        storage = {}
    }
    if vehiclesCarryItemData[vehKey] then
        data.storage = vehiclesCarryItemData[vehKey]
    end

    return data
end

local function addVehicleProp(_vehicleModel, _vehiclePlate, _vehCoords, _itemTransType, _itemPropModel)
    if not spaceconfig.AddVehicleProps then return false end
    if not _itemPropModel or not _vehicleModel or not _vehiclePlate or not _vehCoords or not _itemTransType
        or not spaceconfig.VehicleTransport[_vehicleModel].props
        or not spaceconfig.VehicleTransport[_vehicleModel].props[_itemTransType] then
        return false
    end
    local propVeh = spaceconfig.VehicleTransport[_vehicleModel].props
    local propSlots = propVeh[_itemTransType]
    local vehPropKey = _vehiclePlate .. '_' .. _vehicleModel
    local currentCapacity = getCurrentVehicleCarryCapacity(vehiclesCarryItemData[vehPropKey])
    if not vehiclePropData[vehPropKey] then
        vehiclePropData[vehPropKey] = {}
    end
    for i = 1, currentCapacity, 1 do
        if not vehiclePropData[vehPropKey][i] and propSlots[i] then
            local object = CreateObject(_itemPropModel, _vehCoords.x, _vehCoords.y, _vehCoords.z - 10.0, true, true,
                false)
            while not DoesEntityExist(object) do Wait(0) end
            vehiclePropData[vehPropKey][i] = {
                slot = i,
                position = propSlots[i],
                rot = propSlots[i].rx and vector3(propSlots[i].rx, propSlots[i].ry, propSlots[i].rz) or
                    vector3(0.0, 0.0, 0.0),
                bone = propVeh.bone,
                boneIndex = propVeh.boneIndex,
                objectNetId = NetworkGetNetworkIdFromEntity(object),
                model = _itemPropModel
            }

            return vehiclePropData[vehPropKey][i]
        end
    end
    return false
end

local function removeVehicleProp(_vehicleModel, _vehiclePlate, _itemPropModel)
    local vehPropKey = _vehiclePlate .. '_' .. _vehicleModel
    if not vehiclePropData[vehPropKey] then
        return false
    end

    local topSlot = 0
    ---@param value VehiclePropData
    for key, value in pairs(vehiclePropData[vehPropKey]) do
        if value.slot > topSlot and value.model == _itemPropModel then
            topSlot = value.slot
        end
    end

    if topSlot ~= 0 then
        DeleteEntity(NetworkGetEntityFromNetworkId(vehiclePropData[vehPropKey][topSlot].objectNetId))
        vehiclePropData[vehPropKey][topSlot] = nil
    end
end

local function checkVehicleCanAddItemToStorage(storageData, _industryTradeItemName)
    if not storageData then
        return { status = false, msg = Lang:t('error_when_buy_item') }
    end
    -- Kiểm tra xem xe đó đã có hàng sẵn chưa, ,
    -- nếu có rồi thì kiểm tra loại item xem có có giống nhau hay có cho phép mix không, nếu ko thì không chở được
    if storageData.currentCapacity > 0 then --Đã có sẵn hàng
        for itemName, value in pairs(storageData.storage) do
            if not itemName then
                return { status = false, msg = Lang:t('error_when_buy_item') }
            end
            if not IsItemTransportTypeCanMix(spaceconfig.IndustryItems[itemName].transType) then
                -- Nếu không cho phép mix vậy thì kiểm tra nó có giống hàng đang mua không
                -- Giống thì cho phép mua thêm
                if itemName ~= _industryTradeItemName then
                    return { status = false, msg = Lang:t('currently_another_type_of_cargo') }
                end
            end
        end
        -- Nếu đã có hàng nhưng vẫn cho trộn lẫn có thể là pallet và crate, strongbox
    end

    return { status = true }
end

local function checkVehicleAndPlayerDistance(source, vehicleEntity)
    local vehModelHash = GetEntityModel(vehicleEntity)
    local vehicleCargoData = spaceconfig.VehicleTransport[vehModelHash]

    if not vehicleCargoData then return { status = false, msg = Lang:t('veh_not_found') } end

    local vehCoords = GetEntityCoords(vehicleEntity)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    local distanceCheck = (vehicleCargoData and vehicleCargoData.isTrailer) and spaceconfig.MaxServerVehicleDistanceCheck +
        5 or spaceconfig.MaxServerVehicleDistanceCheck
    if #(playerCoords.xy - vehCoords.xy) > distanceCheck then
        return { status = false, msg = Lang:t('distance_too_far') }
    end

    return { status = true }
end
-- Callbacks
-- ----------------------------------------------- Callbacks
-- Callbacks

CreateCallback('gs_trucker:callback:loadIndustriesTradeData', function(source, cb)
    local industries = Industries:GetIndustries()

    local data = {}

    ---@param industry Industry
    for _, industry in pairs(industries) do
        data[industry.name] = industry.tradeData
    end

    if cb then
        return cb(data)
    else
        return data
    end
end)

-- Buy Item From Industry
CreateCallback('gs_trucker:callback:buyItem',
    function(source, cb, _tradeState, _industryName, _industryTradeItemName, _extendArgs)
        -- Check vị trí đứng với điểm mua trong lúc mua hàng luôn
        local industryData = Industries:GetIndustry(_industryName)
        if not industryData then
            return cb({ status = false, msg = Lang:t('not_found_industry') })
        end

        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local industryTradePointCoords = industryData.forSaleLocation[_industryTradeItemName]

        if not industryTradePointCoords then
            return cb({ status = false, msg = Lang:t('not_found_trading_point') })
        end

        if #(playerCoords - industryTradePointCoords) > 5 then
            return cb({ status = false, msg = Lang:t('distance_too_far') })
        end

        -- Kiểm tra đủ tiền không rồi bán hàng, trừ tiền
        local itemTradeData = industryData.tradeData[spaceconfig.Industry.TradeType.FORSALE][_industryTradeItemName]
        if not itemTradeData then
            return cb({ status = false, msg = Lang:t('not_found_item') })
        end
        -- Kiểm tra loại hàng mua bằng tay hay bằng phương tiện
        if _tradeState == spaceconfig.Industry.TradeState.onFoot then
            -- Bước 2: Kiểm tra trên tay có hàng không
            if playersCarryItemData[source] then
                local carryData = playersCarryItemData[source]
                -- Nếu có: kiểm tra phải đúng itemName của hàng trên tay không và phải mua từ doanh nghiệp này hay không
                if carryData.industryName == _industryName and carryData.itemName == _industryTradeItemName then
                    -- Kiểm tra industry có full hàng đó hay chưa
                    if industryData:IsStorageFull(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName) then
                        return cb({ status = false, msg = Lang:t('storage_is_full') })
                    end
                    -- -- Nếu đúng hết thì trả lại tiền và thêm lại hàng vào storage
                    if AddPlayerCash(source, math.floor(carryData.buyPrice * spaceconfig.ItemBackRate), ('gs_trucker_back_item_%s_from_%s'):format(_industryTradeItemName, _industryName)) then
                        industryData:AddItemAmount(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName, 1, true)
                        -- Return xuống dưới để xóa props và carryData
                        removePlayerCarryItem(source)
                        return cb({ status = true, isBackItem = true })
                    else
                        return cb({ status = false, msg = Lang:t('can_not_add_cash') })
                    end
                else
                    -- -- Nếu không đúng thì hiện thông báo không phải chỗ để bán
                    return cb({ status = false, msg = Lang:t('not_selling_point') })
                end
            end
            -- Nếu không có hàng trên tay:
            -- Kiểm tra doanh nghiệp còn hàng không,
            if industryData:GetInStockAmount(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName) <= 0 then
                return cb({ status = false, msg = Lang:t('industry_out_of_stock') })
            end
            -- Kiểm tra đủ tiền không rồi bán hàng, trừ tiền
            if GetPlayerCash(source) < itemTradeData.price then
                return cb({ status = false, msg = Lang:t('not_enough_money') })
            end
            -- Set các state để tiện kiểm tra (tên item, nơi mua, giá mua, objectId)
            RemovePlayerCash(source, itemTradeData.price,
                ('gs_trucker_buy_%s_from_%s'):format(_industryTradeItemName, _industryName))
            -- Trừ hàng vào doanh nghiệp, lưu dữ liệu trên server
            industryData:RemoveItemAmount(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName, 1, true)
            -- Gọi xuống một event attach objects cho người chơi trên tay,
            addPlayerCarryItem(source, _industryTradeItemName, itemTradeData.price, _industryName, os.time())

            return cb({ status = true })
        else
            if not _extendArgs then
                return cb({ status = false, msg = Lang:t('error_when_buy_item') })
            end

            local buyAmount = _extendArgs.buyAmount
            local vehNetId = _extendArgs.vehNetId
            local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)

            if not DoesEntityExist(vehicleEntity) then
                return cb({ status = false, msg = Lang:t('veh_not_found') })
            end

            -- Xe co bi khoa cua hay khong
            local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
            if vehicleLockStatus >= 2 then
                return cb({ status = false, msg = Lang:t('veh_door_locked') })
            end

            local vehModelHash = GetEntityModel(vehicleEntity)
            -- Co du level de chat hang len xe nay khong
            local truckerSkill = GetPlayerTruckerSkill(source)
            local vehData = spaceconfig.VehicleTransport[vehModelHash]
            if not vehData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
                return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
            end
            if vehData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
                return cb({ status = false, msg = Lang:t('trucker_skill_not_enough') })
            end
            -- Kiểm tra xem xe đó có chở được hàng không, hoặc trailer của xe đó có chở được hàng không
            local defaultItemData = spaceconfig.IndustryItems[_industryTradeItemName]
            if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
                return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
            end

            -- server check vị trí đứng có gần với xe không
            local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
            if not checkPlayerAndVehDistance.status then
                return checkPlayerAndVehDistance
            end

            local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
            local storageData = getVehicleStorageData(vehModelHash, vehPlate)
            if not storageData then
                return cb({ status = false, msg = Lang:t('error_when_buy_item') })
            end

            local checkCanAddItemToStorage = checkVehicleCanAddItemToStorage(storageData, _industryTradeItemName)

            if not checkCanAddItemToStorage.status then
                return cb(checkCanAddItemToStorage)
            end

            local availableCapacity = math.floor((storageData.maxCapacity - storageData.currentCapacity) /
                defaultItemData.capacity)

            if availableCapacity < 1 then
                return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
            end

            if buyAmount > availableCapacity then
                return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
            end

            -- Kiểm tra doanh nghiệp còn hàng không,
            if industryData:GetInStockAmount(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName) < buyAmount then
                return cb({ status = false, msg = Lang:t('industry_out_of_stock') })
            end

            if GetPlayerCash(source) < (itemTradeData.price * buyAmount) then
                return cb({ status = false, msg = Lang:t('not_enough_money') })
            end

            ---@type PlayerCarryItemData
            local addItemData = {
                buyPrice = itemTradeData.price,
                industryName = _industryName,
                itemName = _industryTradeItemName,
                addTime = os.time()
            }
            if addVehicleItem(vehModelHash, vehPlate, addItemData, buyAmount) then
                -- Set các state để tiện kiểm tra (tên item, nơi mua, giá mua, objectId)
                RemovePlayerCash(source, (itemTradeData.price * buyAmount),
                    ('gs_trucker_buy_%s_from_%s'):format(_industryTradeItemName, _industryName))
                -- Trừ hàng vào doanh nghiệp, lưu dữ liệu trên server
                industryData:RemoveItemAmount(spaceconfig.Industry.TradeType.FORSALE, _industryTradeItemName, buyAmount,
                    true)

                if defaultItemData.prop and defaultItemData.prop.model and spaceconfig.VehicleTransport[vehModelHash].props then
                    local vehPropsData = {}
                    for i = 1, buyAmount, 1 do
                        vehPropsData[i] = addVehicleProp(
                            vehModelHash, vehPlate, GetEntityCoords(vehicleEntity), defaultItemData.transType,
                            defaultItemData.prop.model)
                        Wait(50)
                    end

                    return cb({
                        status = true,
                        seconds = buyAmount * defaultItemData.capacity,
                        vehPropsData = vehPropsData
                    })
                else
                    return cb({ status = true, seconds = buyAmount * defaultItemData.capacity })
                end
                -- Gọi xuống chạy progress bar theo giây
            end
        end

        return cb({ status = false, msg = Lang:t('error_when_buy_item') })
    end)

-- Sell Item To Industry
CreateCallback('gs_trucker:callback:sellItem',
    function(source, cb, _tradeState, _industryName, _industryTradeItemName, _extendArgs)
        -- Check vị trí đứng với điểm mua trong lúc mua hàng luôn
        local industryData = Industries:GetIndustry(_industryName)
        if not industryData then
            return cb({ status = false, msg = Lang:t('not_found_industry') })
        end

        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local industryTradePointCoords = industryData.wantedLocation[_industryTradeItemName]

        if not industryTradePointCoords then
            return cb({ status = false, msg = Lang:t('not_found_trading_point') })
        end

        if #(playerCoords - industryTradePointCoords) > 5 then
            return cb({ status = false, msg = Lang:t('distance_too_far') })
        end

        -- Kiểm tra industry có full hàng chưa
        if industryData:IsStorageFull(spaceconfig.Industry.TradeType.WANTED, _industryTradeItemName) then
            return cb({ status = false, msg = Lang:t('storage_is_full') })
        end

        local itemTradeData = industryData.tradeData[spaceconfig.Industry.TradeType.WANTED][_industryTradeItemName]
        if not itemTradeData then
            return cb({ status = false, msg = Lang:t('not_found_item') })
        end

        -- Kiểm tra loại hàng mua bằng tay hay bằng phương tiện
        if _tradeState == spaceconfig.Industry.TradeState.onFoot then
            -- Kiểm tra hàng trên tay có không và có đúng loại trade item này không
            local carryData = playersCarryItemData[source]
            if not carryData or carryData.itemName ~= _industryTradeItemName then
                return cb({ status = false, msg = Lang:t('you_no_have_goods') })
            end

            if not GSTruckerAntiTeleportFilter(source, carryData.industryName, _industryName, carryData.addTime) then
                return cb({ status = false, msg = Lang:t('error_when_sell_item') })
            end

            if AddPlayerCash(source, itemTradeData.price, ('gs_trucker_sell_item_%s_to_%s'):format(_industryTradeItemName, _industryName)) then
                industryData:AddItemAmount(spaceconfig.Industry.TradeType.WANTED, _industryTradeItemName, 1, true)

                -- itemName, sellPrice, buyPrice, sellAmount, buyFrom, sellFrom
                CalculatorPlayerTruckerSkill(source, _industryTradeItemName, itemTradeData.price, carryData.buyPrice, 1,
                    Industries:GetIndustry(carryData.industryName).location, industryData.location)

                -- Return xuống dưới để xóa props và carryData
                removePlayerCarryItem(source)
                return cb({ status = true })
            else
                return cb({ status = false, msg = Lang:t('can_not_add_cash') })
            end
        else
            if not _extendArgs then
                return cb({ status = false, msg = Lang:t('error_when_sell_item') })
            end

            local sellAmount = _extendArgs.sellAmount
            local vehNetId = _extendArgs.vehNetId
            local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)

            if not DoesEntityExist(vehicleEntity) then
                return cb({ status = false, msg = Lang:t('veh_not_found') })
            end

            -- Xe co bi khoa cua hay khong
            local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
            if vehicleLockStatus >= 2 then
                return cb({ status = false, msg = Lang:t('veh_door_locked') })
            end

            local vehModelHash = GetEntityModel(vehicleEntity)

            -- Kiểm tra xem xe đó có chở được hàng không, hoặc trailer của xe đó có chở được hàng không
            local defaultItemData = spaceconfig.IndustryItems[_industryTradeItemName]
            if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
                return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
            end

            -- server check vị trí đứng có gần với xe không
            local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
            if not checkPlayerAndVehDistance.status then
                return cb(checkPlayerAndVehDistance)
            end

            local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
            local storageData = getVehicleStorageData(vehModelHash, vehPlate)
            if not storageData then
                return cb({ status = false, msg = Lang:t('error_when_sell_item') })
            end

            local vehicleItemData = storageData.storage[_industryTradeItemName]
            if not vehicleItemData then
                return cb({ status = false, msg = Lang:t('not_selling_point') })
            end


            if not GSTruckerAntiTeleportFilter(source, vehicleItemData.industryName, _industryName, vehicleItemData.addTime) then
                return cb({ status = false, msg = Lang:t('error_when_sell_item') })
            end

            -- Kiểm tra xem hàng trên xe có đủ số lượng không
            if vehicleItemData.amount < sellAmount then
                return cb({ status = false, msg = Lang:t('veh_storage_is_not_enought') })
            end

            local maxIndustryStorageAmount = itemTradeData.storageSize - itemTradeData.inStock

            -- Kiểm tra xem số lượng bán + kho hiện tại có max không,, nếu có thì fix lại amount
            if sellAmount > maxIndustryStorageAmount then
                sellAmount = maxIndustryStorageAmount
            end

            if removeVehicleItem(vehModelHash, vehPlate, _industryTradeItemName, sellAmount) then
                industryData:AddItemAmount(spaceconfig.Industry.TradeType.WANTED, _industryTradeItemName, sellAmount, true)
                AddPlayerCash(source, itemTradeData.price * sellAmount,
                    ('gs_trucker_sell_%s_item_%s_to_%s'):format(sellAmount, _industryTradeItemName, _industryName))

                -- itemName, sellPrice, buyPrice, sellAmount, buyFrom, sellFrom
                CalculatorPlayerTruckerSkill(source, _industryTradeItemName, itemTradeData.price,
                    vehicleItemData.buyPrice, sellAmount,
                    Industries:GetIndustry(vehicleItemData.industryName).location, industryData.location)

                local addTimeUnloadForCrateOrStrongBox = 0
                if vehModelHash ~= `forklift` and spaceconfig.IsAllowToSellCrateByVehicle and
                    (defaultItemData.transType == spaceconfig.ItemTransportType.CRATE or
                        defaultItemData.transType == spaceconfig.ItemTransportType.STRONGBOX) then
                    addTimeUnloadForCrateOrStrongBox = spaceconfig.DelayTimeWhenSellCrateByVehicle * sellAmount
                end
                if defaultItemData.prop and defaultItemData.prop.model and spaceconfig.VehicleTransport[vehModelHash].props then
                    Citizen.CreateThread(function()
                        for i = 1, sellAmount, 1 do
                            removeVehicleProp(vehModelHash, vehPlate, defaultItemData.prop.model)
                            Wait((1000 * defaultItemData.capacity) +
                                (addTimeUnloadForCrateOrStrongBox > 0 and
                                    spaceconfig.DelayTimeWhenSellCrateByVehicle * 1000 or 0))
                        end
                    end)
                end
                return cb({
                    status = true,
                    seconds = (sellAmount * defaultItemData.capacity) +
                        addTimeUnloadForCrateOrStrongBox
                })
            else
                return cb({ status = false, msg = Lang:t('veh_storage_can_not_remove_item') })
            end
        end
    end)

-- Forklift load item into vehicle
CreateCallback('gs_trucker:callback:forkliftLoadIntoCargo', function(source, cb, data)
    local itemName = data.itemName
    local loadAmount = data.loadAmount
    local forkliftNetId = data.forkliftNetId
    local targetNetId = data.targetNetId
    if not itemName or not loadAmount or not forkliftNetId or not targetNetId then
        return cb({ status = false, msg = Lang:t('error_when_buy_item') })
    end
    -- Đầu tiên xem forklift là 1 industry để mua hàng
    -- Mua hàng hóa như bình thường load vào xe
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local forkliftEntity = NetworkGetEntityFromNetworkId(forkliftNetId)
    local vehicleEntity = NetworkGetEntityFromNetworkId(targetNetId)

    if not DoesEntityExist(vehicleEntity) or not DoesEntityExist(forkliftEntity) then
        return cb({ status = false, msg = Lang:t('veh_not_found') })
    end

    -- Xe co bi khoa cua hay khong
    local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
    if vehicleLockStatus >= 2 then
        return cb({ status = false, msg = Lang:t('veh_door_locked') })
    end

    local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, forkliftEntity)
    if not checkPlayerAndVehDistance.status then
        return cb(checkPlayerAndVehDistance)
    end

    checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkPlayerAndVehDistance.status then
        return cb(checkPlayerAndVehDistance)
    end

    local defaultItemData = spaceconfig.IndustryItems[itemName]
    if not defaultItemData then
        return cb({ status = false, msg = Lang:t('not_found_item') })
    end

    local vehModelHash = GetEntityModel(vehicleEntity)
    local forkliftVehModelHash = `forklift`
    -- Co du level de chat hang len xe nay khong
    local truckerSkill = GetPlayerTruckerSkill(source)
    local vehData = spaceconfig.VehicleTransport[vehModelHash]
    if not vehData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
        return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
    end
    if vehData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
        return cb({ status = false, msg = Lang:t('trucker_skill_not_enough') })
    end
    -- Kiểm tra xem xe đó có chở được hàng không, hoặc trailer của xe đó có chở được hàng không
    if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
        return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
    end

    -- Kiểm tra hàng hóa trong xe mục tiêu và xe forklift
    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
    local storageData = getVehicleStorageData(vehModelHash, vehPlate)

    local forkliftVehPlate = GetVehicleNumberPlateText(forkliftEntity)
    local forkliftStorageData = getVehicleStorageData(forkliftVehModelHash, forkliftVehPlate)
    if not storageData or not forkliftStorageData then
        return cb({ status = false, msg = Lang:t('forklift_error_when_load_item') })
    end

    local checkCanAddItemToStorage = checkVehicleCanAddItemToStorage(storageData, itemName)

    if not checkCanAddItemToStorage.status then
        return cb(checkCanAddItemToStorage)
    end

    local availableCapacity = math.floor((storageData.maxCapacity - storageData.currentCapacity) /
        defaultItemData.capacity)

    if availableCapacity < 1 then
        return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
    end

    if loadAmount > availableCapacity then
        return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
    end

    local forkliftItemData = forkliftStorageData.storage

    if not forkliftItemData or not forkliftItemData[itemName] or forkliftItemData[itemName].amount < loadAmount then
        return cb({ status = false, msg = Lang:t('forklift_error_when_load_item') })
    end

    ---@type PlayerCarryItemData
    local addItemData = {
        buyPrice = forkliftItemData[itemName].buyPrice,
        industryName = forkliftItemData[itemName].industryName,
        itemName = itemName,
        addTime = os.time()
    }

    if addVehicleItem(vehModelHash, vehPlate, addItemData, loadAmount) then
        -- Set các state để tiện kiểm tra (tên item, nơi mua, giá mua, objectId)
        -- Remove vehicle item của forklifts
        removeVehicleItem(forkliftVehModelHash, forkliftVehPlate, itemName, loadAmount)
        if defaultItemData.prop and defaultItemData.prop.model and spaceconfig.VehicleTransport[forkliftVehModelHash].props then
            Citizen.CreateThread(function()
                for i = 1, loadAmount, 1 do
                    removeVehicleProp(forkliftVehModelHash, forkliftVehPlate, defaultItemData.prop.model)
                    Wait(1000 * defaultItemData.capacity)
                end
            end)
        end

        if defaultItemData.prop and defaultItemData.prop.model and spaceconfig.VehicleTransport[vehModelHash].props then
            local vehPropsData = {}
            for i = 1, loadAmount, 1 do
                vehPropsData[i] = addVehicleProp(
                    vehModelHash, vehPlate, GetEntityCoords(vehicleEntity), defaultItemData.transType,
                    defaultItemData.prop.model)
                Wait(50)
            end

            return cb({
                status = true,
                seconds = loadAmount * defaultItemData.capacity,
                data = getVehicleStorageData(vehModelHash, vehPlate),
                vehPropsData = vehPropsData
            })
        else
            return cb({
                status = true,
                seconds = loadAmount * defaultItemData.capacity,
                data = getVehicleStorageData(vehModelHash, vehPlate),
            })
        end
        -- Gọi xuống chạy progress bar theo giây
    end
end)

CreateCallback('gs_trucker:callback:checkCarryItem', function(source, cb)
    if playersCarryItemData[source] then
        return cb and cb(playersCarryItemData[source]) or playersCarryItemData[source]
    end
    return cb and cb(false) or false
end)

CreateCallback('gs_trucker:callback:onPlayerDeath', function(source, cb)
    removePlayerCarryItem(source)
    return cb and cb(true) or true
end)

CreateCallback('gs_trucker:callback:loadPackageIntoVehicleByHand', function(source, cb, vehNetId)
    local playerCarryItem = playersCarryItemData[source]
    -- Kiểm tra có hàng trên tay hay không
    if not playerCarryItem then
        return cb({ status = false, msg = Lang:t('you_no_have_goods_on_hand') })
    end

    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    -- Xe co the cho duoc hang tren tay hay khong
    local vehModelHash = GetEntityModel(vehicleEntity)

    if not DoesEntityExist(vehicleEntity) or not vehModelHash then
        return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
    end
    -- Co du level de chat hang len xe nay khong
    local truckerSkill = GetPlayerTruckerSkill(source)
    local vehData = spaceconfig.VehicleTransport[vehModelHash]
    if not vehData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
        return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
    end
    if vehData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
        return cb({ status = false, msg = Lang:t('trucker_skill_not_enough') })
    end

    local itemTransType = spaceconfig.IndustryItems[playerCarryItem.itemName].transType
    local itemProp = spaceconfig.IndustryItems[playerCarryItem.itemName].prop and
        spaceconfig.IndustryItems[playerCarryItem.itemName].prop.model or nil
    if not IsVehicleModelCanTransportType(vehModelHash, itemTransType) then
        return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
    end

    -- server check vị trí đứng và khả năng vận chuyển đồ
    local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkPlayerAndVehDistance.status then
        return cb(checkPlayerAndVehDistance)
    end

    -- Xe co bi khoa cua hay khong
    local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
    if vehicleLockStatus >= 2 then
        return cb({ status = false, msg = Lang:t('veh_door_locked') })
    end

    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
    local vehKey = vehPlate .. '_' .. vehModelHash

    local storageData = getVehicleStorageData(vehModelHash, vehPlate)
    if not storageData then
        return cb({ status = false, msg = Lang:t('error_when_buy_item') })
    end

    local checkCanAddItemToStorage = checkVehicleCanAddItemToStorage(storageData, playerCarryItem.itemName)

    if not checkCanAddItemToStorage.status then
        return cb(checkCanAddItemToStorage)
    end
    -- Và check xem thử đã đủ hàng trên xe hay chưa
    if isVehicleStorageFull(vehModelHash, vehiclesCarryItemData[vehKey]) then
        return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
    end
    -- Check xem xe này có tải thêm hàng này được không
    if not canVehicleCarryItem(vehModelHash, vehiclesCarryItemData[vehKey], playerCarryItem.itemName, 1) then
        return cb({ status = false, msg = Lang:t('veh_storage_is_full') })
    end

    if addVehicleItem(vehModelHash, vehPlate, playersCarryItemData[source], 1) then
        removePlayerCarryItem(source)
        return cb({
            status = true,
            data = getVehicleStorageData(vehModelHash, vehPlate),
            vehPropData = addVehicleProp(
                vehModelHash, vehPlate, GetEntityCoords(vehicleEntity), itemTransType, itemProp)
        })
    end
    return cb({ status = false, msg = Lang:t('veh_error_when_add_item') })
end)

CreateCallback('gs_trucker:callback:unloadPackageFromVehicleByHand', function(source, cb, vehNetId, itemName)
    local playerCarryItem = playersCarryItemData[source]
    local defaultItemData = spaceconfig.IndustryItems[itemName]

    if not defaultItemData then
        return cb({ status = false, msg = 'item_undefined' })
    end
    -- Kiểm tra có hàng trên tay hay không
    if playerCarryItem then
        return cb({ status = false, msg = Lang:t('you_have_other_goods_on_hand') })
    end

    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    local vehModelHash = GetEntityModel(vehicleEntity)
    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)

    -- Xe co the cho duoc hang hay khong
    if not IsVehicleModelCanDoGSTrucker(vehModelHash) then
        return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
    end
    -- server check vị trí đứng và khả năng vận chuyển đồ
    local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkPlayerAndVehDistance.status then
        return cb(checkPlayerAndVehDistance)
    end
    -- Loại hàng này có được dỡ xuống được hay không
    if defaultItemData.transType ~= spaceconfig.ItemTransportType.CRATE and
        defaultItemData.transType ~= spaceconfig.ItemTransportType.STRONGBOX then
        return cb({ status = false, msg = Lang:t('item_can_not_unload_by_hand') })
    end

    -- Xe co bi khoa cua hay khong
    local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
    if vehicleLockStatus >= 2 then
        return cb({ status = false, msg = Lang:t('veh_door_locked') })
    end

    local vehItemData = getVehicleItemData(vehModelHash, vehPlate, itemName)
    if vehItemData and removeVehicleItem(vehModelHash, vehPlate, itemName, 1) then
        removeVehicleProp(vehModelHash, vehPlate, defaultItemData.prop.model)
        addPlayerCarryItem(source, itemName, vehItemData.buyPrice, vehItemData.industryName, vehItemData.addTime)
        return cb({ status = true })
    end

    return cb({ status = false, msg = Lang:t('veh_error_when_remove_item') })
end)

CreateCallback('gs_trucker:callback:checkVehicleStorage', function(source, cb, vehNetId)
    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    -- Xe co the cho duoc hang hay khong
    local vehModelHash = GetEntityModel(vehicleEntity)
    if not IsVehicleModelCanDoGSTrucker(vehModelHash) then
        return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
    end
    -- server check vị trí đứng và khả năng vận chuyển đồ
    local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
    if not checkPlayerAndVehDistance.status then
        return cb(checkPlayerAndVehDistance)
    end
    -- Neu la trailer va lon hon 15 thi xa,


    -- Xe co bi khoa cua hay khong
    local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
    if vehicleLockStatus >= 2 then
        return cb({ status = false, msg = Lang:t('veh_door_locked') })
    end

    local vehPlate = GetVehicleNumberPlateText(vehicleEntity)

    return cb({ status = true, data = getVehicleStorageData(vehModelHash, vehPlate) })
end)

CreateCallback('gs_trucker:callback:checkMultiVehicleStorage', function(source, cb, vehNetIds)
    local data = {}
    for _, vehNetId in pairs(vehNetIds) do
        local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
        -- Xe co the cho duoc hang hay khong
        local vehModelHash = GetEntityModel(vehicleEntity)
        if not IsVehicleModelCanDoGSTrucker(vehModelHash) then
            return cb({ status = false, msg = Lang:t('veh_is_not_a_freight') })
        end
        -- server check vị trí đứng và khả năng vận chuyển đồ
        local checkPlayerAndVehDistance = checkVehicleAndPlayerDistance(source, vehicleEntity)
        if not checkPlayerAndVehDistance.status then
            return cb(checkPlayerAndVehDistance)
        end
        -- Neu la trailer va lon hon 15 thi xa,


        -- Xe co bi khoa cua hay khong
        local vehicleLockStatus = GetVehicleDoorLockStatus(vehicleEntity)
        if vehicleLockStatus >= 2 then
            return cb({ status = false, msg = Lang:t('veh_door_locked') })
        end

        local vehPlate = GetVehicleNumberPlateText(vehicleEntity)
        data[vehNetId] = getVehicleStorageData(vehModelHash, vehPlate)
    end

    return cb({ status = true, data = data })
end)
