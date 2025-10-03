-- space_trucker/server/s_company.lua
-- =============================================================================
-- REGISTO DE CALLBACKS DAS INDÚSTRIAS (A SER CHAMADO ATRASADAMENTE)
-- =============================================================================

function RegisterIndustryCallbacks()
    print('[space_trucker] A registar callbacks das indústrias...')
    
RegisterNetEvent('space_trucker:server:requestOwnershipData', function()
    local src = source
    local ownerships = MySQL.query.await('SELECT comp.name, ind.industry_name FROM space_trucker_company_industries ind LEFT JOIN space_trucker_companies comp ON ind.company_id = comp.id', {})
    local data = {}
    if ownerships and #ownerships > 0 then
        for _, owner in ipairs(ownerships) do
            if owner.name then
                data[owner.industry_name] = owner.name
            end
        end
    end
    -- Enviamos os dados para o cliente específico que os pediu
    TriggerClientEvent('space_trucker:client:receiveOwnershipData', src, data)
end)

    CreateCallback('space_trucker:callback:buyIndustry', function(source, cb, data)
        local ownerIdentifier = GetPlayerUniqueId(source)
        local industryName = data.industryName
        local company = MySQL.query.await('SELECT id, name, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
        if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
        
        local industry = Industries:GetIndustry(industryName)
        if not industry then return cb({ success = false, message = "Erro: A indústria não foi encontrada no sistema." }) end
        
        local industryPrice = industry:GetPurchasePrice()
        if not industryPrice then return cb({ success = false, message = "Esta indústria não está à venda." }) end
        
        local isOwned = MySQL.query.await('SELECT id FROM space_trucker_company_industries WHERE industry_name = ?', { industryName })
        if isOwned and isOwned[1] then return cb({ success = false, message = "Esta indústria já foi comprada." }) end

        if company[1].balance < industryPrice then return cb({ success = false, message = "A sua empresa não tem saldo suficiente." }) end

        MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { industryPrice, company[1].id })
        -- CORREÇÃO APLICADA AQUI: Usado industry.label em vez de industry:GetLabel()
        MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_purchase', -industryPrice, 'Compra da indústria: ' .. industry.label })
        MySQL.insert.await('INSERT INTO space_trucker_company_industries (company_id, industry_name, purchase_price) VALUES (?, ?, ?)', { company[1].id, industryName, industryPrice })
        Industries:SetIndustryStatus(industryName, 2)
        cb({ success = true, message = "Indústria comprada com sucesso!", updatedData = GetFullCompanyData(company[1].id) })
    end)

    CreateCallback('space_trucker:callback:sellIndustry', function(source, cb, data)
        local ownerIdentifier = GetPlayerUniqueId(source)
        local industryName = data.industryName
        local company = MySQL.query.await('SELECT id, name FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
        if not company or not company[1] then return cb({ success = false, message = "Você não é o dono de uma empresa." }) end
        
        local ownership = MySQL.query.await('SELECT id, purchase_price FROM space_trucker_company_industries WHERE industry_name = ? AND company_id = ?', { industryName, company[1].id })
        if not ownership or not ownership[1] then return cb({ success = false, message = "Você não tem permissão para vender esta indústria." }) end

        local industry = Industries:GetIndustry(industryName)
        if not industry then return cb({ success = false, message = "Erro: A indústria não foi encontrada no sistema." }) end

        local sellPrice = math.floor(ownership[1].purchase_price * 0.70)
        MySQL.update.await('UPDATE space_trucker_companies SET balance = balance + ? WHERE id = ?', { sellPrice, company[1].id })
        MySQL.update.await('DELETE FROM space_trucker_company_industries WHERE id = ?', { ownership[1].id })
        -- CORREÇÃO APLICADA AQUI: Usado industry.label em vez de industry:GetLabel()
        MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { company[1].id, 'industry_sale', sellPrice, 'Venda da indústria: ' .. industry.label })
        Industries:SetIndustryStatus(industryName, 1)
        cb({ success = true, message = "Indústria vendida por $" .. sellPrice .. "!", updatedData = GetFullCompanyData(company[1].id) })
    end)
    
    print('[space_trucker] Callbacks das indústrias registados com SUCESSO.')
end

-- Disponibilizamos a função para ser chamada por outros scripts
exports('RegisterIndustryCallbacks', RegisterIndustryCallbacks)
-- =============================================================================
-- HELPERS E FUNÇÕES GLOBAIS
-- =============================================================================

local QBCore = exports['qb-core']:GetCoreObject()

-- Helper para obter o objeto do jogador QBCore
local function GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

-- Função para obter o identificador único (citizenid para QBCore)
local function GetPlayerUniqueId(source)
    local Player = GetPlayer(source)
    if Player then
        return Player.PlayerData.citizenid
    end
    return nil
end

-- Função centralizada para obter todos os dados de uma empresa
function GetFullCompanyData(companyId)
    if not companyId then return nil end
    local companyData = MySQL.query.await('SELECT * FROM space_trucker_companies WHERE id = ?', { companyId })
    if not companyData or not companyData[1] then return nil end

    local employees = MySQL.query.await('SELECT * FROM space_trucker_employees WHERE company_id = ?', { companyId })
    local fleet = MySQL.query.await('SELECT * FROM space_trucker_fleet WHERE company_id = ?', { companyId })
    local transactions = MySQL.query.await('SELECT * FROM space_trucker_transactions WHERE company_id = ? ORDER BY timestamp DESC LIMIT 50', { companyId })
    
    return { 
        is_owner = true, -- O valor é ajustado depois, se necessário
        company_data = companyData[1], 
        employees = employees, 
        fleet = fleet, 
        transactions = transactions 
    }
end

-- Função para verificar se um jogador já trabalha para uma empresa
function CheckIfPlayerWorksForCompany(source)
    local identifier = GetPlayerUniqueId(source)
    if not identifier then return false, nil end
    local result = MySQL.query.await('SELECT company_id FROM space_trucker_employees WHERE identifier = ? AND is_npc = 0', { identifier })
    if result and result[1] then
        return true, result[1].company_id
    end
    return false, nil
end

-- Exporta as funções para que outros ficheiros do lado do servidor as possam aceder
exports('GetPlayer', GetPlayer)
exports('GetPlayerUniqueId', GetPlayerUniqueId)
exports('GetFullCompanyData', GetFullCompanyData)

-- =============================================================================
-- CALLBACKS PRINCIPAIS
-- =============================================================================

-- Substitua a função existente em s_company.lua

CreateCallback('space_trucker:callback:getCompanyData', function(source, cb)
    local identifier = GetPlayerUniqueId(source)
    if not identifier then return cb(nil) end

    local profile = MySQL.query.await('SELECT * FROM space_trucker_profiles WHERE identifier = ?', { identifier })
    if not profile or not profile[1] then
        return cb({ has_profile = false })
    end

    local companyId, playerRole, isOwner = nil, nil, false
    
    local ownedCompany = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { identifier })
    if ownedCompany and ownedCompany[1] then
        companyId = ownedCompany[1].id
        isOwner = true
        playerRole = 'owner'
    else
        local employedAt = MySQL.query.await('SELECT company_id, role FROM space_trucker_employees WHERE identifier = ?', { identifier })
        if employedAt and employedAt[1] then
            companyId = employedAt[1].company_id
            playerRole = employedAt[1].role
        end
    end

    local companyData, employees, fleet, transactions = nil, {}, {}, {}

    if companyId then
        local companyResult = MySQL.query.await('SELECT * FROM space_trucker_companies WHERE id = ?', { companyId })
        if companyResult and companyResult[1] then
            companyData = companyResult[1]
            employees = MySQL.query.await('SELECT * FROM space_trucker_employees WHERE company_id = ? AND identifier != ?', { companyId, companyData.owner_identifier })
            fleet = MySQL.query.await('SELECT * FROM space_trucker_fleet WHERE company_id = ?', { companyId })
            transactions = MySQL.query.await('SELECT * FROM space_trucker_transactions WHERE company_id = ? ORDER BY timestamp DESC LIMIT 50', { companyId })
        end
    end
    
    cb({
        has_profile = true,
        profile_data = profile[1],
        company_data = companyData,
        employees = employees or {},
        fleet = fleet or {},
        transactions = transactions or {},
        is_owner = isOwner,
        player_role = playerRole -- AQUI ESTÁ A INFORMAÇÃO CRÍTICA
    })
end)


-- =============================================================================
-- CALLBACKS DE FUNCIONÁRIOS
-- =============================================================================
local HIRE_PLAYER_COST = 5000
local HIRE_NPC_COST = 2500

CreateCallback('space_trucker:callback:hirePlayer', function(source, cb, data)
    local ownerIdentifier = GetPlayerUniqueId(source)
    local targetId = tonumber(data.targetId)
    if not targetId then return cb({ success = false, message = "ID inválido."}) end
    
    local targetPlayer = GetPlayer(targetId)
    if not targetPlayer then return cb({ success = false, message = "Jogador não encontrado."}) end
    local targetIdentifier = targetPlayer.PlayerData.citizenid
    
    local company = MySQL.query.await('SELECT id, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é dono de uma empresa."}) end
    local companyData = company[1]

    if companyData.balance < HIRE_PLAYER_COST then return cb({ success = false, message = "Sua empresa não tem saldo suficiente."}) end

    local worksFor, _ = CheckIfPlayerWorksForCompany(targetId)
    if worksFor then return cb({ success = false, message = "Este jogador já trabalha para uma transportadora."}) end

    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { HIRE_PLAYER_COST, companyData.id })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyData.id, 'hire_cost', -HIRE_PLAYER_COST, 'Contratação de ' .. targetPlayer.PlayerData.charinfo.firstname })
    MySQL.insert.await('INSERT INTO space_trucker_employees (company_id, identifier, name, is_npc, rank) VALUES (?, ?, ?, ?, ?)', { companyData.id, targetIdentifier, targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname, false, 'Motorista' })
    
    local updatedData = GetFullCompanyData(companyData.id)
    cb({ success = true, updatedData = updatedData })
end)

CreateCallback('space_trucker:callback:hireNpc', function(source, cb)
    local ownerIdentifier = GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id, balance FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é dono de uma empresa."}) end
    local companyData = company[1]

    if companyData.balance < HIRE_NPC_COST then return cb({ success = false, message = "Sua empresa não tem saldo suficiente."}) end
    
    local firstNames = {"John", "Carlos", "Mike", "David", "Peter", "Walter"}
    local lastNames = {"Smith", "Johnson", "White", "Goodman", "Jones"}
    local npcName = firstNames[math.random(#firstNames)] .. " " .. lastNames[math.random(#lastNames)]

    MySQL.update.await('UPDATE space_trucker_companies SET balance = balance - ? WHERE id = ?', { HIRE_NPC_COST, companyData.id })
    MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyData.id, 'hire_cost', -HIRE_NPC_COST, 'Contratação de NPC: ' .. npcName })
    MySQL.insert.await('INSERT INTO space_trucker_employees (company_id, identifier, name, is_npc, rank) VALUES (?, ?, ?, ?, ?)', { companyData.id, 'npc_'..math.random(10000,99999), npcName, true, 'Motorista' })
    
    local updatedData = GetFullCompanyData(companyData.id)
    cb({ success = true, updatedData = updatedData })
end)

CreateCallback('space_trucker:callback:fireEmployee', function(source, cb, data)
    local ownerIdentifier = GetPlayerUniqueId(source)
    local employeeId = data.employeeId
    
    local employee = MySQL.query.await('SELECT company_id FROM space_trucker_employees WHERE id = ?', { employeeId })
    if not employee or not employee[1] then return cb({ success = false, message = "Funcionário não encontrado." }) end
    
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ? AND id = ?', { ownerIdentifier, employee[1].company_id })
    if not company or not company[1] then return cb({ success = false, message = "Você não tem permissão para demitir este funcionário." }) end

    MySQL.update.await('DELETE FROM space_trucker_employees WHERE id = ?', { employeeId })
    
    local updatedData = GetFullCompanyData(company[1].id)
    cb({ success = true, updatedData = updatedData })
end)

-- =============================================================================
-- CALLBACK DE PERFIL DE TRABALHADOR
-- =============================================================================

CreateCallback('space_trucker:callback:createProfile', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado."}) end

    local identifier = Player.PlayerData.citizenid
    local profileName = data.name
    local profilePicture = data.picture or 'https://i.imgur.com/default-avatar.png' -- Imagem padrão

    local existing = MySQL.query.await('SELECT id FROM space_trucker_profiles WHERE identifier = ?', { identifier })
    if existing and existing[1] then
        return cb({ success = false, message = "Você já tem um perfil."})
    end

    local result = MySQL.insert.await('INSERT INTO space_trucker_profiles (identifier, profile_name, profile_picture) VALUES (?, ?, ?)', {
        identifier, profileName, profilePicture
    })

    cb({ success = (result and result > 0) })
end)


-- =============================================================================
-- CALLBACKS DA AGÊNCIA DE RECRUTAMENTO
-- =============================================================================

CreateCallback('space_trucker:callback:getRecruitmentPosts', function(source, cb)
    -- Esta query busca todos os posts e junta informações importantes:
    -- 1. O nome do perfil do autor (da tabela de perfis)
    -- 2. O nome e o logo da empresa (se o post for de uma empresa)
    local query = [[
        SELECT
            p.*,
            prof.profile_name as author_name,
            comp.name as company_name,
            comp.logo_url as company_logo
        FROM space_trucker_posts p
        LEFT JOIN space_trucker_profiles prof ON p.author_identifier = prof.identifier
        LEFT JOIN space_trucker_companies comp ON p.company_id = comp.id
        WHERE p.status = 'OPEN'
        ORDER BY p.timestamp DESC
        LIMIT 100
    ]]

    local posts = MySQL.query.await(query, {})

    -- Enviamos os posts encontrados (ou uma tabela vazia se não houver nenhum) de volta.
    cb(posts or {})
end)
-- Adicionar no final de s_company.lua

CreateCallback('space_trucker:callback:createRecruitmentPost', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end
    
    local identifier = GetPlayerUniqueId(source)
    
    -- Validação básica dos dados recebidos
    if not data.postType or not data.title or not data.content then
        return cb({ success = false, message = "Dados do anúncio incompletos." })
    end

    local profile = MySQL.query.await('SELECT id FROM space_trucker_profiles WHERE identifier = ?', { identifier })
    if not profile or not profile[1] then
        return cb({ success = false, message = "Você precisa de ter um perfil de trabalhador para criar um anúncio." })
    end

    local companyId = nil
    if data.postType == 'HIRING' then
        local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { identifier })
        if not company or not company[1] then
            return cb({ success = false, message = "Você precisa ser dono de uma empresa para anunciar vagas." })
        end
        companyId = company[1].id
    end

    local query = [[
        INSERT INTO space_trucker_posts 
        (author_identifier, post_type, title, content, company_id, gig_payment) 
        VALUES (?, ?, ?, ?, ?, ?)
    ]]

    local result = MySQL.insert.await(query, {
        identifier,
        data.postType,
        data.title,
        data.content,
        companyId, -- Será nil se não for um anúncio de 'HIRING'
        data.gigPayment -- Será nil se não for um anúncio de 'GIG_OFFER'
    })

    if result then
        cb({ success = true })
    else
        cb({ success = false, message = "Erro ao inserir o anúncio na base de dados." })
    end
end)

-- Adicionar no final de s_company.lua

CreateCallback('space_trucker:callback:hireFromPost', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local ownerIdentifier = GetPlayerUniqueId(source)
    local targetIdentifier = data.targetIdentifier
    local postId = data.postId

    if not targetIdentifier or not postId then
        return cb({ success = false, message = "Dados inválidos para contratação." })
    end

    -- 1. Verificar se quem está a contratar é dono de uma empresa
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não é dono de uma empresa para contratar." })
    end
    local companyId = company[1].id

    -- 2. Verificar se o alvo já não está empregado (nesta ou noutra empresa)
    local isAlreadyEmployed = MySQL.query.await('SELECT id FROM space_trucker_employees WHERE identifier = ?', { targetIdentifier })
    if isAlreadyEmployed and isAlreadyEmployed[1] then
        return cb({ success = false, message = "Este jogador já se encontra empregado." })
    end

    -- 3. Adicionar o jogador à tabela de funcionários
    local result = MySQL.insert.await('INSERT INTO space_trucker_employees (company_id, identifier, name, role, salary) VALUES (?, ?, ?, ?, ?)', {
        companyId,
        targetIdentifier,
        data.targetName, -- Vamos precisar de passar o nome do alvo a partir da UI
        'worker',      -- Cargo padrão
        500            -- Salário padrão
    })

    if not result then
        return cb({ success = false, message = "Erro ao adicionar o funcionário à base de dados." })
    end

    -- 4. Fechar o anúncio para que não possa ser usado novamente
    MySQL.update.await('UPDATE space_trucker_posts SET status = ? WHERE id = ?', { 'CLOSED', postId })

    -- 5. Sucesso!
    cb({ success = true, message = "Jogador contratado com sucesso!" })
end)

-- Adicionar no final de s_company.lua

-- Substitua o callback 'acceptGig' existente em s_company.lua por este

CreateCallback('space_trucker:callback:acceptGig', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local accepterIdentifier = GetPlayerUniqueId(source)
    local postId = data.postId

    if not postId then
        return cb({ success = false, message = "ID do serviço inválido." })
    end

    local post = MySQL.query.await('SELECT * FROM space_trucker_posts WHERE id = ?', { postId })
    if not post or not post[1] then
        return cb({ success = false, message = "Este serviço já não existe." })
    end

    if post[1].status ~= 'OPEN' then
        return cb({ success = false, message = "Este serviço já não está mais disponível." })
    end
    
    if post[1].author_identifier == accepterIdentifier then
        return cb({ success = false, message = "Você não pode aceitar o seu próprio serviço." })
    end

    -- 1. Fecha o anúncio e atribui ao jogador
    MySQL.update.await('UPDATE space_trucker_posts SET status = ?, gig_taker_identifier = ? WHERE id = ?', {
        'CLOSED',
        accepterIdentifier,
        postId
    })

    -- 2. CRIA A SALA DE CHAT
    local chat = MySQL.insert.await('INSERT INTO space_trucker_chats (post_id, poster_identifier, accepter_identifier) VALUES (?, ?, ?)', {
        postId,
        post[1].author_identifier,
        accepterIdentifier
    })

    if chat then
        cb({ success = true, message = "Serviço aceite! Um chat foi iniciado na aba 'Chats'." })
    else
        cb({ success = false, message = "Erro ao tentar aceitar o serviço." })
    end
end)

-- Adicionar no final de s_company.lua

-- NOVO CALLBACK: Para um jogador se candidatar a uma vaga
CreateCallback('space_trucker:callback:applyForJob', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local applicantIdentifier = GetPlayerUniqueId(source)
    local postId = data.postId

    -- 1. Verificar se o jogador já está empregado
    local isEmployed = MySQL.query.await('SELECT id FROM space_trucker_employees WHERE identifier = ?', { applicantIdentifier })
    if isEmployed and isEmployed[1] then
        return cb({ success = false, message = "Você já está empregado." })
    end

    -- 2. Verificar se o jogador já se candidatou a esta vaga
    local hasApplied = MySQL.query.await('SELECT id FROM space_trucker_applications WHERE post_id = ? AND applicant_identifier = ?', { postId, applicantIdentifier })
    if hasApplied and hasApplied[1] then
        return cb({ success = false, message = "Você já se candidatou a esta vaga." })
    end

    -- 3. Inserir a candidatura na base de dados
    local post = MySQL.query.await('SELECT company_id FROM space_trucker_posts WHERE id = ?', { postId })
    if not post or not post[1] then return cb({ success = false, message = "Vaga não encontrada." }) end
    local companyId = post[1].company_id

    MySQL.insert.await('INSERT INTO space_trucker_applications (company_id, post_id, applicant_identifier, applicant_name) VALUES (?, ?, ?, ?)', {
        companyId,
        postId,
        applicantIdentifier,
        Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    })

    -- 4. Notificar o dono da empresa (se estiver online)
    local companyOwner = MySQL.query.await('SELECT owner_identifier FROM space_trucker_companies WHERE id = ?', { companyId })
    if companyOwner and companyOwner[1] then
        local OwnerPlayer = QBCore.Functions.GetPlayerByIdentifier(companyOwner[1].owner_identifier)
        if OwnerPlayer then
            TriggerClientEvent('QBCore:Notify', OwnerPlayer.PlayerData.source, 'Você recebeu uma nova candidatura na sua empresa!', 'primary', 8000)
        end
    end
    
    cb({ success = true, message = "Candidatura enviada com sucesso!" })
end)

-- NOVO CALLBACK: Para o dono da empresa buscar todas as candidaturas pendentes
CreateCallback('space_trucker:callback:getCompanyApplications', function(source, cb)
    local ownerIdentifier = GetPlayerUniqueId(source)
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({}) -- Retorna tabela vazia se não for dono
    end
    local companyId = company[1].id

    local applications = MySQL.query.await([[
        SELECT 
            app.*,
            post.title as job_title
        FROM space_trucker_applications app
        LEFT JOIN space_trucker_posts post ON app.post_id = post.id
        WHERE app.company_id = ? AND app.status = 'PENDING'
        ORDER BY app.timestamp DESC
    ]], { companyId })

    cb(applications or {})
end)


-- NOVO CALLBACK: Para o dono contratar a partir de uma candidatura
CreateCallback('space_trucker:callback:hireFromApplication', function(source, cb, data)
    local ownerIdentifier = GetPlayerUniqueId(source)
    local applicationId = data.applicationId
    local applicantIdentifier = data.applicantIdentifier
    local applicantName = data.applicantName

    -- 1. Verificar se quem contrata é dono da empresa correta
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não é dono de uma empresa." }) end
    local companyId = company[1].id

    -- 2. Verificar se o alvo já foi empregado por outra pessoa enquanto a candidatura estava pendente
    local isEmployed = MySQL.query.await('SELECT id FROM space_trucker_employees WHERE identifier = ?', { applicantIdentifier })
    if isEmployed and isEmployed[1] then
        MySQL.update.await("UPDATE space_trucker_applications SET status = 'REJECTED' WHERE id = ?", { applicationId })
        return cb({ success = false, message = "Este jogador já foi empregado por outra empresa." })
    end

    -- 3. Adicionar o jogador como funcionário
    MySQL.insert.await('INSERT INTO space_trucker_employees (company_id, identifier, name, role, salary) VALUES (?, ?, ?, ?, ?)', {
        companyId, applicantIdentifier, applicantName, 'worker', 500
    })

    -- 4. Atualizar a candidatura para 'ACEITA'
    MySQL.update.await("UPDATE space_trucker_applications SET status = 'ACCEPTED' WHERE id = ?", { applicationId })
    
    cb({ success = true, message = applicantName .. " foi contratado(a) com sucesso!" })
end)

-- Adicionar no final de s_company.lua

CreateCallback('space_trucker:callback:updateEmployee', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local requesterIdentifier = GetPlayerUniqueId(source)
    local employeeId = data.employeeId
    local newRole = data.role
    local newSalary = tonumber(data.salary)

    if not employeeId or not newRole or not newSalary or newSalary < 0 then
        return cb({ success = false, message = "Dados inválidos." })
    end

    -- 1. Verificar o cargo de quem está a fazer o pedido (requester)
    local requesterEmployee = MySQL.query.await('SELECT role, company_id FROM space_trucker_employees WHERE identifier = ?', { requesterIdentifier })
    local isOwner = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { requesterIdentifier })
    
    local requesterRole = nil
    local companyId = nil

    if isOwner and isOwner[1] then
        requesterRole = 'owner'
        companyId = isOwner[1].id
    elseif requesterEmployee and requesterEmployee[1] then
        requesterRole = requesterEmployee[1].role
        companyId = requesterEmployee[1].company_id
    end

    if not requesterRole or (requesterRole ~= 'owner' and requesterRole ~= 'manager') then
        return cb({ success = false, message = "Você não tem permissão para editar funcionários." })
    end

    -- 2. Verificar se o alvo (target) pertence à mesma empresa
    local targetEmployee = MySQL.query.await('SELECT identifier, role FROM space_trucker_employees WHERE id = ? AND company_id = ?', { employeeId, companyId })
    if not targetEmployee or not targetEmployee[1] then
        return cb({ success = false, message = "Funcionário não encontrado na sua empresa." })
    end

    -- 3. Regras de permissão
    if requesterRole == 'manager' and (targetEmployee[1].role == 'owner' or targetEmployee[1].identifier == requesterIdentifier) then
        return cb({ success = false, message = "Você não pode editar o dono ou a si mesmo." })
    end
     if requesterRole == 'owner' and targetEmployee[1].identifier == requesterIdentifier then
        return cb({ success = false, message = "Você não pode editar a si mesmo." })
    end


    -- 4. Atualizar o funcionário
    MySQL.update.await('UPDATE space_trucker_employees SET role = ?, salary = ? WHERE id = ?', { newRole, newSalary, employeeId })

    -- 5. Devolver os dados atualizados
    local updatedData = GetFullCompanyData(companyId)
    cb({ success = true, message = "Funcionário atualizado com sucesso!", updatedData = updatedData })
end)
-- Adicionar no final de s_company.lua

CreateCallback('space_trucker:callback:deleteRecruitmentPost', function(source, cb, data)
    local Player = GetPlayer(source)
    if not Player then return cb({ success = false, message = "Jogador não encontrado." }) end

    local requesterIdentifier = GetPlayerUniqueId(source)
    local postId = data.postId

    if not postId then
        return cb({ success = false, message = "ID do anúncio inválido." })
    end

    -- 1. Verifica se o jogador que está a pedir é o verdadeiro autor
    local post = MySQL.query.await('SELECT author_identifier FROM space_trucker_posts WHERE id = ?', { postId })
    if not post or not post[1] then
        return cb({ success = false, message = "Anúncio não encontrado." })
    end

    if post[1].author_identifier ~= requesterIdentifier then
        return cb({ success = false, message = "Você não tem permissão para apagar este anúncio." })
    end

    -- 2. Apaga o anúncio e as candidaturas associadas
    MySQL.update.await('DELETE FROM space_trucker_posts WHERE id = ?', { postId })
    MySQL.update.await('DELETE FROM space_trucker_applications WHERE post_id = ?', { postId })

    cb({ success = true, message = "Anúncio apagado com sucesso!" })
end)

-- =============================================================================
-- CALLBACKS DO CHAT INTEGRADO
-- =============================================================================

-- Callback para buscar a lista de chats de um jogador
CreateCallback('space_trucker:callback:getChatList', function(source, cb)
    local identifier = GetPlayerUniqueId(source)
    if not identifier then return cb({}) end

    -- Busca todas as conversas onde o jogador é o autor OU quem aceitou
    local chats = MySQL.query.await([[
        SELECT 
            c.id, 
            c.post_id,
            p.title as post_title,
            -- Seleciona o nome do "outro" participante do chat
            IF(c.poster_identifier = ?, prof2.profile_name, prof1.profile_name) as partner_name
        FROM space_trucker_chats c
        LEFT JOIN space_trucker_posts p ON c.post_id = p.id
        LEFT JOIN space_trucker_profiles prof1 ON c.poster_identifier = prof1.identifier
        LEFT JOIN space_trucker_profiles prof2 ON c.accepter_identifier = prof2.identifier
        WHERE c.poster_identifier = ? OR c.accepter_identifier = ?
        ORDER BY c.created_at DESC
    ]], { identifier, identifier, identifier })

    cb(chats or {})
end)

-- Callback para buscar as mensagens de um chat específico
CreateCallback('space_trucker:callback:getChatMessages', function(source, cb, data)
    local identifier = GetPlayerUniqueId(source)
    local chatId = data.chatId
    if not chatId then return cb({}) end

    -- Validação de segurança: verifica se o jogador pertence a este chat
    local canAccess = MySQL.query.await('SELECT id FROM space_trucker_chats WHERE id = ? AND (poster_identifier = ? OR accepter_identifier = ?)', { chatId, identifier, identifier })
    if not canAccess or not canAccess[1] then
        return cb({}) -- Se não pertencer, retorna uma lista vazia
    end

    local messages = MySQL.query.await([[
        SELECT 
            msg.id,
            msg.author_identifier,
            msg.message,
            msg.timestamp,
            prof.profile_name as author_name
        FROM space_trucker_chat_messages msg
        LEFT JOIN space_trucker_profiles prof ON msg.author_identifier = prof.identifier
        WHERE msg.chat_id = ?
        ORDER BY msg.timestamp ASC
    ]], { chatId })

    cb(messages or {})
end)

-- Callback para enviar uma nova mensagem
CreateCallback('space_trucker:callback:sendChatMessage', function(source, cb, data)
    local identifier = GetPlayerUniqueId(source)
    local chatId = data.chatId
    local message = data.message

    if not chatId or not message or message:gsub("%s+", "") == "" then
        return cb({ success = false })
    end

    -- Validação de segurança: verifica se o jogador pertence a este chat
    local canAccess = MySQL.query.await('SELECT id FROM space_trucker_chats WHERE id = ? AND (poster_identifier = ? OR accepter_identifier = ?)', { chatId, identifier, identifier })
    if not canAccess or not canAccess[1] then
        return cb({ success = false })
    -- Aqui não enviamos mensagem de erro para não informar potenciais exploits
    end

    MySQL.insert.await('INSERT INTO space_trucker_chat_messages (chat_id, author_identifier, message) VALUES (?, ?, ?)', {
        chatId, identifier, message
    })

    cb({ success = true })
end)
-- Adicionar no final de s_company.lua

CreateCallback('space_trucker:callback:deleteChat', function(source, cb, data)
    local identifier = GetPlayerUniqueId(source)
    local chatId = data.chatId
    if not chatId then return cb({ success = false, message = "ID do chat inválido." }) end

    -- 1. Validação de segurança: verifica se o jogador pertence a este chat
    local canAccess = MySQL.query.await('SELECT id FROM space_trucker_chats WHERE id = ? AND (poster_identifier = ? OR accepter_identifier = ?)', { chatId, identifier, identifier })
    if not canAccess or not canAccess[1] then
        return cb({ success = false, message = "Você não tem permissão para apagar este chat." })
    end

    -- 2. Apaga o chat e as mensagens associadas
    MySQL.update.await('DELETE FROM space_trucker_chats WHERE id = ?', { chatId })
    MySQL.update.await('DELETE FROM space_trucker_chat_messages WHERE chat_id = ?', { chatId })

    cb({ success = true, message = "Conversa apagada com sucesso." })
end)

-- SUBSTITUA O BLOCO DE CÓDIGO NO FINAL DE s_company.lua POR ESTA VERSÃO FINAL:

RegisterNetEvent('space_trucker:server:createCompany', function(data)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)
    if not user then
        print('[space_trucker DEBUG] ERRO: Não foi possível obter o objeto do jogador.')
        return
    end

    local companyName = data.name
    local companyLogo = data.logo or ''

    if not companyName or companyName:gsub("^%s*(.-)%s*$", "%1") == "" then
        TriggerClientEvent('QBCore:Notify', src, 'O nome da empresa não pode estar vazio.', 'error')
        return
    end

    local creationCost = 50000 -- Custo de criação
    local userMoney = user.Functions.GetMoney('bank')

    print('[space_trucker DEBUG] A criar empresa. Nome: ' .. companyName .. ' | Custo: ' .. creationCost .. ' | Dinheiro do jogador: ' .. userMoney)

    if userMoney >= creationCost then
        user.Functions.RemoveMoney('bank', creationCost, "criacao-de-empresa")

        -- Usamos 'pcall' para executar a query de forma segura e apanhar qualquer erro
        local success, result = pcall(function()
            return MySQL.insert.await('INSERT INTO space_trucker_companies (name, owner_identifier, balance, logo_url) VALUES (?, ?, ?, ?)', {
                companyName,
                user.PlayerData.citizenid,
                0, -- Saldo inicial
                companyLogo
            })
        end)

        if success and result then
            local newCompanyId = result
            local ownerName = user.PlayerData.charinfo.firstname .. ' ' .. user.PlayerData.charinfo.lastname

            -- Insere o dono na tabela de funcionários
            local employeeResult = MySQL.insert.await('INSERT INTO space_trucker_employees (company_id, identifier, name, role, is_npc) VALUES (?, ?, ?, ?, ?)', {
                newCompanyId,
                user.PlayerData.citizenid,
                ownerName,
                'owner',
                false
            })

            if employeeResult then
                print('[space_trucker] SUCESSO! Empresa ' .. companyName .. ' (ID: ' .. newCompanyId .. ') criada para ' .. ownerName)
                TriggerClientEvent('QBCore:Notify', src, 'Empresa criada com sucesso!', 'success')
                TriggerClientEvent('space_trucker:client:forceRefresh', src)
            else
                print('[space_trucker ERRO CRÍTICO] A empresa foi criada na DB, mas falhou ao registar o dono como funcionário. Verifique a tabela space_trucker_employees.')
                TriggerClientEvent('QBCore:Notify', src, 'Erro crítico ao finalizar o seu registo como dono. Contacte um administrador.', 'error')
            end
        else
            -- Se a inserção falhou, 'result' terá a mensagem de erro.
            print('[space_trucker ERRO FATAL] A query para criar a empresa falhou. Devolvendo dinheiro. Erro: ' .. tostring(result))
            user.Functions.AddMoney('bank', creationCost, "reembolso-criacao-empresa")
            TriggerClientEvent('QBCore:Notify', src, 'Erro do servidor ao registar a empresa. Verifique a consola do servidor.', 'error')
        end
    else
        print('[space_trucker DEBUG] O jogador não tem dinheiro suficiente para criar a empresa.')
        TriggerClientEvent('QBCore:Notify', src, 'Você não tem dinheiro suficiente. Custo: $' .. creationCost, 'error')
    end
end)
-- Adicione este bloco no final do seu arquivo s_company.lua

CreateCallback('space_trucker:callback:transferOwnership', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end

    local oldOwnerIdentifier = user.PlayerData.citizenid
    local targetEmployeeId = tonumber(data.targetEmployeeId)

    -- 1. Verifica se o jogador é realmente o dono de uma empresa
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { oldOwnerIdentifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não é o dono de uma empresa." })
    end
    local companyId = company[1].id

    -- 2. Busca os dados do funcionário que será o novo dono
    local newOwner = MySQL.query.await('SELECT identifier FROM space_trucker_employees WHERE id = ? AND company_id = ? AND is_npc = 0', { targetEmployeeId, companyId })
    if not newOwner or not newOwner[1] then
        return cb({ success = false, message = "Funcionário alvo não encontrado ou é um NPC." })
    end
    local newOwnerIdentifier = newOwner[1].identifier
    
    -- Segurança: Impede que o dono se transfira para si mesmo
    if newOwnerIdentifier == oldOwnerIdentifier then
        return cb({ success = false, message = "Você não pode transferir a empresa para si mesmo." })
    end

    -- 3. Executa as atualizações no banco de dados
    -- Atualiza o dono na tabela da empresa
    MySQL.update.await('UPDATE space_trucker_companies SET owner_identifier = ? WHERE id = ?', { newOwnerIdentifier, companyId })
    -- Define o novo dono com o cargo 'owner'
    MySQL.update.await("UPDATE space_trucker_employees SET role = 'owner' WHERE identifier = ? AND company_id = ?", { newOwnerIdentifier, companyId })
    -- Define o antigo dono com o cargo 'worker'
    MySQL.update.await("UPDATE space_trucker_employees SET role = 'worker' WHERE identifier = ? AND company_id = ?", { oldOwnerIdentifier, companyId })

    print('[space_trucker] Empresa ID '..companyId..' transferida de '..oldOwnerIdentifier..' para '..newOwnerIdentifier)
    cb({ success = true, message = "Propriedade transferida com sucesso!" })
end)

-- Adicione este novo callback em s_company.lua

CreateCallback('space_trucker:callback:updateManagerPermissions', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end

    local ownerIdentifier = user.PlayerData.citizenid
    local newPermissions = data.permissions

    -- 1. Verifica se o jogador é realmente o dono de uma empresa
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não tem permissão para alterar as configurações." })
    end
    local companyId = company[1].id

    -- 2. Converte a tabela de permissões para uma string JSON para guardar no banco de dados
    local permissionsJson = json.encode(newPermissions)

    -- 3. Atualiza a coluna de permissões no banco de dados
    MySQL.update.await('UPDATE space_trucker_companies SET permissions = ? WHERE id = ?', { permissionsJson, companyId })

    print('[space_trucker] Permissões da empresa ID ' .. companyId .. ' atualizadas.')
    
    -- 4. Retorna os dados completos e atualizados para a UI
    local updatedData = GetFullCompanyData(companyId)
    cb({ success = true, updatedData = updatedData })
end)

-- Adicione este novo callback em s_company.lua

CreateCallback('space_trucker:callback:toggleAutoSalary', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end

    local ownerIdentifier = user.PlayerData.citizenid
    local isEnabled = data.enabled

    -- 1. Verifica se o jogador é realmente o dono de uma empresa
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then
        return cb({ success = false, message = "Você não tem permissão para alterar as configurações." })
    end
    local companyId = company[1].id

    -- 2. Atualiza a coluna no banco de dados
    MySQL.update.await('UPDATE space_trucker_companies SET salary_payment_enabled = ? WHERE id = ?', { isEnabled, companyId })

    print('[space_trucker] Pagamento automático de salários ' .. (isEnabled and 'ATIVADO' or 'DESATIVADO') .. ' para a empresa ID ' .. companyId)
    
    -- 3. Retorna os dados completos e atualizados para a UI
    local updatedData = GetFullCompanyData(companyId)
    cb({ success = true, updatedData = updatedData })
end)

CreateCallback('space_trucker:callback:getGarageLocation', function(source, cb, data)
    print("^2[space-trucker DIAGNÓSTICO - SERVIDOR]^7: Recebido pedido de localização da garagem para a empresa ID: ^3" .. tostring(data.companyId) .. "^7")
    
    if not data or not data.companyId then 
        print("^1[space-trucker DIAGNÓSTICO - SERVIDOR]^7: ID da empresa inválido ou não fornecido. A devolver nil.")
        return cb(nil) 
    end
    
    local company = MySQL.query.await('SELECT garage_location FROM space_trucker_companies WHERE id = ?', { data.companyId })
    
    if company and company[1] and company[1].garage_location then
        local locationJson = company[1].garage_location
        print("^2[space-trucker DIAGNÓSTICO - SERVIDOR]^7: Localização encontrada na base de dados (JSON string): ^3" .. locationJson .. "^7")
        
        -- Tenta descodificar o JSON de forma segura
        local success, locationData = pcall(json.decode, locationJson)
        
        if success and locationData then
            print("^2[space-trucker DIAGNÓSTICO - SERVIDOR]^7: ^2SUCESSO!^7 JSON descodificado. A enviar coordenadas para o cliente.")
            cb(locationData)
        else
            print("^1[space-trucker DIAGNÓSTICO - SERVIDOR]^7: ^1FALHA!^7 Erro ao descodificar o JSON da base de dados. Verifique se o formato está correto. Ex: {\"x\":1.0,\"y\":2.0,\"z\":3.0,\"h\":4.0}. A devolver nil.")
            cb(nil)
        end
    else
        print("^1[space-trucker DIAGNÓSTICO - SERVIDOR]^7: ^1FALHA!^7 Nenhuma localização de garagem encontrada na base de dados para esta empresa. A coluna está vazia ou a empresa não existe. A devolver nil.")
        cb(nil)
    end
end)
CreateCallback('space_trucker:callback:setGarageLocation', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end
    local ownerIdentifier = user.PlayerData.citizenid
    local location = data.location
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não tem permissão." }) end
    local companyId = company[1].id
    MySQL.update.await('UPDATE space_trucker_companies SET garage_location = ? WHERE id = ?', { json.encode(location), companyId })
    
    -- NOVO: Envia a nova localização para TODOS os clientes em tempo real.
    -- O cliente decidirá se mostra o blip com base no seu emprego.
    TriggerClientEvent('space_trucker:client:updateGarageLocation', -1, companyId, location)
    
    local updatedData = GetFullCompanyData(companyId)
    cb({ success = true, message = "Local da garagem definido com sucesso!", updatedData = updatedData })
end)

CreateCallback('space_trucker:callback:getPlayerVehicles', function(source, cb)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({}) end
    local citizenid = user.PlayerData.citizenid
    local availableVehicles = MySQL.query.await([[
        SELECT plate, vehicle FROM player_vehicles 
        WHERE citizenid = ? 
        AND plate NOT IN (SELECT plate COLLATE utf8mb4_unicode_ci FROM space_trucker_fleet)
    ]], { citizenid })
    cb(availableVehicles or {})
end)

CreateCallback('space_trucker:callback:addVehicleToFleet', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end
    local ownerIdentifier = user.PlayerData.citizenid
    local vehiclePlate = data.plate
    if not vehiclePlate then return cb({ success = false, message = "Nenhum veículo selecionado." }) end
    local company = MySQL.query.await('SELECT id FROM space_trucker_companies WHERE owner_identifier = ?', { ownerIdentifier })
    if not company or not company[1] then return cb({ success = false, message = "Você não tem permissão." }) end
    local companyId = company[1].id
    local vehicleData = MySQL.query.await('SELECT vehicle FROM player_vehicles WHERE plate = ? AND citizenid = ?', { vehiclePlate, ownerIdentifier })
    if not vehicleData or not vehicleData[1] then return cb({ success = false, message = "Veículo não encontrado ou não pertence a si." }) end
    
    MySQL.insert.await('INSERT INTO space_trucker_fleet (company_id, plate, model, damage) VALUES (?, ?, ?, ?)', {
        companyId, vehiclePlate, vehicleData[1].vehicle, '{}'
    })
    MySQL.update.await('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', { 'company:' .. companyId, vehiclePlate })
    
    -- >> NOVO: Avisa o cliente para apagar o veículo do mundo, se ele existir <<
    TriggerClientEvent('space_trucker:client:deleteVehicleByPlate', -1, vehiclePlate)

    local updatedData = GetFullCompanyData(companyId)
    cb({ success = true, message = "Veículo adicionado à frota com sucesso!", updatedData = updatedData })
end)

-- NOVO: Callback para buscar os veículos da frota para o menu da garagem
CreateCallback('space_trucker:callback:getFleetVehicles', function(source, cb)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({}) end
    
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(source)
    if not isEmployed then return cb({}) end

    local vehicles = MySQL.query.await('SELECT * FROM space_trucker_fleet WHERE company_id = ?', { companyId })
    cb(vehicles or {})
end)


-- NOVO: Callback para guardar um veículo na garagem
CreateCallback('space_trucker:callback:storeFleetVehicle', function(source, cb, data)
    local user = QBCore.Functions.GetPlayer(source)
    if not user then return cb({ success = false, message = "Jogador não encontrado." }) end
    
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(source)
    if not isEmployed then return cb({ success = false, message = "Você não trabalha aqui." }) end

    local vehicle = MySQL.query.await('SELECT id FROM space_trucker_fleet WHERE plate = ? AND company_id = ?', { data.plate, companyId })
    if not vehicle or not vehicle[1] then return cb({ success = false, message = "Este veículo não pertence à sua empresa." }) end

    local playerName = user.PlayerData.charinfo.firstname .. ' ' .. user.PlayerData.charinfo.lastname
    
    MySQL.update.await('UPDATE space_trucker_fleet SET status = ?, damage = ? WHERE id = ?', { 'Na Garagem', json.encode(data.damage), vehicle[1].id })
    MySQL.insert.await('INSERT INTO space_trucker_fleet_logs (fleet_id, company_id, player_name, action) VALUES (?, ?, ?, ?)', { vehicle[1].id, companyId, playerName, 'Guardado' })

    cb({ success = true, message = "Veículo guardado com sucesso." })
end)

CreateCallback('space_trucker:callback:getFleetLogs', function(source, cb, data)
    local fleetId = data.fleetId
    local logs = MySQL.query.await('SELECT * FROM space_trucker_fleet_logs WHERE fleet_id = ? ORDER BY timestamp DESC LIMIT 50', { fleetId })
    cb(logs or {})
end)

-- Adicione este bloco no final de s_company.lua

-- Callback para o cliente perguntar se o jogador está empregado e onde
CreateCallback('space_trucker:callback:checkEmployment', function(source, cb)
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(source)
    cb(isEmployed, companyId)
end)

-- Callback para o cliente perguntar a localização da garagem de uma empresa
CreateCallback('space_trucker:callback:getGarageLocation', function(source, cb, data)
    if not data or not data.companyId then return cb(nil) end
    
    local company = MySQL.query.await('SELECT garage_location FROM space_trucker_companies WHERE id = ?', { data.companyId })
    
    if company and company[1] and company[1].garage_location then
        cb(json.decode(company[1].garage_location))
    else
        cb(nil)
    end
end)

-- Adicione este código no final do seu ficheiro space_trucker/server/s_company.lua
-- space_trucker/server/s_company.lua

-- ADICIONE ESTE NOVO BLOCO DE CÓDIGO NO LUGAR DOS DOIS QUE APAGOU
RegisterNetEvent('space_trucker:server:requestSpawn', function(data)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)
    if not user then 
        TriggerClientEvent('QBCore:Notify', src, "Jogador não encontrado.", "error")
        return 
    end

    local isEmployed, companyId = CheckIfPlayerWorksForCompany(src)
    if not isEmployed then 
        TriggerClientEvent('QBCore:Notify', src, "Você não trabalha aqui.", "error")
        return 
    end

    local vehicle = MySQL.query.await('SELECT * FROM space_trucker_fleet WHERE id = ? AND company_id = ?', { data.vehicleId, companyId })
    if not vehicle or not vehicle[1] then 
        TriggerClientEvent('QBCore:Notify', src, "Veículo não encontrado.", "error")
        return 
    end

    if vehicle[1].status ~= 'Na Garagem' then 
        TriggerClientEvent('QBCore:Notify', src, "Este veículo já está em uso.", "error")
        return 
    end

    local playerName = user.PlayerData.charinfo.firstname .. ' ' .. user.PlayerData.charinfo.lastname
    local newStatus = 'Em uso por ' .. playerName

    MySQL.update.await('UPDATE space_trucker_fleet SET status = ?, last_driver = ? WHERE id = ?', { newStatus, playerName, data.vehicleId })
    MySQL.insert.await('INSERT INTO space_trucker_fleet_logs (fleet_id, company_id, player_name, action) VALUES (?, ?, ?, ?)', { data.vehicleId, companyId, playerName, 'Retirada' })

    -- Avisa o cliente para criar o veículo no mundo
    TriggerClientEvent('space_trucker:client:spawnVehicle', src, vehicle[1])
end)


CreateCallback('space_trucker:callback:returnVehicleToOwner', function(source, cb, data)
    -- O 'pcall' (protected call) executa o código de forma segura.
    -- Se ocorrer um erro, ele não quebra o script e permite-nos lidar com ele.
    local success, result = pcall(function()
        local user = QBCore.Functions.GetPlayer(source)
        if not user then return { success = false, message = "Jogador não encontrado." } end

        local ownerIdentifier = user.PlayerData.citizenid
        local fleetId = data.fleetId

        if not fleetId then return { success = false, message = "ID do veículo inválido." } end

        -- 1. Verificar se o jogador é o dono da empresa à qual o veículo pertence
        local vehicle = MySQL.query.await('SELECT * FROM space_trucker_fleet WHERE id = ?', { fleetId })
        if not vehicle or not vehicle[1] then
            return { success = false, message = "Veículo da frota não encontrado." }
        end
        local vehicleData = vehicle[1]
        local companyId = vehicleData.company_id

        local company = MySQL.query.await('SELECT * FROM space_trucker_companies WHERE id = ? AND owner_identifier = ?', { companyId, ownerIdentifier })
        if not company or not company[1] then
            return { success = false, message = "Você não tem permissão para realizar esta ação." }
        end

        -- 2. Devolver o veículo ao dono (atualizar a tabela player_vehicles)
        MySQL.update.await('UPDATE player_vehicles SET citizenid = ? WHERE plate = ?', { ownerIdentifier, vehicleData.plate })

        -- 3. Remover o veículo da frota da empresa
        MySQL.update.await('DELETE FROM space_trucker_fleet WHERE id = ?', { fleetId })

        -- 4. Adicionar um registo da transação
        MySQL.insert.await('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyId, 'fleet_change', 0, 'Veículo ' .. vehicleData.plate .. ' devolvido ao dono.' })

        -- 5. Devolver os dados atualizados da empresa
        local updatedData = GetFullCompanyData(companyId)
        return { success = true, message = "Veículo devolvido com sucesso!", updatedData = updatedData }
    end)

    -- Após a execução do pcall, enviamos o resultado de volta para o cliente.
    if success then
        -- Se tudo correu bem, 'result' contém a tabela de sucesso.
        cb(result)
    else
        -- Se ocorreu um erro, 'result' contém a mensagem de erro.
        print("^1[space-trucker ERRO FATAL]^7: Ocorreu um erro ao devolver o veículo: ^3" .. tostring(result) .. "^7")
        cb({ success = false, message = "Ocorreu um erro no servidor. Verifique a consola do servidor." })
    end
end)


-- =============================================================================
-- * NOVAS FUNÇÕES PARA GESTÃO DE INDÚSTRIAS
-- =============================================================================

-- NOTA IMPORTANTE:
-- Para que a compra e venda funcionem, você precisa de definir os preços das indústrias
-- no seu ficheiro de configuração (ex: shared/gst_config.lua ou onde as indústrias são registadas).
-- Exemplo:
-- Industries:AddIndustry('nome_da_industria', 'Label', ...):SetPurchasePrice(1000000) -- Preço de 1,000,000

-- Callback para a UI saber quem é o dono de cada indústria
CreateCallback('space_trucker:callback:getIndustryOwnershipData', function(source, cb)
    local ownerships = MySQL.query.await('SELECT comp.name, ind.industry_name FROM space_trucker_company_industries ind LEFT JOIN space_trucker_companies comp ON ind.company_id = comp.id', {})
    
    local data = {} -- Garante que 'data' é sempre uma tabela, mesmo que vazia.
    
    if ownerships and #ownerships > 0 then
        for _, owner in ipairs(ownerships) do
            data[owner.industry_name] = owner.name
        end
    end
    
    -- A correção crucial: Enviamos sempre uma tabela, que será convertida para um JSON válido ('{}' ou '{...}').
    cb(data)
end)




CreateCallback('space_trucker:callback:isVehicleInMyCompanyFleet', function(source, cb, plate)
    -- Verifica se o jogador trabalha para alguma empresa
    local isEmployed, companyId = CheckIfPlayerWorksForCompany(source)
    if not isEmployed then 
        cb(false) 
        return
    end

    -- VERIFICAÇÃO SIMPLIFICADA:
    -- Apenas confirma se o veículo com esta matrícula pertence à frota da empresa do jogador.
    local vehicle = MySQL.query.await('SELECT id FROM space_trucker_fleet WHERE plate = ? AND company_id = ?', { plate, companyId })
    
    if vehicle and vehicle[1] then
        -- Se o veículo for encontrado na frota da empresa, a verificação é bem-sucedida.
        cb(true)
    else
        -- Caso contrário, falha.
        cb(false)
    end
end)

-- CALLBACK PARA OBTER A REPUTAÇÃO (VERSÃO FINAL COM TABELA E COLUNA CORRETAS)
CreateCallback('space_trucker:callback:getCompanyReputation', function(source, cb)
    print("[space-trucker LOG] Callback 'getCompanyReputation' iniciado para o source: " .. tostring(source))
    
    local QBCore = exports['qb-core']:GetCoreObject()
    local qbPlayer = QBCore.Functions.GetPlayer(source)
    if not qbPlayer then
        print("[space-trucker ERRO] Não foi possível encontrar o jogador do QBCore para o source: " .. tostring(source))
        return cb(0)
    end
    -- Usamos o citizenid que corresponde ao 'identifier' na tabela de funcionários
    local identifier = qbPlayer.PlayerData.citizenid
    print("[space-trucker LOG] Identifier do jogador encontrado: " .. tostring(identifier))

    -- Passo 1: Encontrar a qual empresa o jogador pertence usando a tabela e coluna corretas
    MySQL.Async.fetchAll('SELECT company_id FROM space_trucker_employees WHERE identifier = ?', { identifier }, function(employees)
        if not employees or not employees[1] then
            print("[space-trucker AVISO] O jogador com o identifier " .. identifier .. " não foi encontrado como funcionário de nenhuma empresa.")
            return cb(0)
        end

        local companyId = employees[1].company_id
        print("[space-trucker LOG] ID da empresa encontrado: " .. tostring(companyId) .. ". A consultar a reputação...")

        -- Passo 2: Com o ID da empresa, obter a reputação da tabela de empresas
        MySQL.Async.fetchAll('SELECT reputation FROM space_trucker_companies WHERE id = ?', { companyId }, function(companies)
            local reputation = 0
            if companies and companies[1] then
                reputation = companies[1].reputation or 0
                print("[space-trucker SUCESSO] Reputação encontrada na DB: " .. tostring(reputation))
            else
                print("[space-trucker AVISO] Não foi encontrada nenhuma empresa com o ID: " .. tostring(companyId))
            end
            -- Envia o valor final para a interface
            cb(reputation)
        end)
    end)
end)

CreateCallback('space_trucker:callback:rentCompanyVehicle', function(source, cb, vehicleKey) -- Recebemos a chave/identificador
    local src = source
    local QBCore = exports['qb-core']:GetCoreObject()
    local qbPlayer = QBCore.Functions.GetPlayer(src)
    if not qbPlayer then
        return cb({ success = false, message = "Jogador não encontrado." })
    end
    local identifier = qbPlayer.PlayerData.citizenid

    MySQL.Async.fetchAll('SELECT company_id FROM space_trucker_employees WHERE identifier = ?', { identifier }, function(employees)
        if not employees or not employees[1] then
            return cb({ success = false, message = "Você não é funcionário de nenhuma empresa." })
        end
        local companyId = employees[1].company_id

        MySQL.Async.fetchAll('SELECT * FROM space_trucker_companies WHERE id = ?', { companyId }, function(companies)
            if not companies or not companies[1] then
                return cb({ success = false, message = "Erro interno: A sua empresa não foi encontrada." })
            end
            
            local companyData = companies[1]
            -- Usamos a chave para encontrar os dados do veículo. ISTO VAI RESOLVER O ERRO.
            local vehicleData = spaceconfig.VehicleTransport[vehicleKey]
            if not vehicleData then
                return cb({ success = false, message = "Veículo inválido." })
            end

            if (companyData.reputation or 0) < (vehicleData.level or 0) then
                return cb({ success = false, message = ('Reputação %d necessária para alugar este veículo.'):format(vehicleData.level) })
            end

            local rentPrice = vehicleData.rentPrice or (spaceconfig.VehicleRentBaseCost * vehicleData.capacity)
            if (companyData.balance or 0) < rentPrice then
                return cb({ success = false, message = "A sua empresa não tem saldo suficiente." })
            end
            
            local newBalance = companyData.balance - rentPrice
            local description = ('Aluguer do veículo: %s'):format(vehicleData.label)

            MySQL.Async.execute('UPDATE space_trucker_companies SET balance = ? WHERE id = ?', { newBalance, companyId }, function(affectedRows)
                if affectedRows > 0 then
                    MySQL.Async.execute('INSERT INTO space_trucker_transactions (company_id, type, amount, description) VALUES (?, ?, ?, ?)', { companyId, 'rental', -rentPrice, description })
                    
                    local plate = "LOC" .. math.random(100, 999) .. companyId
                    local rentalHours = spaceconfig.Company.RentalDurationHours or 24
                    
                    -- ## CORREÇÃO FINAL AQUI ##
                    -- Usamos 'vehicleData.name' para guardar o NOME DO MODELO (texto) na base de dados
                    local vehicleModelNameToSave = vehicleData.name 
                    
                    local query = "INSERT INTO space_trucker_fleet (company_id, model, plate, status, damage, rent_expires_at) VALUES (?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL ? HOUR))"
                    local params = { companyId, vehicleModelNameToSave, plate, 'Na Garagem', '{}', rentalHours }

                    MySQL.Async.execute(query, params, function(insertResult)
                        if insertResult and insertResult > 0 then
                            cb({ success = true, message = ('Veículo %s alugado por $%s! Expira em %d horas.'):format(vehicleData.label, rentPrice, rentalHours) })
                        else
                            cb({ success = false, message = "Falha ao adicionar o veículo à frota." })
                        end
                    end)
                else
                    cb({ success = false, message = "Ocorreu um erro ao processar o pagamento." })
                end
            end)
        end)
    end)
end)

RegisterNetEvent('space_trucker:server:updateProfile', function(data)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    
    if not identifier or not data or not data.profile_name then
        -- Adicione uma notificação de erro se desejar
        return
    end

    -- Limita o tamanho do nome e da URL para segurança
    local name = string.sub(data.profile_name, 1, 50)
    local picture = string.sub(data.profile_picture or '', 1, 255)

    -- Atualiza os dados no banco de dados
    MySQL.update.await(
        'UPDATE space_trucker_profiles SET profile_name = ?, profile_picture = ? WHERE identifier = ?',
        { name, picture, identifier }
    )

    -- Opcional: Adicione uma notificação de sucesso para o jogador
    -- TriggerClientEvent('your:notification', src, 'Perfil atualizado com sucesso!', 'success')
end)






exports('CheckIfPlayerWorksForCompany', CheckIfPlayerWorksForCompany)


