-- space-store-fivem/space_trucker/space_trucker-mais2/client/c_missions.lua

local QBCore = exports['qb-core']:GetCoreObject()
local currentMission = nil
local missionPoints = { collect = nil, deliver = nil } -- Guarda os objetos dos pontos criados

-- Função para desenhar texto 3D no mundo
local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Função para limpar tudo relacionado à missão atual
local function clearMission()
    print('[c_missions] A limpar a missão atual.')
    if missionPoints.collect then
        missionPoints.collect:remove()
        if missionPoints.collect.blip then RemoveBlip(missionPoints.collect.blip) end
        missionPoints.collect = nil
    end
    if missionPoints.deliver then
        missionPoints.deliver:remove()
        if missionPoints.deliver.blip then RemoveBlip(missionPoints.deliver.blip) end
        missionPoints.deliver = nil
    end
    currentMission = nil
end

-- Callback para a interface pedir a lista de missões
RegisterNUICallback('getMissions', function(_, cb)
    QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissions', function(missions)
        cb(missions or {})
    end)
end)

-- Função que efetivamente inicia a missão no jogo
local function startMission(missionData)
    print('[c_missions] startMission chamada com os dados:', json.encode(missionData))
    local sourceIndustry = Industries:GetIndustry(missionData.sourceIndustry)
    local destinationBusiness = Industries:GetIndustry(missionData.destinationBusiness)

    if not sourceIndustry or not destinationBusiness then
        print('[c_missions] ERRO: Não foi possível encontrar a definição da indústria ou do negócio.')
        QBCore.Functions.Notify("Erro ao iniciar a missão. Indústria não encontrada.", "error")
        return
    end

    currentMission = missionData
    print('[c_missions] A iniciar a missão: Transportar '..currentMission.item..' de '..currentMission.sourceLabel..' para '..currentMission.destinationLabel)

    -- Cria o ponto de COLETA usando o sistema de c_points.lua
    local collectPoint = Point.add({
        coords = sourceIndustry.location,
        distance = 5.0,
        onPedStanding = function(self)
            DrawMarker(2, self.coords.x, self.coords.y, self.coords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 200, 0, 100, false, true, 2, false, nil, nil, false)
            DrawText3D(self.coords.x, self.coords.y, self.coords.z, '[E] - Carregar Carga')
            if IsControlJustReleased(0, 38) then -- Key E
                TriggerEvent('gs_trucker:client:startShipping', self.id)
            end
        end,
    })

    -- Adiciona um blip no mapa também
    local blip = AddBlipForCoord(sourceIndustry.location)
    SetBlipSprite(blip, 477)
    SetBlipColour(blip, 2)
    SetBlipRoute(blip, true) -- Adiciona rota no GPS
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Coletar Carga (' .. missionData.itemLabel .. ')')
    EndTextCommandSetBlipName(blip)

    collectPoint.blip = blip -- Armazena o blip para poder removê-lo depois
    missionPoints.collect = collectPoint

    print('[c_missions] Ponto de coleta interativo e blip criados.')
end

-- Callback para quando o jogador aceita uma missão no tablet
RegisterNUICallback('acceptMission', function(data, cb)
    if currentMission then
        QBCore.Functions.Notify("Você já tem uma missão de transporte ativa.", "error")
        return
    end

    if data and data.id then
        QBCore.Functions.TriggerCallback('gs_trucker:callback:getMissionDetails', function(missionDetails)
            if missionDetails then
                startMission(missionDetails)
                QBCore.Functions.Notify("Missão aceita! Verifique o seu mapa para o ponto de coleta.", "success")

                -- CORREÇÃO APLICADA AQUI: Usando a função exportada para fechar o tablet
                exports['gs_trucker']:SetTabletOpened(false)
                
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

-- Evento disparado quando o jogador CARREGA o caminhão
RegisterNetEvent('gs_trucker:client:startShipping', function(pointId)
    if currentMission and missionPoints.collect then
        print('[c_missions] Carga coletada. A criar ponto de entrega.')
        
        -- Remove o ponto de coleta
        missionPoints.collect:remove()
        RemoveBlip(missionPoints.collect.blip)
        missionPoints.collect = nil

        -- Cria o ponto de ENTREGA
        local destinationBusiness = Industries:GetIndustry(currentMission.destinationBusiness)
        local deliverPoint = Point.add({
            coords = destinationBusiness.location,
            distance = 5.0,
            onPedStanding = function(self)
                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                DrawText3D(self.coords.x, self.coords.y, self.coords.z, '[E] - Entregar Carga')
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('gs_trucker:client:finishShipping', self.id)
                end
            end,
        })
        
        local blip = AddBlipForCoord(destinationBusiness.location)
        SetBlipSprite(blip, 51)
        SetBlipColour(blip, 2)
        SetBlipRoute(blip, true) -- Adiciona rota no GPS
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Entregar Carga (' .. currentMission.itemLabel .. ')')
        EndTextCommandSetBlipName(blip)

        deliverPoint.blip = blip
        missionPoints.deliver = deliverPoint
        
        QBCore.Functions.Notify("Carga coletada! Siga para o ponto de entrega.", "primary")
    end
end)

-- Evento disparado quando o jogador ENTREGA a carga
RegisterNetEvent('gs_trucker:client:finishShipping', function(pointId)
    if currentMission and missionPoints.deliver then
        print('[c_missions] Carga entregue com sucesso! A enviar dados para o servidor.')
        TriggerServerEvent('gs_trucker:server:missionCompleted', currentMission)
        QBCore.Functions.Notify("Entrega concluída! Reputação da empresa aumentada.", "success")
        clearMission()
    end
end)

-- Comando para cancelar a missão
RegisterCommand('cancelarmissao', function()
    if currentMission then
        clearMission()
        QBCore.Functions.Notify("Missão de transporte cancelada.", "error")
    else
        QBCore.Functions.Notify("Você não tem nenhuma missão ativa.", "primary")
    end
end, false)