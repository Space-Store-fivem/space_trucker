local GS = exports.space_trucker

-- NOVA FUNÇÃO: Busca as últimas 50 transações de uma empresa
local function GetCompanyTransactions(companyId)
    local transactions = MySQL.query.await('SELECT * FROM space_trucker_transactions WHERE company_id = ? ORDER BY timestamp DESC LIMIT 50', { companyId })
    return transactions or {}
end

-- Callback para depositar dinheiro na empresa
CreateCallback('space_trucker:callback:depositMoney', function(source, cb, data)
    local Player = GS:GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local amount = tonumber(data.amount)
    if not amount or amount <= 0 then
        return cb({ success = false, message = "Valor inválido." })
    end

    if Player.Functions.GetMoney('cash') < amount then
        return cb({ success = false, message = "Você não tem dinheiro suficiente em mão." })
    end

    local worksFor, companyId = CheckIfPlayerWorksForCompany(source)
    if not worksFor then
        return cb({ success = false, message = "Você não trabalha para nenhuma empresa." })
    end

    Player.Functions.RemoveMoney('cash', amount, 'deposito-empresa-space-trucker')
    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { amount, companyId })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', {
        companyId, 'deposit', amount, 'Depósito feito por ' .. Player.PlayerData.charinfo.firstname
    })

    local newBalance = MySQL.scalar.await('SELECT balance FROM space_trucker_companies WHERE id = ?', { companyId }) or 0

    -- CORREÇÃO: Agora buscamos as transações reais e enviamos de volta
    local updatedData = {
        company_data = {
            balance = newBalance
        },
        transactions = GetCompanyTransactions(companyId) -- Usamos a nova função aqui
    }

    cb({
        success = true,
        message = "Depósito realizado com sucesso!",
        updatedData = updatedData
    })
end)

-- Callback para levantar dinheiro da empresa (apenas dono)
CreateCallback('space_trucker:callback:withdrawMoney', function(source, cb, data)
    local Player = GS:GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local amount = tonumber(data.amount)
    if not amount or amount <= 0 then
        return cb({ success = false, message = "Valor inválido." })
    end

    local ownerIdentifier = GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })

    if not company or not company[1] then
        return cb({ success = false, message = "Apenas o dono da empresa pode levantar dinheiro." })
    end

    local companyId = company[1].id
    if company[1].balance < amount then
        return cb({ success = false, message = "A empresa não tem saldo suficiente." })
    end

    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { amount, companyId })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', {
        companyId, 'withdraw', -amount, 'Levantamento feito por ' .. Player.PlayerData.charinfo.firstname
    })
    Player.Functions.AddMoney('cash', amount, 'levantamento-empresa-space-trucker')

    local newBalance = MySQL.scalar.await('SELECT balance FROM space_trucker_companies WHERE id = ?', { companyId }) or 0

    -- CORREÇÃO: E também aqui!
    local updatedData = {
        company_data = {
            balance = newBalance
        },
        transactions = GetCompanyTransactions(companyId) -- Usamos a nova função aqui
    }

    cb({
        success = true,
        message = "Saque realizado com sucesso!",
        updatedData = updatedData
    })
end)