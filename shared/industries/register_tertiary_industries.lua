-- 1. Indústria de Eletrônicos (Consome peças e metal)
Industries:AddIndustry(
    'electronics_mfg',
    'industry_electronics',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(300.0, -900.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['smartphone'] = { production = 10, price = 5000, storageSize = 100 },
            ['tablet'] = { production = 8, price = 7000, storageSize = 80 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 2, storageSize = 200 }, -- Peças da Fábrica de Eletrodomésticos
            ['steel_shapes'] = { amount_needed = 1, storageSize = 150 } -- Metal da Siderúrgica
        }
    }
):SetPurchasePrice(1200000)

-- 2. Indústria de Móveis de Luxo (Consome madeira e metal)
Industries:AddIndustry(
    'luxury_furniture',
    'industry_furniture',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(320.0, -880.0, 32.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['sofa_modern'] = { production = 5, price = 12000, storageSize = 50 },
            ['mesa_vidro'] = { production = 7, price = 8000, storageSize = 70 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['wood_plank'] = { amount_needed = 5, storageSize = 500 }, -- Tábuas da Serraria
            ['steel_shapes'] = { amount_needed = 3, storageSize = 300 } -- Estruturas da Siderúrgica
        }
    }
):SetPurchasePrice(900000)

-- 3. Indústria de Automóveis Elétricos (Consome peças e metal)
Industries:AddIndustry(
    'ev_manufacturer',
    'industry_ev',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(350.0, -850.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['electric_car'] = { production = 1, price = 100000, storageSize = 10 },
            ['motor_electric'] = { production = 5, price = 20000, storageSize = 50 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 4, storageSize = 200 }, -- Componentes Eletrônicos
            ['steel_shapes'] = { amount_needed = 5, storageSize = 400 } -- Chassis de Metal
        }
    }
):SetPurchasePrice(2500000)

-- 4. Indústria de Cosméticos (Consome químicos e bebidas para base)
Industries:AddIndustry(
    'cosmetics',
    'industry_cosmetics',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(280.0, -920.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['perfume'] = { production = 20, price = 3000, storageSize = 200 },
            ['creme_rejuv'] = { production = 15, price = 5000, storageSize = 150 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['dyes'] = { amount_needed = 4, storageSize = 400 }, -- Corantes/Químicos da Destilaria
            ['beverages'] = { amount_needed = 2, storageSize = 300 } -- Base líquida da Cervejaria
        }
    }
):SetPurchasePrice(800000)

-- 5. Indústria de Roupa de Grife (Consome tecido e peças de metal)
Industries:AddIndustry(
    'fashion_brand',
    'industry_fashion',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(360.0, -870.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['jaqueta_luxo'] = { production = 10, price = 10000, storageSize = 100 },
            ['sapato_design'] = { production = 12, price = 8000, storageSize = 120 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['clothes'] = { amount_needed = 10, storageSize = 1000 }, -- Tecido da Fábrica Têxtil
            ['coins'] = { amount_needed = 2, storageSize = 400 } -- Moedas (para botões/zíperes) da Casa da Moeda
        }
    }
):SetPurchasePrice(950000)

-- 6. Indústria de Eletrônicos Domésticos (Consome peças e madeira)
Industries:AddIndustry(
    'home_electronics',
    'industry_home_elec',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(400.0, -800.0, 25.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['smart_tv'] = { production = 6, price = 15000, storageSize = 60 },
            ['soundbar'] = { production = 8, price = 6000, storageSize = 80 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 3, storageSize = 300 }, -- Peças da Fábrica de Eletrodomésticos
            ['wood_plank'] = { amount_needed = 2, storageSize = 250 } -- Madeira para acabamento
        }
    }
):SetPurchasePrice(1100000)

-- 7. Indústria de Dispositivos Médicos (Consome peças e metal)
Industries:AddIndustry(
    'medical_devices',
    'industry_medical',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(420.0, -760.0, 26.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['scanner_ct'] = { production = 1, price = 200000, storageSize = 10 },
            ['ventilator'] = { production = 4, price = 80000, storageSize = 40 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 5, storageSize = 500 }, -- Componentes eletrônicos
            ['steel_shapes'] = { amount_needed = 6, storageSize = 600 } -- Estruturas de Aço
        }
    }
):SetPurchasePrice(3000000)

-- 8. Indústria de Equipamentos de Telecomunicações (Consome peças e químicos)
Industries:AddIndustry(
    'telecom_equip',
    'industry_telecom',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(450.0, -720.0, 27.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['router_5g'] = { production = 10, price = 12000, storageSize = 100 },
            ['antenna_array'] = { production = 7, price = 25000, storageSize = 70 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 5, storageSize = 500 }, -- Circuitos
            ['dyes'] = { amount_needed = 3, storageSize = 400 } -- Plásticos/Químicos
        }
    }
):SetPurchasePrice(1800000)

-- 9. Indústria de Jogos Eletrônicos / Consoles (Consome peças e químicos para plástico)
Industries:AddIndustry(
    'gaming_hardware',
    'industry_gaming',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(470.0, -680.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['console_nextgen'] = { production = 4, price = 100000, storageSize = 40 },
            ['vr_headset'] = { production = 6, price = 45000, storageSize = 60 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 3, storageSize = 300 }, -- Chips/GPUs
            ['dyes'] = { amount_needed = 4, storageSize = 400 } -- Químicos para o Plástico da carcaça
        }
    }
):SetPurchasePrice(1500000)

-- 10. Indústria de Automação / Robôs (Consome peças e metal)
Industries:AddIndustry(
    'robotics',
    'industry_robotics',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(490.0, -640.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['robot_arm'] = { production = 5, price = 50000, storageSize = 50 },
            ['automation_unit'] = { production = 8, price = 3000, storageSize = 80 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['metal_ores'] = { amount_needed = 6, storageSize = 600 }, -- Motores e Controles
            ['steel_shapes'] = { amount_needed = 5, storageSize = 500 } -- Estrutura metálica
        }
    }
):SetPurchasePrice(2200000)

-- 11. Indústria de Produtos de Luxo / Relógios (Consome metal precioso e químicos)
Industries:AddIndustry(
    'luxury_watches',
    'industry_watches',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(510.0, -600.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['watch_gold'] = { production = 10, price = 25000, storageSize = 100 },
            ['watch_silver'] = { production = 15, price = 12000, storageSize = 150 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['coins'] = { amount_needed = 4, storageSize = 400 }, -- Metais da Casa da Moeda
            ['dyes'] = { amount_needed = 2, storageSize = 200 } -- Químicos para polimento/tratamento
        }
    }
):SetPurchasePrice(1200000)

-- 12. Indústria de Software (Consome papel e peças)
Industries:AddIndustry(
    'software_dev',
    'industry_software',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(530.0, -580.0, 32.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['packaged_software'] = { production = 20, price = 1500, storageSize = 200 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['wood_plank'] = { amount_needed = 2, storageSize = 400 }, -- Para fazer Papel para manuais/caixas
            ['appliances'] = { amount_needed = 1, storageSize = 250 } -- Para mídias físicas (discos/pen drives)
        }
    }
):SetPurchasePrice(900000)

-- 13. Indústria de Moda / Acessórios (Consome tecido e metal)
Industries:AddIndustry(
    'fashion_accessories',
    'industry_accessories',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(550.0, -540.0, 33.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['bolsa_couro'] = { production = 12, price = 8000, storageSize = 120 },
            ['oculos_design'] = { production = 10, price = 9000, storageSize = 100 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['clothes'] = { amount_needed = 6, storageSize = 600 }, -- Tecido/Couro da Fábrica Têxtil
            ['coins'] = { amount_needed = 1, storageSize = 300 } -- Para peças metálicas (fivelas, etc.)
        }
    }
):SetPurchasePrice(850000)

-- 14. Indústria de Bebidas Premium (Consome malte e madeira)
Industries:AddIndustry(
    'premium_beverage',
    'industry_beverage',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(570.0, -500.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['wine_premium'] = { production = 8, price = 20000, storageSize = 80 },
            ['whisky_aged'] = { production = 4, price = 50000, storageSize = 40 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['malt'] = { amount_needed = 10, storageSize = 1000 }, -- Malte da Casa de Malte
            ['wood_plank'] = { amount_needed = 4, storageSize = 400 } -- Para os Barris de Carvalho
        }
    }
):SetPurchasePrice(1300000)

-- 15. Indústria de Perfumes / Fragrâncias (Consome bebidas e químicos)
Industries:AddIndustry(
    'perfume_factory',
    'industry_perfume',
    1,
    spaceconfig.Industry.Tier.TERTIARY,
    'tertiary',
    vector3(590.0, -460.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            ['parfum_exclusive'] = { production = 15, price = 7000, storageSize = 150 },
            ['essence_flower'] = { production = 20, price = 4000, storageSize = 200 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['beverages'] = { amount_needed = 5, storageSize = 500 }, -- Para a base de álcool
            ['dyes'] = { amount_needed = 3, storageSize = 400 } -- Essências e fixadores químicos
        }
    }
):SetPurchasePrice(1000000)