-- gs_trucker/server/s_industry_management.lua (VERSÃO FINAL E CORRIGIDA)

local QBCore = exports['qb-core']:GetCoreObject()

-- Função auxiliar para obter os dados detalhados de uma indústria possuída (VERSÃO ÚNICA E CORRIGIDA)
function GetOwnedIndustryDetails(companyId, industryName)
    local industryData = MySQL.query.await('SELECT * FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not industryData or not industryData[1] then return nil end

    local industryDef = Industries:GetIndustry(industryName)
    if not industryDef then return nil end

    -- Busca os produtos que a indústria VENDE
    local products = {}
    if industryDef.tradeData and industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
        for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
            local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
            products[itemName] = {
                label = 'item_name_' .. itemName, -- Envia a chave de tradução
                inStock = stockResult and stockResult[1] and stockResult[1].stock or 0,
                storageSize = itemData.storageSize,
                price = itemData.price,
            }
        end
    end

    -- Busca os produtos que a indústria PRECISA (inputs)
    local inputs = {}
    if industryDef.tradeData and industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] then
        for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
            local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
            inputs[itemName] = {
                label = 'item_name_' .. itemName, -- Envia a chave de tradução
                inStock = stockResult and stockResult[1] and stockResult[1].stock or 0,
                storageSize = itemData.storageSize,
            }
        end
    end

    return {
        investment_level = industryData[1].investment_level or 0,
        npc_workers = industryData[1].npc_workers or 0,
        products = products,
        inputs = inputs,
    }
end

CreateCallback('gs_trucker:callback:getIndustryDetails', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({}) 
    end

    local details = GetOwnedIndustryDetails(company[1].id, data.industryName)
    cb(details or {})
end)


CreateCallback('gs_trucker:callback:investInIndustry', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName = data.industryName
    local investmentCost = 50000

    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end

    if company[1].balance < investmentCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { investmentCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET investment_level = investment_level + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    
    local industryDef = Industries:GetIndustry(industryName)
    local description = 'Investimento na indústria: ' .. (industryDef and industryDef.label or industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_investment', -investmentCost, description})

    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "Investimento realizado com sucesso!", updatedData = updatedData })
end)

CreateCallback('gs_trucker:callback:hireNpcForIndustry', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName = data.industryName
    local hireCost = 10000

    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end

    if company[1].balance < hireCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end
    
    local industryData = MySQL.query.await('SELECT npc_workers FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    if industryData and industryData[1] and industryData[1].npc_workers >= 10 then
        return cb({ success = false, message = "Limite de NPCs atingido para esta indústria." })
    end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { hireCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET npc_workers = npc_workers + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })

    local industryDef = Industries:GetIndustry(industryName)
    local description = 'Contratação de NPC para a indústria: ' .. (industryDef and industryDef.label or industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'npc_hire', -hireCost, description})

    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "NPC contratado!", updatedData = updatedData })
end)


-- Função auxiliar para encontrar a indústria que VENDE um item específico
local function findItemSource(itemName)
    local allIndustries = Industries:GetIndustries()
    for name, industry in pairs(allIndustries) do
        -- [[ CORREÇÃO APLICADA AQUI ]] --
        -- Validação mais robusta para garantir que a indústria e o item têm um preço definido
        if industry.tradeData and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE] and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE][itemName] and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE][itemName].price then
            return industry -- Retorna o objeto completo da indústria
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Ciclo de 1 minuto

        -- #####################################################################
        -- ## CICLO DE PRODUÇÃO PARA INDÚSTRIAS COMPRADAS POR JOGADORES       ##
        -- #####################################################################
        local ownedIndustries = MySQL.query.await('SELECT ci.* FROM gs_trucker_company_industries ci', {})
        if ownedIndustries and #ownedIndustries > 0 then
            for _, ownedIndustry in ipairs(ownedIndustries) do
                local industryDef = Industries:GetIndustry(ownedIndustry.industry_name)
                if not industryDef or not industryDef.tradeData then goto purchased_industry_continue end

                local companyId = ownedIndustry.company_id
                local industryName = ownedIndustry.industry_name
                local hasAllMaterials = true
                local materialsToConsume = {}

                if industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
                    for materialName, materialData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                        local requiredAmount = materialData.amount_needed or 1
                        local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, materialName })
                        local currentStock = stockResult and stockResult[1] and stockResult[1].stock or 0
                        
                        if currentStock < requiredAmount then
                            hasAllMaterials = false
                            print(('[PRODUÇÃO JOGADOR] A indústria %s parou. Faltam materiais: %s'):format(industryName, tostring(materialName)))
                            break
                        else
                            table.insert(materialsToConsume, { name = materialName, amount = requiredAmount })
                        end
                    end
                else 
                    local utilityCost = 500
                    local company = MySQL.query.await('SELECT balance FROM gs_trucker_companies WHERE id = ?', { companyId })
                    if not company or not company[1] or company[1].balance < utilityCost then
                        hasAllMaterials = false
                        print(('[PRODUÇÃO JOGADOR] A indústria primária %s parou. Saldo da empresa insuficiente.'):format(industryName))
                    end
                end

                if hasAllMaterials then
                    for _, material in ipairs(materialsToConsume) do
                        MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = stock - ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { material.amount, companyId, industryName, material.name })
                    end
                    if #materialsToConsume == 0 then
                        local utilityCost = 500
                        MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { utilityCost, companyId })
                    end
                    for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
                        local baseProduction = itemData.production or 5
                        local investmentBonus = (ownedIndustry.investment_level or 0) * 2
                        local npcBonus = (ownedIndustry.npc_workers or 0) * 1
                        local finalProduction = math.floor(baseProduction + investmentBonus + npcBonus)
                        MySQL.execute('INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = LEAST(stock + ?, ?)', { companyId, industryName, itemName, finalProduction, finalProduction, itemData.storageSize or 100 })
                        print(('[PRODUÇÃO JOGADOR] A indústria %s produziu %d de %s.'):format(industryName, finalProduction, itemName))
                    end
                end
                ::purchased_industry_continue::
            end
        end

        -- #####################################################################
        -- ## CICLO DE ENCOMENDAS PARA INDÚSTRIAS NÃO COMPRADAS (SISTEMA)     ##
        -- #####################################################################
        local allDefinedIndustries = Industries:GetIndustries()
        local purchasedIndustriesResult = MySQL.query.await('SELECT industry_name FROM gs_trucker_company_industries', {})
        local purchasedIndustriesMap = {}
        for _, row in ipairs(purchasedIndustriesResult) do
            purchasedIndustriesMap[row.industry_name] = true
        end

        for name, industryDef in pairs(allDefinedIndustries) do
            if not purchasedIndustriesMap[name] then
                if industryDef and industryDef.tradeData then
                    if industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
                        for materialName, materialData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                            local existingOrder = MySQL.query.await('SELECT id FROM gs_trucker_logistics_orders WHERE creator_name = ? AND item_name = ? AND status = ?', { industryDef.label, materialName, 'OPEN' })
                            
                            if not existingOrder or #existingOrder == 0 then
                                local sourceIndustry = findItemSource(materialName)
                                
                                if sourceIndustry then
                                    local itemPrice = sourceIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][materialName].price

                                    if itemPrice then
                                        local orderAmount = materialData.storageSize or 100 
                                        local distance = #(sourceIndustry.location - industryDef.location)
                                        local reward = math.floor((itemPrice * orderAmount * 0.1) + (distance / 5))
                                        local cargoValue = itemPrice * orderAmount
                                        local itemLabel = Lang:t('item_name_' .. materialName) or materialName
                                        
                                        -- [[ CORREÇÃO FINAL APLICADA AQUI: Removido o '?' extra ]]
                                        MySQL.insert.await('INSERT INTO gs_trucker_logistics_orders (creator_identifier, creator_name, item_name, item_label, quantity, reward, cargo_value, pickup_industry_name, pickup_location, dropoff_location, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', { 
                                            'system', industryDef.label, materialName, itemLabel, orderAmount, reward, cargoValue, sourceIndustry.name, json.encode(sourceIndustry.location), json.encode(industryDef.location), 'OPEN' 
                                        })
                                        print(('[LOGÍSTICA DO SISTEMA] A indústria %s criou uma encomenda de %d x %s.'):format(name, orderAmount, materialName))
                                    else
                                        print(('[AVISO DE CONFIGURAÇÃO] O material "%s" na indústria "%s" não tem um preço definido.'):format(tostring(materialName), sourceIndustry.name))
                                    end
                                end
                            end
                        end
                    end
                else
                    print(('[ERRO DE CONFIGURAÇÃO] A indústria "%s" não foi carregada corretamente (falta tradeData).'):format(name))
                end
            end
        end
        ::continue::
    end
end)