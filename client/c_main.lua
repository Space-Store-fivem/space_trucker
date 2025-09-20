-- Encrypt File
-- Variables
local is_industries_loaded = false
local industries_points = {}

local is_player_busy = false
local player_action_hand_buy_time = GetGameTimer()
local forklift_data = {}
local mainThread = false

local playerCarryPropId = nil

---@class PlayerCarryData
---@field isCarry boolean
---@field carryItemName string
---@field carryItemPrice number
---@field carryItemFromIndustry string

---@type PlayerCarryData
PlayerCarryData = {
    isCarry = false,
    carryItemName = '',
    carryItemPrice = 0,
    carryItemFromIndustry = ''
}
-- Functions

local function addTradePoint(_industryName, _forSaleLocation, _wantedLocation)
    industries_points[_industryName] = {}

    for key, value in pairs(_forSaleLocation) do
        if spaceconfig.ShowTradePointBlipOnMinimap then
            AddTradeBlip(_industryName .. '_' .. key, spaceconfig.Industry.TradeType.FORSALE, value)
        end

        local point = Point.add({
            coords = value,
            distance = 15,
            industryName = _industryName,
            tradeItem = key,
            tradeType = spaceconfig.Industry.TradeType.FORSALE
        })

        local marker, rotate = GetMarkerForItemTransType(spaceconfig.Industry.TradeType.FORSALE, key)

        function point:onPedStanding()
            if spaceconfig.JobRequired and GetPlayerJobName() ~= spaceconfig.JobName then return end
            DrawMarker(marker, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, rotate, 0.0, 1.0, 1.0,
                1.0, 255,
                ---@diagnostic disable-next-line: param-type-mismatch
                222, 20, 200, true, true, 2, false, nil, nil, false)

            if self.currentDistance < 10 then
                Draw3DText(self.coords.x, self.coords.y, self.coords.z,
                    GetTradePointDescription(self.industryName, spaceconfig.Industry.TradeType.FORSALE, self.tradeItem), 4,
                    0.1,
                    0.1)
            end

            local playerPed = PlayerPedId()

            if GetGameTimer() - player_action_hand_buy_time < spaceconfig.DelayBuyItemByHandTime then return end
            if (self.currentDistance <= 2) or (IsPedInAnyVehicle(playerPed, false) and self.currentDistance <= 5) then
                ShowHelpNotify(Lang:t('help_text_press_e_to_interact'))
            end
            if (self.currentDistance < 2 and IsControlJustReleased(0, 38))
                or (IsPedInAnyVehicle(playerPed, false) and IsControlJustReleased(0, 38) and self.currentDistance <= 5) then
                OnPlayerActiveForSaleLocation(_industryName, self.tradeItem)
            end
        end

        industries_points[_industryName][key] = point
    end
    for key, value in pairs(_wantedLocation) do
        if spaceconfig.ShowTradePointBlipOnMinimap then
            AddTradeBlip(_industryName .. '_' .. key, spaceconfig.Industry.TradeType.WANTED, value)
        end

        local point = Point.add({
            coords = value,
            distance = 15,
            industryName = _industryName,
            tradeItem = key,
            tradeType = spaceconfig.Industry.TradeType.WANTED
        })

        local marker, rotate = GetMarkerForItemTransType(spaceconfig.Industry.TradeType.FORSALE, key)

        function point:onPedStanding()
            if spaceconfig.JobRequired and GetPlayerJobName() ~= spaceconfig.JobName then return end
            DrawMarker(marker, self.coords.x, self.coords.y, self.coords.z + 0.5, 0.0, 0.0, 0.0, 0.0, rotate, 0.0, 1.0,
                1.0,
                ---@diagnostic disable-next-line: param-type-mismatch
                1.0, 20, 255, 20, 200, true, true, 2, false, nil, nil, false)

            if self.currentDistance < 10 then
                Draw3DText(self.coords.x, self.coords.y, self.coords.z,
                    GetTradePointDescription(self.industryName, spaceconfig.Industry.TradeType.WANTED, self.tradeItem), 4,
                    0.1,
                    0.1)
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

        industries_points[_industryName][key] = point
    end
end

local function generateIndustriesBlipAndTradePoint()
    local industries = Industries:GetIndustries()
    for k, v in pairs(industries) do
        addTradePoint(k, v.forSaleLocation, v.wantedLocation)
    end
end

local function getAllIndustriesData()
    -- Get industries and create instances
    local industriesTradeData = TriggerCallbackAwait('gs_trucker:callback:loadIndustriesTradeData')

    for industryName, industryTradeData in pairs(industriesTradeData) do
        Industries:UpdateTradeData(industryName, industryTradeData)
    end
end

local function addPlayerCarryProp(_prop)
    PlayCarryAnim()
    Wait(100)
    local itemPropData = _prop or {
        model = `prop_cs_cardbox_01`,
        boneId = 28422,
        x = -0.05,
        y = 0.0,
        z = -0.10,
        rx = 0.0,
        ry = 0.0,
        rz = 0.0
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

-- Vehicle functions
---addVehicleProp
---@param entity number
---@param vehPropData VehiclePropData
local function addVehicleProp(entity, vehPropData)
    local object = NetworkGetEntityFromNetworkId(vehPropData.objectNetId)
    if not DoesEntityExist(object) then return end
    local entityModel = GetEntityModel(object)
    local addFixZ = spaceconfig.FixCratePropPosZ[entityModel]

    local rot = vector3(0.0, 0.0, 0.0)

    if vehPropData.rot then
        rot = vector3(vehPropData.rot.x, vehPropData.rot.y, vehPropData.rot.z)
    end

    AttachEntityToEntity(object, entity,
        vehPropData.boneIndex and vehPropData.boneIndex or GetEntityBoneIndexByName(entity, vehPropData.bone),
        vehPropData.position.x,
        vehPropData.position.y, addFixZ and vehPropData.position.z + addFixZ or vehPropData.position.z,
        rot.x, rot.y, rot.z,
        true, true,
        false, false, 2, true);
end

---isPedInForkLift
---@param playerPed any
---@return boolean
local function isPedInForkLift(playerPed)
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if GetEntityModel(vehicle) == `forklift` then
            return true
        end
        return false
    end
    return false
end

function GetIndustryInformation(_industryName)
    local industryData = Industries:GetIndustry(_industryName) --[[@as Industry]]

    local _industryDataForSale = {}
    local _industryDataWanted = {}

    if industryData.tradeData[spaceconfig.Industry.TradeType.FORSALE] and next(industryData.tradeData[spaceconfig.Industry.TradeType.FORSALE]) then
        for key, value in pairs(industryData.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
            local productionStr = industryData.tier == spaceconfig.Industry.Tier.PRIMARY and "+" .. value.production or
                Lang:t("production_per_resources", { value = value.production })
            local defaultItemData = spaceconfig.IndustryItems[key]
            _industryDataForSale[#_industryDataForSale + 1] = {
                name = key,
                label = defaultItemData.label,
                price = value.price,
                production = productionStr,
                inStock = value.inStock,
                storageSize = value.storageSize,
                unit = spaceconfig.ItemTransportUnit[defaultItemData.transType],
                buyFromInfo = defaultItemData.buyFromInfo,
                sellToInfo = defaultItemData.sellToInfo
            }
        end
    end

    if industryData.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryData.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
        for key, value in pairs(industryData.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
            local defaultItemData = spaceconfig.IndustryItems[key]
            _industryDataWanted[#_industryDataWanted + 1] = {
                name = key,
                label = defaultItemData.label,
                price = value.price,
                consumption = Lang:t("consumption_per_hour", { value = value.consumption }),
                inStock = value.inStock,
                storageSize = value.storageSize,
                unit = spaceconfig.ItemTransportUnit[defaultItemData.transType],
                buyFromInfo = defaultItemData.buyFromInfo,
                sellToInfo = defaultItemData.sellToInfo
            }
        end
    end


    local returnData = {
        industryData = {
            name = industryData.name,
            label = industryData.label,
            status = 1,
            isPrimaryIndustry = industryData.tier == spaceconfig.Industry.Tier.PRIMARY,
            isBusiness = industryData.tier == spaceconfig.Industry.Tier.BUSINESS,
        },
        industryDataForSale = _industryDataForSale,
        industryDataWanted = _industryDataWanted
    }

    return returnData
end

-- Vehicle function

local function checkVehicleCanAddItemToStorage(_vehNetId, _industryTradeItemName)
    local checkStorageCB = TriggerCallbackAwait('gs_trucker:callback:checkVehicleStorage', _vehNetId)

    if not checkStorageCB.status then
        return checkStorageCB
    end

    ---@type VehicleStorageData
    local storageData = checkStorageCB.data
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

    return checkStorageCB
end

-- Player Global Function
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
    -- Get All Data of Industries
    getAllIndustriesData()
    -- Generate Industries Blip & Trade Point
    generateIndustriesBlipAndTradePoint()
    PlayerCarryData = {
        isCarry = false,
        carryItemName = '',
        carryItemPrice = 0,
        carryItemFromIndustry = ''
    }

    local toggleModalConfirm = GetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key)
    if toggleModalConfirm == 0 then
        SetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key, spaceconfig.ToggleModalConfirmKvp.on)
    end

    StartMainThread()
    is_industries_loaded = true
end

function OnPlayerActiveForSaleLocation(_industryName, _industryTradeItemName)
    if is_player_busy then return end

    local defaultItemData = spaceconfig.IndustryItems[_industryTradeItemName]

    if not defaultItemData then return end

    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then
        Notify(Lang:t('not_found_industry'), 'error')
        return
    end

    local itemTradeData = industryData.tradeData[spaceconfig.Industry.TradeType.FORSALE][_industryTradeItemName]
    if not itemTradeData then
        Notify(Lang:t('not_found_item'), 'error')
        return
    end

    local playerPed = PlayerPedId()
    -- Bước 1: Kiểm tra loại hàng hóa này sẽ phải mua bằng cách nào? cầm trên tay hoặc phải có xe
    -- Hàng trên tay: crate
    -- Hàng cần xe: liquid, lóose,vehicle, strongbox, pallet
    if not isPedInForkLift(playerPed) and (defaultItemData.transType == spaceconfig.ItemTransportType.CRATE or
            defaultItemData.transType == spaceconfig.ItemTransportType.STRONGBOX) then
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
                amount = 1,
                type = GetItemTransportUnit(_industryTradeItemName),
                item = defaultItemData.label,
                price = math.groupdigits(itemTradeData.price)
            })

        local toggleModalConfirm = GetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key)

        local confirmData = toggleModalConfirm == spaceconfig.ToggleModalConfirmKvp.on and ShowModal({
            type = spaceconfig.NUIModalType.CONFIRM,
            title = Lang:t('trade_point_of', { industry = industryData.label }),
            description = desc,
            extraArgs = {}
        }) or {
            confirm = true
        }

        if confirmData and confirmData.confirm then
            local result = TriggerCallbackAwait('gs_trucker:callback:buyItem', spaceconfig.Industry.TradeState.onFoot,
                _industryName, _industryTradeItemName)

            if not result.status then
                -- If status is False and fallback error msg
                Notify(result.msg, 'error')
                return
            end
            -- Bán trả lại item cho industry với giá cũ
            if result.isBackItem then
                removePlayerCarryProp()

                Notify(Lang:t('return_item_to_industry'), 'success')
                return
            end

            addPlayerCarryProp(defaultItemData.prop)
            -- Mua hàng thành công, chỗ này thêm object attach vào người chơi
            -- Notify('mua thanh cong', 'success')
            player_action_hand_buy_time = GetGameTimer()
        end
    else
        -- Kiểm tra có đang ở trên xe không
        if not IsPedInAnyVehicle(playerPed, false) then
            Notify(Lang:t('you_need_in_a_vehicle_to_buy_this_type'), 'error')
            return
        end

        local vehicle = GetVehiclePedIsIn(playerPed, false)
        -- Kiểm tra xem có đang dính vào trailer không
        if IsVehicleAttachedToTrailer(vehicle) then
            local retval, trailer = GetVehicleTrailerVehicle(vehicle)
            if retval then vehicle = trailer end
        end
        -- Kiểm tra xem xe đó có chở được hàng không, hoặc trailer của xe đó có chở được hàng không
        local vehModelHash = GetEntityModel(vehicle)
        -- Co du level de chat hang len xe nay khong
        local truckerSkill = GetPlayerTruckerSkill()
        local vehData = spaceconfig.VehicleTransport[vehModelHash]
        if not vehData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then return false end
        if vehData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
            Notify(Lang:t('trucker_skill_not_enough'), 'error')
            return false
        end

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
        -- Hiện thông tin xe đó có thể mua tối đa được bao nhiêu hàng
        local availableCapacity = (storageData.maxCapacity - storageData.currentCapacity) / defaultItemData.capacity

        if availableCapacity < 1 then
            Notify(Lang:t('veh_storage_is_full'), 'error')
            return false
        end
        -- Hien modal dialog de nhap so luong
        local maxAmount = itemTradeData.inStock

        maxAmount = math.floor((availableCapacity > maxAmount) and maxAmount or availableCapacity)

        if maxAmount <= 0 then
            Notify(Lang:t('industry_out_of_stock'), 'error')
            return false
        end

        local modalData = ShowModal({
            type = spaceconfig.NUIModalType.DIALOG,
            title = Lang:t('buy_amount_label'),
            description = Lang:t('enter_quantity_you_want', { max = maxAmount }),
            extraArgs = {
                min = 1,
                max = maxAmount,
                default = maxAmount,
            }
        })

        if not modalData or not modalData.confirm then return false end

        local amountInput = modalData.value
        if not amountInput then return false end
        if amountInput > tonumber(availableCapacity) or amountInput < 1 then return false end
        -- Gọi callback lên server check lần nữa
        local args = {
            buyAmount = amountInput,
            vehNetId = vehNetId
        }

        is_player_busy = true
        local result = TriggerCallbackAwait('gs_trucker:callback:buyItem', spaceconfig.Industry.TradeState.onVehicle,
            _industryName, _industryTradeItemName, args)

        if not result.status then
            -- If status is False and fallback error msg
            Notify(result.msg, 'error')
            is_player_busy = false
            return
        end

        if result.seconds then
            Progressbar('truck_loading', Lang:t('progress_loading'), result.seconds * 1000, false, false,
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                    -- OnFinish
                    is_player_busy = false
                end, function()
                    -- OnCancel
                    is_player_busy = false
                end)
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

    local defaultItemData = spaceconfig.IndustryItems[_industryTradeItemName]

    if not defaultItemData then return end

    local industryData = Industries:GetIndustry(_industryName)
    if not industryData then
        Notify(Lang:t('not_found_industry'), 'error')
        return
    end

    local itemTradeData = industryData.tradeData[spaceconfig.Industry.TradeType.WANTED][_industryTradeItemName]
    if not itemTradeData then
        Notify(Lang:t('not_found_item'), 'error')
        return
    end

    local playerPed = PlayerPedId()

    if not IsPedInAnyVehicle(playerPed, false) and
        (defaultItemData.transType == spaceconfig.ItemTransportType.CRATE or
            defaultItemData.transType == spaceconfig.ItemTransportType.STRONGBOX) then
        -- if IsPedInAnyVehicle(playerPed, false) then
        --     Notify(Lang:t('you_need_to_get_out_car'), 'error')
        --     return
        -- end

        local carryItem = TriggerCallbackAwait('gs_trucker:callback:checkCarryItem')
        if not carryItem then
            Notify(Lang:t('you_no_have_goods'), 'error')
            return
        end

        if carryItem.itemName ~= _industryTradeItemName then
            Notify(Lang:t('not_selling_point'), 'error')
            return
        end

        local toggleModalConfirm = GetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key)

        local confirmData = toggleModalConfirm == spaceconfig.ToggleModalConfirmKvp.on and ShowModal({
            type = spaceconfig.NUIModalType.CONFIRM,
            title = Lang:t('trade_point_of', { industry = industryData.label }),
            description = Lang:t('are_you_sure_want_to_sell',
                {
                    type = GetItemTransportUnit(_industryTradeItemName),
                    item = defaultItemData.label,
                    price = math.groupdigits(itemTradeData.price)
                }),
            extraArgs = {}
        }) or {
            confirm = true
        }

        if confirmData and confirmData.confirm then
            local result = TriggerCallbackAwait('gs_trucker:callback:sellItem', spaceconfig.Industry.TradeState
                .onFoot,
                _industryName, _industryTradeItemName)

            if not result.status then
                -- If status is False and fallback error msg
                Notify(result.msg, 'error')
                return
            end

            removePlayerCarryProp()
        end
    else
        -- Kiểm tra loại hàng có phải crate/strongbox ko, nếu đúng thì phải có thêm isallow
        if (defaultItemData.transType == spaceconfig.ItemTransportType.CRATE or
                defaultItemData.transType == spaceconfig.ItemTransportType.STRONGBOX) and
            (not isPedInForkLift(playerPed) and not spaceconfig.IsAllowToSellCrateByVehicle) then
            Notify(Lang:t('you_need_to_get_out_car'), 'error')
            return
        end
        -- Kiểm tra có đang ở trên xe không
        if not IsPedInAnyVehicle(playerPed, false) then
            Notify(Lang:t('you_need_in_a_vehicle_to_sell'), 'error')
            return
        end
        local vehicleEntity = GetVehiclePedIsIn(playerPed, false)
        -- Kiểm tra xem có đang dính vào trailer không
        if IsVehicleAttachedToTrailer(vehicleEntity) then
            local retval, trailer = GetVehicleTrailerVehicle(vehicleEntity)
            if retval then vehicleEntity = trailer end
        end
        -- Kiểm tra xem xe đó có chở được hàng không, hoặc trailer của xe đó có chở được hàng không
        local vehModelHash = GetEntityModel(vehicleEntity)
        if not IsVehicleModelCanTransportType(vehModelHash, defaultItemData.transType) then
            Notify(Lang:t('veh_is_not_a_freight'), 'error')
            return false
        end

        local vehNetId = VehToNet(vehicleEntity)
        local checkStorageCB = TriggerCallbackAwait('gs_trucker:callback:checkVehicleStorage', vehNetId)

        if not checkStorageCB.status then
            Notify(checkStorageCB.msg, 'error')
            return false
        end

        ---@type VehicleStorageData
        local storageData = checkStorageCB.data
        -- Kiểm tra xem xe đó đã có hàng sẵn chưa, ,
        -- Nếu chưa có hàng thì báo lỗi không có hàng để bán
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

        -- Hien modal dialog de nhap so luong
        local maxAmount = itemTradeData.storageSize - itemTradeData.inStock

        maxAmount = (maxAmount > sellItemData.amount) and sellItemData.amount or maxAmount

        local modalData = ShowModal({
            type = spaceconfig.NUIModalType.DIALOG,
            title = Lang:t('sell_amount_label'),
            description = Lang:t('enter_quantity_you_want_sell', { max = maxAmount }),
            extraArgs = {
                min = 1,
                max = maxAmount,
                default = maxAmount,
            }
        })

        if not modalData or not modalData.confirm then return false end

        local amountInput = modalData.value
        if not amountInput then return false end
        if amountInput > sellItemData.amount or amountInput < 1 then return false end

        local args = {
            sellAmount = amountInput,
            vehNetId = vehNetId
        }

        is_player_busy = true

        local result = TriggerCallbackAwait('gs_trucker:callback:sellItem', spaceconfig.Industry.TradeState.onVehicle,
            _industryName, _industryTradeItemName, args)

        if not result.status then
            -- If status is False and fallback error msg
            Notify(result.msg, 'error')
            is_player_busy = false
            return
        end

        if result.seconds then
            Progressbar('truck_unloading', Lang:t('progress_unloading'), result.seconds * 1000, false, false,
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                    -- On Finish
                    is_player_busy = false
                end, function()
                    -- on Cancel
                    is_player_busy = false
                end)
        end
    end
end

---OnPlayerLoadPackageIntoVehicle
---@param entity any
---@return boolean
function OnPlayerLoadPackageIntoVehicle(entity)
    if not IsEntityAVehicle(entity) then return false end

    local vehNetId = VehToNet(entity)
    local vehModelHash = GetEntityModel(entity)
    local vehicleLockStatus = GetVehicleDoorLockStatus(entity)

    -- Client Check
    -- Co du level de chat hang len xe nay khong
    local truckerSkill = GetPlayerTruckerSkill()
    local vehData = spaceconfig.VehicleTransport[vehModelHash]
    if not vehData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then return false end
    if vehData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
        Notify(Lang:t('trucker_skill_not_enough'), 'error')
        return false
    end
    -- Co hang tren tay hay khong
    if not HasPlayerCarryItem() then
        Notify(Lang:t('you_no_have_goods_on_hand'), 'error')
        return false
    end
    -- Xe co the cho duoc hang tren tay hay khong
    local carryItemName = GetPlayerCarryItemName()
    if not IsVehicleModelCanTransportType(vehModelHash, spaceconfig.IndustryItems[carryItemName].transType) then
        Notify(Lang:t('veh_is_not_a_freight'), 'error')
        return false
    end
    -- Xe co bi khoa cua hay khong
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end

    local checkStorageCB = checkVehicleCanAddItemToStorage(vehNetId, carryItemName)

    if not checkStorageCB.status then
        Notify(checkStorageCB.msg, 'error')
        return false
    end
    -- Hien len modal cofirm
    local toggleModalConfirm = GetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key)

    local confirmData = toggleModalConfirm == spaceconfig.ToggleModalConfirmKvp.on and ShowModal({
        type = spaceconfig.NUIModalType.CONFIRM,
        title = Lang:t('modal_load_package_into_vehicle_title'),
        description = Lang:t('modal_load_package_into_vehicle_desc',
            {
                item = spaceconfig.IndustryItems[carryItemName].label,
                plate = GetVehicleNumberPlateText(entity)
            }),
        extraArgs = {}
    }) or {
        confirm = true
    }

    if confirmData and confirmData.confirm then
        -- Đầu tiên sẽ lấy netId gửi lên cho server
        local result = TriggerCallbackAwait('gs_trucker:callback:loadPackageIntoVehicleByHand', vehNetId)

        if not result.status then
            Notify(result.msg, 'error')
            return false
        end

        removePlayerCarryProp()

        if result.data and result.data.currentCapacity then
            Notify(
                Lang:t('veh_current_storage_capacity_is',
                    { current = result.data.currentCapacity, max = result.data.maxCapacity }),
                'success')
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

    -- Xe co bi khoa cua hay khong
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end

    -- Xe co the cho duoc hang hay khong
    if not IsVehicleModelCanDoGSTrucker(vehModelHash) then
        Notify(Lang:t('veh_is_not_a_freight'), 'error')
        return false
    end

    local result = TriggerCallbackAwait('gs_trucker:callback:checkVehicleStorage', vehNetId)

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
        -- local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        -- if GetEntityModel(currentVehicle) ~= `forklift` then
        --     return
        -- end

        -- -- Neu o tren xe forklift
        -- OnForkliftUnloadFromVehicleStorage(_vehEntity, _itemName)
        return
    end

    local vehNetId = VehToNet(_vehEntity)
    local vehicleLockStatus = GetVehicleDoorLockStatus(_vehEntity)
    local defaultItemData = spaceconfig.IndustryItems[_itemName]

    if not defaultItemData then return false end
    -- Client Check
    -- Co hang tren tay hay khong
    if HasPlayerCarryItem() then
        Notify(Lang:t('you_have_other_goods_on_hand'), 'error')
        return false
    end

    -- Loại hàng này có được dỡ xuống được hay không
    if defaultItemData.transType ~= spaceconfig.ItemTransportType.CRATE and
        defaultItemData.transType ~= spaceconfig.ItemTransportType.STRONGBOX then
        Notify(Lang:t('item_can_not_unload_by_hand'), 'error')
        return false
    end

    -- Xe co bi khoa cua hay khong
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end

    local result = TriggerCallbackAwait('gs_trucker:callback:unloadPackageFromVehicleByHand', vehNetId, _itemName)

    if not result.status then
        Notify(result.msg, 'error')
        return
    end

    addPlayerCarryProp(defaultItemData.prop)
end

function OnPlayerDeath()
    if spaceconfig.DropPackageWhenDie then
        local result = TriggerCallbackAwait('gs_trucker:callback:onPlayerDeath')

        if result then
            removePlayerCarryProp()
        end
    end
end

-- V2 Forklift functions
-- Thread
local rotationToDirection = function(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

local rayCastFromForkLiftFindCargo = function(distance, currentVehicle)
    local cameraRotation = GetEntityRotation(currentVehicle)
    local cameraCoord = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, 1.0, 1.0)
    local direction = rotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination
        .x, destination.y, destination.z, 2, currentVehicle, 0))
    return b, c, e
end

---drawArrowMarkerData
---@param count number
---@param isBack? boolean
local drawArrowMarkerData = function(count, isBack)
    local markerId = 20
    local fixZ = 1.78
    local scale = vector3(0.6, 0.6, 0.6)
    if count < 50 then
        markerId = 20
        scale = vector3(0.6, 0.6, 0.6)
        fixZ = 1.78
    elseif count < 100 then
        markerId = 21
        scale = vector3(0.7, 0.7, 0.7)
        fixZ = 1.65
    elseif count < 150 then
        markerId = 22
        scale = vector3(1, 1, 1)
        fixZ = 1.524
    elseif isBack then
        markerId = 21
        scale = vector3(0.7, 0.7, 0.7)
        fixZ = 1.65
    end
    return markerId, fixZ, scale
end

function StartMainThread()
    Citizen.CreateThread(function()
        mainThread = true
        while mainThread do
            local playerPed = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            if currentVehicle and IsPedInAnyVehicle(playerPed, false)
                and DoesEntityExist(currentVehicle) and GetEntityModel(currentVehicle) == `forklift` then
                local count = 0
                repeat
                    local hit, coords, entity = rayCastFromForkLiftFindCargo(15.0, currentVehicle)
                    if hit and IsEntityAVehicle(entity) then
                        local model = GetEntityModel(entity)
                        local vehCargoData = spaceconfig.VehicleTransport[model]
                        if vehCargoData then
                            count = count + 1
                            if count > 150 then count = 0 end
                            local markerId, fixZ, scale = drawArrowMarkerData(count, false)
                            local entityCoords = GetOffsetFromEntityInWorldCoords(entity, vehCargoData.trunkOffset.x,
                                vehCargoData.trunkOffset.y, vehCargoData.trunkOffset.z)

                            DrawMarker(markerId, entityCoords.x, entityCoords.y, entityCoords.z + fixZ, 0.0, 0.0, 0.0,
                                0.0,
                                180.0, 0.0, scale.x, scale.y, scale.z, 255, 222, 20, 200, false, true, 2, false, nil, nil,
                                false)
                            if IsControlJustReleased(0, 38) and #(GetEntityCoords(playerPed).xy - entityCoords.xy) <= 5 then
                                local currentNearPoint = Point.getClosestPoint()
                                if not currentNearPoint or currentNearPoint.currentDistance > 5 then
                                    OnPlayerActiveTrunkByForkLift(currentVehicle, entity)
                                else
                                    Notify(Lang:t('forklift_too_closest_trade_point'), 'error')
                                end
                            end
                        end
                    end
                    Wait(1)
                until not IsPedInAnyVehicle(playerPed, false)
            end


            Wait(1000)
        end
    end)
end

function OnPlayerActiveTrunkByForkLift(forkliftEntity, targetEntity)
    -- Kiểm tra xem có phải là forklift ko
    local forkliftModelHash = `forklift`
    if GetEntityModel(forkliftEntity) ~= forkliftModelHash then
        return false
    end

    local vehicleLockStatus = GetVehicleDoorLockStatus(targetEntity)
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end

    local targetModelHash = GetEntityModel(targetEntity)
    local vehicleTargetCargoData = spaceconfig.VehicleTransport[targetModelHash]
    -- Kiểm tra phương tiện mục tiêu có thể chở hàng hay không
    if not vehicleTargetCargoData then return false end

    local forkliftNetId = VehToNet(forkliftEntity)
    local targetNetId = VehToNet(targetEntity)
    local vehiclesStorage = TriggerCallbackAwait('gs_trucker:callback:checkMultiVehicleStorage',
        { forkliftNetId, targetNetId })

    if not vehiclesStorage.status then
        Notify(vehiclesStorage.msg, 'error')
        return false
    end

    ---@type VehicleStorageData
    local forkliftStorageData = vehiclesStorage.data[forkliftNetId]
    ---@type VehicleStorageData
    local targetStorageData = vehiclesStorage.data[targetNetId]

    -- Kiểm tra xem xe đó đã có hàng sẵn chưa,
    if forkliftStorageData.currentCapacity <= 0 then
        -- Nếu chưa có hàng thì Kiểm tra xe mục tiêu có hàng để dỡ xuống hay không
        Notify(Lang:t('veh_storage_is_empty'), 'error')
        return false
        -- if targetStorageData.currentCapacity <= 0 then
        --     Notify(Lang:t('veh_storage_is_empty'), 'error')
        --     return false
        -- end
        -- Làm tương tự như mua hàng
        -- Lấy dữ liệu loại hàng trên xe

        -- ShowVehicleStorage(targetEntity, targetStorageData)
    else
        --Neu da co hang hoa tren xe roi thi tai hang len xe muc tieu
        local firstItem = next(forkliftStorageData.storage)
        local defaultItemData = spaceconfig.IndustryItems[firstItem]
        if not defaultItemData then return false end
        -- Kiem tra Skill
        local truckerSkill = GetPlayerTruckerSkill()
        if not vehicleTargetCargoData or not truckerSkill or not truckerSkill[spaceconfig.SkillTypeField.currentLevel] then return false end
        if vehicleTargetCargoData.level > truckerSkill[spaceconfig.SkillTypeField.currentLevel] then
            Notify(Lang:t('trucker_skill_not_enough'), 'error')
            return false
        end
        -- Kiểm tra loại hàng trên xe forklift có phù hợp để tải lên xe truck ko

        -- Kiểm tra xem xe đó đã có hàng sẵn chưa, ,
        -- nếu có rồi thì kiểm tra loại item xem có có giống nhau hay có cho phép mix không, nếu ko thì không chở được
        if targetStorageData.currentCapacity > 0 then --Đã có sẵn hàng
            for itemName, value in pairs(targetStorageData.storage) do
                if not itemName then
                    Notify(Lang:t('forklift_error_when_load_item'), 'error')
                    return false
                end
                if not IsItemTransportTypeCanMix(spaceconfig.IndustryItems[itemName].transType) then
                    -- Nếu không cho phép mix vậy thì kiểm tra nó có giống hàng đang mua không
                    -- Giống thì cho phép mua thêm
                    if itemName ~= firstItem then
                        Notify(Lang:t('currently_another_type_of_cargo'), 'error')
                        return false
                    end
                end
            end
            -- Nếu đã có hàng nhưng vẫn cho trộn lẫn có thể là pallet và crate, strongbox
        end

        if not IsVehicleModelCanTransportType(targetModelHash, defaultItemData.transType) then
            Notify(Lang:t('veh_is_not_a_freight'), 'error')
            return false
        end

        -- Hien modal dialog de nhap so luong muon do hang xuong

        -- Hiện thông tin xe đó có thể mua tối đa được bao nhiêu hàng
        local availableCapacity = (targetStorageData.maxCapacity - targetStorageData.currentCapacity) /
            defaultItemData.capacity

        if availableCapacity < 1 then
            Notify(Lang:t('veh_storage_is_full'), 'error')
            return false
        end
        -- Hien modal dialog de nhap so luong
        local maxAmount = forkliftStorageData.currentCapacity

        maxAmount = math.floor((maxAmount > availableCapacity) and availableCapacity or maxAmount)

        local modalData = ShowModal({
            type = spaceconfig.NUIModalType.DIALOG,
            title = Lang:t('forklift_load_amount_label'),
            description = Lang:t('forklift_enter_quantity_you_want_load', { max = maxAmount }),
            extraArgs = {
                min = 1,
                max = maxAmount,
                default = maxAmount,
            }
        })

        if not modalData or not modalData.confirm then return false end

        local amountInput = modalData.value
        if not amountInput then return false end
        if amountInput > maxAmount or amountInput < 1 then return false end

        local args = {
            itemName = firstItem,
            loadAmount = amountInput,
            forkliftNetId = forkliftNetId,
            targetNetId = targetNetId
        }

        local result = TriggerCallbackAwait('gs_trucker:callback:forkliftLoadIntoCargo', args)

        if not result.status then
            -- If status is False and fallback error msg
            Notify(result.msg, 'error')
            is_player_busy = false
            return
        end

        if result.seconds then
            Progressbar('truck_loading', Lang:t('progress_loading'), result.seconds * 1000, false, false,
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                    -- OnFinish
                    is_player_busy = false
                end, function()
                    -- OnCancel
                    is_player_busy = false
                end)
        end

        if result.data and result.data.currentCapacity then
            Notify(
                Lang:t('veh_current_storage_capacity_is',
                    { current = result.data.currentCapacity, max = result.data.maxCapacity }),
                'success')
        end

        if result.vehPropsData then
            Citizen.CreateThread(function()
                for key, value in pairs(result.vehPropsData) do
                    if value and value.slot then
                        addVehicleProp(targetEntity, value)
                        Wait(1000 * defaultItemData.capacity)
                    end
                end
            end)
        end
    end
end

function OnForkliftUnloadFromVehicleStorage(_vehEntity, _itemName)
    local playerPed = PlayerPedId()
    local forkliftEntity = GetVehiclePedIsIn(playerPed, false)

    if GetEntityModel(forkliftEntity) ~= `forklift` then return end

    local vehicleLockStatus = GetVehicleDoorLockStatus(_vehEntity)
    if vehicleLockStatus >= 2 then
        Notify(Lang:t('veh_door_locked'), 'error')
        return false
    end

    local forkliftNetId = VehToNet(forkliftEntity)
    local targetNetId = VehToNet(_vehEntity)
    local vehiclesStorage = TriggerCallbackAwait('gs_trucker:callback:checkMultiVehicleStorage',
        { forkliftNetId, targetNetId })

    if not vehiclesStorage.status then
        Notify(vehiclesStorage.msg, 'error')
        return false
    end

    ---@type VehicleStorageData
    local forkliftStorageData = vehiclesStorage.data[forkliftNetId]
    ---@type VehicleStorageData
    local targetStorageData = vehiclesStorage.data[targetNetId]
end

local tradeBlips = {}
local tradeBlipData = {}
function OnPlayerJobUpdate(jobName)
    if spaceconfig.JobRequired and jobName == spaceconfig.JobName then
        for _, value in pairs(tradeBlipData) do
            DrawTradeBlip(value.id, value.tradeType, value.blipCoords)
        end
    else
        for _, value in pairs(tradeBlipData) do
            RemoveTradeBlip(value.id)
        end
    end
end

function AddTradeBlip(id, _tradeType, _blipCoords)
    tradeBlipData[id] = {
        id = id,
        blipCoords = _blipCoords,
        tradeType = _tradeType,
    }
    if spaceconfig.JobRequired and GetPlayerJobName() ~= spaceconfig.JobName then return end
    DrawTradeBlip(id, _tradeType, _blipCoords)
end

function DrawTradeBlip(id, _tradeType, _blipCoords)
    if tradeBlips[id] then
        RemoveBlip(tradeBlips[id])
        tradeBlips[id] = nil
    end

    local blip = AddBlipForCoord(_blipCoords.x, _blipCoords.y, _blipCoords.z)
    SetBlipSprite(blip, _tradeType == spaceconfig.Industry.TradeType.FORSALE and 120 or 106)
    SetBlipDisplay(blip, 5)
    SetBlipScale(blip, 0.5)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, _tradeType == spaceconfig.Industry.TradeType.FORSALE and 5 or 2)
    EndTextCommandSetBlipName(blip)
    tradeBlips[id] = blip
end

function RemoveTradeBlip(id)
    if tradeBlips[id] then
        RemoveBlip(tradeBlips[id])
        tradeBlips[id] = nil
    end
end
