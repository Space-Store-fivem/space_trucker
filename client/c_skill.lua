-- space-store-fivem/space_trucker/space_trucker-teste/client/c_skill.lua (CORRIGIDO)

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

-- Função para obter o nível de habilidade do servidor
function GetSkillLevel(skillName)
    local skillLevel = QBCore.Functions.TriggerRpc('space_trucker:rpc:getSkillLevel', skillName)
    return skillLevel
end

-- Função para verificar se o jogador tem o nível de habilidade necessário
function HasSkill(skillName, requiredLevel)
    local currentLevel = GetSkillLevel(skillName)
    return currentLevel >= requiredLevel
end

-- Exemplo de como usar (não é necessário alterar, apenas para referência)
-- RegisterCommand('checkskill', function()
--     local hasRequiredSkill = HasSkill('TRUCKING', 5)
--     if hasRequiredSkill then
--         print('Você tem o nível de habilidade necessário!')
--     else
--         print('Você NÃO tem o nível de habilidade necessário.')
--     end
-- end, false)