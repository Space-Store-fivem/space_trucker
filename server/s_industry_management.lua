-- gs_trucker/server/s_industry_management.lua (VERSÃO FINAL, COMPLETA E CORRIGIDA)

local QBCore = exports['qb-core']:GetCoreObject()

-- Funções de gestão de indústrias compradas (sem alterações)
function GetOwnedIndustryDetails(companyId, industryName)
    local industryData = MySQL.query.await('SELECT * FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not industryData or not industryData[1] then return nil end

    local industryDef = Industries:GetIndustry(industryName)
    if not industryDef then return nil end

    local products, inputs = {}, {}
    if industryDef.tradeData then
        if industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
            for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
                local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
                products[itemName] = { label = 'item_name_' .. itemName, inStock = stockResult and stockResult[1] and stockResult[1].stock or 0, storageSize = itemData.storageSize, price = itemData.price }
            end
        end
        if industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] then
            for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
                inputs[itemName] = { label = 'item_name_' .. itemName, inStock = stockResult and stockResult[1] and stockResult[1].stock or 0, storageSize = itemData.storageSize }
            end
        end
    end

    return { investment_level = industryData[1].investment_level or 0, npc_workers = industryData[1].npc_workers or 0, products = products, inputs = inputs }
end

CreateCallback('gs_trucker:callback:getIndustryDetails', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({}) end
    local details = GetOwnedIndustryDetails(company[1].id, data.industryName)
    cb(details or {})
end)

CreateCallback('gs_trucker:callback:investInIndustry', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName, investmentCost = data.industryName, 50000
    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
    if company[1].balance < investmentCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { investmentCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET investment_level = investment_level + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    
    local industryDef = Industries:GetIndustry(industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_investment', -investmentCost, 'Investimento na indústria: ' .. (industryDef and industryDef.label or industryName)})

    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "Investimento realizado com sucesso!", updatedData = updatedData })
end)

CreateCallback('gs_trucker:callback:hireNpcForIndustry', function(source, cb, data)
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName, hireCost = data.industryName, 10000
    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
    if company[1].balance < hireCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end
    
    local industryData = MySQL.query.await('SELECT npc_workers FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    if industryData and industryData[1] and industryData[1].npc_workers >= 10 then return cb({ success = false, message = "Limite de NPCs atingido para esta indústria." }) end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { hireCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET npc_workers = npc_workers + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })

    local industryDef = Industries:GetIndustry(industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'npc_hire', -hireCost, 'Contratação de NPC para a indústria: ' .. (industryDef and industryDef.label or industryName)})

    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "NPC contratado!", updatedData = updatedData })
end)

-- Função auxiliar corrigida para encontrar a indústria que VENDE um item e TEM ESTOQUE
local function findItemSource(itemName, requiredAmount)
    local allIndustries = Industries:GetIndustries()
    
    for name, industry in pairs(allIndustries) do
        if industry.tradeData and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE] and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE][itemName] then
            local ownerResult = MySQL.query.await('SELECT company_id FROM gs_trucker_company_industries WHERE industry_name = ?', { name })
            local companyIdToCheck
            if ownerResult and ownerResult[1] then
                companyIdToCheck = ownerResult[1].company_id
            else
                local systemCompany = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE name = ?', { 'Sistema' })
                if systemCompany and systemCompany[1] then companyIdToCheck = systemCompany[1].id end
            end

            if companyIdToCheck then
                local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyIdToCheck, name, itemName })
                if stockResult and stockResult[1] and stockResult[1].stock >= requiredAmount then
                    return industry
                end
            end
        end
    end
    return nil
end


Citizen.CreateThread(function()
    local SystemCompanyId = nil
    Citizen.Wait(3000) -- Espera para garantir que tudo carregou
    local result = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE name = ?', { 'Sistema' })
    if result and result[1] then
        SystemCompanyId = result[1].id
        print(('[gs-trucker] Economia iniciada. ID da empresa do Sistema: %d'):format(SystemCompanyId))
    else
        print('[gs-trucker] ERRO CRÍTICO: Empresa "Sistema" não encontrada. A economia não funcionará.')
    end

    while true do
        Citizen.Wait(60000) -- Ciclo principal a cada 1 minuto

        if not SystemCompanyId then goto continue_main_loop end

        local allIndustries = Industries:GetIndustries()
        local purchasedIndustries = MySQL.query.await('SELECT * FROM gs_trucker_company_industries', {})
        local purchasedMap = {}
        for _, row in ipairs(purchasedIndustries) do purchasedMap[row.industry_name] = row end

        -- #####################################################################
        -- ## 1. CICLO UNIFICADO DE PRODUÇÃO (JOGADORES E SISTEMA)            ##
        -- #####################################################################
        for industryName, industryDef in pairs(allIndustries) do
            -- Ignora indústrias que não produzem nada (como negócios)
            if not industryDef.tradeData or not industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] then goto continue_production end

            local ownerData = purchasedMap[industryName]
            local isPlayerOwned = (ownerData ~= nil)
            local companyId = isPlayerOwned and ownerData.company_id or SystemCompanyId
            
            local hasAllMaterials = true
            -- A. Verifica se precisa de matéria-prima (Secundária/Terciária)
            if industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
                for materialName, materialData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                    local requiredAmount = materialData.amount_needed or 1
                    local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, materialName })
                    if not stockResult or not stockResult[1] or stockResult[1].stock < requiredAmount then
                        hasAllMaterials = false -- Não tem matéria-prima suficiente
                        break
                    end
                end
            -- B. Se for Primária, verifica condições diferentes
            elseif isPlayerOwned then -- Primária de Jogador
                local company = MySQL.query.await('SELECT balance FROM gs_trucker_companies WHERE id = ?', { companyId })
                if not company or not company[1] or company[1].balance < 500 then hasAllMaterials = false end -- Não tem dinheiro
            end
            -- C. Primária do Sistema não precisa verificar nada, 'hasAllMaterials' continua 'true' e ela produzirá sempre.

            -- Se todas as condições foram atendidas, a indústria PRODUZ
            if hasAllMaterials then
                -- Consome os recursos necessários (se houver)
                if industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
                    for materialName, materialData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                        MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = stock - ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { materialData.amount_needed or 1, companyId, industryName, materialName })
                    end
                elseif isPlayerOwned then -- Consome dinheiro se for Primária de Jogador
                    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { 500, companyId })
                end
                
                -- Gera os novos produtos
                for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
                    local baseProduction = itemData.production or 5
                    if isPlayerOwned then -- Adiciona bônus para jogadores
                        baseProduction = baseProduction + (ownerData.investment_level or 0) * 2 + (ownerData.npc_workers or 0) * 1
                    end
                    MySQL.execute('INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = LEAST(stock + ?, ?)', { companyId, industryName, itemName, baseProduction, baseProduction, itemData.storageSize or 100 })
                    -- print(('[PRODUÇÃO] Indústria %s (%s) produziu %d de %s.'):format(industryName, isPlayerOwned and 'Jogador' or 'Sistema', baseProduction, itemName))
                end
            end
            ::continue_production::
        end

        -- #####################################################################
        -- ## 2. CICLO DE CRIAÇÃO DE ENCOMENDAS (APENAS PARA SISTEMA)         ##
        -- #####################################################################
        for name, industryDef in pairs(allIndustries) do
            if not purchasedMap[name] and industryDef.tier ~= spaceconfig.Industry.Tier.BUSINESS then
                if industryDef.tradeData and industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED] and next(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) then
                    for materialName, materialData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
                        local existingOrder = MySQL.query.await('SELECT id FROM gs_trucker_logistics_orders WHERE creator_name = ? AND item_name = ? AND status = ?', { industryDef.label, materialName, 'OPEN' })
                        if not existingOrder or #existingOrder == 0 then
                            
                            local maxStorage = materialData.storageSize or 100
                            local orderAmount = math.random(math.max(10, math.floor(maxStorage * 0.20)), math.min(maxStorage, math.floor(maxStorage * 0.30)))

                            local sourceIndustry = findItemSource(materialName, orderAmount)
                            
                            if sourceIndustry then
                                local itemPrice = sourceIndustry.tradeData[spaceconfig.Industry.TradeType.FORSALE][materialName].price
                                if itemPrice then
                                    local distance = #(sourceIndustry.location - industryDef.location)
                                    local reward = math.floor((itemPrice * orderAmount * 0.1) + (distance / 5))
                                    local cargoValue = itemPrice * orderAmount
                                    local itemLabel = Lang:t('item_name_' .. materialName) or materialName
                                    
                                    MySQL.insert.await('INSERT INTO gs_trucker_logistics_orders (creator_identifier, creator_name, item_name, item_label, quantity, reward, cargo_value, pickup_industry_name, pickup_location, dropoff_location, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', { 
                                        'system', industryDef.label, materialName, itemLabel, orderAmount, reward, cargoValue, sourceIndustry.name, json.encode(sourceIndustry.location), json.encode(industryDef.location), 'OPEN' 
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
        ::continue_main_loop::
    end
end)