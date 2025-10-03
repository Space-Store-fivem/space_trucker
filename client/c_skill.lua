local truckerData = {
    totalProfit = 0,
    totalPackage = 0,
    totalDistance = 0,
    -- Campos de XP e Nível removidos da lógica principal
    exp = 0,
    needExp = 0,
    level = 0
}

CreateThread(function()
    local result = RPC.execute('space_trucker:server:getSkill')
    if result then
        truckerData = result
    end
end)

function GetTruckerSkill()
    return truckerData
end

function UpdateSkill(key, value)
    if not truckerData[key] then truckerData[key] = 0 end

    -- Mantemos a atualização dos valores base (lucro, pacotes, distância)
    if key == spaceconfig.SkillTypeField.currentLevel then
        truckerData[key] = value
    else
        truckerData[key] = truckerData[key] + value
    end

    -- ==================================================================
    -- ========= ✨ LÓGICA DE XP E NÍVEL REMOVIDA DAQUI ✨ =========
    -- ==================================================================
    -- A lógica que calculava o XP com base no lucro, pacotes e distância foi removida.
    -- A lógica de "level up" também foi removida.
    -- O script agora apenas acumula as estatísticas diretas.

    -- Notifica a NUI com os dados atualizados (sem XP)
    SendNUIMessage({ action = "setTruckerStats", data = truckerData })
    -- Salva os dados no servidor
    TriggerServerEvent('space_trucker:server:SaveSkill', truckerData)
end
