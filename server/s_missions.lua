-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_missions.lua (VERSÃO REVISADA E VALIDADA)

local QBCore = exports['qb-core']:GetCoreObject()
local AvailableMissions = {}
local MISSION_GENERATION_INTERVAL = 5 * 60 * 1000 -- 5 minutos

local function generateMissions()
    print('[gs-trucker | s_missions] A gerar novas missões de transporte...')
    AvailableMissions = {}
    local allIndustries = Industries:GetIndustries()
    
    local sourceIndustries, destinationBusinesses = {}, {}
    for name, industry in pairs(allIndustries) do
        if industry.tier == spaceconfig.Industry.Tier.PRIMARY or industry.tier == spaceconfig.Industry.Tier.SECONDARY then
            table.insert(sourceIndustries, industry)
        elseif industry.tier == spaceconfig.Industry.Tier.BUSINESS then
            table.insert(destinationBusinesses, industry)
        end
    end

    if #sourceIndustries == 0 or #destinationBusinesses == 0 then
        print('[gs-trucker | s_missions] AVISO: Indústrias de origem ou destino insuficientes para gerar missões.')
        return
    end

    for i = 1, 15 do
        if #sourceIndustries > 0 and #destinationBusinesses > 0 then
            local source = sourceIndustries[math.random(#sourceIndustries)]
            local destination = destinationBusinesses[math.random(#destinationBusinesses)]
            
            local forSaleItems = {}
            if source.tradeData and source.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
                for itemName, _ in pairs(source.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do table.insert(forSaleItems, itemName) end
            end

            if #forSaleItems > 0 then
                local itemToTransport = forSaleItems[math.random(#forSaleItems)]
                local itemInfo = spaceconfig.IndustryItems[itemToTransport]
                
                local vehicleRequirement = "Veículo de Carga Padrão" -- Fallback
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
                
                table.insert(AvailableMissions, {
                    id = 'mission_'..i..'_'..math.random(1000, 9999),
                    sourceIndustry = source.name,
                    sourceLabel = source.label,
                    destinationBusiness = destination.name,
                    destinationLabel = destination.label,
                    item = itemToTransport,
                    itemLabel = Lang:t('item_name_' .. itemToTransport) or itemToTransport,
                    reputation = math.floor(#(source.location - destination.location) / 150) + 5,
                    vehicleRequirement = vehicleRequirement,
                    amount = math.random(5, 15)
                })
            end
        end
    end
    print('[gs-trucker | s_missions] ' .. #AvailableMissions .. ' novas missões geradas.')
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

QBCore.Functions.CreateCallback('gs_trucker:callback:getMissions', function(source, cb)
    cb(AvailableMissions)
end)

QBCore.Functions.CreateCallback('gs_trucker:callback:getMissionDetails', function(source, cb, data)
    local missionId = data.id
    for _, mission in ipairs(AvailableMissions) do
        if mission.id == missionId then
            cb(mission)
            return
        end
    end
    cb(nil)
end)

RegisterNetEvent('gs_trucker:server:missionCompleted', function(missionData)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    -- Adicionada validação para garantir que os dados recebidos do cliente são válidos
    if not player or not missionData or type(missionData) ~= 'table' then return end

    local _, companyId = exports['gs_trucker']:CheckIfPlayerWorksForCompany(src)

    if companyId then
        local reputationGained = missionData.reputation or 5
        MySQL.update.await('UPDATE gs_trucker_companies SET reputation = reputation + ? WHERE id = ?', { reputationGained, companyId })
        print('[gs-trucker | s_missions] Empresa '..companyId..' ganhou '..reputationGained..' de reputação.')
        TriggerClientEvent('QBCore:Notify', src, "A sua empresa ganhou +" .. reputationGained .. " de reputação!", "success")
    end
end)