-- Exemplo: registrar 15 indústrias terciárias

-- Helper: para cada indústria você define nome, tradução, status, tier, tipo “tertiary”, localização, etc.

-- 1. Indústria de Eletrônicos
Industries:AddIndustry(
    'electronics_mfg',
    'industry_electronics',
    1,
    3,
    'tertiary',
    vector3(300.0, -900.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'smartphone', amount = 10, price = 5000 },
            { product = 'tablet', amount = 8, price = 7000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'circuit_board', amount = 20 },
            { product = 'microchip', amount = 15 }
        }
    }
):SetPurchasePrice(120000)

-- 2. Indústria de Móveis de Luxo
Industries:AddIndustry(
    'luxury_furniture',
    'industry_furniture',
    1,
    3,
    'tertiary',
    vector3(320.0, -880.0, 32.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'sofa_modern', amount = 5, price = 12000 },
            { product = 'mesa_vidro', amount = 7, price = 8000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'wood_planks', amount = 50 },
            { product = 'metal_frames', amount = 30 }
        }
    }
):SetPurchasePrice(900000)

-- 3. Indústria de Automóveis Elétricos
Industries:AddIndustry(
    'ev_manufacturer',
    'industry_ev',
    1,
    3,
    'tertiary',
    vector3(350.0, -850.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'electric_car', amount = 3, price = 100000 },
            { product = 'motor_electric', amount = 5, price = 20000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'battery_pack', amount = 20 },
            { product = 'aluminum_sheet', amount = 40 }
        }
    }
):SetPurchasePrice(2500000)

-- 4. Indústria de Cosméticos
Industries:AddIndustry(
    'cosmetics',
    'industry_cosmetics',
    1,
    3,
    'tertiary',
    vector3(280.0, -920.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'perfume', amount = 20, price = 3000 },
            { product = 'creme_rejuv', amount = 15, price = 5000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'essence_oil', amount = 40 },
            { product = 'bottle_glass', amount = 60 }
        }
    }
):SetPurchasePrice(800000)

-- 5. Indústria de Roupa de Grife
Industries:AddIndustry(
    'fashion_brand',
    'industry_fashion',
    1,
    3,
    'tertiary',
    vector3(360.0, -870.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'jaqueta_luxo', amount = 10, price = 10000 },
            { product = 'sapato_design', amount = 12, price = 8000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'tecido', amount = 100 },
            { product = 'zippers', amount = 40 }
        }
    }
):SetPurchasePrice(950000)

-- 6. Indústria de Eletrônicos Domésticos
Industries:AddIndustry(
    'home_electronics',
    'industry_home_elec',
    1,
    3,
    'tertiary',
    vector3(400.0, -800.0, 25.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'smart_tv', amount = 6, price = 15000 },
            { product = 'soundbar', amount = 8, price = 6000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'lcd_panel', amount = 30 },
            { product = 'speaker_unit', amount = 25 }
        }
    }
):SetPurchasePrice(1100000)
-- 7. Indústria de Dispositivos Médicos
Industries:AddIndustry(
    'medical_devices',
    'industry_medical',
    1,
    3,
    'tertiary',
    vector3(420.0, -760.0, 26.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'scanner_ct', amount = 2, price = 200000 },
            { product = 'ventilator', amount = 4, price = 80000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'sensor_chip', amount = 50 },
            { product = 'steel_frame', amount = 60 }
        }
    }
):SetPurchasePrice(3000000)

-- 8. Indústria de Equipamentos de Telecomunicações
Industries:AddIndustry(
    'telecom_equip',
    'industry_telecom',
    1,
    3,
    'tertiary',
    vector3(450.0, -720.0, 27.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'router_5g', amount = 10, price = 12000 },
            { product = 'antenna_array', amount = 7, price = 25000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'fiber_optic', amount = 80 },
            { product = 'pcb_board', amount = 50 }
        }
    }
):SetPurchasePrice(1800000)

-- 9. Indústria de Jogos Eletrônicos / Consoles
Industries:AddIndustry(
    'gaming_hardware',
    'industry_gaming',
    1,
    3,
    'tertiary',
    vector3(470.0, -680.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'console_nextgen', amount = 4, price = 100000 },
            { product = 'vr_headset', amount = 6, price = 45000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'gpu_chip', amount = 30 },
            { product = 'plastics_mold', amount = 40 }
        }
    }
):SetPurchasePrice(1500000)

-- 10. Indústria de Automação / Robôs
Industries:AddIndustry(
    'robotics',
    'industry_robotics',
    1,
    3,
    'tertiary',
    vector3(490.0, -640.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'robot_arm', amount = 5, price = 50000 },
            { product = 'automation_unit', amount = 8, price = 3000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'servo_motor', amount = 60 },
            { product = 'control_board', amount = 50 }
        }
    }
):SetPurchasePrice(2200000)

-- 11. Indústria de Produtos de Luxo / Relógios
Industries:AddIndustry(
    'luxury_watches',
    'industry_watches',
    1,
    3,
    'tertiary',
    vector3(510.0, -600.0, 30.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'watch_gold', amount = 10, price = 25000 },
            { product = 'watch_silver', amount = 15, price = 12000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'watch_mechanism', amount = 40 },
            { product = 'jewelry_part', amount = 50 }
        }
    }
):SetPurchasePrice(1200000)

-- 12. Indústria de Software / Aplicativos
Industries:AddIndustry(
    'software_dev',
    'industry_software',
    1,
    3,
    'tertiary',
    vector3(530.0, -580.0, 32.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'mobile_app', amount = 20, price = 15000 },
            { product = 'web_service', amount = 10, price = 2000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'code_module', amount = 40 },
            { product = 'server_license', amount = 25 }
        }
    }
):SetPurchasePrice(900000)

-- 13. Indústria de Moda / Acessórios
Industries:AddIndustry(
    'fashion_accessories',
    'industry_accessories',
    1,
    3,
    'tertiary',
    vector3(550.0, -540.0, 33.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'bolsa_luxo', amount = 12, price = 8000 },
            { product = 'oculos_design', amount = 10, price = 9000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'leather_strip', amount = 60 },
            { product = 'glass_lens', amount = 30 }
        }
    }
):SetPurchasePrice(850000)

-- 14. Indústria de Bebidas Premium
Industries:AddIndustry(
    'premium_beverage',
    'industry_beverage',
    1,
    3,
    'tertiary',
    vector3(570.0, -500.0, 28.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'wine_premium', amount = 8, price = 20000 },
            { product = 'whisky_aged', amount = 4, price = 50000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'grape_bulk', amount = 100 },
            { product = 'oak_barrel', amount = 40 }
        }
    }
):SetPurchasePrice(1300000)

-- 15. Indústria de Perfumes / Fragrâncias
Industries:AddIndustry(
    'perfume_factory',
    'industry_perfume',
    1,
    3,
    'tertiary',
    vector3(590.0, -460.0, 29.0),
    {}, {},
    {
        [spaceconfig.Industry.TradeType.FORSALE] = {
            { product = 'parfum_exclusive', amount = 15, price = 7000 },
            { product = 'essence_flower', amount = 20, price = 4000 }
        },
        [spaceconfig.Industry.TradeType.WANTED] = {
            { product = 'alcohol_base', amount = 80 },
            { product = 'glass_bottle', amount = 60 }
        }
    }
):SetPurchasePrice(1000000)
