-- space_trucker/server/s_industry_management.lua (VERSÃO FINAL COM PREÇOS NO MONITOR)

local QBCore = exports['qb-core']:GetCoreObject()

-- Funções de gestão de indústrias compradas (sem alterações)
function GetOwnedIndustryDetails(companyId, industryName)
    local industryData = MySQL.query.await('SELECT * FROM space_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not industryData or not industryData[1] then return nil end
    local industryDef = Industries:GetIndustry(industryName)
    if not industryDef then return nil end
    local products, inputs = {}, {}
    if industryDef.tradeData then
        if industryDef.tradeData[config.Industry.TradeType.FORSALE] then
            for itemName, itemData in pairs(industryDef.tradeData[config.Industry.TradeType.FORSALE]) do
                local stockResult = MySQL.query.await('SELECT stock FROM space_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
                
                -- ## CORREÇÃO SEGURA APLICADA AQUI ##
                -- Verifica se o item existe na config. Se sim, usa o nome correto.
                -- Se não, usa o nome antigo para evitar que o script quebre.
                local itemLabel = (config.IndustryItems[itemName] and config.IndustryItems[itemName].label) or ('item_name_' .. itemName)
                
                products[itemName] = { label = itemLabel, inStock = stockResult and stockResult[1] and stockResult[1].stock or 0, storageSize = itemData.storageSize, price = itemData.price }
            end
        end
        if industryDef.tradeData[config.Industry.TradeType.WANTED] then
            for itemName, itemData in pairs(industryDef.tradeData[config.Industry.TradeType.WANTED]) do
                local stockResult = MySQL.query.await('SELECT stock FROM space_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })

                -- ## CORREÇÃO SEGURA APLICADA AQUI ##
                local itemLabel = (config.IndustryItems[itemName] and config.IndustryItems[itemName].label) or ('item_name_' .. itemName)

                inputs[itemName] = { label = itemLabel, inStock = stockResult and stockResult[1] and stockResult[1].stock or 0, storageSize = itemData.storageSize }
            end
        end
    end
    return { investment_level = industryData[1].investment_level or 0, npc_workers = industryData[1].npc_workers or 0, products = products, inputs = inputs }
end 
CreateCallback('space_trucker:callback:getIndustryDetails', function(source, cb, data)
    local ownerIdentifier = exports['space_trucker']:GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({}) end
    local details = GetOwnedIndustryDetails(company[1].id, data.industryName)
    cb(details or {})
end)
CreateCallback('space_trucker:callback:investInIndustry', function(source, cb, data)
    local ownerIdentifier = exports['space_trucker']:GetPlayerUniqueId(source)
    local industryName, investmentCost = data.industryName, 50000
    local company = MySQL.query.await('SELECT id, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
    if company[1].balance < investmentCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end
    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { investmentCost, company[1].id })
    MySQL.update.await('UPDATE space_trucker_company_industries SET investment_level = investment_level + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    local industryDef = Industries:GetIndustry(industryName)
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_investment', -investmentCost, 'Investimento na indústria: ' .. (industryDef and industryDef.label or industryName)})
    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "Investimento realizado com sucesso!", updatedData = updatedData })
end)
CreateCallback('space_trucker:callback:hireNpcForIndustry', function(source, cb, data)
    local ownerIdentifier = exports['space_trucker']:GetPlayerUniqueId(source)
    local industryName, hireCost = data.industryName, 10000
    local company = MySQL.query.await('SELECT id, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
    if company[1].balance < hireCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end
    local industryData = MySQL.query.await('SELECT npc_workers FROM space_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    if industryData and industryData[1] and industryData[1].npc_workers >= 10 then return cb({ success = false, message = "Limite de NPCs atingido." }) end
    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { hireCost, company[1].id })
    MySQL.update.await('UPDATE space_trucker_company_industries SET npc_workers = npc_workers + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    local industryDef = Industries:GetIndustry(industryName)
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'npc_hire', -hireCost, 'Contratação de NPC para a indústria: ' .. (industryDef and industryDef.label or industryName)})
    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "NPC contratado!", updatedData = updatedData })
end)

local function findItemSource(itemName, requiredAmount)
    local allIndustries = Industries:GetIndustries()
    for name, industry in pairs(allIndustries) do
        if industry.tradeData and industry.tradeData[config.Industry.TradeType.FORSALE] and industry.tradeData[config.Industry.TradeType.FORSALE][itemName] then
            local ownerResult = MySQL.query.await('SELECT company_id FROM space_trucker_company_industries WHERE industry_name = ?', { name })
            local companyIdToCheck
            if ownerResult and ownerResult[1] then
                companyIdToCheck = ownerResult[1].company_id
            else
                local systemCompany = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE name = ?', { 'Sistema' })
                if systemCompany and systemCompany[1] then companyIdToCheck = systemCompany[1].id end
            end
            if companyIdToCheck then
                local stockResult = MySQL.query.await('SELECT stock FROM space_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyIdToCheck, name, itemName })
                if stockResult and stockResult[1] and stockResult[1].stock >= (requiredAmount or 1) then
                    return industry
                end
            end
        end
    end
    return nil
end

Citizen.CreateThread(function()
    local SystemCompanyId = nil
    Citizen.Wait(3000)
    local result = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE name = ?', { 'Sistema' })
    if result and result[1] then SystemCompanyId = result[1].id end

    while true do
        Citizen.Wait(60000)
        if not SystemCompanyId then goto continue_main_loop end
        local allIndustries = Industries:GetIndustries()
        local purchasedIndustries = MySQL.query.await('SELECT * FROM space_trucker_company_industries', {})
        local purchasedMap = {}
        for _, row in ipairs(purchasedIndustries) do purchasedMap[row.industry_name] = row end

        for industryName, industryDef in pairs(allIndustries) do
            if not industryDef.tradeData or not industryDef.tradeData[config.Industry.TradeType.FORSALE] then goto continue_production end
            local ownerData = purchasedMap[industryName]
            local isPlayerOwned = (ownerData ~= nil)
            local companyId = isPlayerOwned and ownerData.company_id or SystemCompanyId
            local hasAllMaterials = true
            if industryDef.tradeData[config.Industry.TradeType.WANTED] and next(industryDef.tradeData[config.Industry.TradeType.WANTED]) then
                for materialName, materialData in pairs(industryDef.tradeData[config.Industry.TradeType.WANTED]) do
                    local requiredAmount = materialData.amount_needed or 1
                    local stockResult = MySQL.query.await('SELECT stock FROM space_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, materialName })
                    if not stockResult or not stockResult[1] or stockResult[1].stock < requiredAmount then
                        hasAllMaterials = false
                        break
                    end
                end
            elseif isPlayerOwned then
                local company = MySQL.query.await('SELECT balance FROM space_trucker_companies WHERE id = ?', { companyId })
                if not company or not company[1] or company[1].balance < 500 then hasAllMaterials = false end
            end
            if hasAllMaterials then
                if industryDef.tradeData[config.Industry.TradeType.WANTED] and next(industryDef.tradeData[config.Industry.TradeType.WANTED]) then
                    for materialName, materialData in pairs(industryDef.tradeData[config.Industry.TradeType.WANTED]) do
                        MySQL.update.await('UPDATE space_trucker_industry_stock SET stock = stock - ? WHERE company_id = ? AND industry_name = ? AND item_name = ?', { materialData.amount_needed or 1, companyId, industryName, materialName })
                    end
                elseif isPlayerOwned then
                    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { 500, companyId })
                end
                for itemName, itemData in pairs(industryDef.tradeData[config.Industry.TradeType.FORSALE]) do
                    local baseProduction = itemData.production or 5
                    if isPlayerOwned then
                        baseProduction = baseProduction + (ownerData.investment_level or 0) * 2 + (ownerData.npc_workers or 0) * 1
                    end
                    MySQL.execute('INSERT INTO space_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE stock = LEAST(stock + ?, ?)', { companyId, industryName, itemName, baseProduction, baseProduction, itemData.storageSize or 100 })
                end
            end
            ::continue_production::
        end

        for name, industryDef in pairs(allIndustries) do
            if not purchasedMap[name] and industryDef.tier ~= config.Industry.Tier.BUSINESS then
                if industryDef.tradeData and industryDef.tradeData[config.Industry.TradeType.WANTED] and next(industryDef.tradeData[config.Industry.TradeType.WANTED]) then
                    for materialName, materialData in pairs(industryDef.tradeData[config.Industry.TradeType.WANTED]) do
                        local existingOrder = MySQL.query.await('SELECT id FROM space_trucker_logistics_orders WHERE creator_name = ? AND item_name = ? AND status = ?', { industryDef.label, materialName, 'OPEN' })
                        if not existingOrder or #existingOrder == 0 then
                            local maxStorage = materialData.storageSize or 100
                            local orderAmount = math.random(math.max(10, math.floor(maxStorage * 0.20)), math.min(maxStorage, math.floor(maxStorage * 0.30)))
                            local sourceIndustry = findItemSource(materialName, orderAmount)
                            if sourceIndustry then
                                local itemPrice = sourceIndustry.tradeData[config.Industry.TradeType.FORSALE][materialName].price
                                if itemPrice then
                                    local distance = #(sourceIndustry.location - industryDef.location)
                                    local reward = math.floor((itemPrice * orderAmount * 0.1) + (distance / 5))
                                    local cargoValue = itemPrice * orderAmount
                                    local itemLabel = Lang:t('item_name_' .. materialName) or materialName
                                    MySQL.insert.await('INSERT INTO space_trucker_logistics_orders (creator_identifier, creator_name, item_name, item_label, quantity, reward, cargo_value, pickup_industry_name, pickup_location, dropoff_location, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', { 'system', industryDef.label, materialName, itemLabel, orderAmount, reward, cargoValue, sourceIndustry.name, json.encode(sourceIndustry.location), json.encode(industryDef.location), 'OPEN' })
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

CreateCallback('space_trucker:callback:getIndustryStatus', function(source, cb)
    local SystemCompanyId = nil
    local result = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE name = ?', { 'Sistema' })
    if result and result[1] then SystemCompanyId = result[1].id end
    if not SystemCompanyId then return cb({}) end

    local allIndustries = Industries:GetIndustries()
    local purchasedIndustries = MySQL.query.await('SELECT * FROM space_trucker_company_industries', {})
    local allStock = MySQL.query.await('SELECT * FROM space_trucker_industry_stock', {})
    
    local purchasedMap = {}
    for _, row in ipairs(purchasedIndustries) do purchasedMap[row.industry_name] = row end
    
    local stockMap = {}
    for _, row in ipairs(allStock) do
        local key = ('%s_%s'):format(row.company_id, row.industry_name)
        if not stockMap[key] then stockMap[key] = {} end
        stockMap[key][row.item_name] = row.stock
    end

    local statusData = {}

    for name, def in pairs(allIndustries) do
        if def.tier ~= config.Industry.Tier.BUSINESS then
            local ownerData = purchasedMap[name]
            local isPlayerOwned = (ownerData ~= nil)
            local companyId = isPlayerOwned and ownerData.company_id or SystemCompanyId
            local ownerType = isPlayerOwned and "Jogador" or "Sistema"
            
            local industryStatus = { name = name, label = Lang:t(def.label), tier = def.tier, owner = ownerType, status = "Inativo", reason = "N/A", inputs = {}, outputs = {} }

            local industryStockKey = ('%s_%s'):format(companyId, name)
            local currentIndustryStock = stockMap[industryStockKey] or {}

            if def.tradeData then
                if def.tradeData[config.Industry.TradeType.WANTED] then
                    for itemName, itemData in pairs(def.tradeData[config.Industry.TradeType.WANTED]) do
                        -- [[ CORREÇÃO PARA PREÇO DE INPUT ]] --
                        local sourceIndustry = findItemSource(itemName, 1) -- Encontra quem vende
                        local price = 0
                        if sourceIndustry and sourceIndustry.tradeData[config.Industry.TradeType.FORSALE][itemName] then
                            price = sourceIndustry.tradeData[config.Industry.TradeType.FORSALE][itemName].price or 0
                        end
                        table.insert(industryStatus.inputs, {
                            label = Lang:t('item_name_' .. itemName),
                            stock = currentIndustryStock[itemName] or 0,
                            needed = itemData.amount_needed or 1,
                            price = price
                        })
                    end
                end
                if def.tradeData[config.Industry.TradeType.FORSALE] then
                     for itemName, itemData in pairs(def.tradeData[config.Industry.TradeType.FORSALE]) do
                        table.insert(industryStatus.outputs, {
                            label = Lang:t('item_name_' .. itemName),
                            stock = currentIndustryStock[itemName] or 0,
                            capacity = itemData.storageSize or 100,
                            price = itemData.price or 0 -- [[ CORREÇÃO PARA PREÇO DE OUTPUT ]]
                        })
                    end
                end
            end

            local hasAllMaterials = true
            if def.tier == config.Industry.Tier.PRIMARY and isPlayerOwned then
                local company = MySQL.query.await('SELECT balance FROM space_trucker_companies WHERE id = ?', { companyId })
                if not company or not company[1] or company[1].balance < 500 then
                    hasAllMaterials = false
                    industryStatus.reason = "Saldo da empresa insuficiente"
                end
            elseif #industryStatus.inputs > 0 then
                for _, input in ipairs(industryStatus.inputs) do
                    if input.stock < input.needed then
                        hasAllMaterials = false
                        industryStatus.reason = "Falta: " .. input.label
                        break
                    end
                end
            end
            
            if hasAllMaterials then
                industryStatus.status = "Produzindo"
                industryStatus.reason = "Operacional"
            else
                industryStatus.status = "Parado"
            end
            
            table.insert(statusData, industryStatus)
        end
    end
    
    cb(statusData)
end)