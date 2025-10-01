-- gs_trucker/server/s_logistics_hub.lua (VERSÃO COMPLETA E ATUALIZADA)

local QBCore = exports['qb-core']:GetCoreObject()

local SystemCompanyId = nil -- Variável para guardar o ID da empresa "Sistema"

-- No início do script, encontra e guarda o ID da empresa do sistema para uso posterior
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Espera o MySQL estar pronto
    local result = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE name = ?', { 'Sistema' })
    if result and result[1] then
        SystemCompanyId = result[1].id
        print(('[gs-trucker] ID da empresa do Sistema carregado: %d'):format(SystemCompanyId))
    else
        print('[gs-trucker] ERRO CRÍTICO: Não foi possível encontrar a empresa "Sistema" na base de dados.')
    end
end)


CreateCallback('gs_trucker:callback:getOrderItemPrice', function(source, cb, data)
    if not data or not data.itemName then return cb(0) end
    local producingIndustry = Industries:GetIndustryThatProduces(data.itemName)
    if not producingIndustry or not producingIndustry.tradeData or not producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE] then return cb(0) end
    local itemData = producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][data.itemName]
    if not itemData or not itemData.price then return cb(0) end
    cb(itemData.price)
end)

-- Função corrigida para buscar e preparar os nomes das indústrias para a UI
CreateCallback('gs_trucker:callback:getLogisticsOrders', function(source, cb)
    -- 1. Busca as encomendas como de costume
    local orders = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE status = ? ORDER BY created_at DESC', { 'OPEN' })
    
    if orders then
        for i = 1, #orders do
            -- 2. Processa a INDÚSTRIA DE PARTIDA (DE:)
            local pickupIndustry = Industries:GetIndustry(orders[i].pickup_industry_name)
            if pickupIndustry and pickupIndustry.label then
                -- O painel TSX espera 'sourceLabel'
                orders[i].sourceLabel = Lang:t(pickupIndustry.label)
            else
                orders[i].sourceLabel = orders[i].pickup_industry_name -- Fallback
            end

            -- 3. Processa a INDÚSTRIA DE CHEGADA (PARA:)
            local destinationLabel = "Destino Desconhecido"
            if orders[i].creator_identifier == 'system' then
                destinationLabel = Lang:t(orders[i].creator_name)
            else
                local industryNameInDetails = orders[i].dropoff_details:match("%((.-)%)")
                if industryNameInDetails then
                    local dropoffIndustry = Industries:GetIndustry(industryNameInDetails)
                    if dropoffIndustry and dropoffIndustry.label then
                        destinationLabel = Lang:t(dropoffIndustry.label)
                    else
                        destinationLabel = industryNameInDetails -- Fallback
                    end
                end
            end
            -- O painel TSX espera 'destinationLabel'
            orders[i].destinationLabel = destinationLabel
        end
    end
    
    -- 4. Envia a lista de encomendas já com os nomes corretos para a interface
    cb(orders or {})
end)

CreateCallback('gs_trucker:callback:createLogisticsOrder', function(source, cb, data)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    local identifier = player.PlayerData.citizenid
    
    local company = MySQL.query.await('SELECT * FROM gs_trucker_companies WHERE owner_identifier = ?', { identifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é dono de uma empresa." }) end
    
    if not data.itemName or not data.quantity or not data.requestingIndustry then return cb({ success = false, message = "Dados da encomenda inválidos." }) end
    local quantity = tonumber(data.quantity)
    if not quantity or quantity <= 0 then return cb({ success = false, message = "Quantidade inválida." }) end

    local producingIndustry = Industries:GetIndustryThatProduces(data.itemName)
    if not producingIndustry then return cb({ success = false, message = "Nenhuma indústria produz este item." }) end
    
    local itemPrice = producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][data.itemName].price
    if not itemPrice or itemPrice <= 0 then return cb({ success = false, message = "Não foi possível calcular o custo. O preço do item é zero." }) end
    
    local totalCargoValue = itemPrice * quantity
    local truckerReward = math.floor(totalCargoValue * 0.30)
    local totalOrderCost = totalCargoValue + truckerReward
    
    if company[1].balance < totalOrderCost then
        return cb({ success = false, message = ("Saldo insuficiente. Custo total: $%s"):format(totalOrderCost) })
    end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { totalOrderCost, company[1].id })
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'order_cost', -totalOrderCost, ('Encomenda de %d %s'):format(quantity, Lang:t('item_name_' .. data.itemName))})

    local requestingIndustry = Industries:GetIndustry(data.requestingIndustry)
    local result = MySQL.insert.await(
        'INSERT INTO gs_trucker_logistics_orders (creator_identifier, creator_name, company_id, item_name, item_label, quantity, reward, cargo_value, pickup_industry_name, pickup_location, dropoff_location, dropoff_details) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        {
            identifier, company[1].name, company[1].id, data.itemName, 'item_name_' .. data.itemName, quantity, truckerReward, totalCargoValue,
            producingIndustry.name,
            json.encode(producingIndustry.location),
            json.encode(requestingIndustry.location),
            company[1].name .. ' (' .. requestingIndustry.name .. ')'
        }
    )

    if result then
        cb({ success = true, message = "Encomenda publicada com sucesso!" })
    else
        MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance + ? WHERE id = ?', { totalOrderCost, company[1].id })
        cb({ success = false, message = "Erro ao publicar a encomenda." })
    end
end)

-- Ficheiro: s_logistics_hub.lua

CreateCallback('gs_trucker:callback:acceptLogisticsOrder', function(source, cb, data)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    
    local orderId = tonumber(data.orderId)
    if not orderId then return cb({ success = false, message = "ID da encomenda inválido." }) end
    
    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ?', { orderId })
    if not order or not order[1] then return cb({ success = false, message = "Esta encomenda já não existe." }) end
    local ord = order[1]

    if ord.status ~= 'OPEN' then return cb({ success = false, message = "Esta encomenda já foi aceite." }) end
    
    -- [[ CORREÇÃO ESTRUTURAL APLICADA AQUI ]] --
    
    -- 1. Determina qual empresa é a dona da indústria de origem
    local sourceIndustryName = ord.pickup_industry_name
    local sourceOwnerResult = MySQL.query.await('SELECT company_id FROM gs_trucker_company_industries WHERE industry_name = ?', { sourceIndustryName })
    local sourceCompanyId
    
    if sourceOwnerResult and sourceOwnerResult[1] then
        sourceCompanyId = sourceOwnerResult[1].company_id -- É de um jogador
    else
        local systemCompany = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE name = ?', { 'Sistema' })
        if systemCompany and systemCompany[1] then
            sourceCompanyId = systemCompany[1].id -- É do sistema
        end
    end

    if not sourceCompanyId then
        return cb({ success = false, message = "Erro: Não foi possível identificar o dono da indústria de origem." })
    end

    -- 2. VERIFICA O ESTOQUE ANTES de aceitar a missão
    local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { sourceCompanyId, sourceIndustryName, ord.item_name })

    if not stockResult or not stockResult[1] or stockResult[1].stock < ord.quantity then
        return cb({ success = false, message = "A indústria de origem não tem estoque suficiente para esta encomenda." })
    end

    -- 3. Se houver estoque, deduz IMEDIATAMENTE para "reservar" a carga
    MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = stock - ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { ord.quantity, sourceCompanyId, sourceIndustryName, ord.item_name })

    -- 4. Agora sim, atribui a missão ao jogador
    local identifier = player.PlayerData.citizenid
    local result = MySQL.update.await('UPDATE gs_trucker_logistics_orders SET status = ?, taker_identifier = ? WHERE id = ? AND status = ?', { 'IN_PROGRESS', identifier, orderId, 'OPEN' })
    
    if result and result > 0 then
        -- Lógica de pagamento para a empresa vendedora (se não for do sistema)
        if ord.creator_identifier ~= 'system' then
            local producerCompanyQuery = MySQL.query.await('SELECT ind.company_id FROM gs_trucker_company_industries ind WHERE ind.industry_name = ?', { ord.pickup_industry_name })
            if producerCompanyQuery and producerCompanyQuery[1] then
                local producerCompanyId = producerCompanyQuery[1].company_id
                MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance + ? WHERE id = ?', { ord.cargo_value, producerCompanyId })
                MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { producerCompanyId, 'sale_of_goods', ord.cargo_value, ('Venda de %d %s'):format(ord.quantity, Lang:t(ord.item_label)) })
            end
        end

        local industry = Industries:GetIndustry(ord.pickup_industry_name)
        if industry then ord.pickup_industry_name = Lang:t(industry.label) end
        cb({ success = true, orderData = ord })
    else
        -- Se algo der errado ao atribuir a missão, devolve o estoque
        MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = stock + ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { ord.quantity, sourceCompanyId, sourceIndustryName, ord.item_name })
        cb({ success = false, message = "Esta encomenda acabou de ser aceite por outro jogador." })
    end
end)

RegisterNetEvent('gs_trucker:server:completeLogisticsOrder', function(missionData)
    local src = source
    local player = exports['gs_trucker']:GetPlayer(src)
    if not player or not missionData or not missionData.orderId then return end
    
    local identifier = player.PlayerData.citizenid
    local orderId = missionData.orderId

    -- Busca a encomenda para garantir que ela ainda pertence ao jogador
    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ? AND taker_identifier = ?', { orderId, identifier })
    if not order or not order[1] then return end
    local ord = order[1]

    -- Paga a recompensa ao jogador
    player.Functions.AddMoney('bank', ord.reward, "Pagamento de encomenda de logística")

    -- Lógica para adicionar o estoque na indústria de destino
    if ord.creator_identifier == 'system' then
        if SystemCompanyId then
            local destinationIndustryLabel = ord.creator_name
            local destinationIndustryName = nil
            for name, industry in pairs(Industries:GetIndustries()) do
                if Lang:t(industry.label) == destinationIndustryLabel then
                    destinationIndustryName = name
                    break
                end
            end
            if destinationIndustryName then
                MySQL.execute('INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)', { SystemCompanyId, destinationIndustryName, ord.item_name, ord.quantity })
            end
        end
    else
        local requestingIndustryName = ord.dropoff_details:match("%((.-)%)")
        if requestingIndustryName and ord.company_id then
            MySQL.execute('INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)', { ord.company_id, requestingIndustryName, ord.item_name, ord.quantity })
        end
    end

    -- [[ CORREÇÃO APLICADA AQUI ]] --
    -- Em vez de atualizar o status, agora a encomenda é excluída do banco de dados.
    MySQL.execute('DELETE FROM gs_trucker_logistics_orders WHERE id = ?', { orderId })

    TriggerClientEvent('QBCore:Notify', src, ('Encomenda concluída! Você recebeu $%s.'):format(ord.reward), 'success')
end)