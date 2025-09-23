-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_industry_management.lua

local QBCore = exports['qb-core']:GetCoreObject()

-- Função auxiliar para obter os dados detalhados de uma indústria possuída
function GetOwnedIndustryDetails(companyId, industryName)
    print("[s_industry_management] Buscando detalhes para a indústria: " .. industryName .. " da empresa: " .. companyId)
    local industryData = MySQL.query.await('SELECT * FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not industryData or not industryData[1] then
        print("[s_industry_management] Indústria não encontrada ou não pertence à empresa.")
        return nil
    end

    local industryDef = Industries:GetIndustry(industryName)
    if not industryDef then
        print("[s_industry_management] Definição da indústria não encontrada no script.")
        return nil
    end

    local products = {}
    if industryDef.tradeData and industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
        for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
            local stockResult = MySQL.query.await('SELECT stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { companyId, industryName, itemName })
            local currentStock = 0
            if stockResult and stockResult[1] then
                currentStock = stockResult[1].stock
            end

            products[itemName] = {
                label = Lang:t('item_name_' .. itemName),
                inStock = currentStock,
                storageSize = itemData.storageSize,
                price = itemData.price,
            }
        end
    end

    return {
        investment_level = industryData[1].investment_level or 0,
        npc_workers = industryData[1].npc_workers or 0,
        products = products,
    }
end

CreateCallback('gs_trucker:callback:getIndustryDetails', function(source, cb, data)
    -- CORREÇÃO: Chamada correta para a função exportada
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({}) 
    end

    local details = GetOwnedIndustryDetails(company[1].id, data.industryName)
    if details then
        cb(details)
    else
        cb({})
    end
end)


CreateCallback('gs_trucker:callback:investInIndustry', function(source, cb, data)
    -- CORREÇÃO: Chamada correta para a função exportada
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName = data.industryName
    local investmentCost = 50000
    print("[s_industry_management] Processando investimento de " .. ownerIdentifier .. " na indústria " .. industryName)

    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end

    if company[1].balance < investmentCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { investmentCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET investment_level = investment_level + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    
    -- NOVO: Adiciona um registro da transação
    local industryDef = Industries:GetIndustry(industryName)
    local description = 'Investimento na indústria: ' .. (industryDef and industryDef.label or industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_investment', -investmentCost, description})

    print("[s_industry_management] Investimento realizado com sucesso!")
    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "Investimento realizado com sucesso!", updatedData = updatedData })
end)

CreateCallback('gs_trucker:callback:hireNpcForIndustry', function(source, cb, data)
    -- CORREÇÃO: Chamada correta para a função exportada
    local ownerIdentifier = exports['gs_trucker']:GetPlayerUniqueId(source)
    local industryName = data.industryName
    local hireCost = 10000
    print("[s_industry_management] Processando contratação de NPC por " .. ownerIdentifier .. " na indústria " .. industryName)

    local company = MySQL.query.await('SELECT id, balance FROM gs_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end

    if company[1].balance < hireCost then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end
    
    local industryData = MySQL.query.await('SELECT npc_workers FROM gs_trucker_company_industries WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })
    if industryData and industryData[1] and industryData[1].npc_workers >= 10 then
        return cb({ success = false, message = "Limite de NPCs atingido para esta indústria." })
    end

    MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { hireCost, company[1].id })
    MySQL.update.await('UPDATE gs_trucker_company_industries SET npc_workers = npc_workers + 1 WHERE company_id = ? AND industry_name = ?', { company[1].id, industryName })

    -- NOVO: Adiciona um registro da transação
    local industryDef = Industries:GetIndustry(industryName)
    local description = 'Contratação de NPC para a indústria: ' .. (industryDef and industryDef.label or industryName)
    MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'npc_hire', -hireCost, description})

    print("[s_industry_management] NPC contratado com sucesso!")
    local updatedData = GetOwnedIndustryDetails(company[1].id, industryName)
    cb({ success = true, message = "NPC contratado!", updatedData = updatedData })
end)


-- =============================================================================
-- LOOP DE PRODUÇÃO DAS INDÚSTRIAS (COM PERSISTÊNCIA NO BANCO DE DADOS)
-- =============================================================================
Citizen.CreateThread(function()
    while true do
        -- Intervalo de 1 minuto para testes (60000 ms)
        Citizen.Wait(60000)
        
        print('[gs_trucker] Iniciando ciclo de produção das indústrias...')
        
        local ownedIndustries = MySQL.query.await('SELECT * FROM gs_trucker_company_industries', {})
        
        if ownedIndustries and #ownedIndustries > 0 then
            for _, ownedIndustry in ipairs(ownedIndustries) do
                local industryDef = Industries:GetIndustry(ownedIndustry.industry_name)
                
                if industryDef and industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
                    local company = MySQL.query.await('SELECT balance FROM gs_trucker_companies WHERE id = ?', { ownedIndustry.company_id })
                    local operationalCost = 250 

                    if company and company[1] and company[1].balance >= operationalCost then
                        MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { operationalCost, ownedIndustry.company_id })

                        for itemName, itemData in pairs(industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
                            local baseProduction = itemData.production or 5
                            local investmentBonus = (ownedIndustry.investment_level or 0) * 2
                            local npcBonus = (ownedIndustry.npc_workers or 0) * 1
                            local finalProduction = math.floor(baseProduction + investmentBonus + npcBonus)
                            
                            local stockResult = MySQL.query.await('SELECT id, stock FROM gs_trucker_industry_stock WHERE company_id = ? AND industry_name = ? AND item_name = ?', { ownedIndustry.company_id, ownedIndustry.industry_name, itemName })
                            
                            local currentStock = 0
                            if stockResult and stockResult[1] then
                                currentStock = stockResult[1].stock
                            end
                            
                            local storageSize = itemData.storageSize or 100
                            local newStock = math.min(currentStock + finalProduction, storageSize)
                            
                            if stockResult and stockResult[1] then
                                MySQL.update.await('UPDATE gs_trucker_industry_stock SET stock = ? WHERE id = ?', { newStock, stockResult[1].id })
                            else
                                MySQL.insert.await('INSERT INTO gs_trucker_industry_stock (company_id, industry_name, item_name, stock) VALUES (?, ?, ?, ?)', { ownedIndustry.company_id, ownedIndustry.industry_name, itemName, newStock })
                            end
                            
                            print('[gs_trucker] Indústria '..ownedIndustry.industry_name..' produziu '..finalProduction..' de '..itemName..'. Novo estoque: '..newStock)
                        end
                    else
                        print('[gs_trucker] Indústria '..ownedIndustry.industry_name..' sem saldo suficiente para a produção. (Custo: '..operationalCost..')')
                    end
                end
            end
        end
        print('[gs_trucker] Ciclo de produção finalizado.')
    end
end)