local QBCore = exports['qb-core']:GetCoreObject()

-- Garante que os callbacks da NUI sejam registrados apenas uma vez
local nuiCallbacksRegistered = false
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and not nuiCallbacksRegistered then
        print('^2[space-trucker]^7 A registar Callbacks da NUI pela primeira e única vez...')
        
        RegisterNuiCallback('loadPlayerStats', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getPlayerStats', function(stats)
                if stats then
                    cb(stats)
                else
                    cb({}) -- Retorna um objeto vazio em caso de erro para evitar crash na UI
                end
            end)
        end)

        RegisterNuiCallback('loadMissionHistory', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getMissionHistory', function(history)
                if history then
                    cb(history)
                else
                    cb({}) -- Retorna um objeto vazio em caso de erro
                end
            end)
        end)

        nuiCallbacksRegistered = true
    end
end)


-- Adicione este callback ao seu arquivo client/c_nui_callbacks.lua

RegisterNuiCallback('space_trucker:callback:updateProfile', function(data, cb)
    -- Este log irá confirmar que a UI está a comunicar com o cliente LUA
    print('--- [LOG | NUI_CALLBACK] Recebido pedido "updateProfile" da UI ---')
    
    QBCore.Functions.TriggerCallback('space_trucker:callback:updateProfile', function(result)
        -- Este log irá confirmar que o servidor respondeu e estamos a enviar de volta para a UI
        print('--- [LOG | NUI_CALLBACK] Servidor respondeu a "updateProfile". A enviar para a UI. ---')
        cb(result)
    end, data)
end)