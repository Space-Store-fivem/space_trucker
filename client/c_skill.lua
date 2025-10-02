
local playerTruckerSkill = {
    citizenId = 'not_set',
    exp = 0,
    level = 1,
    totalDistance = 0.0,
    totalPackage = 0,
    totalProfit = 0.0
}

RegisterNetEvent('space_trucker:client:setPlayerSkillData', function(data)
    playerTruckerSkill = data
end)

function GetPlayerTruckerSkill()
    return playerTruckerSkill
end
