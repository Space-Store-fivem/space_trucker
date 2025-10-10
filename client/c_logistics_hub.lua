-- space-trucker/client/c_logistics_hub.lua (VERSÃO FINAL COM VERIFICAÇÕES E PRINTS)

local QBCore = exports['qb-core']:GetCoreObject()

-- Funções originais do ficheiro (mantidas para compatibilidade)
RegisterNUICallback('getOrderItemPrice', function(data, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:getOrderItemPrice', function(price) cb(price or 0) end, data)
end)

RegisterNUICallback('requestLogisticsOrders', function(_, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:getLogisticsOrders', function(orders)
        SendNUIMessage({ action = 'setLogisticsOrders', data = orders or {} })
    end)
    cb('ok')
end)

RegisterNUICallback('createLogisticsOrder', function(data, cb)
    QBCore.Functions.TriggerCallback('space_trucker:callback:createLogisticsOrder', function(result)
        if result and result.success then QBCore.Functions.Notify(result.message, 'success')
        elseif result and not result.success then QBCore.Functions.Notify(result.message, 'error') end
        cb(result)
    end, data)
end)

-- [[ FUNÇÃO MODIFICADA PARA INCLUIR TODAS AS VERIFICAÇÕES E PRINTS ]] --
RegisterNUICallback('acceptLogisticsOrder', function(data, cb)
    print('--- [PASSO 1] Callback `acceptLogisticsOrder` recebido da NUI.')
    print(json.encode(data, { indent = true }))

    if currentMission then
        QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error")
        return cb({ success = false, message = "Já em missão" })
    end

    local orderId = data.orderData and data.orderData.id or data.orderId or data.id
    if not orderId then
        QBCore.Functions.Notify("ID da encomenda inválido (Erro C-301).", "error")
        print('--- [ERRO PASSO 1] Não foi possível extrair o ID da encomenda dos dados da NUI.')
        return cb({ success = false, message = "ID inválido" })
    end
    print(('--- [PASSO 2] ID da encomenda extraído com sucesso: %s. A pedir detalhes ao servidor...'):format(orderId))

    QBCore.Functions.TriggerCallback('space_trucker:callback:getLogisticsOrderDetails', function(orderData)
        if not orderData then
            QBCore.Functions.Notify("Não foi possível encontrar esta encomenda. Tente outra.", "error")
            print('--- [ERRO PASSO 2] Servidor não retornou detalhes para o ID da encomenda.')
            return cb({ success = false, message = "Detalhes não encontrados" })
        end
        print('--- [PASSO 3] Detalhes da encomenda recebidos do servidor. A iniciar verificações do veículo...')
        print(json.encode(orderData, { indent = true }))
        
        local playerPed = PlayerPedId()
        if not IsPedInAnyVehicle(playerPed, false) then
            QBCore.Functions.Notify("Você precisa estar dentro de um veículo da sua empresa.", "error")
            return cb({ success = false, message = "Entre em um veículo" })
        end

        local truckCab = GetVehiclePedIsIn(playerPed, false)
        local vehiclePlate = GetVehicleNumberPlateText(truckCab)
        print(('--- [PASSO 4] A verificar se o veículo com placa [%s] pertence à frota...'):format(vehiclePlate))

        QBCore.Functions.TriggerCallback('space_trucker:callback:isVehicleInCompanyFleet', function(isCompanyVehicle)
            if not isCompanyVehicle then
                QBCore.Functions.Notify("Este veículo não pertence à sua empresa.", "error")
                print('--- [ERRO PASSO 4] Verificação de frota falhou.')
                return cb({ success = false, message = "Veículo não pertence à frota" })
            end
            print('--- [PASSO 5] Veículo pertence à frota. A verificar compatibilidade...')

            local vehicleToCheck = truckCab
            if IsVehicleAttachedToTrailer(truckCab) then
                local success, trailer = GetVehicleTrailerVehicle(truckCab)
                if success and DoesEntityExist(trailer) then vehicleToCheck = trailer end
            end

            local vehicleModelHash = GetEntityModel(vehicleToCheck)
            local vehicleConfig
            for spawnName, vConfig in pairs(config.VehicleTransport) do
                if GetHashKey(tostring(spawnName)) == vehicleModelHash or (tonumber(spawnName) and tonumber(spawnName) == vehicleModelHash) then
                    vehicleConfig = vConfig
                    break
                end
            end

            if not vehicleConfig then
                QBCore.Functions.Notify("O veículo que você está usando não é um veículo de carga registrado.", "error")
                return cb({ success = false, message = "Veículo não registrado" })
            end

            local itemInfo = config.IndustryItems[orderData.item_name]
            if not itemInfo then
                QBCore.Functions.Notify("Erro de configuração: Item da missão não encontrado.", "error")
                return cb({ success = false, message = "Item não encontrado na config" })
            end

            local isCrateMission = itemInfo.transType == config.ItemTransportType.CRATE or itemInfo.transType == config.ItemTransportType.STRONGBOX
            if not vehicleConfig.transType or not vehicleConfig.transType[itemInfo.transType] then
                QBCore.Functions.Notify(("Seu %s não é compatível para transportar este tipo de carga."):format(vehicleConfig.label), "error")
                return cb({ success = false, message = "Carga incompatível" })
            end

            if isCrateMission and vehicleConfig.capacity < orderData.quantity then
                QBCore.Functions.Notify(('Capacidade insuficiente. A encomenda requer espaço para %d caixas, mas seu %s só tem %d.'):format(orderData.quantity, vehicleConfig.label, vehicleConfig.capacity), "error")
                return cb({ success = false, message = "Capacidade insuficiente" })
            end
            print('--- [PASSO 6] Todas as verificações passaram. A enviar pedido final ao servidor...')

            -- A sua versão original do script espera receber 'data.orderData' no servidor.
            -- Por isso, reconstruímos o objeto 'data' com os detalhes completos que obtivemos.
            local finalData = { orderData = orderData }

            QBCore.Functions.TriggerCallback('space_trucker:callback:acceptLogisticsOrder', function(result)
                print('--- [PASSO 7] Resposta final do servidor recebida.')
                print(json.encode(result, { indent = true }))
                if result and result.success then
                    TriggerEvent('space_trucker:client:startLogisticsMission', result.orderData)
                    TriggerEvent('space_trucker:client:closeCompanyPanel')
                    TriggerEvent('space_trucker:client:toggleTablet', false)
                else
                    QBCore.Functions.Notify(result.message or "Esta encomenda já não está disponível.", 'error')
                end
                cb(result)
            end, finalData)
        end, vehiclePlate)
    end, orderId)
end)