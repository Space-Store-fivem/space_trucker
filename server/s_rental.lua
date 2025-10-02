local truck_rental_data = {}

CreateCallback('space_trucker:callback:getCash', function (source, cb)
    local cash = GetPlayerCash(source)
    return cb and cb(cash) or cash
end)

CreateCallback('space_trucker:callback:rentVehicle',
    function(source, cb, rentPointId, vehicleIndex, vehicleHash, spawnCoords)
        if not spaceconfig.VehicleRentLocations[rentPointId] or spaceconfig.VehicleRentLocations[rentPointId].vehList[vehicleIndex] ~= vehicleHash then
            return cb({ status = false, msg = Lang:t('vehicle_not_found') })
        end

        local vehicle = spaceconfig.VehicleTransport[vehicleHash]
        local rentPrice = vehicle.rentPrice and vehicle.rentPrice or (spaceconfig.VehicleRentBaseCost * vehicle.capacity)

        if GetPlayerCash(source) < rentPrice then
            return cb({ status = false, msg = Lang:t('not_enough_money') })
        end

        RemovePlayerCash(source, rentPrice, 'rent_truck_vehicle')

        local veh = CreateVehicle(vehicleHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, true, true)

        local vehPlate = Lang:t('veh_truck_plate') .. tostring(math.random(10000, 99999))

        truck_rental_data[vehPlate .. '_' .. vehicleHash] = {
            rentPointId = rentPointId,
            rentPrice = rentPrice
        }

        SetVehicleNumberPlateText(veh, vehPlate)
        while not DoesEntityExist(veh) do Wait(0) end
        while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
        return cb({ status = true, netId = NetworkGetNetworkIdFromEntity(veh), vehPlate = vehPlate })
    end)

RegisterNetEvent('space_trucker:server:returnRentTruck', function(rentPointId, vehNetId)
    local source = source
    if not spaceconfig.VehicleRentLocations[rentPointId] then
        return
    end

    local vehicleEntity = NetworkGetEntityFromNetworkId(vehNetId)
    local vehicleCoords = GetEntityCoords(vehicleEntity)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local rentPointCoords = spaceconfig.VehicleRentLocations[rentPointId].location

    if #(vehicleCoords - playerCoords) > 15 then
        return
    end

    if #(rentPointCoords - playerCoords) > 5 then
        return
    end
    local vehiclePlate = GetVehicleNumberPlateText(vehicleEntity)
    local vehicleHash = GetEntityModel(vehicleEntity)

    local rentData = truck_rental_data[vehiclePlate .. '_' .. vehicleHash]
    if not rentData then return end
    if rentData.rentPointId ~= rentPointId then return end

    local returnMoney = rentData.rentPrice *  (spaceconfig.VehicleRentReturnFeePercent / 100)
    AddPlayerCash(source, returnMoney, 'return_truck_money')
    DeleteEntity(vehicleEntity)
end)
