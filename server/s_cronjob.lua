
---@param _industry Industry
local function updatePrimaryIndustry(_industry)

    local updateData = {}
    for itemName, value in pairs(_industry.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
        if not _industry:IsStorageFull(spaceconfig.Industry.TradeType.FORSALE, itemName) then
            _industry:AddItemAmount(spaceconfig.Industry.TradeType.FORSALE, itemName, value.production, false)
            updateData[itemName] = {
                amount = _industry:GetInStockAmount(spaceconfig.Industry.TradeType.FORSALE, itemName)
            }
        end
    end

    return updateData
end

---@param _industry Industry
local function updateBusinessIndustry(_industry)
    local updateData = {}
    for itemName, value in pairs(_industry.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
        if _industry:GetInStockAmount(spaceconfig.Industry.TradeType.WANTED, itemName) > 0 then
            _industry:RemoveItemAmount(spaceconfig.Industry.TradeType.WANTED, itemName, value.consumption, false)
            updateData[itemName] = {
                amount = _industry:GetInStockAmount(spaceconfig.Industry.TradeType.WANTED, itemName)
            }
        end
    end

    return updateData
end


---@param _industry Industry
local function updateSecondaryIndustry(_industry)
    local updateData = {}
    updateData[spaceconfig.Industry.TradeType.FORSALE] = {}
    updateData[spaceconfig.Industry.TradeType.WANTED] = {}
    
    local canConsumption = false
    local resourceCanConsumptionCount = 0
    -- Đầu tiên kiểm tra tất cả hàng đang bán xem có full hết chưa, nếu chưa full thì tiếp tục
    for itemName, value in pairs(_industry.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
        -- Nếu có một loại hàng nào đó chưa Full Storage
        if not _industry:IsStorageFull(spaceconfig.Industry.TradeType.FORSALE, itemName) then
            canConsumption = true
            break
        end
    end

    -- Nếu đã full hết thì ngừng không xóa wanted
    if not canConsumption then return updateData end
    -- Sau đó loop qua tất cả hàng consumption (WANTED). 
    for itemName, value in pairs(_industry.tradeData[spaceconfig.Industry.TradeType.WANTED]) do
        -- Kiểm tra xem tài nguyên đó có còn đủ số lượng để sản xuất ko (Đủ số lượng để xóa 1 lần không)
        if _industry:GetInStockAmount(spaceconfig.Industry.TradeType.WANTED, itemName) >= value.consumption then
            -- Nếu Đủ thì xóa đúng số lượng và count++ không đủ thì bỏ qua.
            _industry:RemoveItemAmount(spaceconfig.Industry.TradeType.WANTED, itemName, value.consumption, false)
       
            updateData[spaceconfig.Industry.TradeType.WANTED][itemName] = {
                amount = _industry:GetInStockAmount(spaceconfig.Industry.TradeType.WANTED, itemName)
            }
         
            resourceCanConsumptionCount = resourceCanConsumptionCount + 1
        end
    end

    -- Nếu không có tài nguyên nào để có thể sản xuất thì dừng lại luôn
    if resourceCanConsumptionCount == 0 then return updateData end
    -- Tiếp theo loop qua tất cả hàng đang bán (FORSALE)
    for itemName, value in pairs(_industry.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do
        -- Kiểm tra thằng nào đang ko full thì thêm số lượng cho nó bằng production*count 
        if not _industry:IsStorageFull(spaceconfig.Industry.TradeType.FORSALE, itemName) then
            _industry:AddItemAmount(spaceconfig.Industry.TradeType.FORSALE, itemName, value.production*resourceCanConsumptionCount, false)

            updateData[spaceconfig.Industry.TradeType.FORSALE][itemName] = {
                amount = _industry:GetInStockAmount(spaceconfig.Industry.TradeType.FORSALE, itemName)
            }
        end
    end

    return updateData
end

local function updateIndustry()
    local industries = Industries:GetIndustries()

    local update_industries_data = {}
    ---@param value Industry
    for key, value in pairs(industries) do
        update_industries_data[value.name] = {}

        if value.tier == spaceconfig.Industry.Tier.PRIMARY then
            update_industries_data[value.name][spaceconfig.Industry.TradeType.FORSALE] = updatePrimaryIndustry(value)
        elseif value.tier == spaceconfig.Industry.Tier.SECONDARY then
            update_industries_data[value.name] = updateSecondaryIndustry(value)
        elseif value.tier == spaceconfig.Industry.Tier.BUSINESS then
            update_industries_data[value.name][spaceconfig.Industry.TradeType.WANTED] = updateBusinessIndustry(value)
        end
    end

    TriggerClientEvent('gs_trucker:client:updateIndustriesData', -1, update_industries_data)
end

-- Every 1 hour update industry production and cosumption

CreateThread(function ()
    while true do
        Wait(spaceconfig.Industry.UpdateTime * 1000)
        updateIndustry()
    end
end)

CreateThread(function()
    -- Adiciona uma pequena espera inicial para garantir que todos os scripts carregaram
    Wait(5000) 

    while true do
        -- Tempo de espera de 1 minuto (60000 milissegundos).
        -- Para produção, altere para 3600000 (1 hora).
        Wait(60000)

        local QBCore = exports['qb-core']:GetCoreObject()

        if QBCore and QBCore.Functions then
            local companiesToPay = MySQL.query.await('SELECT id, balance, owner_identifier FROM gs_trucker_companies WHERE salary_payment_enabled = 1', {})

            if companiesToPay and #companiesToPay > 0 then
                for i, company in ipairs(companiesToPay) do
                    local employees = MySQL.query.await("SELECT identifier, name, salary FROM gs_trucker_employees WHERE company_id = ? AND is_npc = 0 AND role <> 'owner'", { company.id })
                    
                    if employees and #employees > 0 then
                        local totalSalaryCost = 0
                        for j, emp in ipairs(employees) do
                            totalSalaryCost = totalSalaryCost + emp.salary
                        end

                        local ownerPlayer = QBCore.Functions.GetPlayerByCitizenId(company.owner_identifier)

                        if company.balance >= totalSalaryCost then
                            MySQL.update.await('UPDATE gs_trucker_companies SET balance = balance - ? WHERE id = ?', { totalSalaryCost, company.id })
                            MySQL.insert.await('INSERT INTO gs_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company.id, 'salaries', -totalSalaryCost, 'Pagamento de salários a ' .. #employees .. ' funcionários' })

                            if ownerPlayer then
                                TriggerClientEvent('QBCore:Notify', ownerPlayer.PlayerData.source, 'O pagamento automático de salários foi efetuado a ' .. #employees .. ' funcionários. Custo: $' .. totalSalaryCost, 'success', 10000)
                            end

                            for j, emp in ipairs(employees) do
                                local player = QBCore.Functions.GetPlayerByCitizenId(emp.identifier)
                                if player then
                                    player.Functions.AddItem('money', emp.salary)
                                    TriggerClientEvent('QBCore:Notify', player.PlayerData.source, 'Você recebeu o seu salário de $' .. emp.salary .. ' em dinheiro da sua empresa.', 'success', 8000)
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