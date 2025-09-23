-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_missions.lua

local QBCore = exports['qb-core']:GetCoreObject()
local AvailableMissions = {}
local MISSION_GENERATION_INTERVAL = 5 * 60 * 1000 -- 5 minutos

local function generateMissions()
    print('[s_missions] Gerando novas missões de transporte...')
    local newMissions = {}
    local allIndustries = Industries:GetIndustries()

    local sourceIndustries, destinationBusinesses = {}, {}

    for name, industry in pairs(allIndustries) do
        if industry.tier == spaceconfig.Industry.Tier.PRIMARY or industry.tier == spaceconfig.Industry.Tier.SECONDARY then
            table.insert(sourceIndustries, industry)
        elseif industry.tier == spaceconfig.Industry.Tier.BUSINESS then
            table.insert(destinationBusinesses, industry)
        end
    end

    if #sourceIndustries == 0 then
        print('[s_missions] AVISO: Nenhuma indústria Primária ou Secundária encontrada para servir como origem de missões.')
    end
    if #destinationBusinesses == 0 then
        print('[s_missions] AVISO: Nenhuma indústria de Negócios (Business) encontrada para servir como destino.')
    end

    local missionsToGenerate = 15
    for i = 1, missionsToGenerate do
        if #sourceIndustries > 0 and #destinationBusinesses > 0 then
            local source = sourceIndustries[math.random(#sourceIndustries)]
            local destination = destinationBusinesses[math.random(#destinationBusinesses)]

            local forSaleItems = {}
            if source.tradeData and source.tradeData[spaceconfig.Industry.TradeType.FORSALE] then
                for itemName, _ in pairs(source.tradeData[spaceconfig.Industry.TradeType.FORSALE]) do table.insert(forSaleItems, itemName) end
            end

            if #forSaleItems > 0 then
                local itemToTransport = forSaleItems[math.random(#forSaleItems)]
                local distance = #(source.location - destination.location)

                local mission = {
                    id = 'mission_'..i..'_'..math.random(1000, 9999),
                    sourceIndustry = source.name,
                    sourceLabel = source.label,
                    destinationBusiness = destination.name,
                    destinationLabel = destination.label,
                    item = itemToTransport,
                    itemLabel = Lang:t('item_name_' .. itemToTransport) or itemToTransport,
                    reputation = math.floor(distance / 150) + 5,
                }
                table.insert(newMissions, mission)
                print('[s_missions] Missão gerada:', json.encode(mission))
            end
        end
    end

    AvailableMissions = newMissions
    print('[s_missions] ' .. #AvailableMissions .. ' novas missões geradas.')
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
    if not player then return end

    local _, companyId = exports['gs_trucker']:CheckIfPlayerWorksForCompany(src)

    if companyId then
        local reputationGained = missionData.reputation or 5
        MySQL.update.await('UPDATE gs_trucker_companies SET reputation = reputation + ? WHERE id = ?', { reputationGained, companyId })
        print('[s_missions] Empresa '..companyId..' ganhou '..reputationGained..' de reputação.')
        TriggerClientEvent('QBCore:Notify', src, "A sua empresa ganhou +" .. reputationGained .. " de reputação!", "success")
    end
end)