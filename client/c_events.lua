RegisterNetEvent('space_trucker:client:addPlayerCarryData', function(data)
    PlayerCarryData = {
        isCarry = data.isCarry,
        carryItemName = data.carryItemName,
        carryItemPrice = data.carryItemPrice,
        carryItemFromIndustry = data.carryItemFromIndustry
    }
end)