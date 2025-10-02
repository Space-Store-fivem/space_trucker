-- CORREÇÃO DEFINITIVA (Client-Side)

-- Coloque esta linha no topo do seu script do lado do cliente.
GS_COMPANY_CALLBACKS_REGISTERED = GS_COMPANY_CALLBACKS_REGISTERED or false

-- Apenas execute o registo se a variável de guarda for falsa.
if not GS_COMPANY_CALLBACKS_REGISTERED then

    -- Mensagem para sabermos que o código correu
    print("^2[space-trucker]^7 A registar Callbacks da NUI pela primeira e única vez...")

    RegisterNUICallback('depositMoney', function(data, cb)
        local result = TriggerCallbackAwait('space_trucker:callback:depositMoney', data)
        cb(result)
    end)

    RegisterNUICallback('withdrawMoney', function(data, cb)
        local result = TriggerCallbackAwait('space_trucker:callback:withdrawMoney', data)
        cb(result)
    end)

    -- Marca como registado para que este bloco não execute novamente
    GS_COMPANY_CALLBACKS_REGISTERED = true
end