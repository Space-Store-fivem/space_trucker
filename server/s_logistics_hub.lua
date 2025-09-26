-- gs_trucker/server/s_logistics_hub.lua

CreateCallback('gs_trucker:callback:getLogisticsOrders', function(source, cb)
    local orders = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE status = ? ORDER BY timestamp DESC', { 'OPEN' })
    cb(orders or {})
end)

CreateCallback('gs_trucker:callback:createLogisticsOrder', function(source, cb, data)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local identifier = player.PlayerData.citizenid
    local profile = MySQL.query.await('SELECT profile_name FROM gs_trucker_profiles WHERE identifier = ?', { identifier })
    if not profile or not profile[1] then
        return cb({ success = false, message = "Você precisa de um perfil de trabalhador para criar encomendas." })
    end
    
    local company = MySQL.query.await('SELECT id, name FROM gs_trucker_companies WHERE owner_identifier = ?', { identifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não é dono de uma empresa." })
    end
    
    if not data.itemName or not data.quantity or not data.reward or not data.requestingIndustry then
        return cb({ success = false, message = "Dados da encomenda inválidos." })
    end

    local quantity = tonumber(data.quantity)
    local reward = tonumber(data.reward)
    if not quantity or quantity <= 0 or not reward or reward < 0 then
        return cb({ success = false, message = "Valores de quantidade ou recompensa inválidos." })
    end

    local producingIndustry = Industries:GetIndustryThatProduces(data.itemName)
    if not producingIndustry then
        return cb({ success = false, message = "Nenhuma indústria produtora para este item foi encontrada." })
    end
    
    local requestingIndustry = Industries:GetIndustry(data.requestingIndustry)
    if not requestingIndustry then
        return cb({ success = false, message = "A sua indústria não foi encontrada." })
    end
    
    local producingIndustryLabel = Industries:GetIndustryLabel(producingIndustry.name)
    local requestingIndustryLabel = Industries:GetIndustryLabel(requestingIndustry.name)

    local result = MySQL.insert.await(
        'INSERT INTO gs_trucker_logistics_orders (creator_identifier, creator_name, item_name, item_label, quantity, reward, pickup_industry_name, pickup_location, dropoff_location, dropoff_details) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        {
            identifier,
            profile[1].profile_name,
            data.itemName,
            Lang:t('item_name_' .. data.itemName),
            quantity,
            reward,
            Lang:t(producingIndustryLabel),
            json.encode(producingIndustry.location),
            json.encode(requestingIndustry.location),
            company[1].name .. ' (' .. Lang:t(requestingIndustryLabel) .. ')'
        }
    )

    if result then
        cb({ success = true, message = "Encomenda publicada com sucesso na Central de Logística!" })
    else
        cb({ success = false, message = "Erro ao publicar a encomenda." })
    end
end)

CreateCallback('gs_trucker:callback:acceptLogisticsOrder', function(source, cb, data)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return cb({ success = false, message = "Jogador não encontrado." }) end
    local identifier = player.PlayerData.citizenid
    
    local orderId = tonumber(data.orderId)
    if not orderId then return cb({ success = false, message = "ID da encomenda inválido." }) end
    
    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ?', { orderId })
    if not order or not order[1] then
        return cb({ success = false, message = "Esta encomenda já não existe." })
    end
    if order[1].status ~= 'OPEN' then
        return cb({ success = false, message = "Esta encomenda já foi aceite por outro jogador." })
    end

    -- [[ MODO DE TESTE: Verificação desativada temporariamente
    -- if order[1].creator_identifier == identifier then
    --     return cb({ success = false, message = "Você não pode aceitar a sua própria encomenda." })
    -- end
    -- ]]

    local result = MySQL.update.await(
        'UPDATE gs_trucker_logistics_orders SET status = ?, taker_identifier = ? WHERE id = ? AND status = ?',
        { 'IN_PROGRESS', identifier, orderId, 'OPEN' }
    )

    if result and result > 0 then
        cb({ success = true, orderData = order[1] })
    else
        cb({ success = false, message = "Esta encomenda já foi aceite por outro jogador." })
    end
end)

RegisterNetEvent('gs_trucker:server:completeLogisticsOrder', function(missionData)
    local player = exports['gs_trucker']:GetPlayer(source)
    if not player then return end
    local identifier = player.PlayerData.citizenid

    local orderId = missionData.orderId
    
    local order = MySQL.query.await('SELECT * FROM gs_trucker_logistics_orders WHERE id = ? AND taker_identifier = ?', { orderId, identifier })

    if order and order[1] then
        player.Functions.AddMoney('bank', order[1].reward, "Pagamento de encomenda de logística")

        local dropoffDetails = order[1].dropoff_details
        local companyName = dropoffDetails:match("^(.-) %(") or dropoffDetails
        local requestingIndustryLabelKey = dropoffDetails:match("%((.-)%)")

        if companyName and requestingIndustryLabelKey then
            local companyResult = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE name = ?', { companyName })
            if companyResult and companyResult[1] then
                local companyId = companyResult[1].id
                local industryName = nil
                
                -- Encontra o nome da indústria a partir da sua label
                for name, industry in pairs(Industries:GetIndustries()) do
                    if industry.label == requestingIndustryLabelKey then
                        industryName = name
                        break
                    end
                end

                if industryName then
                    MySQL.execute(
                        'INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = stock + VALUES(stock)',
                        { companyId, industryName, order[1].item_name, order[1].quantity }
                    )
                end
            end
        end

        MySQL.update.await('UPDATE gs_trucker_logistics_orders SET status = ? WHERE id = ?', { 'COMPLETED', orderId })
        TriggerClientEvent('QBCore:Notify', source, ('Encomenda concluída! Você recebeu $%s.'):format(order[1].reward), 'success')
    end
end)