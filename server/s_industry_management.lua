-- NO FICHEIRO: server/s_industry_management.lua
-- SUBSTITUA O CONTEÚDO COMPLETO PELA VERSÃO ABAIXO:

local function GetCompanyIdForPlayer(source)
    local Player = exports.Space_trucker:GetPlayer(source)
    if not Player then return nil end
    local identifier = Player.PlayerData.citizenid
    local company = MySQL.query.await('SELECT id FROM Space_trucker_companies WHERE owner_identifier = ?', { identifier })
    return company and company[1] and company[1].id or nil
end

-- Este callback para buscar os dados iniciais já é seguro e permanece o mesmo.
CreateCallback('Space_trucker:callback:getIndustryManagementData', function(source, cb, data)
    local companyId = GetCompanyIdForPlayer(source)
    local industryName = data.industryName
    if not companyId then return cb({ success = false }) end

    local managementData = MySQL.query.await('SELECT * FROM Space_trucker_industry_management WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not managementData or not managementData[1] then
        MySQL.insert.await('INSERT INTO Space_trucker_industry_management (company_id, industry_name) VALUES (?, ?)', { companyId, industryName })
        managementData = MySQL.query.await('SELECT * FROM Space_trucker_industry_management WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    end

    local industryObject = Industries:GetIndustry(industryName)
    local tradeData = industryObject and industryObject:GetTradeData() or nil

    cb({ success = true, data = { management = managementData[1], stock = tradeData } })
end)

-- CORREÇÃO: Convertido para Evento de Rede para ser mais robusto
RegisterNetEvent('Space_trucker:server:investInIndustry', function(data)
    local src = source
    local companyId = GetCompanyIdForPlayer(src)
    local industryName = data.industryName
    if not companyId then return end

    local companyData = MySQL.query.await('SELECT balance FROM Space_trucker_companies WHERE id = ?', { companyId })
    local managementData = MySQL.query.await('SELECT id, investment_level FROM Space_trucker_industry_management WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not companyData or not companyData[1] or not managementData or not managementData[1] then return end

    local INVESTMENT_COST_PER_LEVEL = { [2] = 50000, [3] = 100000, [4] = 250000, [5] = 500000 }
    local nextLevel = managementData[1].investment_level + 1
    local investmentCost = INVESTMENT_COST_PER_LEVEL[nextLevel]

    if not investmentCost then
        return TriggerClientEvent('Space_trucker:client:notify', src, "Esta indústria já atingiu o nível máximo.", "error")
    end
    if companyData[1].balance < investmentCost then
        return TriggerClientEvent('Space_trucker:client:notify', src, "A sua empresa não tem saldo suficiente. Custo: $" .. investmentCost, "error")
    end

    MySQL.update.await('UPDATE Space_trucker_companies SET balance = balance - ? WHERE id = ?', { investmentCost, companyId })
    MySQL.update.await('UPDATE Space_trucker_industry_management SET investment_level = ? WHERE id = ?', { nextLevel, managementData[1].id })
    MySQL.insert.await('INSERT INTO Space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyId, 'industry_investment', -investmentCost, 'Investimento na indústria: ' .. industryName })

    TriggerClientEvent('Space_trucker:client:notify', src, "Investimento realizado com sucesso!", "success")
    TriggerClientEvent('Space_trucker:client:managementUpdate', src) -- Avisa a UI para recarregar os dados
end)

-- Lógica para contratar funcionário, também como Evento de Rede
RegisterNetEvent('Space_trucker:server:hireNpcForIndustry', function(data)
    local src = source
    local companyId = GetCompanyIdForPlayer(src)
    local industryName = data.industryName
    if not companyId then return end

    local companyData = MySQL.query.await('SELECT balance FROM Space_trucker_companies WHERE id = ?', { companyId })
    local managementData = MySQL.query.await('SELECT id, npc_workers FROM Space_trucker_industry_management WHERE company_id = ? AND industry_name = ?', { companyId, industryName })
    if not companyData or not companyData[1] or not managementData or not managementData[1] then return end

    local HIRE_COST = 25000
    local MAX_WORKERS = 10

    if managementData[1].npc_workers >= MAX_WORKERS then
        return TriggerClientEvent('Space_trucker:client:notify', src, "Esta indústria já atingiu o número máximo de funcionários.", "error")
    end
    if companyData[1].balance < HIRE_COST then
        return TriggerClientEvent('Space_trucker:client:notify', src, "A sua empresa não tem saldo suficiente. Custo: $" .. HIRE_COST, "error")
    end

    MySQL.update.await('UPDATE Space_trucker_companies SET balance = balance - ? WHERE id = ?', { HIRE_COST, companyId })
    MySQL.update.await('UPDATE Space_trucker_industry_management SET npc_workers = npc_workers + 1 WHERE id = ?', { managementData[1].id })
    MySQL.insert.await('INSERT INTO Space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyId, 'npc_hire', -HIRE_COST, 'Contratação de funcionário para: ' .. industryName })

    TriggerClientEvent('Space_trucker:client:notify', src, "Funcionário contratado com sucesso!", "success")
    TriggerClientEvent('Space_trucker:client:managementUpdate', src) -- Avisa a UI para recarregar os dados
end)