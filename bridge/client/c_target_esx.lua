local ESX = exports['es_extended']:getSharedObject()

RegisterCommand('tpda', function(source, args, raw)
    TriggerEvent('gstrucker:client:showTruckerPDA')
end)

-- Notify
function Notify(notifyMsg, notifyType)
    if not notifyType then notifyType = 'success' end
    TriggerEvent('ESX:Notify', notifyType, 5000, notifyMsg)
end

-- Progressbar From QBCore
function Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo,
                     onFinish, onCancel)
    return ESX.Progressbar(label, duration, {
        FreezePlayer = true,
        animation = {},
        onFinish = onFinish
    })
end

local vehModels = {}
for vHash, _ in pairs(spaceconfig.VehicleTransport) do
    vehModels[#vehModels + 1] = vHash
end

exports.ox_target:addModel(vehModels, {
    icon = 'fas fa-truck-ramp-box',
    label = Lang:t('veh_load_package'),
    distance = 2.0,
    bones = { 'boot', 'bodyshell', 'seat_pside_r', 'seat_dside_r', 'seat_pside_f', 'seat_dside_f' },
    canInteract = function(entity, distance, coords, name, bone) -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
        local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
        if HasPlayerCarryItem() and vehicleLockStatus <= 1 then
            local carryItemName = GetPlayerCarryItemName()
            if IsVehicleModelCanTransportType(GetEntityModel(entity), spaceconfig.IndustryItems[carryItemName].transType) then
                return true
            end
            return false
        end -- This will return false if the entity interacted with is a player and otherwise returns true
        return false
    end,
    onSelect = function(data)
        OnPlayerLoadPackageIntoVehicle(data.entity)
    end
})

exports.ox_target:addModel(vehModels, {
    icon = 'fas fa-truck-ramp-box',
    label = Lang:t('veh_check_storage'),
    distance = 2.0,
    bones = { 'boot', 'bodyshell', 'seat_pside_r', 'seat_dside_r', 'seat_pside_f', 'seat_dside_f' },
    canInteract = function(entity, distance, coords, name, bone) -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
        local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
        if not IsPedInAnyVehicle(PlayerPedId(), false) and vehicleLockStatus <= 1 and IsVehicleModelCanDoGSTrucker(GetEntityModel(entity)) then
            return true
        end -- This will return false if the entity interacted with is a player and otherwise returns true
        return false
    end,
    onSelect = function(data)
        OnPlayerCheckVehicleStorage(data.entity)
    end
})
