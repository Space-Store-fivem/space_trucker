-- Tertiary Industries
-- Este ficheiro segue o padrão dos outros ficheiros de registo de indústria.

-- Adiciona a indústria de Logística ao registo geral de indústrias
Industries:AddIndustry(
    'logistics', -- Nome único da indústria
    'logistics_company', -- Chave de tradução para o nome a ser exibido
    1, -- Status (1: Não Comprada)
    3, -- Tier (3: Terciário)
    'tertiary', -- Tipo da indústria
    vector3(532.0, -179.0, 54.0), -- Localização principal
    {}, -- Localizações de "FORSALE" (não aplicável para este tipo)
    {}, -- Localizações de "WANTED" (não aplicável para este tipo)
    { -- tradeData (configuração de input/output)
        [spaceconfig.Industry.TradeType.FORSALE] = {},
        [spaceconfig.Industry.TradeType.WANTED] = {}
    }
)
:SetPurchasePrice(750000) -- Define o preço de compra para a indústria