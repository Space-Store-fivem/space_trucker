-- space-trucker/client/c_nui_callbacks.lua (VERSÃO FINAL, COMPLETA E CORRIGIDA)
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
            'deleteProfile' -- << ADICIONADO AQUI
            -- 'updateProfile' e outros callbacks específicos são tratados abaixo
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