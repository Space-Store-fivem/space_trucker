-- space-trucker/client/c_nui_callbacks.lua (VERSÃO FINAL, LIMPA E CORRIGIDA)
local QBCore = exports['qb-core']:GetCoreObject()

-- Garante que os callbacks da NUI sejam registrados apenas uma vez
local nuiCallbacksRegistered = false
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and not nuiCallbacksRegistered then
        print('^2[space-trucker]^7 A registar Callbacks da NUI pela primeira e única vez...')
        
        -- Callback para carregar as estatísticas do jogador
        RegisterNuiCallback('loadPlayerStats', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getPlayerStats', function(stats)
                cb(stats or {}) -- Retorna um objeto vazio em caso de erro para evitar crash na UI
            end)
        end)

        -- Callback para carregar o histórico de missões
        RegisterNuiCallback('loadMissionHistory', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getMissionHistory', function(history)
                cb(history or {}) -- Retorna um objeto vazio em caso de erro
            end)
        end)

        -- Callback para atualizar o perfil do jogador
        RegisterNuiCallback('space_trucker:callback:updateProfile', function(data, cb)
            print('--- [LOG | NUI_CALLBACK] Recebido pedido "updateProfile" da UI ---')
            QBCore.Functions.TriggerCallback('space_trucker:callback:updateProfile', function(result)
                print('--- [LOG | NUI_CALLBACK] Servidor respondeu a "updateProfile". A enviar para a UI. ---')
                cb(result)
            end, data)
        end)

        -- Callback para o Painel de Cargas
        RegisterNuiCallback('getCargoAndVehicleData', function(_, cb)
            print('--- [LOG | NUI_CALLBACK] Recebido pedido "getCargoAndVehicleData" da UI ---')
            QBCore.Functions.TriggerCallback('space_trucker:callback:getCargoAndVehicleData', function(data)
                print('--- [LOG | NUI_CALLBACK] Servidor respondeu a "getCargoAndVehicleData". A enviar para a UI. ---')
                cb(data or {})
            end)
        end)

        nuiCallbacksRegistered = true
    end
end)