-- =================================================================
-- ARQUIVO bridge/client/c_framework_qbcore.lua (VERSÃO FINAL E LIMPA)
-- =================================================================

local QBCore = exports['qb-core']:GetCoreObject()

--[[
    NOTA: Os eventos 'OnPlayerLoaded', 'OnJobUpdate' e a função 'GetPlayerJobName'
    foram removidos pois pertenciam ao sistema antigo (PDA, aluguer, empregos)
    e não são mais utilizados. Apenas as funções essenciais de callback foram mantidas.
]]

function TriggerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

function TriggerCallbackAwait(name, ...)
    local promise = promise.new()
    TriggerCallback(name, function(response, ...)
        response = { response, ... }
        promise:resolve(response)
    end, ...)

    return table.unpack(Citizen.Await(promise))
end