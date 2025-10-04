
-- CRON JOB PARA PAGAMENTO AUTOMÁTICO DE SALÁRIOS
CreateThread(function()
    -- Adiciona uma pequena espera inicial para garantir que todos os scripts carregaram
    Wait(5000) 

    while true do
        -- Tempo de espera de 1 hora (3600000 milissegundos).
        -- Para testes, pode usar um valor menor como 60000 (1 minuto).
        Wait(3600000)

        local QBCore = exports['qb-core']:GetCoreObject()

        if QBCore and QBCore.Functions then
            local companiesToPay = MySQL.query.await('SELECT id, balance, owner_identifier FROM space_trucker_companies WHERE salary_payment_enabled = 1', {})

            if companiesToPay and #companiesToPay > 0 then
                for i, company in ipairs(companiesToPay) do
                    local employees = MySQL.query.await("SELECT identifier, name, salary FROM space_trucker_employees WHERE company_id = ? AND is_npc = 0 AND role <> 'owner'", { company.id })
                    
                    if employees and #employees > 0 then
                        local totalSalaryCost = 0
                        for j, emp in ipairs(employees) do
                            totalSalaryCost = totalSalaryCost + emp.salary
                        end

                        local ownerPlayer = QBCore.Functions.GetPlayerByCitizenId(company.owner_identifier)

                        if company.balance >= totalSalaryCost then
                            MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { totalSalaryCost, company.id })
                            MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company.id, 'salaries', -totalSalaryCost, 'Pagamento de salários a ' .. #employees .. ' funcionários' })

                            if ownerPlayer then
                                TriggerClientEvent('QBCore:Notify', ownerPlayer.PlayerData.source, 'O pagamento automático de salários foi efetuado a ' .. #employees .. ' funcionários. Custo: $' .. totalSalaryCost, 'success', 10000)
                            end

                            for j, emp in ipairs(employees) do
                                local player = QBCore.Functions.GetPlayerByCitizenId(emp.identifier)
                                if player then
                                    player.Functions.AddMoney('bank', emp.salary, "Pagamento de salário da empresa")
                                    TriggerClientEvent('QBCore:Notify', player.PlayerData.source, 'Você recebeu o seu salário de $' .. emp.salary .. ' da sua empresa.', 'success', 8000)
                                end
                            end
                        else
                            if ownerPlayer then
                                TriggerClientEvent('QBCore:Notify', ownerPlayer.PlayerData.source, 'FALHA: A sua empresa não tem saldo suficiente para pagar os salários! (Custo: $' .. totalSalaryCost .. ')', 'error', 10000)
                            end

                            for j, emp in ipairs(employees) do
                                local player = QBCore.Functions.GetPlayerByCitizenId(emp.identifier)
                                if player then
                                    TriggerClientEvent('QBCore:Notify', player.PlayerData.source, 'A sua empresa não tem saldo para pagar o seu salário de $' .. emp.salary .. '. Fale com o seu patrão.', 'error', 10000)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- CRON JOB PARA REMOVER VEÍCULOS ALUGADOS EXPIRADOS DA FROTA
CreateThread(function()
    while true do
        -- A verificação acontece a cada 15 minutos (900000 ms)
        Wait(900000)

        -- Procura na base de dados por veículos que tenham uma data de expiração e que essa data já tenha passado.
        local expiredVehicles = MySQL.update.await('DELETE FROM space_trucker_fleet WHERE rent_expires_at IS NOT NULL AND rent_expires_at < NOW()')

        if expiredVehicles > 0 then
            print(('[space_trucker] Cron: Foram removidos %d veículos alugados expirados da frota de empresas.'):format(expiredVehicles))
        end
    end
end)