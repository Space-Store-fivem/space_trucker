local truckRentalBlips = {}
local truckRentalNUIData = {}

local function registerTruckRentalMenu()
    for rentPointId, rentData in pairs(spaceconfig.VehicleRentLocations) do
        local vehicles_rental = {}
        for _vehIndex, _vehHash in pairs(rentData.vehList) do
            local vehicle = spaceconfig.VehicleTransport[_vehHash]
            local rentPrice = vehicle.rentPrice and vehicle.rentPrice or
                (spaceconfig.VehicleRentBaseCost * vehicle.capacity)
            vehicles_rental[#vehicles_rental + 1] = {
                title = vehicle.label,
                capacity = vehicle.capacity,
                transType = GetVehicleTransportTypeLabel(vehicle.transType),
                image = spaceconfig.VehicleImageUrl:format(vehicle.name),
                rentPrice = rentPrice,
                level = vehicle.level,
                vehicleIndex = _vehIndex,
                vehicleHash = _vehHash,
                rentPointId = rentPointId
            }
        end

        table.sort(vehicles_rental, function(a, b)
            return a.rentPrice < b.rentPrice
        end)

        truckRentalNUIData[rentPointId] = vehicles_rental
    end
end

---showTruckRentalMenu
---@param rentPointId string
local function showTruckRentalMenu(rentPointId)
    local truckerData = GetPlayerTruckerSkill()
    local money = TriggerCallbackAwait('gs_trucker:callback:getCash')

    SendNUIMessage({
        action = 'sendTruckRentalMenu',
        data = {
            truckRentalInfo = truckRentalNUIData[rentPointId],
            playerRentalInfo = {
                level = truckerData and truckerData.level or 1,
                money = money
            }
        }
    })
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
end

---getClearSpawnPosition
---@param spawnPositions table
---@return boolean
---@return vector4
local function getClearSpawnPosition(spawnPositions)
    local vehicles = GetGamePool('CVehicle')
    for key, value in pairs(spawnPositions) do
        local coords = vector3(value.x, value.y, value.z)
        local closeVeh = {}
        for i = 1, #vehicles, 1 do
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance = #(vehicleCoords - coords)
            if distance <= 5.0 then
                closeVeh[#closeVeh + 1] = vehicles[i]
            end
        end

        if #closeVeh <= 0 then
            return true, value
        end
    end
    return false, vector4(0, 0, 0, 0)
end

local function returnRentTruck(rentPointId)
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if IsVehicleAttachedToTrailer(currentVehicle) then
        local isAttachToTrailer, trailer = GetVehicleTrailerVehicle(currentVehicle)

        if isAttachToTrailer then
            currentVehicle = trailer
        end
    end

    if not IsVehicleModelCanDoGSTrucker(GetEntityModel(currentVehicle)) then
        return
    end

    TriggerServerEvent('gs_trucker:server:returnRentTruck', rentPointId, VehToNet(currentVehicle))
end

function AddTruckRentalPoint()
    for key, value in pairs(spaceconfig.VehicleRentLocations) do
        if key and value then
            if truckRentalBlips[key] and DoesBlipExist(truckRentalBlips[key]) then
                RemoveBlip(truckRentalBlips[key])
            end

            if value.showBlip then
                local blip = AddBlipForCoord(value.location.x, value.location.y, value.location.z)
                SetBlipSprite(blip, value.blipSprite)
                SetBlipDisplay(blip, value.private and 5 or 2)
                SetBlipScale(blip, value.private and 0.6 or 0.8)
                SetBlipAsShortRange(blip, true)
                SetBlipColour(blip, value.blipColor)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(value.blipLabel)
                EndTextCommandSetBlipName(blip)
                truckRentalBlips[key] = blip
            end

            local rentPoint = Point.add({
                coords = value.location,
                distance = 15,
                title = value.title,
                rentPointId = key
            })

            function rentPoint:onPedStanding()
                DrawMarker(39, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,
                    255,
                    222, 20, 200, true, true, 2, false, nil, nil, false)

                if self.currentDistance < 10 then
                    Draw3DText(self.coords.x, self.coords.y, self.coords.z - 0.4,
                        value.title .. '\n' .. value.description, 4,
                        0.1, 0.1)
                end

                if self.currentDistance <= 2 then
                    ShowHelpNotify(Lang:t('help_text_press_e_to_interact'))
                end

                if self.currentDistance < 2 and IsControlJustReleased(0, 38) and not IsPedInAnyVehicle(PlayerPedId(), false) then
                    showTruckRentalMenu(self.rentPointId)
                elseif self.currentDistance < 5 and IsControlJustReleased(0, 38) and IsPedInAnyVehicle(PlayerPedId(), false) then
                    returnRentTruck(self.rentPointId)
                end
            end
        end
    end

    registerTruckRentalMenu()
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    for key, _ in pairs(truckRentalBlips) do
        if truckRentalBlips[key] and DoesBlipExist(truckRentalBlips[key]) then
            RemoveBlip(truckRentalBlips[key])
        end
    end
end)

local function rentVehicle(args)
    if not args.vehicleHash or not args.vehicleIndex or not args.rentPointId then return end

    local spawnPositions = spaceconfig.VehicleRentLocations[args.rentPointId].spawnPositions

    local isClearSpawn, clearSpawn = getClearSpawnPosition(spawnPositions)

    if not isClearSpawn then
        return Notify(Lang:t('no_parking_spot_available'), 'error')
    end

    local result = TriggerCallbackAwait('gs_trucker:callback:rentVehicle', args.rentPointId, args.vehicleIndex,
        args.vehicleHash,
        clearSpawn)

    if not result.status then
        return Notify(result.msg, 'error')
    end

    local veh = NetToVeh(result.netId)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    SetVehicleEngineOn(veh, true, true, false)
end

RegisterNUICallback('rentVehicle', function(data, cb)
    cb(1)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    local rentVehicleData = data.vehicle
    rentVehicle(rentVehicleData)
end)
