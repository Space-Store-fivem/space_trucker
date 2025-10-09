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
                    price = vehicleData.rentPrice or 0,
                    image = vehicleData.image or nil -- ✨ ADICIONADO: Envia a URL da imagem
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
    if not trailers then return cb({}) end

    -- ✨ ADICIONADO: Procura a imagem para cada trailer que a empresa possui
    for i, trailer in ipairs(trailers) do
        for _, vehicleData in pairs(config.VehicleTransport) do
            if vehicleData.name:lower() == trailer.model:lower() then
                trailers[i].image = vehicleData.image
                break
            end
        end
    end

    cb(trailers)
end)

-- Callback para processar a COMPRA de um trailer
CreateCallback('space_trucker:callback:requestTrailerPurchase', function(source, cb, data)
    local src = source
    local trailerKey = data.trailerKey
    local user = QBCore.Functions.GetPlayer(src)
    if not user then return cb({ success = false }) end

    local isEmployed, companyId = CheckIfPlayerWorksForCompany(src)
    if not isEmployed then
        TriggerClientEvent('QBCore:Notify', src, "Você não está empregado.", "error")
        return cb({ success = false })
    end

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
    
    local plate = "TR" .. math.random(100, 999) .. string.sub(tostring(companyId), 1, 2)
    local result = MySQL.insert.await('INSERT INTO space_trucker_trailers (company_id, model, plate, status) VALUES (?, ?, ?, ?)', { companyId, trailerInfo.name, plate, 'Na Garagem' })

    if result and result > 0 then
        TriggerClientEvent('QBCore:Notify', src, ("Trailer %s comprado por $%s!"):format(trailerInfo.label, price), "success")
        cb({ success = true })
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
    
    -- ✨ CORREÇÃO CRÍTICA APLICADA AQUI ✨
    -- A função 'update.await' retorna um NÚMERO, não uma tabela.
    -- A verificação foi alterada de 'result.affectedRows > 0' para 'result > 0'
    -- para evitar o erro do servidor.
    local result = MySQL.update.await('UPDATE space_trucker_trailers SET status = ?, last_driver = ? WHERE id = ?', { 'Em uso por ' .. playerName, playerName, trailerId })

    if result and result > 0 then
        -- Se a base de dados foi atualizada, envia o evento para o cliente criar o trailer.
        TriggerClientEvent('space_trucker:client:spawnAndAttachTrailer', src, trailer[1])
    else
        TriggerClientEvent('QBCore:Notify', src, "Ocorreu um erro ao tentar retirar o trailer.", "error")
    end
end)


-- ADICIONE ESTE NOVO EVENTO NO FINAL DO FICHEIRO 'server/s_trailer_garage.lua'

RegisterNetEvent('space_trucker:server:storeNearbyTrailer', function(trailerPlate)
    local src = source
    if not trailerPlate then return end

    local isEmployed, companyId = CheckIfPlayerWorksForCompany(src)
    if not isEmployed then return end

    -- Verifica se o trailer com esta matrícula pertence à empresa e está em uso
    local trailer = MySQL.query.await('SELECT id FROM space_trucker_trailers WHERE plate = ? AND company_id = ? AND status LIKE "Em uso%"', { trailerPlate, companyId })

    if trailer and trailer[1] then
        -- Se o trailer for válido, atualiza o status e apaga-o do mundo
        local updated = MySQL.update.await('UPDATE space_trucker_trailers SET status = ? WHERE id = ?', { 'Na Garagem', trailer[1].id })
        
        if updated > 0 then
            TriggerClientEvent('space_trucker:client:deleteVehicleByPlate', -1, trailerPlate) -- Evento global para apagar o veículo
            TriggerClientEvent('QBCore:Notify', src, ('O trailer %s foi guardado na garagem.'):format(trailerPlate), 'success')
        end
    end
end)