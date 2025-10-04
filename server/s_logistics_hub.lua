-- space_trucker/server/s_logistics_hub.lua (VERSÃO FINAL E CORRIGIDA)

local QBCore = exports['qb-core']:GetCoreObject()

local SystemCompanyId = nil

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local result = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE name = ?', { 'Sistema' })
    if result and result[1] then
        SystemCompanyId = result[1].id
        print(('[space-trucker] ID da empresa do Sistema carregado: %d'):format(SystemCompanyId))
    else
        print('[space-trucker] ERRO CRÍTICO: Não foi possível encontrar a empresa "Sistema" na base de dados.')
    end
end)

QBCore.Functions.CreateCallback('space_trucker:callback:getOrderItemPrice', function(source, cb, data)
    if not data or not data.itemName then return cb(0) end
    local producingIndustry = Industries:GetIndustryThatProduces(data.itemName)
    if not producingIndustry or not producingIndustry.tradeData or not producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE] then return cb(0) end
    local itemData = producingIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][data.itemName]
    if not itemData or not itemData.price then return cb(0) end
    cb(itemData.price)
end)

local function getSuggestedVehicle(itemName, quantity)
    local item = spaceconfig.IndustryItems[itemName]
    if not item then return "Camião de Carga" end
    local requiredCapacity = (item.capacity or 1) * quantity
    local itemTransType = item.transType
    local bestVehicle = nil
    local smallestCapacity = math.huge
    for model, vehicleData in pairs(spaceconfig.VehicleTransport) do
        if not vehicleData.isTrailer then
            local canTransport = false
            if vehicleData.transType and vehicleData.transType[itemTransType] then
                canTransport = true
            end
            if canTransport then
                if vehicleData.capacity >= requiredCapacity and vehicleData.capacity < smallestCapacity then
                    bestVehicle = vehicleData
                    smallestCapacity = vehicleData.capacity
                end
            end
        end
    end
    if bestVehicle then return bestVehicle.label else return "Camião Pesado" end
end

QBCore.Functions.CreateCallback('space_trucker:callback:getLogisticsOrders', function(source, cb)
    local orders = MySQL.query.await('SELECT * FROM space_trucker_logistics_orders WHERE status = ? ORDER BY created_at DESC', { 'OPEN' })
    if orders then
        for i = 1, #orders do
            local pickupIndustry = Industries:GetIndustry(orders[i].pickup_industry_name)
            if pickupIndustry and pickupIndustry.name then
                -- CORREÇÃO: Usa o nome interno da indústria para criar a chave de tradução correta.
                orders[i].sourceLabel = Lang:t('industry_name_' .. pickupIndustry.name)
            else
                orders[i].sourceLabel = orders[i].pickup_industry_name -- Fallback
            end

            local destinationIndustry = Industries:GetIndustry(orders[i].destination_industry_name)
            if destinationIndustry and destinationIndustry.name then
                -- CORREÇÃO: Usa o nome interno da indústria para criar a chave de tradução correta.
                 orders[i].destinationLabel = Lang:t('industry_name_' .. destinationIndustry.name)
            else
                 orders[i].destinationLabel = orders[i].destination_industry_name or "Destino Desconhecido"
            end

            if orders[i].creator_identifier == 'system' then
                orders[i].type = 'system'
            else
                orders[i].type = 'player'
            end
            orders[i].suggested_vehicle = getSuggestedVehicle(orders[i].item_name, orders[i].quantity)
        end
    end
    cb(orders or {})
end)

QBCore.Functions.CreateCallback('space_trucker:callback:createLogisticsOrder', function(source, cb, data)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    local identifier = player.PlayerData.citizenid
    
    local company = MySQL.query.await('SELECT * FROM space_trucker_companies WHERE owner_identifier = ?', { identifier })
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

    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { totalOrderCost, company[1].id })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'order_cost', -totalOrderCost, ('Encomenda de %d %s'):format(quantity, Lang:t('item_name_' .. data.itemName))})

    local requestingIndustry = Industries:GetIndustry(data.requestingIndustry)
    
    -- [[ CORREÇÃO DEFINITIVA: USA 'pickup_industry_name' e adiciona 'destination_industry_name' ]] --
    local result = MySQL.insert.await(
        'INSERT INTO space_trucker_logistics_orders (creator_identifier, creator_name, company_id, item_name, item_label, quantity, reward, cargo_value, pickup_industry_name, destination_industry_name, pickup_location, dropoff_location, dropoff_details) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        {
            identifier, company[1].name, company[1].id, data.itemName, 'item_name_' .. data.itemName, quantity, truckerReward, totalCargoValue,
            producingIndustry.name,         -- <- Usa a sua coluna original `pickup_industry_name`
            requestingIndustry.name,        -- <- Adiciona a nova coluna `destination_industry_name`
            json.encode(producingIndustry.location),
            json.encode(requestingIndustry.location),
            company[1].name .. ' (' .. requestingIndustry.name .. ')'
        }
    )

    if result then
        cb({ success = true, message = "Encomenda publicada com sucesso!" })
    else
        MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { totalOrderCost, company[1].id })
        cb({ success = false, message = "Erro ao publicar a encomenda." })
    end
end)


QBCore.Functions.CreateCallback('space_trucker:callback:acceptLogisticsOrder', function(source, cb, data)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    
    local orderId = tonumber(data.orderId)
    if not orderId then return cb({ success = false, message = "ID da encomenda inválido." }) end
    
    local order = MySQL.query.await('SELECT * FROM space_trucker_logistics_orders WHERE id = ?', { orderId })
    if not order or not order[1] then return cb({ success = false, message = "Esta encomenda já não existe." }) end
    local ord = order[1]

    if ord.status ~= 'OPEN' then return cb({ success = false, message = "Esta encomenda já foi aceite." }) end
    
    local sourceIndustryName = ord.pickup_industry_name
    local sourceOwnerResult = MySQL.query.await('SELECT company_id FROM space_trucker_company_industries WHERE industry_name = ?', { sourceIndustryName })
    local sourceCompanyId
    
    if sourceOwnerResult and sourceOwnerResult[1] then
        sourceCompanyId = sourceOwnerResult[1].company_id
    else
        sourceCompanyId = SystemCompanyId
    end

    if not sourceCompanyId then
        return cb({ success = false, message = "Erro: Não foi possível identificar o dono da indústria de origem." })
    end

    local stockResult = MySQL.query.await('SELECT stock FROM space_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { sourceCompanyId, sourceIndustryName, ord.item_name })

    if not stockResult or not stockResult[1] or stockResult[1].stock < ord.quantity then
        return cb({ success = false, message = "A indústria de origem não tem estoque suficiente para esta encomenda." })
    end

    MySQL.update.await('UPDATE space_trucker_industry_stock SET stock = stock - ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { ord.quantity, sourceCompanyId, sourceIndustryName, ord.item_name })

    local identifier = player.PlayerData.citizenid
    local result = MySQL.update.await('UPDATE space_trucker_logistics_orders SET status = ?, taker_identifier = ? WHERE id = ? AND status = ?', { 'IN_PROGRESS', identifier, orderId, 'OPEN' })
    
    if result and result > 0 then
        if ord.creator_identifier ~= 'system' then
            local producerCompanyQuery = MySQL.query.await('SELECT ind.company_id FROM space_trucker_company_industries ind WHERE ind.industry_name = ?', { ord.pickup_industry_name })
            if producerCompanyQuery and producerCompanyQuery[1] then
                local producerCompanyId = producerCompanyQuery[1].company_id
                MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { ord.cargo_value, producerCompanyId })
                MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { producerCompanyId, 'sale_of_goods', ord.cargo_value, ('Venda de %d %s'):format(ord.quantity, Lang:t(ord.item_label)) })
            end
        end
        
        -- Renomeia 'pickup_industry_name' para 'sourceIndustry' para ser consistente com o resto do script
        ord.sourceIndustry = ord.pickup_industry_name
        ord.destinationBusiness = ord.destination_industry_name

        TriggerClientEvent('space_trucker:client:startLogisticsMission', source, ord)
        cb({ success = true })
    else
        MySQL.update.await('UPDATE space_trucker_industry_stock SET stock = stock + ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { ord.quantity, sourceCompanyId, sourceIndustryName, ord.item_name })
        cb({ success = false, message = "Esta encomenda acabou de ser aceite por outro jogador." })
    end
end)

RegisterNetEvent('space_trucker:server:completeLogisticsOrder', function(missionData)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not missionData or not missionData.orderId then return end
    
    local identifier = player.PlayerData.citizenid
    local orderId = missionData.orderId

    local order = MySQL.query.await('SELECT * FROM space_trucker_logistics_orders WHERE id = ? AND taker_identifier = ?', { orderId, identifier })
    if not order or not order[1] then return end
    local ord = order[1]

    -- SALVA O HISTÓRICO PRIMEIRO, USANDO OS NOMES CORRETOS DAS COLUNAS
    local sourceIndustryDef = Industries:GetIndustry(ord.pickup_industry_name)
    local destinationBusinessDef = Industries:GetIndustry(ord.destination_industry_name)

    if sourceIndustryDef and destinationBusinessDef then
        local distance = #(sourceIndustryDef.location - destinationBusinessDef.location) / 1000
        MySQL.update.await('INSERT INTO space_trucker_player_stats (identifier, total_profit, total_distance, total_packages) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE total_profit = total_profit + VALUES(total_profit), total_distance = total_distance + VALUES(total_distance), total_packages = total_packages + VALUES(total_packages)', { identifier, ord.reward, distance, ord.quantity })
        MySQL.insert.await('INSERT INTO space_trucker_mission_history (identifier, mission_id, source_industry, destination_business, item, amount, profit, distance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', { identifier, ord.id, ord.pickup_industry_name, ord.destination_industry_name, ord.item_name, ord.quantity, ord.reward, distance })
    end
    
    player.Functions.AddMoney('bank', ord.reward, "Pagamento de encomenda de logística")

    if ord.creator_identifier == 'system' then
        if SystemCompanyId then
            local destinationIndustryName = ord.destination_industry_name
            if destinationIndustryName then
                MySQL.execute('INSERT INTO space_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)', { SystemCompanyId, destinationIndustryName, ord.item_name, ord.quantity })
            end
        end
    else
        local requestingIndustryName = ord.destination_industry_name
        if requestingIndustryName and ord.company_id then
            MySQL.execute('INSERT INTO space_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)', { ord.company_id, requestingIndustryName, ord.item_name, ord.quantity })
        end
    end

    MySQL.execute('DELETE FROM space_trucker_logistics_orders WHERE id = ?', { orderId })
    TriggerClientEvent('QBCore:Notify', src, ('Encomenda concluída! Você recebeu $%s.'):format(ord.reward), 'success')
end)