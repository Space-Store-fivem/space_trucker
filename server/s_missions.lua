-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_missions.lua (VERSÃO FINAL COM PAGAMENTO AO MOTORISTA)

local QBCore = exports['qb-core']:GetCoreObject()
local AvailableMissions = {}
local MISSION_GENERATION_INTERVAL = 5 * 60 * 1000 -- 5 minutos

local function generateMissions()
    print('[space-trucker | s_missions] A gerar missões de transporte com base no estoque real...')
    AvailableMissions = {}
    
    local allIndustries = Industries:GetIndustries()
    local destinationBusinesses = {}
    for name, industry in pairs(allIndustries) do
        if industry.tier == config.Industry.Tier.BUSINESS then
            table.insert(destinationBusinesses, industry)
        end
    end

    if #destinationBusinesses == 0 then
        print('[space-trucker | s_missions] AVISO: Nenhuma empresa de destino (Business) encontrada. Missões não podem ser geradas.')
        return
    end

    local availableStock = MySQL.query.await('SELECT industry_name, item_name, stock FROM space_trucker_industry_stock WHERE stock > 4', {})
    if not availableStock or #availableStock == 0 then
        print('[space-trucker | s_missions] AVISO: Nenhum estoque encontrado em nenhuma indústria. Nenhuma missão foi gerada.')
        return
    end

    local missionIdCounter = 1
    for _, stockItem in ipairs(availableStock) do
        local sourceIndustryName = stockItem.industry_name
        local sourceIndustryDef = Industries:GetIndustry(sourceIndustryName)

        if sourceIndustryDef and (sourceIndustryDef.tier == config.Industry.Tier.PRIMARY or sourceIndustryDef.tier == config.Industry.Tier.SECONDARY) and
           (sourceIndustryDef.tradeData[config.Industry.TradeType.FORSALE] and sourceIndustryDef.tradeData[config.Industry.TradeType.FORSALE][stockItem.item_name]) then

            local destination = destinationBusinesses[math.random(#destinationBusinesses)]
            local itemToTransport = stockItem.item_name
            local itemInfo = config.IndustryItems[itemToTransport]
            
            local vehicleRequirement = "Veículo de Carga Padrão"
            if itemInfo and itemInfo.transType then
                local compatibleVehicles = {}
                for vehicleName, vehicleData in pairs(config.VehicleTransport) do
                    if vehicleData.transType and vehicleData.transType[itemInfo.transType] then
                        table.insert(compatibleVehicles, vehicleData.label)
                        if #compatibleVehicles >= 2 then break end
                    end
                end
                if #compatibleVehicles > 0 then
                    vehicleRequirement = table.concat(compatibleVehicles, ' / ')
                end
            end
            
            local maxAmount = math.floor(math.min(stockItem.stock, 15))
            local minAmount = math.floor(math.min(maxAmount, 5))
            
            if minAmount > 0 and maxAmount > 0 and minAmount <= maxAmount then
                local missionAmount = math.random(minAmount, maxAmount)
            
                table.insert(AvailableMissions, {
                    id = 'mission_'..missionIdCounter..'_'..math.random(1000, 9999),
                    sourceIndustry = sourceIndustryName,
                    sourceLabel = sourceIndustryDef.label,
                    destinationBusiness = destination.name,
                    destinationLabel = destination.label,
                    item = itemToTransport,
                    itemLabel = Lang:t('item_name_' .. itemToTransport) or itemToTransport,
                    reputation = math.floor(#(sourceIndustryDef.location - destination.location) / 150) + 5,
                    vehicleRequirement = vehicleRequirement,
                    amount = missionAmount
                })
                missionIdCounter = missionIdCounter + 1
            end
        end
    end
    print('[space-trucker | s_missions] ' .. #AvailableMissions .. ' novas missões geradas com base no estoque.')
end

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    generateMissions()
    CreateThread(function()
        while true do
            Citizen.Wait(MISSION_GENERATION_INTERVAL)
            generateMissions()
        end
    end)
end)

QBCore.Functions.CreateCallback('space_trucker:callback:getMissions', function(source, cb)
    cb(AvailableMissions)
end)

QBCore.Functions.CreateCallback('space_trucker:callback:getMissionDetails', function(source, cb, data)
    local missionId = data.id
    for _, mission in ipairs(AvailableMissions) do
        if mission.id == missionId then
            cb(mission)
            return
        end
    end
    cb(nil)
end)

-- [[ SUBSTITUA ESTA FUNÇÃO INTEIRA NO SEU s_missions.lua ]] --

RegisterNetEvent('space_trucker:server:missionCompleted', function(missionData)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if not player or not missionData or type(missionData) ~= 'table' or not missionData.sourceIndustry or not missionData.destinationBusiness or not missionData.item or not missionData.amount then 
        print('[space-trucker | s_missions] ERRO: Dados de missão de CONTRATO inválidos na conclusão.')
        return 
    end

    local _, playerCompanyId = exports['space_trucker']:CheckIfPlayerWorksForCompany(src)

    if playerCompanyId then
        -- [[ CORREÇÃO APLICADA AQUI ]] --
        -- 1. Calcula o valor total da venda PRIMEIRO, antes de verificar o dono.
        local industryDef = Industries:GetIndustry(missionData.sourceIndustry)
        local itemPrice = industryDef and industryDef.tradeData[config.Industry.TradeType.FORSALE] and industryDef.tradeData[config.Industry.TradeType.FORSALE][missionData.item].price or 0
        local totalSale = 0
        if itemPrice > 0 then
            totalSale = itemPrice * missionData.amount
        end

        -- 2. Agora, verifica quem é o dono e paga o lucro da venda à empresa correspondente.
        local sourceOwnerResult = MySQL.query.await('SELECT company_id FROM space_trucker_company_industries WHERE industry_name = ?', { missionData.sourceIndustry })
        
        if sourceOwnerResult and sourceOwnerResult[1] then
            local sourceCompanyId = sourceOwnerResult[1].company_id
            MySQL.update.await('UPDATE space_trucker_industry_stock SET stock = GREATEST(0, stock - ?) WHERE company_id = ? AND industry_name = ? AND item_name = ?', { missionData.amount, sourceCompanyId, missionData.sourceIndustry, missionData.item })
            
            if totalSale > 0 then
                MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { totalSale, sourceCompanyId })
            end
        else
            -- Se a indústria não tem dono, o lucro vai para o "sistema" (nada a fazer aqui).
            print(('[space-trucker | s_missions] AVISO: A indústria de origem (%s) não tem dono. O dinheiro da venda foi para o "sistema".'):format(missionData.sourceIndustry))
        end

        -- 3. Concede reputação à empresa do motorista.
        local reputationGained = missionData.reputation or 5
        MySQL.update.await('UPDATE space_trucker_companies SET reputation = reputation + ? WHERE id = ?', { reputationGained, playerCompanyId })
        TriggerClientEvent('QBCore:Notify', src, "A sua empresa ganhou +" .. reputationGained .. " de reputação!", "success")

        -- 4. Calcula e paga o frete ao motorista e salva o histórico.
        local sourceIndustryDef = Industries:GetIndustry(missionData.sourceIndustry)
        local destinationBusinessDef = Industries:GetIndustry(missionData.destinationBusiness)
        
        if sourceIndustryDef and destinationBusinessDef then
            local distance = #(sourceIndustryDef.location - destinationBusinessDef.location) / 1000
            local identifier = player.PlayerData.citizenid

            -- O cálculo do pagamento agora funciona porque 'totalSale' tem o valor correto.
            local driverPayment = math.floor(totalSale * 0.15)
            if driverPayment > 0 then
                player.Functions.AddMoney('bank', driverPayment, "Pagamento de frete de contrato")
                TriggerClientEvent('QBCore:Notify', src, ("Você recebeu $%s pelo seu serviço de frete."):format(driverPayment), "success")
            end

            -- Salva as estatísticas com o lucro REAL do jogador.
            MySQL.update.await('INSERT INTO space_trucker_player_stats (identifier, total_profit, total_distance, total_packages) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE total_profit = total_profit + VALUES(total_profit), total_distance = total_distance + VALUES(total_distance), total_packages = total_packages + VALUES(total_packages)', { identifier, driverPayment, distance, missionData.amount })
            MySQL.insert.await('INSERT INTO space_trucker_mission_history (identifier, mission_id, source_industry, destination_business, item, amount, profit, distance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', { identifier, missionData.id or 'CONTRATO', missionData.sourceIndustry, missionData.destinationBusiness, missionData.item, missionData.amount, driverPayment, distance })
        end
    end
end)

-- (O resto do ficheiro, incluindo completeLogisticsOrder, etc., continua igual ao seu original)
RegisterNetEvent('space_trucker:server:completeLogisticsOrder', function(orderData)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if not player or not orderData or type(orderData) ~= 'table' or not orderData.sourceIndustry or not orderData.destinationBusiness or not orderData.item or not orderData.amount then
        print('[space-trucker | s_missions] ERRO: Dados de missão de LOGÍSTICA inválidos na conclusão.')
        return
    end

    local identifier = player.PlayerData.citizenid
    local profit = orderData.reward or 0

    player.Functions.AddMoney('bank', profit)
    TriggerClientEvent('QBCore:Notify', src, ("Você recebeu $%s pela entrega da encomenda!"):format(profit), "success")

    MySQL.update.await('UPDATE space_trucker_logistics_orders SET status = ? WHERE id = ?', { 'COMPLETED', orderData.orderId })

    local sourceIndustryDef = Industries:GetIndustry(orderData.sourceIndustry)
    local destinationBusinessDef = Industries:GetIndustry(orderData.destinationBusiness)

    if sourceIndustryDef and destinationBusinessDef then
        local distance = #(sourceIndustryDef.location - destinationBusinessDef.location) / 1000
        MySQL.update.await('INSERT INTO space_trucker_player_stats (identifier, total_profit, total_distance, total_packages) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE total_profit = total_profit + VALUES(total_profit), total_distance = total_distance + VALUES(total_distance), total_packages = total_packages + VALUES(total_packages)', { identifier, profit, distance, orderData.amount })
        MySQL.insert.await('INSERT INTO space_trucker_mission_history (identifier, mission_id, source_industry, destination_business, item, amount, profit, distance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', { identifier, orderData.orderId or 'LOGISTICA', orderData.sourceIndustry, orderData.destinationBusiness, orderData.item, orderData.amount, profit, distance })
        print(('[space-trucker | s_missions] Encomenda de logística #%s concluída e registada para %s.'):format(orderData.orderId, identifier))
    else
        print(('[space-trucker | s_missions] AVISO: Não foi possível calcular a distância para a encomenda #%s. O histórico não foi salvo.'):format(orderData.orderId))
    end
end)


RegisterNetEvent('space_trucker:server:cancelLogisticsOrder', function(orderId)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not orderId then return end

    local result = MySQL.update.await('UPDATE space_trucker_logistics_orders SET status = ?, taker_identifier = NULL WHERE id = ? AND taker_identifier = ?', { 'OPEN', orderId, player.PlayerData.citizenid })

    if result and result > 0 then
        print(('[space-trucker | Logistics] A encomenda %d foi cancelada e está novamente disponível.'):format(orderId))
    end
end)

QBCore.Functions.CreateCallback('space_trucker:callback:getPlayerStats', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    print('--- [LOG | getPlayerStats] Callback Recebido ---')
    if not player then
        print('--- [LOG | getPlayerStats] ERRO: Jogador não encontrado.')
        cb(nil)
        return
    end
    local identifier = player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT total_profit, total_distance, total_packages FROM space_trucker_player_stats WHERE identifier = ?', { identifier })
    if result and result[1] then
        print(('[--- [LOG | getPlayerStats] Estatísticas encontradas para %s. Enviando dados... ---]'):format(identifier))
        cb({
            totalProfit = result[1].total_profit,
            totalDistance = result[1].total_distance,
            totalPackage = result[1].total_packages,
        })
    else
        print(('[--- [LOG | getPlayerStats] Nenhuma estatística encontrada para %s. Enviando dados zerados... ---]'):format(identifier))
        cb({ totalProfit = 0, totalDistance = 0, totalPackage = 0 })
    end
end)

QBCore.Functions.CreateCallback('space_trucker:callback:getMissionHistory', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    print('--- [LOG | getMissionHistory] Callback Recebido ---')
    if not player then
        print('--- [LOG | getMissionHistory] ERRO: Jogador não encontrado.')
        cb(nil)
        return
    end
    local identifier = player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM space_trucker_mission_history WHERE identifier = ? ORDER BY timestamp DESC LIMIT 10', { identifier })
    if result then
        print(('[--- [LOG | getMissionHistory] %d registos de histórico encontrados para %s. Enviando dados... ---]'):format(#result, identifier))
        cb(result)
    else
        print(('[--- [LOG | getMissionHistory] Nenhum histórico encontrado para %s. Enviando tabela vazia... ---]'):format(identifier))
        cb({})
    end
end)