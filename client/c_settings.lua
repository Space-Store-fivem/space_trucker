-- space_trucker/client/c_settings.lua

-- Callback para atualizar as configurações
RegisterNUICallback('updateCompanySettings', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:updateCompanySettings', data)
    cb(result)
end)

-- Callback para vender a empresa
RegisterNUICallback('sellCompany', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:sellCompany', data)
    cb(result)
end)

-- GARANTA QUE NÃO HÁ MAIS NENHUM RegisterNUICallback NESTE FICHEIRO