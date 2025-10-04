

local QBCore = exports['qb-core']:GetCoreObject()
local vehModels = {}


-- Notify
function Notify(notifyMsg, notifyType)
    if not notifyType then notifyType = 'success' end
    QBCore.Functions.Notify(notifyMsg, notifyType)
end

-- Progressbar From QBCore
function Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo,
                      onFinish, onCancel)
    return QBCore.Functions.Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation,
        prop, propTwo, onFinish, onCancel)
end

-- Target Logic adapted for ox_target and QBCore environment
function AddTargetModels()
    if #vehModels == 0 then
        for vHash, _ in pairs(spaceconfig.VehicleTransport) do
            vehModels[#vehModels + 1] = vHash
        end
    end

    exports.ox_target:addModel(vehModels, {
        {
            icon = 'fas fa-truck-ramp-box',
            label = Lang:t('veh_load_package'),
            distance = 2.0,
            bones = { 'boot', 'bodyshell', 'seat_pside_r', 'seat_dside_r', 'seat_pside_f', 'seat_dside_f' },
            canInteract = function(entity)
                local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
                if HasPlayerCarryItem() and vehicleLockStatus <= 1 then
                    local carryItemName = GetPlayerCarryItemName()
                    if IsVehicleModelCanTransportType(GetEntityModel(entity), spaceconfig.IndustryItems[carryItemName].transType) then
                        return true
                    end
                end
                return false
            end,
            onSelect = function(data)
                OnPlayerLoadPackageIntoVehicle(data.entity)
            end
        },
        {
            icon = 'fas fa-truck-ramp-box',
            label = Lang:t('veh_check_storage'),
            distance = 2.0,
            bones = { 'boot', 'bodyshell', 'seat_pside_r', 'seat_dside_r', 'seat_pside_f', 'seat_dside_f' },
            canInteract = function(entity)
                local vehicleLockStatus = GetVehicleDoorLockStatus(entity)
                if not IsPedInAnyVehicle(PlayerPedId(), false) and vehicleLockStatus <= 1 and IsVehicleModelCanDospacetrucker(GetEntityModel(entity)) then
                    return true
                end
                return false
            end,
            onSelect = function(data)
                OnPlayerCheckVehicleStorage(data.entity)
            end
        }
    })
end

function RemoveTargetModels()
    if #vehModels > 0 then
        -- Corrigido para remover pelo nome da label traduzida
        exports.ox_target:removeModel(vehModels, { Lang:t('veh_load_package'), Lang:t('veh_check_storage') })
    end
end

-- Add target models when the resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        AddTargetModels()
    end
end)

-- Remove options when the resource stops to prevent warnings
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    RemoveTargetModels()
end)