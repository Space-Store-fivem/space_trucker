-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_missions.lua

local QBCore = exports['qb-core']:GetCoreObject()
local currentMission = nil -- Guarda os dados da missão ativa
local missionPoints = { collect = nil, deliver = nil } -- Guarda os IDs dos pontos no mapa

-- Função para limpar tudo relacionado à missão atual
local function clearMission()
    print('[c_missions] A limpar a missão atual.')
    if missionPoints.collect then
        exports['gs_trucker']:RemoveMissionPoint(missionPoints.collect)
    end
    if missionPoints.deliver then
        exports['gs_trucker']:RemoveMissionPoint(missionPoints.deliver)
    end
    currentMission = nil
    missionPoints = { collect = nil, deliver = nil }
end

-- Callback para a interface pedir a lista de missões
RegisterNUICallback('getMissions', function(_, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissions', function(missions)
        cb(missions or {})
    end)
end)

-- Função que efetivamente inicia a missão no jogo
local function startMission(missionData)
    local sourceIndustry = Industries:GetIndustry(missionData.sourceIndustry)
    local destinationBusiness = Industries:GetIndustry(missionData.destinationBusiness)

    if not sourceIndustry or not destinationBusiness then
        print('[c_missions] ERRO: Não foi possível encontrar a definição da indústria ou do negócio.')
        QBCore.Functions.Notify("Erro ao iniciar a missão. Indústria não encontrada.", "error")
        return
    end

    currentMission = missionData
    print('[c_missions] A iniciar a missão: Transportar '..currentMission.item..' de '..currentMission.sourceLabel..' para '..currentMission.destinationLabel)

    -- Cria o ponto de COLETA
    local collectPointId = 'mission_collect_' .. missionData.id
    missionPoints.collect = collectPointId
    
    exports['gs_trucker']:CreateMissionPoint({
        id = collectPointId,
        location = sourceIndustry.location,
        item = missionData.item,
        type = 'load', -- Tipo 'carregar'
        blip = {
            text = 'Coletar Carga (' .. missionData.itemLabel .. ')',
            sprite = 477,
            color = 2,
            scale = 1.2,
        }
    })
end

-- Callback para quando o jogador aceita uma missão no tablet
RegisterNUICallback('acceptMission', function(data, cb)
    if currentMission then
        QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error")
        return
    end

    if data and data.id then
        -- Pede ao servidor os detalhes completos da missão para evitar batota
        QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissionDetails', function(missionDetails)
            if missionDetails then
                startMission(missionDetails)
                QBCore.Functions.Notify("Missão aceite! Verifique o seu mapa para o ponto de coleta.", "success")
                SetNUIFocus(false, false)
                SendNUIMessage({ action = 'setVisible', data = { panel = 'company', visible = false }})
                cb({ success = true })
            else
                QBCore.Functions.Notify("Esta missão já não está mais disponível.", "error")
                cb({ success = false })
            end
        end, data)
    else
        cb({ success = false, message = "ID da missão inválido." })
    end
end)

-- Evento disparado por c_points.lua quando o jogador CARREGA o caminhão
RegisterNetEvent('gs_trucker:client:startShipping', function(pointId)
    if currentMission and pointId == missionPoints.collect then
        print('[c_missions] Carga coletada. A criar ponto de entrega.')
        
        -- Remove o ponto de coleta
        exports['gs_trucker']:RemoveMissionPoint(missionPoints.collect)
        missionPoints.collect = nil

        -- Cria o ponto de ENTREGA
        local destinationBusiness = Industries:GetIndustry(currentMission.destinationBusiness)
        local deliverPointId = 'mission_deliver_' .. currentMission.id
        missionPoints.deliver = deliverPointId
        
        exports['gs_trucker']:CreateMissionPoint({
            id = deliverPointId,
            location = destinationBusiness.location,
            item = currentMission.item,
            type = 'unload', -- Tipo 'descarregar'
            blip = {
                text = 'Entregar Carga (' .. currentMission.itemLabel .. ')',
                sprite = 51,
                color = 2,
                scale = 1.2,
            }
        })
        
        QBCore.Functions.Notify("Carga coletada! Siga para o ponto de entrega.", "primary")
    end
end)

-- Evento disparado por c_points.lua quando o jogador ENTREGA a carga
RegisterNetEvent('gs_trucker:client:finishShipping', function(pointId)
    if currentMission and pointId == missionPoints.deliver then
        print('[c_missions] Carga entregue com sucesso! A enviar dados para o servidor.')
        
        TriggerServerEvent('gs_trucker:server:missionCompleted', currentMission)
        
        QBCore.Functions.Notify("Entrega concluída! Reputação da empresa aumentada.", "success")
        
        -- Limpa tudo
        clearMission()
    end
end)

-- Comando para cancelar a missão (opcional)
RegisterCommand('cancelarmissao', function()
    if currentMission then
        clearMission()
        QBCore.Functions.Notify("Missão de transporte cancelada.", "error")
    else
        QBCore.Functions.Notify("Você não tem nenhuma missão ativa.", "primary")
    end
end, false)