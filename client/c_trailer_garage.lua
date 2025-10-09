-- space_trucker/client/c_trailer_garage.lua
local QBCore = exports['qb-core']:GetCoreObject()

-- Evento que recebe os dados do trailer do servidor para criá-lo no jogo
RegisterNetEvent('space_trucker:client:spawnAndAttachTrailer', function(trailerData)
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then return end
    local truck = GetVehiclePedIsIn(playerPed, false)

    QBCore.Functions.Notify("Preparando seu trailer...", "primary")

    local model = GetHashKey(trailerData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local spawnPos = GetOffsetFromEntityInWorldCoords(truck, 0.0, -8.0, 0.5)
    local trailer = CreateVehicle(model, spawnPos, GetEntityHeading(truck), true, false)
    
    SetVehicleNumberPlateText(trailer, trailerData.plate)
    SetModelAsNoLongerNeeded(model)
    
    AttachVehicleToTrailer(truck, trailer, 15.0)

    QBCore.Functions.Notify("Trailer retirado e engatado com sucesso!", "success")
    
    -- ✨ ADICIONADO: Fecha o tablet (NUI) automaticamente ✨
    SetNuiFocus(false, false)
end)