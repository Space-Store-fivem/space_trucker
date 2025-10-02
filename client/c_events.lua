RegisterNetEvent('space_trucker:client:industry:addItemAmount', function(_industryName, _tradeType, _itemName, _amount)
    if not HasIndustriesLoaded() then return end
    local industry = Industries:GetIndustry(_industryName)
    if not industry then return end
    industry:AddItemAmount(_tradeType, _itemName, _amount)
end)

RegisterNetEvent('space_trucker:client:industry:removeItemAmount', function(_industryName, _tradeType, _itemName, _amount)
    if not HasIndustriesLoaded() then return end
    local industry = Industries:GetIndustry(_industryName)
    if not industry then return end
    industry:RemoveItemAmount(_tradeType, _itemName, _amount)
end)

RegisterNetEvent('space_trucker:client:addPlayerCarryData', function(data)
    if not source or source == '' then
        print('DEBUG: Event call from client')
        return
    end
    PlayerCarryData = {
        isCarry = data.isCarry,
        carryItemName = data.carryItemName,
        carryItemPrice = data.carryItemPrice,
        carryItemFromIndustry = data.carryItemFromIndustry
    }
end)

---@class IndustryUpdateData
---@field tier number
---@field wanted? table
---@field forsale? table

RegisterNetEvent('space_trucker:client:updateIndustriesData', function(_industriesData)
    if not HasIndustriesLoaded() then return end

    ---@param industryName string
    ---@param value IndustryUpdateData
    for industryName, value in pairs(_industriesData) do
        local industry = Industries:GetIndustry(industryName)
        if industry then
            if value[spaceconfig.Industry.TradeType.FORSALE] and next(value[spaceconfig.Industry.TradeType.FORSALE]) then
                for itemName, updateData in pairs(value[spaceconfig.Industry.TradeType.FORSALE]) do
                    industry.tradeData[spaceconfig.Industry.TradeType.FORSALE][itemName].inStock = updateData.amount
                end
            end
            if value[spaceconfig.Industry.TradeType.WANTED] and next(value[spaceconfig.Industry.TradeType.WANTED]) then
                for itemName, updateData in pairs(value[spaceconfig.Industry.TradeType.WANTED]) do
                    industry.tradeData[spaceconfig.Industry.TradeType.WANTED][itemName].inStock = updateData.amount
                end
            end
        end
    end
end)


RegisterNetEvent('gstrucker:client:showTruckerPDA', function()
    ToggleTablet(true)
    local industryCounts = Industries:GetCounts()
    local truckerData = GetPlayerTruckerSkill()
    if not truckerData then
        truckerData = {
            totalProfit = 0,
            totalPackage = 0,
            totalDistance = 0,
            level = 1,
            exp = 0
        }
    end

    local toggleModalConfirm = GetResourceKvpInt(spaceconfig.ToggleModalConfirmKvp.key)


    local carryData = {
        isCarry = false,
        itemName = '',
        buyPrice = 0,
        industryName = ''
    }

    if HasPlayerCarryItem() then
        carryData = {
            isCarry = true,
            itemName = GetItemLabel(GetPlayerCarryItemName()),
            buyPrice = GetPlayerCarryItemPrice(),
            industryName = GetPlayerCarryIndustryLabel()
        }
    end

    SendNUIMessage({
        action = 'sendTruckerPDA',
        data = {
            truckerData = {
                totalProfit = truckerData.totalProfit,
                totalPackage = truckerData.totalPackage,
                totalDistance = truckerData.totalDistance,
                exp = truckerData.exp,
                needExp = GetTruckerNextEXP(truckerData.level),
                level = truckerData.level
            },
            pdaData = {
                totalPrimary = industryCounts.primary,
                totalSecondary = industryCounts.secondary,
                totalBusinesses = industryCounts.business,
                totalVehicleCargo = spaceconfig.VehicleTransportCount,
            },
            carryData = carryData,
            isToggleModalConfirm = toggleModalConfirm == 1 and true or false
        }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
end)
