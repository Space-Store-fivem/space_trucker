-- space_trucker/server/s_trailer_garage.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Funções de verificação (Helpers)
local function GetPlayerUniqueId(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player and Player.PlayerData.citizenid or nil
end

local function CheckIfPlayerWorksForCompany(source)
    local identifier = GetPlayerUniqueId(source)
    if not identifier then return false, nil end
    local result = MySQL.query.await('SELECT company_id FROM space_trucker_employees WHERE identifier = ? AND is_npc = 0', { identifier })
    if result and result[1] then
        return true, result[1].company_id
    end
    return false, nil
end

-- Callback para buscar os trailers à venda na config
CreateCallback('space_trucker:callback:getTrailersForSale', function(source, cb)
    local trailersForSale = {}
    if config and config.VehicleTransport then
        for key, vehicleData in pairs(config.VehicleTransport) do
            if vehicleData.isTrailer then
                table.insert(trailersForSale, {
                    key = key,
                    label = vehicleData.label,
                    model = vehicleData.name,
                    price = vehicleData.rentPrice or 0
                })
            end
        end
    end
    cb(trailersForSale)
end)

-- Callback para buscar os trailers que a empresa já possui
CreateCallback('space_trucker:callback:getCompanyTrailers', function(source, cb)
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(source)
    if not isEmployed then return cb({}) end
    local trailers = MySQL.query.await('SELECT id, model, plate, status FROM space_trucker_trailers WHERE company_id = ?', { companyId })
    cb(trailers or {})
end)

CreateCallback('space_trucker:callback:requestTrailerPurchase', function(source, cb, data)
    local src = source
    local trailerKey = data.trailerKey
    local user = QBCore.Functions.GetPlayer(src)
    if not user then return cb({ success = false }) end

    local isEmployed, companyId = CheckIfPlayerWorksForCompany(src)
    if not isEmployed then return cb({ success = false }) end

    local trailerInfo = config.VehicleTransport[trailerKey]
    if not trailerInfo or not trailerInfo.isTrailer then return cb({ success = false }) end

    local price = trailerInfo.rentPrice or 0
    local company = MySQL.query.await('SELECT balance FROM space_trucker_companies WHERE id = ?', { companyId })

    if not company or not company[1] or company[1].balance < price then
        TriggerClientEvent('QBCore:Notify', src, "Sua empresa não tem saldo suficiente.", "error")
        return cb({ success = false })
    end

    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { price, companyId })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyId, 'trailer_purchase', -price, 'Compra do trailer: ' .. trailerInfo.label })
    
    local plate = "TR" .. math.random(100, 999) .. string.sub(companyId, 1, 2)
    local result = MySQL.insert.await('INSERT INTO space_trucker_trailers (company_id, model, plate, status) VALUES (?, ?, ?, ?)', { companyId, trailerInfo.name, plate, 'Na Garagem' })

    if result then
        TriggerClientEvent('QBCore:Notify', src, ("Trailer %s comprado por $%s!"):format(trailerInfo.label, price), "success")
        cb({ success = true }) -- Avisa a UI que a compra deu certo
    else
        TriggerClientEvent('QBCore:Notify', src, "Erro ao registar o trailer. Reembolsando...", "error")
        MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { price, companyId })
        cb({ success = false })
    end
end)
-- Evento para processar a RETIRADA de um trailer
RegisterNetEvent('space_trucker:server:requestTrailerSpawn', function(data)
    local src = source
    local trailerId = data.trailerId
    local user = QBCore.Functions.GetPlayer(src)
    if not user then return end
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(src)
    if not isEmployed then return end
    local trailer = MySQL.query.await('SELECT * FROM space_trucker_trailers WHERE id = ? AND company_id = ?', { trailerId, companyId })
    if not trailer or not trailer[1] or trailer[1].status ~= 'Na Garagem' then
        TriggerClientEvent('QBCore:Notify', src, "Este trailer não está disponível.", "error")
        return 
    end
    local playerName = user.PlayerData.charinfo.firstname .. ' ' .. user.PlayerData.charinfo.lastname
    MySQL.update.await('UPDATE space_trucker_trailers SET status = ?, last_driver = ? WHERE id = ?', { 'Em uso por ' .. playerName, trailerId })
    TriggerClientEvent('space_trucker:client:spawnAndAttachTrailer', src, trailer[1])
end)