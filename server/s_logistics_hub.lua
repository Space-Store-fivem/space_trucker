local QBCore = exports['qb-core']:GetCoreObject()

CreateCallback('gs_trucker:callback:getOrderItemPrice', function(source, cb, data)
    print('--- INÍCIO DO DIAGNÓSTICO DE PREÇO ---')
    if not data or not data.itemName then 
        print('[LOGS-PREÇO] [FALHA 1] Pedido da UI não continha o nome do item. A devolver 0.')
        return cb(0) 
    end
    print(('[LOGS-PREÇO] [PASSO 1] A UI pediu o preço para o item: "%s"'):format(data.itemName))
    
    local producingIndustry = Industries:GetIndustryThatProduces(data.itemName)
    if not producingIndustry then
        print(('[LOGS-PREÇO] [FALHA 2] Nenhuma indústria encontrada na configuração que produza "%s".'):format(data.itemName))
        return cb(0)
    end
    print(('[LOGS-PREÇO] [PASSO 2] Indústria produtora encontrada: "%s"'):format(producingIndustry.name))
    
    if not producingIndustry.tradeData or not producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
        print(('[LOGS-PREÇO] [FALHA 3] A indústria "%s" não tem uma tabela "FORSALE".'):format(producingIndustry.name))
        return cb(0)
    end

    local itemData = producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][data.itemName]
    if not itemData or not itemData.price then
        print(('[LOGS-PREÇO] [FALHA 4] O item "%s" existe na indústria "%s", mas não tem "price" definido.'):format(data.itemName, producingIndustry.name))
        return cb(0)
    end
    
    print(('[LOGS-PREÇO] [SUCESSO] Preço encontrado: $%d. A enviar para a UI.'):format(itemData.price))
    print('--- FIM DO DIAGNÓSTICO DE PREÇO ---')
    cb(itemData.price)
end)

CreateCallback('gs_trucker:callback:getLogisticsOrders', function(source, cb)
    local orders = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE status = ? ORDER BY timestamp DESC', { 'OPEN' })
    if orders then
        for i = 1, #orders do
            local industry = Industries:GetIndustry(orders[i].pickup_industry_name)
            if industry then
                orders[i].pickup_industry_name = Lang:t(industry.label)
            end
        end
    end
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
            company[1].name .. ' (' .. requestingIndustry.label .. ')'
        }
    )

    if result then
        cb({ success = true, message = "Encomenda publicada com sucesso!" })
    else
        MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance + ? WHERE id = ?', { totalOrderCost, company[1].id })
        cb({ success = false, message = "Erro ao publicar a encomenda." })
    end
end)

-- Aceitar ordem logística
CreateCallback('gs_trucker:callback:acceptLogisticsOrder', function(source, cb, data)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    local identifier = player.PlayerData.citizenid
    
    local orderId = tonumber(data.orderId)
    if not orderId then return cb({ success = false, message = "ID da encomenda inválido." }) end
    
    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ?', { orderId })
    if not order or not order[1] then return cb({ success = false, message = "Esta encomenda já não existe." }) end
    local ord = order[1]

    if ord.status ~= 'OPEN' then return cb({ success = false, message = "Esta encomenda já foi aceite." }) end
    
    local producerCompanyQuery = MySQL.query.await('SELECT ind.company_id FROM gs_trucker_company_industries ind WHERE ind.industry_name = ?', { ord.pickup_industry_name })
    if not producerCompanyQuery or not producerCompanyQuery[1] then return cb({success = false, message = "A indústria produtora não tem dono."}) end
    local producerCompanyId = producerCompanyQuery[1].company_id

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance + ? WHERE id = ?', { ord.cargo_value, producerCompanyId })
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { producerCompanyId, 'sale_of_goods', ord.cargo_value, ('Venda de %d %s'):format(ord.quantity, Lang:t(ord.item_label)) })
    MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = stock - ? WHERE industry_name = ? AND item_name = ? AND company_id = ?', { ord.quantity, ord.pickup_industry_name, ord.item_name, producerCompanyId })

    local result = MySQL.update.await('UPDATE gs_trucker_logistics_orders SET status = ?, taker_identifier = ? WHERE id = ? AND status = ?', { 'IN_PROGRESS', identifier, orderId, 'OPEN' })
    if result and result > 0 then
        local industry = Industries:GetIndustry(ord.pickup_industry_name)
        if industry then ord.pickup_industry_name = Lang:t(industry.label) end
        cb({ success = true, orderData = ord })
    else
        MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { ord.cargo_value, producerCompanyId })
        cb({ success = false, message = "Esta encomenda já foi aceite." })
    end
end)

-- Evento para completar ordem
RegisterNetEvent('gs_trucker:server:completeLogisticsOrder', function(missionData)
    local src = source
    local player = exports['gs_trucker']:GetPlayer(src)
    if not player then return end
    local identifier = player.PlayerData.citizenid
    local orderId = missionData.orderId

    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ? AND taker_identifier = ?', { orderId, identifier })
    if not order or not order[1] then return end
    local ord = order[1]

    player.Functions.AddMoney('bank', ord.reward, "Pagamento de encomenda de logística")

    local requestingIndustryLabel = ord.dropoff_details:match("%((.-)%)")
    local requestingIndustryName = nil
    for name, industry in pairs(Industries:GetIndustries()) do
        if industry.label == requestingIndustryLabel then
            requestingIndustryName = name
            break
        end
    end

    if requestingIndustryName then
        MySQL.execute(
            'INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)',
            { ord.company_id, requestingIndustryName, ord.item_name, ord.quantity }
        )
    end

    MySQL.update.await('UPDATE gs_trucker_logistics_orders SET status = ? WHERE id = ?', { 'COMPLETED', orderId })
    TriggerClientEvent('QBCore:Notify', src, ('Encomenda concluída! Você recebeu $%s.'):format(ord.reward), 'success')
end)