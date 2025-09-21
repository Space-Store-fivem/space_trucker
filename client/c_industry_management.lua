-- NO FICHEIRO: client/c_industry_management.lua
-- SUBSTITUA O CONTEÚDO COMPLETO PELA VERSÃO ABAIXO:

-- Ouve o pedido da interface para os DADOS e responde diretamente (este método é seguro)
RegisterNUICallback('getIndustryManagementData', function(data, cb)
    local result = TriggerCallbackAwait('Space_trucker:callback:getIndustryManagementData', { industryName = data.industryName })
    cb(result)
end)

-- Ouve o pedido da interface para a AÇÃO de investir e reencaminha para o servidor
RegisterNUICallback('investInIndustry', function(data, cb)
    TriggerServerEvent('Space_trucker:server:investInIndustry', data)
    cb('ok')
end)

-- Ouve o pedido da interface para a AÇÃO de contratar e reencaminha para o servidor
RegisterNUICallback('hireNpcForIndustry', function(data, cb)
    TriggerServerEvent('Space_trucker:server:hireNpcForIndustry', data)
    cb('ok')
end)

-- Ouve o "aviso" do servidor de que uma atualização foi feita e reencaminha para a UI
RegisterNetEvent('Space_trucker:client:managementUpdate', function()
    SendNUIMessage({ action = 'managementUpdate' })
end)

-- Ouve as notificações do servidor e mostra-as ao jogador
RegisterNetEvent('Space_trucker:client:notify', function(message, type)
    -- ADAPTE ESTA LINHA AO SEU SISTEMA DE NOTIFICAÇÕES (EX: QBCore, ESX, etc.)
    -- Exemplo para QBCore: exports['qb-core']:GetCoreObject().Functions.Notify(message, type, 5000)
    print(('[%s]: %s'):format(type, message))
end)