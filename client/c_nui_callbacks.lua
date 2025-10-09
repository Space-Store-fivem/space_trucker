-- space-trucker/client/c_nui_callbacks.lua (VERSÃO FINAL, SINCRONIZADA COM A UI)
local QBCore = exports['qb-core']:GetCoreObject()

-- Garante que os callbacks da NUI sejam registrados apenas uma vez
local nuiCallbacksRegistered = false
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() and not nuiCallbacksRegistered then
        print('^2[space-trucker]^7 A registar Callbacks da NUI pela primeira e única vez...')

        -- =============================================================================
        -- CALLBACKS GENÉRICOS (NÃO MEXER)
        -- =============================================================================
        local callbacks = {
            'createCompany', 'getCompanyData', 'hirePlayer', 'hireNpc', 'fireEmployee',
            'createProfile', 'getRecruitmentPosts', 'createRecruitmentPost',
            'hireFromPost', 'acceptGig', 'applyForJob', 'getCompanyApplications',
            'hireFromApplication', 'updateEmployee', 'deleteRecruitmentPost',
            'getChatList', 'getChatMessages', 'sendChatMessage', 'deleteChat',
            'transferOwnership', 'updateManagerPermissions', 'toggleAutoSalary',
            'setGarageLocation', 'getPlayerVehicles', 'addVehicleToFleet',
            'returnVehicleToOwner', 'getFleetVehicles', 'storeFleetVehicle', 'getFleetLogs',
            'buyIndustry', 'sellIndustry', 'getIndustryOwnershipData', 'isVehicleInMyCompanyFleet',
            'getCompanyReputation', 'rentCompanyVehicle',
            'deleteProfile'
        }

        for _, callbackName in ipairs(callbacks) do
            RegisterNuiCallback(callbackName, function(data, cb)
                QBCore.Functions.TriggerCallback('space_trucker:callback:' .. callbackName, function(result)
                    cb(result)
                end, data)
            end)
        end

        -- =============================================================================
        -- CALLBACKS ESPECÍFICOS QUE JÁ EXISTIAM
        -- =============================================================================
        RegisterNuiCallback('loadPlayerStats', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getPlayerStats', function(stats)
                cb(stats or {})
            end)
        end)

        RegisterNuiCallback('loadMissionHistory', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getMissionHistory', function(history)
                cb(history or {})
            end)
        end)

        RegisterNuiCallback('space_trucker:callback:updateProfile', function(data, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:updateProfile', function(result)
                cb(result)
            end, data)
        end)

        RegisterNuiCallback('getCargoAndVehicleData', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getCargoAndVehicleData', function(data)
                cb(data or {})
            end)
        end)
        
        -- ==================================================================
        -- ✨ CALLBACKS DA CONCESSIONÁRIA E GARAGEM DE TRAILERS (CORRIGIDOS) ✨
        -- ==================================================================
        
        -- Busca a lista de trailers à venda (Correto)
        RegisterNuiCallback('getTrailersForSale', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getTrailersForSale', function(trailers)
                cb(trailers or {})
            end)
        end)

        -- Busca os trailers que a empresa já possui (Correto)
        RegisterNuiCallback('getCompanyTrailers', function(_, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:getCompanyTrailers', function(trailers)
                cb(trailers or {})
            end)
        end)

        -- CORREÇÃO: Nome do evento alinhado com 'TrailerGarage.tsx'.
        -- Lógica usa 'TriggerCallback' para devolver uma resposta à UI e evitar erro de JSON.
        RegisterNuiCallback('requestTrailerPurchase', function(data, cb)
            QBCore.Functions.TriggerCallback('space_trucker:callback:requestTrailerPurchase', function(response)
                if response and response.success then
                    cb({ success = true })
                else
                    cb({ success = false })
                end
            end, data)
        end)
        
-- ✨ SUBSTITUA A SUA FUNÇÃO 'requestTrailerSpawn' ANTIGA POR ESTA VERSÃO CORRIGIDA ✨
RegisterNuiCallback('requestTrailerSpawn', function(data, cb)
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then
        QBCore.Functions.Notify("Você precisa estar em um caminhão para retirar um trailer.", "error")
        return cb({ success = false })
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        QBCore.Functions.Notify("Você precisa estar no assento do motorista.", "error")
        return cb({ success = false })
    end

    -- CORREÇÃO: Lógica melhorada para lidar com o "trailer fantasma"
    if IsVehicleAttachedToTrailer(vehicle) then
        local currentTrailer = GetVehicleTrailerVehicle(vehicle)
        -- Se o jogo diz que há um trailer, mas a entidade não existe, é um "fantasma".
        if not DoesEntityExist(currentTrailer) then
            QBCore.Functions.Notify("Um trailer fantasma foi detetado e removido. A processar o seu pedido...", "primary", 4000)
            DetachVehicleFromTrailer(vehicle) -- Remove o fantasma
            Wait(500) -- Dá tempo ao jogo para processar a remoção
        else
            -- Se o trailer existe de verdade, avisa o jogador e para a ação.
            QBCore.Functions.Notify("Seu caminhão já possui um trailer engatado.", "error")
            return cb({ success = false })
        end
    end

    -- Se a verificação passou (ou o fantasma foi removido), envia o pedido para o servidor.
    TriggerServerEvent('space_trucker:server:requestTrailerSpawn', data)
    cb({ success = true })
end)
        -- ==================================================================
        -- ========= ✨ CALLBACKS DE PERSONALIZAÇÃO ADICIONADOS ✨ ==========
        -- ==================================================================
        RegisterNuiCallback('space_trucker:save_customization', function(data, cb)
            TriggerServerEvent('space_trucker:server:saveCustomization', data)
            cb('ok')
        end)

        RegisterNuiCallback('space_trucker:get_customization', function(_, cb)
            if PlayerData and PlayerData.profile_data then
                cb({
                    backgroundColor = PlayerData.profile_data.backgroundColor,
                    backgroundImage = PlayerData.profile_data.backgroundImage,
                    blurEnabled = PlayerData.profile_data.blurEnabled
                })
            else
                cb({})
            end
        end)
        
        -- =============================================================================
        -- CALLBACKS DE CONTROLO DA UI
        -- =============================================================================
        RegisterNuiCallback('forceRefreshData', function(_, cb)
            TriggerEvent('space_trucker:client:forceRefresh')
            cb('ok')
        end)

        RegisterNuiCallback('closePanel', function(_, cb)
            SetNUIMode(false)
            cb('ok')
        end)

        RegisterNuiCallback('hideFrame', function(data, cb)
            SetDisplay(false, data.visibleType, data.proceed)
            cb('ok')
        end)

        RegisterNuiCallback('space_trucker:garage_close', function(data, cb)
            SetNuiFocus(false, false)
            cb('ok')
        end)

        nuiCallbacksRegistered = true
        print('^2[space-trucker]^7 Callbacks da NUI registados com sucesso.')
    end
end)