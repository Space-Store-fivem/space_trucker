local QBCore = exports['qb-core']:GetCoreObject()

-- Este callback irá ler as suas configurações e criar uma lista de todas as cargas
-- e os veículos que as podem transportar.
QBCore.Functions.CreateCallback('space_trucker:callback:getCargoAndVehicleData', function(source, cb)
    local cargoData = {}

    -- 1. Itera sobre todos os itens (cargas) definidos no seu spaceconfig
    for itemName, itemInfo in pairs(spaceconfig.IndustryItems) do
        local compatibleVehicles = {}

        -- 2. Para cada item, procura todos os veículos compatíveis
        for vehicleSpawn, vehicleInfo in pairs(spaceconfig.VehicleTransport) do
            -- 3. Verifica se o tipo de transporte do veículo corresponde ao do item
            if vehicleInfo.transType and itemInfo.transType and vehicleInfo.transType[itemInfo.transType] then
                table.insert(compatibleVehicles, {
                    label = vehicleInfo.label,
                    capacity = vehicleInfo.capacity
                })
            end
        end

        -- Ordena os veículos por capacidade para uma melhor visualização
        table.sort(compatibleVehicles, function(a, b) return a.capacity < b.capacity end)

        -- 4. Adiciona a carga e a sua lista de veículos compatíveis à lista final
        table.insert(cargoData, {
            itemName = itemName,
            itemLabel = Lang:t('item_name_' .. itemName) or itemName,
            transType = itemInfo.transType,
            compatibleVehicles = compatibleVehicles
        })
    end

    -- 5. Envia a lista completa para a interface
    cb(cargoData)
end)