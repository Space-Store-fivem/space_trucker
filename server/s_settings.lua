-- space_trucker/server/s_settings.lua

-- [[ CORREÇÃO: Obtém o recurso 'space_trucker' para aceder às funções exportadas ]]
local GS = exports.space_trucker

-- =============================================================================
-- CALLBACKS DE CONFIGURAÇÕES
-- =============================================================================

CreateCallback('space_trucker:callback:updateCompanySettings', function(source, cb, data)
    -- [[ CORREÇÃO: Usa a função exportada ]]
    local ownerIdentifier = GS:GetPlayerUniqueId(source)
    if not ownerIdentifier then return cb({ success = false, message = "Jogador não encontrado."}) end
    
    local newName = data.name
    local newLogo = data.logo

    if not newName or newName == '' then return cb({ success = false, message = "O nome da empresa não pode estar vazio."}) end

    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa."}) end
    local companyId = company[1].id

    local nameCheck = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE name = ? AND id != ?', { newName, companyId })
    if nameCheck and nameCheck[1] then return cb({ success = false, message = "Este nome de empresa já está em uso."}) end

    MySQL.update.await('UPDATE space_trucker_companies SET name = ?, logo_url = ? WHERE id = ?', { newName, newLogo, companyId })
    
    -- [[ CORREÇÃO: Usa a função exportada ]]
    local updatedData = GS:GetFullCompanyData(companyId)
    cb({ success = true, updatedData = updatedData })
end)

CreateCallback('space_trucker:callback:sellCompany', function(source, cb)
    -- [[ CORREÇÃO: Usa a função exportada ]]
    local Player = GS:GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado."}) end

    local ownerIdentifier = Player.PlayerData.citizenid
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não é o dono de uma empresa para vender."})
    end

    local companyId = company[1].id
    
    if not config or not config.Company or not config.Company.SellReturnValue then
        print("^1[space_trucker] ERRO: A configuração 'config.Company.SellReturnValue' não foi encontrada! Verifique o seu ficheiro config.lua.^7")
        return cb({ success = false, message = "Erro de configuração no servidor."})
    end

    local sellValue = config.Company.SellReturnValue
    print(('[space_trucker] A tentar vender a empresa #%s. Valor de Venda Fixo a ser pago: %s'):format(companyId, sellValue))

    -- [[ CORREÇÃO: Usar MySQL.update.await para a operação DELETE ]]
    local result = MySQL.update.await('DELETE FROM space_trucker_companies WHERE id = ?', { companyId })

    if result and result > 0 then
        Player.Functions.AddMoney('cash', sellValue, 'venda-empresa-space-trucker')
        cb({ success = true, message = ("Empresa vendida com sucesso! Você recebeu $%s em dinheiro."):format(sellValue) })
    else
        cb({ success = false, message = "Ocorreu um erro ao tentar vender a empresa."})
    end
end)
