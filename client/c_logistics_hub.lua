-- gs_trucker/client/c_logistics_hub.lua (VERSÃO FINAL E CORRIGIDA)

local QBCore = exports['qb-core']:GetCoreObject()

-- ## ADICIONADO: Callback para a UI pedir o preço de um item ##
-- Este bloco estava em falta e era a causa do erro de cálculo.
RegisterNUICallback('getOrderItemPrice', function(data, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getOrderItemPrice', function(price)
        cb(price or 0) -- Garante que sempre retorna um número para a UI
    end, data)
end)


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
        if result and result.success then
            QBCore.Functions.Notify(result.message, 'success')
        elseif result and not result.success then
            QBCore.Functions.Notify(result.message, 'error')
        end
        cb(result)
    end, data)
end)

RegisterNUICallback('acceptLogisticsOrder', function(data, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:acceptLogisticsOrder', function(result)
        if result and result.success then
            TriggerEvent('gs_trucker:client:startLogisticsMission', result.orderData)
            TriggerEvent('gs_trucker:client:closeCompanyPanel') 
        else
            QBCore.Functions.Notify(result.message or "Ocorreu um erro.", 'error')
        end
        cb(result)
    end, data)
end)