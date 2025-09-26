-- gs_trucker/client/c_loglogistics_hub.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNUICallback('requestLogisticsOrders', function(_, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getLogisticsOrders', function(orders)
        SendNUIMessage({
            action = 'setLogisticsOrders',
            data = orders or {}
        })
    end)
    cb('ok')
end)

RegisterNUICallback('createLogisticsOrder', function(data, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:createLogisticsOrder', function(result)
        if result.success then
            QBCore.Functions.Notify(result.message, 'success')
        else
            QBCore.Functions.Notify(result.message, 'error')
        end
        cb(result)
    end, data)
end)

RegisterNUICallback('acceptLogisticsOrder', function(data, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:acceptLogisticsOrder', function(result)
        if result and result.success then
            -- CORREÇÃO: Dispara um evento para o ficheiro de missões tratar
            TriggerEvent('gs_trucker:client:startLogisticsMission', result.orderData)
            
            -- Fecha o painel (vamos criar este evento no c_nui.lua)
            TriggerEvent('gs_trucker:client:closeCompanyPanel') 
        else
            QBCore.Functions.Notify(result.message or "Ocorreu um erro.", 'error')
        end
        cb(result)
    end, data)
end)