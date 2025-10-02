-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_missions.lua (VERSÃO REVISADA E VALIDADA)

local QBCore = exports['qb-core']:GetCoreObject()
local AvailableMissions = {}
local MISSION_GENERATION_INTERVAL = 5 * 60 * 1000 -- 5 minutos

local function generateMissions()
    print('[space-trucker | s_missions] A gerar missões de transporte com base no estoque real...')
    AvailableMissions = {}
    
    -- 1. Obter todas as possíveis empresas de destino (tier "BUSINESS")
    local allIndustries = Industries:GetIndustries()
    local destinationBusinesses = {}
    for name, industry in pairs(allIndustries) do
        if industry.tier == spaceconfig.Industry.Tier.BUSINESS then
            table.insert(destinationBusinesses, industry)
        end
    end

    if #destinationBusinesses == 0 then
        print('[space-trucker | s_missions] AVISO: Nenhuma empresa de destino (Business) encontrada. Missões não podem ser geradas.')
        return
    end

    -- 2. Obter TODOS os itens de TODAS as indústrias que têm estoque maior que zero
    local availableStock = MySQL.query.await('SELECT industry_name, item_name, stock FROM space_trucker_industry_stock WHERE stock > 4', {}) -- Pega apenas se tiver um estoque mínimo (ex: 5)
    if not availableStock or #availableStock == 0 then
        print('[space-trucker | s_missions] AVISO: Nenhum estoque encontrado em nenhuma indústria. Nenhuma missão foi gerada.')
        return
    end

    local missionIdCounter = 1
    -- 3. Iterar sobre cada item em estoque para criar uma missão
    for _, stockItem in ipairs(availableStock) do
        local sourceIndustryName = stockItem.industry_name
        local sourceIndustryDef = Industries:GetIndustry(sourceIndustryName)

        -- 4. Validar se a indústria de origem é um produtor (Primária ou Secundária) e se o item é de venda
        if sourceIndustryDef and (sourceIndustryDef.tier == spaceconfig.Industry.Tier.PRIMARY or sourceIndustryDef.tier == spaceconfig.Industry.Tier.SECONDARY) and
           (sourceIndustryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE] and sourceIndustryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE][stockItem.item_name]) then

            local destination = destinationBusinesses[math.random(#destinationBusinesses)]
            local itemToTransport = stockItem.item_name
            local itemInfo = spaceconfig.IndustryItems[itemToTransport]
            
            -- Lógica para definir o requisito de veículo (mantida como antes)
            local vehicleRequirement = "Veículo de Carga Padrão"
            if itemInfo and itemInfo.transType then
                local compatibleVehicles = {}
                for vehicleName, vehicleData in pairs(spaceconfig.VehicleTransport) do
                    if vehicleData.transType and vehicleData.transType[itemInfo.transType] then
                        table.insert(compatibleVehicles, vehicleData.label)
                        if #compatibleVehicles >= 2 then break end
                    end
                end
                if #compatibleVehicles > 0 then
                    vehicleRequirement = table.concat(compatibleVehicles, ' / ')
                end
            end
            
            -- Define a quantidade da missão, limitada pelo estoque disponível
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

RegisterNetEvent('space_trucker:server:missionCompleted', function(missionData)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    -- Validação robusta dos dados da missão
    if not player or not missionData or type(missionData) ~= 'table' or not missionData.sourceIndustry or not missionData.item or not missionData.amount then 
        print('[space-trucker | s_missions] ERRO: Dados de missão inválidos ou incompletos na conclusão.')
        return 
    end

    local _, playerCompanyId = exports['space_trucker']:CheckIfPlayerWorksForCompany(src)

    if playerCompanyId then
        -- [[ CORREÇÃO FINAL APLICADA ]] --

        -- 1. Encontrar qual empresa (seja NPC ou de jogador) é dona da indústria de origem
        local sourceOwnerResult = MySQL.query.await('SELECT company_id FROM space_trucker_company_industries WHERE industry_name = ?', { missionData.sourceIndustry })
        
        if sourceOwnerResult and sourceOwnerResult[1] then
            local sourceCompanyId = sourceOwnerResult[1].company_id
            
            -- 2. Remover o item do estoque da empresa dona da indústria de origem
            MySQL.update.await(
                'UPDATE space_trucker_industry_stock SET stock = GREATEST(0, stock - ?) WHERE company_id = ? AND industry_name = ? AND item_name = ?', 
                { missionData.amount, sourceCompanyId, missionData.sourceIndustry, missionData.item }
            )
            print(('[space-trucker | s_missions] Estoque consumido da indústria de origem (%s) da empresa %d.'):format(missionData.sourceIndustry, sourceCompanyId))

            -- 3. Calcular o valor da venda e adicionar ao saldo da empresa dona
            local industryDef = Industries:GetIndustry(missionData.sourceIndustry)
            local itemPrice = industryDef and industryDef.tradeData[spaceconfig.Industry.TradeType.FORSALE][missionData.item].price or 0

            if itemPrice > 0 then
                local totalSale = itemPrice * missionData.amount
                MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { totalSale, sourceCompanyId })
                print(('[space-trucker | s_missions] Empresa %d recebeu $%d pela venda de %d x %s.'):format(sourceCompanyId, totalSale, missionData.amount, missionData.item))
            end
        else
            -- Se a indústria não tiver dono, o dinheiro "some" e o estoque não é alterado (pois não há tabela de estoque para ela)
            print(('[space-trucker | s_missions] AVISO: A indústria de origem (%s) não tem dono. O dinheiro da venda foi para o "sistema".'):format(missionData.sourceIndustry))
        end

        -- 4. Conceder reputação para a empresa do jogador que fez a entrega
        local reputationGained = missionData.reputation or 5
        MySQL.update.await('UPDATE space_trucker_companies SET reputation = reputation + ? WHERE id = ?', { reputationGained, playerCompanyId })
        print('[space-trucker | s_missions] Empresa '..playerCompanyId..' ganhou '..reputationGained..' de reputação.')
        TriggerClientEvent('QBCore:Notify', src, "A sua empresa ganhou +" .. reputationGained .. " de reputação!", "success")
    end
end)

RegisterNetEvent('space_trucker:server:cancelLogisticsOrder', function(orderId)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player or not orderId then return end

    -- Reverte o status da encomenda para 'OPEN' e remove o 'taker'
    local result = MySQL.update.await('UPDATE space_trucker_logistics_orders SET status = ?, taker_identifier = NULL WHERE id = ? AND taker_identifier = ?', { 'OPEN', orderId, player.PlayerData.citizenid })

    if result and result > 0 then
        print(('[space-trucker | Logistics] A encomenda %d foi cancelada e está novamente disponível.'):format(orderId))
    end
end)