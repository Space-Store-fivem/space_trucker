-- space-store-fivem/space_trucker/space_trucker-mais2/server/s_company_gps.lua

local QBCore = exports['qb-core']:GetCoreObject()
local CompanyMemberData = {} -- Tabela para armazenar dados por companyId

-- Thread para limpar dados de jogadores que deslogaram
CreateThread(function()
    while true do
        Wait(30000) -- A cada 30 segundos
        for companyId, members in pairs(CompanyMemberData) do
            for src, _ in pairs(members) do
                if not GetPlayerEndpoint(src) then
                    print(('[gs-trucker | GPS]: Jogador %s desconectado. Removendo dados de GPS.'):format(src))
                    CompanyMemberData[companyId][src] = nil
                    TriggerClientEvent('gs_trucker:client:updateCompanyGPS', -1, CompanyMemberData[companyId])
                end
            end
        end
    end
end)

RegisterNetEvent('gs_trucker:server:updatePlayerGPS', function(data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    local _, companyId = exports['gs_trucker']:CheckIfPlayerWorksForCompany(src)
    if not companyId then return end

    if not CompanyMemberData[companyId] then
        CompanyMemberData[companyId] = {}
    end

    CompanyMemberData[companyId][src] = {
        name = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
        coords = data.coords,
        vehicle = data.vehicle,
        mission = data.mission,
    }

    -- Envia os dados atualizados para todos os membros da mesma empresa
    TriggerClientEvent('gs_trucker:client:updateCompanyGPS', -1, CompanyMemberData[companyId])
end)

-- Evento para quando um jogador sai da empresa ou é demitido
RegisterNetEvent('gs_trucker:server:playerLeftCompany', function(companyId, targetSrc)
    local src = targetSrc or source
    if CompanyMemberData[companyId] and CompanyMemberData[companyId][src] then
        CompanyMemberData[companyId][src] = nil
        print(('[gs-trucker | GPS]: Jogador %s saiu da empresa %s. Removendo dados.'):format(src, companyId))
        TriggerClientEvent('gs_trucker:client:updateCompanyGPS', -1, CompanyMemberData[companyId])
    end
end)