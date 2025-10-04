-- =================================================================
-- ARQUIVO DE REGISTRO DAS INDÚSTRIAS TERCIÁRIAS (CORRIGIDO)
-- =================================================================

-- 1. Indústria de Eletrônicos
Industries:AddIndustry(
    'electronics_mfg',
    Lang:t('industry_electronics'), -- CORRIGIDO: Agora usa a função de tradução.
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_electronics',
    vector3(300.0, -900.0, 30.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['smartphone'] = { production = 10, price = 5000, storageSize = 100 },
            ['tablet']     = { production = 8,  price = 7000, storageSize = 80 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances']   = { amount_needed = 2, storageSize = 200 },
            ['steel_shapes'] = { amount_needed = 1, storageSize = 150 }
        }
    }
):SetPurchasePrice(1200000)

-- 2. Indústria de Móveis de Luxo
Industries:AddIndustry(
    'luxury_furniture',
    Lang:t('industry_furniture'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_furniture',
    vector3(320.0, -880.0, 32.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['sofa_modern'] = { production = 5, price = 12000, storageSize = 50 },
            ['mesa_vidro']  = { production = 7, price = 8000, storageSize = 70 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['wood_plank']   = { amount_needed = 5, storageSize = 500 },
            ['steel_shapes'] = { amount_needed = 3, storageSize = 300 }
        }
    }
):SetPurchasePrice(900000)

-- 3. Indústria de Automóveis Elétricos
Industries:AddIndustry(
    'ev_manufacturer',
    Lang:t('industry_ev'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_ev',
    vector3(350.0, -850.0, 28.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['electric_car']   = { production = 1, price = 100000, storageSize = 10 },
            ['motor_electric'] = { production = 5, price = 20000, storageSize = 50 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances']   = { amount_needed = 4, storageSize = 200 },
            ['steel_shapes'] = { amount_needed = 5, storageSize = 400 }
        }
    }
):SetPurchasePrice(2500000)

-- 4. Indústria de Cosméticos
Industries:AddIndustry(
    'cosmetics',
    Lang:t('industry_cosmetics'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_cosmetics',
    vector3(280.0, -920.0, 29.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['perfume']     = { production = 20, price = 3000, storageSize = 200 },
            ['creme_rejuv'] = { production = 15, price = 5000, storageSize = 150 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['dyes']      = { amount_needed = 4, storageSize = 400 },
            ['beverages'] = { amount_needed = 2, storageSize = 300 }
        }
    }
):SetPurchasePrice(800000)

-- 5. Indústria de Roupa de Grife
Industries:AddIndustry(
    'fashion_brand',
    Lang:t('industry_fashion'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_fashion',
    vector3(360.0, -870.0, 30.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['jaqueta_luxo']  = { production = 10, price = 10000, storageSize = 100 },
            ['sapato_design'] = { production = 12, price = 8000, storageSize = 120 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = { amount_needed = 10, storageSize = 1000 },
            ['coins']   = { amount_needed = 2, storageSize = 400 }
        }
    }
):SetPurchasePrice(950000)

-- 6. Indústria de Eletrônicos Domésticos
Industries:AddIndustry(
    'home_electronics',
    Lang:t('industry_home_elec'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_home_electronics',
    vector3(400.0, -800.0, 25.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['smart_tv'] = { production = 6, price = 15000, storageSize = 60 },
            ['soundbar'] = { production = 8, price = 6000, storageSize = 80 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 3, storageSize = 300 },
            ['wood_plank'] = { amount_needed = 2, storageSize = 250 }
        }
    }
):SetPurchasePrice(1100000)

-- 7. Indústria de Dispositivos Médicos
Industries:AddIndustry(
    'medical_devices',
    Lang:t('industry_medical'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_medical',
    vector3(420.0, -760.0, 26.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['scanner_ct'] = { production = 1, price = 200000, storageSize = 10 },
            ['ventilator'] = { production = 4, price = 80000, storageSize = 40 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances']   = { amount_needed = 5, storageSize = 500 },
            ['steel_shapes'] = { amount_needed = 6, storageSize = 600 }
        }
    }
):SetPurchasePrice(3000000)

-- 8. Indústria de Equipamentos de Telecomunicações
Industries:AddIndustry(
    'telecom_equip',
    Lang:t('industry_telecom'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_telecom',
    vector3(450.0, -720.0, 27.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['router_5g']     = { production = 10, price = 12000, storageSize = 100 },
            ['antenna_array'] = { production = 7, price = 25000, storageSize = 70 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 5, storageSize = 500 },
            ['dyes']       = { amount_needed = 3, storageSize = 400 }
        }
    }
):SetPurchasePrice(1800000)

-- 9. Indústria de Jogos Eletrônicos / Consoles
Industries:AddIndustry(
    'gaming_hardware',
    Lang:t('industry_gaming'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_gaming',
    vector3(470.0, -680.0, 28.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['console_nextgen'] = { production = 4, price = 100000, storageSize = 40 },
            ['vr_headset']      = { production = 6, price = 45000, storageSize = 60 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = { amount_needed = 3, storageSize = 300 },
            ['dyes']       = { amount_needed = 4, storageSize = 400 }
        }
    }
):SetPurchasePrice(1500000)

-- 10. Indústria de Automação / Robôs
Industries:AddIndustry(
    'robotics',
    Lang:t('industry_robotics'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_robotics',
    vector3(490.0, -640.0, 29.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['robot_arm']       = { production = 5, price = 50000, storageSize = 50 },
            ['automation_unit'] = { production = 8, price = 3000, storageSize = 80 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['metal_ores']   = { amount_needed = 6, storageSize = 600 },
            ['steel_shapes'] = { amount_needed = 5, storageSize = 500 }
        }
    }
):SetPurchasePrice(2200000)

-- 11. Indústria de Produtos de Luxo / Relógios
Industries:AddIndustry(
    'luxury_watches',
    Lang:t('industry_watches'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_watches',
    vector3(510.0, -600.0, 30.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['watch_gold']   = { production = 10, price = 25000, storageSize = 100 },
            ['watch_silver'] = { production = 15, price = 12000, storageSize = 150 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = { amount_needed = 4, storageSize = 400 },
            ['dyes']  = { amount_needed = 2, storageSize = 200 }
        }
    }
):SetPurchasePrice(1200000)

-- 12. Indústria de Software
Industries:AddIndustry(
    'software_dev',
    Lang:t('industry_software'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_software',
    vector3(530.0, -580.0, 32.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['packaged_software'] = { production = 20, price = 1500, storageSize = 200 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['wood_plank'] = { amount_needed = 2, storageSize = 400 },
            ['appliances'] = { amount_needed = 1, storageSize = 250 }
        }
    }
):SetPurchasePrice(900000)

-- 13. Indústria de Moda / Acessórios
Industries:AddIndustry(
    'fashion_accessories',
    Lang:t('industry_accessories'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_accessories',
    vector3(550.0, -540.0, 33.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['bolsa_couro']   = { production = 12, price = 8000, storageSize = 120 },
            ['oculos_design'] = { production = 10, price = 9000, storageSize = 100 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = { amount_needed = 6, storageSize = 600 },
            ['coins']   = { amount_needed = 1, storageSize = 300 }
        }
    }
):SetPurchasePrice(850000)

-- 14. Indústria de Bebidas Premium
Industries:AddIndustry(
    'premium_beverage',
    Lang:t('industry_beverage'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_beverage',
    vector3(570.0, -500.0, 28.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['wine_premium'] = { production = 8, price = 20000, storageSize = 80 },
            ['whisky_aged']  = { production = 4, price = 50000, storageSize = 40 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['malt']       = { amount_needed = 10, storageSize = 1000 },
            ['wood_plank'] = { amount_needed = 4, storageSize = 400 }
        }
    }
):SetPurchasePrice(1300000)

-- 15. Indústria de Perfumes / Fragrâncias
Industries:AddIndustry(
    'perfume_factory',
    Lang:t('industry_perfume'), -- CORRIGIDO
    config.Industry.Status.OPEN,
    config.Industry.Tier.TERTIARY,
    'tertiary_perfume',
    vector3(590.0, -460.0, 29.0),
    {}, {},
    {
        [config.Industry.TradeType.FORSALE] = {
            ['parfum_exclusive'] = { production = 15, price = 7000, storageSize = 150 },
            ['essence_flower']   = { production = 20, price = 4000, storageSize = 200 }
        },
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = { amount_needed = 5, storageSize = 500 },
            ['dyes']      = { amount_needed = 3, storageSize = 400 }
        }
    }
):SetPurchasePrice(1000000)