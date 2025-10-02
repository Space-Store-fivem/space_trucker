-- space_trucker/client/c_industry_management.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- NUI Callback para a interface pedir os detalhes de uma indústria específica.
RegisterNUICallback('getIndustryDetails', function(data, cb)
    if not data or not data.industryName then
        -- Se não recebermos um nome de indústria, devolvemos uma tabela vazia.
        return cb({})
    end
    
    -- Usamos o TriggerCallback para pedir os dados ao servidor de forma segura.
    QBCore.Functions.TriggerCallback('space_trucker:callback:getIndustryDetails', function(details)
        -- Quando o servidor responder, esta função é executada, e nós enviamos
        -- os detalhes de volta para a interface através do 'cb'.
        cb(details or {})
    end, data) -- Enviamos 'data' (que contém industryName) para o servidor.
end)

-- NUI Callback para investir numa indústria.
RegisterNUICallback('investInIndustry', function(data, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:investInIndustry', function(result)
        cb(result or { success = false, message = "Erro de comunicação." })
    end, data)
end)

-- NUI Callback para contratar um NPC para uma indústria.
RegisterNUICallback('hireNpcForIndustry', function(data, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:hireNpcForIndustry', function(result)
        cb(result or { success = false, message = "Erro de comunicação." })
    end, data)
end)

-- Adicione este código no final do ficheiro c_industry_management.lua

-- [[ CORREÇÃO APLICADA AQUI ]] --
-- Callback para o Painel de Monitoramento da Economia
-- Ouve o pedido 'getIndustryStatus' vindo da interface (IndustryMonitor.tsx)
RegisterNUICallback('getIndustryStatus', function(_, cb)
    -- Pede os dados ao servidor usando o callback que já criámos no lado do servidor
    QBCore.Functions.TriggerCallback('space_trucker:callback:getIndustryStatus', function(statusData)
        -- Envia os dados recebidos do servidor de volta para a interface
        cb(statusData or {})
    end)
end)