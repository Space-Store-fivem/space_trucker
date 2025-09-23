-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_industry_management.lua
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNUICallback('getIndustryDetails', function(data, cb)
    print("[c_industry_management] Pedindo detalhes da indústria para o servidor: " .. data.industryName)
    -- CORREÇÃO: Usando a função correta do QBCore para o lado do cliente
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getIndustryDetails', function(industryDetails)
        print("[c_industry_management] Detalhes recebidos do servidor: ", json.encode(industryDetails))
        cb(industryDetails)
    end, data)
end)

RegisterNUICallback('investInIndustry', function(data, cb)
    print("[c_industry_management] Enviando pedido de investimento para o servidor: " .. data.industryName)
    -- CORREÇÃO: Usando a função correta do QBCore para o lado do cliente
    QBCore.Functions.TriggerCallback('gs_trucker:callback:investInIndustry', function(result)
        print("[c_industry_management] Resultado do investimento: ", json.encode(result))
        cb(result)
    end, data)
end)

RegisterNUICallback('hireNpcForIndustry', function(data, cb)
    print("[c_industry_management] Enviando pedido de contratação de NPC para o servidor: " .. data.industryName)
    -- CORREÇÃO: Usando a função correta do QBCore para o lado do cliente
    QBCore.Functions.TriggerCallback('gs_trucker:callback:hireNpcForIndustry', function(result)
        print("[c_industry_management] Resultado da contratação de NPC: ", json.encode(result))
        cb(result)
    end, data)
end)