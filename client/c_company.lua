-- space_trucker/client/c_company.lua

-- Comando principal para abrir o painel
RegisterCommand('company', function()
    print('[space_trucker] [CLIENTE] Comando /company executado. A pedir dados ao servidor...')
    
    local companyData = TriggerCallbackAwait('space_trucker:callback:getCompanyData')

    if companyData then
        -- O servidor sempre retorna uma tabela, seja com dados completos ou com { has_profile = false }
        print('[space_trucker] [CLIENTE] Dados recebidos do servidor. A abrir o painel.')
        SendNuiMessage(json.encode({ action = 'showCompanyPanel', data = companyData }))
        SetNuiFocus(true, true)
    else
        -- Este caso só deve acontecer se houver um erro grave no servidor
        print('[space_trucker] [CLIENTE] ERRO: O servidor não respondeu.')
        exports['qb-core']:GetCoreObject().Functions.Notify("Ocorreu um erro ao carregar os dados. Tente novamente.", "error")
    end
end, false)

-- =============================================================================
-- CALLBACKS DO NUI (Ponte entre UI e Servidor)
-- =============================================================================

-- Callback para fechar o painel a partir do React
RegisterNUICallback('closePanel', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Callback para forçar a atualização dos dados (usado após criar perfil)
RegisterNUICallback('forceRefreshData', function(data, cb)
    -- Fecha o foco atual para evitar bugs
    SetNuiFocus(false, false)
    -- Simula a reabertura do painel para obter os dados mais recentes
    ExecuteCommand('company')
    cb('ok')
end)
-- Adicione este pequeno bloco em qualquer lugar do seu arquivo c_company.lua

RegisterNetEvent('space_trucker:client:forceRefresh', function()
    print('[space_trucker] [CLIENTE] Recebido pedido do servidor para forçar atualização. Reabrindo painel...')
    -- Fecha o foco atual para evitar bugs
    SetNuiFocus(false, false)
    -- Simula a reabertura do painel para obter os dados mais recentes
    ExecuteCommand('company')
end)

-- Callback para criar o perfil
RegisterNUICallback('createProfile', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:createProfile', data)
    cb(result)
end)

RegisterNUICallback('space_trucker:createCompany', function(data, cb)
    -- Adicione este print para ter certeza que esta parte está funcionando
    print('[space_trucker DEBUG] Callback da NUI recebido! Enviando para o servidor... Dados: ' .. json.encode(data))
    
    TriggerServerEvent('space_trucker:server:createCompany', data)
    cb({ success = true })
end)

-- Callback para contratar um jogador
RegisterNUICallback('hirePlayer', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:hirePlayer', data)
    cb(result)
end)

-- Callback para contratar um NPC
RegisterNUICallback('hireNpc', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:hireNpc', data)
    cb(result)
end)

-- Callback para demitir um funcionário
RegisterNUICallback('fireEmployee', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:fireEmployee', data)
    cb(result)
end)

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
-- Callback para a Agência de Recrutamento
RegisterNUICallback('getRecruitmentPosts', function(data, cb)
    local posts = TriggerCallbackAwait('space_trucker:callback:getRecruitmentPosts')
    cb(posts)
end)
-- Adicionar no final de c_company.lua

RegisterNUICallback('createRecruitmentPost', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:createRecruitmentPost', data)
    cb(result)
end)
-- -- Callback para depositar dinheiro
-- RegisterNUICallback('depositMoney', function(data, cb)
--     local result = TriggerCallbackAwait('space_trucker:callback:depositMoney', data)
--     cb(result)
-- end)

-- -- Callback para levantar dinheiro
-- RegisterNUICallback('withdrawMoney', function(data, cb)
--     local result = TriggerCallbackAwait('space_trucker:callback:withdrawMoney', data)
--     cb(result)
-- end)
-- Adicionar no final de c_company.lua

RegisterNUICallback('hireFromPost', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:hireFromPost', data)
    cb(result)
end)

-- Adicionar no final de c_company.lua

RegisterNUICallback('acceptGig', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:acceptGig', data)
    cb(result)
end)

-- Adicionar no final de c_company.lua

RegisterNUICallback('applyForJob', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:applyForJob', data)
    cb(result)
end)

RegisterNUICallback('getCompanyApplications', function(data, cb)
    local applications = TriggerCallbackAwait('space_trucker:callback:getCompanyApplications')
    cb(applications)
end)

RegisterNUICallback('hireFromApplication', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:hireFromApplication', data)
    cb(result)
end)

-- Adicionar no final de c_company.lua

RegisterNUICallback('updateEmployee', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:updateEmployee', data)
    cb(result)
end)

-- Adicionar no final de c_company.lua

RegisterNUICallback('deleteRecruitmentPost', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:deleteRecruitmentPost', data)
    cb(result)
end)
-- =============================================================================
-- CALLBACKS DO CHAT INTEGRADO
-- =============================================================================

-- Ponte para buscar a lista de chats do jogador
RegisterNUICallback('getChatList', function(data, cb)
    local chats = TriggerCallbackAwait('space_trucker:callback:getChatList')
    cb(chats)
end)

-- Ponte para buscar as mensagens de um chat específico
RegisterNUICallback('getChatMessages', function(data, cb)
    local messages = TriggerCallbackAwait('space_trucker:callback:getChatMessages', data)
    cb(messages)
end)

-- Ponte para enviar uma nova mensagem
RegisterNUICallback('sendChatMessage', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:sendChatMessage', data)
    cb(result)
end)
-- Adicionar no final de c_company.lua

RegisterNUICallback('deleteChat', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:deleteChat', data)
    cb(result)
end)

-- Adicione este bloco no final do seu arquivo c_company.lua

RegisterNUICallback('transferOwnership', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:transferOwnership', data)
    cb(result)
end)

-- Adicione este callback em c_company.lua

RegisterNUICallback('updateManagerPermissions', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:updateManagerPermissions', data)
    cb(result)
end)

-- Adicione este callback em c_company.lua

RegisterNUICallback('toggleAutoSalary', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:toggleAutoSalary', data)
    cb(result)
end)

-- Adicione este bloco no final de c_company.lua

-- Callback para definir a localização da garagem
RegisterNUICallback('setGarageLocation', function(data, cb)
    -- Obtém as coordenadas atuais do jogador e envia para o servidor
    local coords = GetEntityCoords(PlayerPedId())
    local result = TriggerCallbackAwait('space_trucker:callback:setGarageLocation', { location = { x = coords.x, y = coords.y, z = coords.z } })
    cb(result)
end)

-- Callback para adicionar um veículo
RegisterNUICallback('addVehicleToFleet', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:addVehicleToFleet', data)
    cb(result)
end)

-- Callback para buscar os logs (será usado no futuro)
RegisterNUICallback('getFleetLogs', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:getFleetLogs', data)
    cb(result)
end)
-- Adicione este callback no final de c_company.lua

RegisterNUICallback('getPlayerVehicles', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:getPlayerVehicles')
    cb(result)
end)
-- Adicionar no final de c_company.lua
RegisterNUICallback('returnVehicleToOwner', function(data, cb)
    local result = TriggerCallbackAwait('space_trucker:callback:returnVehicleToOwner', data)
    cb(result)
end)

-- =============================================================================
-- * NOVA ALTERAÇÃO ADICIONADA AQUI
-- =============================================================================
RegisterNUICallback('requestCompanyIndustries', function(data, cb)
    print('[space_trucker] NUI: A interface pediu a lista de indústrias.')
    local allIndustries = Industries:GetIndustries()
    local purchasableIndustries = {} -- Tabela para guardar apenas as indústrias compráveis

    if allIndustries and next(allIndustries) ~= nil then
        for name, industry in pairs(allIndustries) do
            -- Apenas adiciona indústrias que têm um preço de compra definido
            if type(industry) == 'table' and industry.name and industry.label and industry:GetPurchasePrice() then
                
                -- CORREÇÃO: Removemos a lógica if/elseif desnecessária.
                -- Agora usamos o 'tier' que foi definido diretamente no ficheiro de registo da indústria.
                table.insert(purchasableIndustries, {
                    name = industry.name,
                    label = industry.label,
                    tier = industry.tier, -- Usamos o valor original e correto
                    type = industry.type,
                    status = industry.status
                })
            end
        end
        
        local jsonData = json.encode(purchasableIndustries)
        SendNUIMessage({
            action = 'setCompanyIndustries',
            data = jsonData
        })
        print('[space_trucker] NUI: Foram enviadas ' .. #purchasableIndustries .. ' indústrias compráveis para a UI.')
    else
        print('[space_trucker] NUI ERRO: A função Industries:GetIndustries() retornou vazia.')
        SendNUIMessage({
            action = 'setCompanyIndustries',
            data = '[]'
        })
    end
    
    cb('ok')
end)
-- =============================================================================
-- * FIM DA NOVA ALTERAÇÃO
-- =============================================================================

-- =============================================================================
-- * NOVAS ALTERAÇÕES PARA COMPRA/VENDA DE INDÚSTRIAS
-- =============================================================================
RegisterNUICallback('buyIndustry', function(data, cb)
    if not data or not data.industryName then
        return cb({ success = false, message = "Nome da indústria inválido." })
    end
    
    -- Chama o callback do servidor para tentar comprar a indústria
    local result = TriggerCallbackAwait('space_trucker:callback:buyIndustry', { industryName = data.industryName })
    cb(result)
end)

RegisterNUICallback('sellIndustry', function(data, cb)
    if not data or not data.industryName then
        return cb({ success = false, message = "Nome da indústria inválido." })
    end
    
    -- Chama o callback do servidor para tentar vender a indústria
    local result = TriggerCallbackAwait('space_trucker:callback:sellIndustry', { industryName = data.industryName })
    cb(result)
end)

RegisterNetEvent('space_trucker:client:receiveOwnershipData', function(ownershipData)
    SendNUIMessage({
        action = 'setIndustryOwnership',
        data = ownershipData
    })
end)

-- 2. Ouve o pedido da interface (UI) e reencaminha para o servidor
RegisterNUICallback('requestIndustryOwnership', function(data, cb)
    TriggerServerEvent('space_trucker:server:requestOwnershipData')
    cb('ok') -- Apenas confirma que o pedido foi recebido
end)