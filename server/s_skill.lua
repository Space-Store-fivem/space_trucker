-- Variables
---@class PlayerTruckerSkill
---@field citizenId any
---@field totalProfit number
---@field totalPackage number
---@field totalDistance number
---@field exp number
---@field level number

---@type table<number, PlayerTruckerSkill>
local playerTruckerSkills = {}
-- Functions
function AddPlayerTruckerSkillPoint(source, skillData)
    local playerSkillData = playerTruckerSkills[source]

    if not playerSkillData then return end

    if skillData.profit and playerSkillData[spaceconfig.SkillTypeField.totalProfit] ~= nil then
        playerSkillData[spaceconfig.SkillTypeField.totalProfit] = playerSkillData[spaceconfig.SkillTypeField.totalProfit] +
            skillData.profit
    end

    if skillData.package and playerSkillData[spaceconfig.SkillTypeField.totalPackage] ~= nil then
        playerSkillData[spaceconfig.SkillTypeField.totalPackage] = playerSkillData[spaceconfig.SkillTypeField.totalPackage] +
            skillData.package
    end

    if skillData.distance and playerSkillData[spaceconfig.SkillTypeField.totalDistance] ~= nil then
        playerSkillData[spaceconfig.SkillTypeField.totalDistance] = playerSkillData
            [spaceconfig.SkillTypeField.totalDistance] + skillData.distance
    end

    if skillData.exp and playerSkillData[spaceconfig.SkillTypeField.currentExp] ~= nil then
        local updateExp = playerSkillData[spaceconfig.SkillTypeField.currentExp] + skillData.exp
        local updateLevel = 1

        local currentLevel = playerSkillData[spaceconfig.SkillTypeField.currentLevel]
        if currentLevel == 0 then
            currentLevel = 1
            updateLevel = 1
        end

        local nextExp = GetTruckerNextEXP(currentLevel)
        if updateExp >= nextExp then
            local diff = updateExp - nextExp
            updateExp = diff
            updateLevel = currentLevel + 1
        end

        playerSkillData[spaceconfig.SkillTypeField.currentExp] = updateExp
        playerSkillData[spaceconfig.SkillTypeField.currentLevel] = updateLevel
    end

    playerTruckerSkills[source] = playerSkillData
    SavePlayerTruckerSkill(source)

    TriggerClientEvent('gs_trucker:client:setPlayerSkillData', source, playerTruckerSkills[source])
end

function GetPlayerTruckerSkill(source)
    return playerTruckerSkills[source] or {
        citizenId = 'not_set',
        exp = 0,
        level = 1,
        totalDistance = 0.0,
        totalPackage = 0,
        totalProfit = 0.0
    }
end

-- Em gs_trucker/server/s_skill.lua

function CalculatorPlayerTruckerSkill(source, itemName, sellPrice, buyPrice, sellAmount, buyFromCoords, sellToCoords)
    local defaultItemData = spaceconfig.IndustryItems[itemName]

    local skillProfit = math.floor((sellPrice - buyPrice) * sellAmount)
    local skillPackage = spaceconfig.IsPackageMultiplyItemCapacity and (sellAmount * defaultItemData.capacity) or sellAmount
    local skillDistance = math.floor(#(sellToCoords - buyFromCoords))

    local skillExpByProfit = sellAmount > 1 and math.floor(skillProfit / spaceconfig.RateExp.profit) or math.floor(skillProfit / spaceconfig.RateExp.profitByHand)
    local skillExpByPackage = math.floor(skillPackage / spaceconfig.RateExp.package)
    local skillExpByDistance = math.floor(skillDistance / spaceconfig.RateExp.distance)

    -- >>>>> MODIFICAÇÃO AQUI <<<<<
    local worksForCompany, companyId = CheckIfPlayerWorksForCompany(source)
    if worksForCompany then
        -- Se trabalha para uma empresa, o lucro vai para a empresa
        AddCompanyBalance(companyId, skillProfit, ('Entrega de %s por %s'):format(GetItemLabel(itemName), GetPlayerName(source)))
    else
        -- Senão, o lucro vai para o jogador (comportamento original)
        AddPlayerCash(source, skillProfit, ('gs_trucker_sell_%s_item_%s_to_%s'):format(sellAmount, itemName, industryData.name))
    end
    -- >>>>> FIM DA MODIFICAÇÃO <<<<<

    AddPlayerTruckerSkillPoint(source, {
        profit = skillProfit,
        package = skillPackage,
        distance = skillDistance,
        exp = skillExpByProfit + skillExpByPackage + skillExpByDistance,
    })
end

function LoadPlayerTruckerSkill(source)
    local playerCitizenId = GetPlayerUniqueId(source)

    if not playerCitizenId then return print('Not found player unique id to load skill: ', source) end

    local result = MySQL.query.await('SELECT * FROM ' .. spaceconfig.SkillTable .. ' where citizenId = ?',
        { playerCitizenId })
    if result and #result > 0 then
        local data = result[1]
        playerTruckerSkills[source] = {
            citizenId = playerCitizenId,
            exp = data.exp,
            level = data.level,
            totalDistance = data.totalDistance,
            totalPackage = data.totalPackage,
            totalProfit = data.totalProfit
        }
    else
        playerTruckerSkills[source] = {
            citizenId = playerCitizenId,
            exp = 0,
            level = 1,
            totalDistance = 0.0,
            totalPackage = 0,
            totalProfit = 0.0
        }
    end

    TriggerClientEvent('gs_trucker:client:setPlayerSkillData', source, playerTruckerSkills[source])
end

function SavePlayerTruckerSkill(source)
    if not playerTruckerSkills[source] then return end
    local data = playerTruckerSkills[source]

    MySQL.insert(
        'INSERT INTO ' .. spaceconfig.SkillTable ..
        ' (citizenId, exp, level, totalDistance, totalPackage, totalProfit) VALUES (:citizenId, :exp, :level, :totalDistance, :totalPackage, :totalProfit) ON DUPLICATE KEY UPDATE exp = :exp, level = :level, totalDistance = :totalDistance, totalPackage = :totalPackage, totalProfit = :totalProfit',
        {
            citizenId = data.citizenId,
            exp = data.exp,
            level = data.level,
            totalDistance = data.totalDistance,
            totalPackage = data.totalPackage,
            totalProfit = data.totalProfit
        })
end

-- Event & Callback
CreateCallback('gstrucker:callback:getTruckerSkill', function(source, cb)
    local skills = GetPlayerTruckerSkill(source)
    return cb and cb(skills) or skills
end)
