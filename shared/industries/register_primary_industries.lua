-- OIL FIELD
Industries:AddIndustry(
    config.Industry.Name.OILFIELD_MURRIETA,-- This is industry name define in config
    Lang:t('industry_name_oilfield_murrieta'),-- This is label of industry
    config.Industry.Status.OPEN,           -- Status default is Open  
    config.Industry.Tier.PRIMARY,          -- Tier: PRIMARY, SECONDARY, BUSINESS
    config.Industry.Type.Primary.OILFIELD,         -- Type: OILFIELD define in config
    vector3(1535.7732, -2098.0173, 77.1174),  -- vector3: Main Location of industry
    { -- for Sale Storage Location
        ['fuel'] = vector3(1548.8333, -2116.9224, 77.2558)
    },
    {
        -- In this case, this is primary industry and don't need anything
    }, --Wanted Storage Location
    {
        -- This is Trade Data of industry
        [config.Industry.TradeType.FORSALE] = {
            ['fuel'] = {
                -- use func Industries:GetIndustryItemPriceData(industryName, itemName) to get price of item (Will random when restart sv)
                -- for forsale we will use ().price for wanted we will use ().profitPrice
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.OILFIELD_MURRIETA, 'fuel').price, --random min max
                production = math.random(10,15), --Number of resource production per hour
                storageSize = 100,  --Number of storage size
                inStock = math.random(10,50), --Number of in stock storage
            }
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- CHEMICALS

Industries:AddIndustry(
    config.Industry.Name.CHEMICAL_FACTORY,
    Lang:t('industry_name_chemical_factory'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.CHEMICAL,
    vector3(3424.7166, 3761.3540, 30.6424),
    { -- for Sale Storage Location
        ['gunpowder'] = vector3(3609.2507, 3733.7976, 28.6901),
        ['dyes'] = vector3(3460.5471, 3682.1433, 32.8651),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['gunpowder'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHEMICAL_FACTORY, 'gunpowder').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 100,  -- crate
                inStock = math.random(10,50), -- crate
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHEMICAL_FACTORY, 'dyes').price, --random min max
                production = math.random(15,25), -- crate
                storageSize = 400,  -- crate
                inStock = math.random(40,50), -- crate
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- SCRAPYARD
Industries:AddIndustry(
    config.Industry.Name.ROGERS_SCRAPYARD,
    Lang:t('industry_name_rogers_scrapyard'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.SCRAPYARD,
    vector3(-428.9064, -1728.5099, 19.7838),
    { -- for Sale Storage Location
        ['scrap_metal'] = vector3(-424.3152, -1684.7904, 19.0291),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['scrap_metal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROGERS_SCRAPYARD, 'scrap_metal').price, --random min max
                production = math.random(25,45), -- tonnes per hours
                storageSize = 500,  -- tonnes
                inStock = math.random(70,150), -- tonnes
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.THOMSON_SCRAPYARD,
    Lang:t('industry_name_thomson_scrapyard'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.SCRAPYARD,
    vector3(2392.1606, 3121.2771, 48.1520),
    { -- for Sale Storage Location
        ['scrap_metal'] = vector3(2376.2388, 3121.2212, 48.0934),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['scrap_metal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.THOMSON_SCRAPYARD, 'scrap_metal').price, --random min max
                production = math.random(25,45), -- tonnes per hours
                storageSize = 400,  -- tonnes
                inStock = math.random(70,150), -- tonnes
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- FOREST
Industries:AddIndustry(
    config.Industry.Name.FOREST_CENTER,
    Lang:t('industry_name_forest_center'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FOREST,
    vector3(1531.5858, 1727.7963, 109.9243),
    { -- for Sale Storage Location
        ['wood_log'] = vector3(1524.4712, 1723.2703, 110.0111),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['wood_log'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FOREST_CENTER, 'wood_log').price, --random min max
                production = math.random(5,15), -- pallet
                storageSize = 100,  -- pallet
                inStock = math.random(10,50), -- pallet
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- FARM
Industries:AddIndustry(
    config.Industry.Name.ZANCUDO_FARM,
    Lang:t('industry_name_zancudo_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(421.0968, 6474.4663, 28.8128),
    { -- for Sale Storage Location
        ['fruits'] = vector3(407.9106, 6493.8721, 28.0804),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ZANCUDO_FARM, 'fruits').price, --random min max
                production = math.random(5,15), -- crates
                storageSize = 200,  -- crates
                inStock = math.random(10,50), -- crates
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_FARM,
    Lang:t('industry_name_paleto_bay_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(414.6897, 6616.3325, 27.5510),
    { -- for Sale Storage Location
        ['cotton'] = vector3(404.9787, 6619.0591, 28.2106),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['cotton'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FARM, 'cotton').price, --random min max
                production = math.random(5,15), -- tonnes
                storageSize = 100,  -- tonnes
                inStock = math.random(10,50), -- tonnes
            }
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.N10_FARM,
    Lang:t('industry_name_n10_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2931.6179, 4624.7612, 48.7236),
    { -- for Sale Storage Location
        ['cereal'] = vector3(2928.5081, 4638.2798, 48.5450),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N10_FARM, 'cereal').price, --random min max
                production = math.random(2,5), -- tonnes
                storageSize = 100,  -- tonnes
                inStock = math.random(10,50), -- tonnes
            }
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.N11_FARM,
    Lang:t('industry_name_n11_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2569.8550, 4667.4697, 34.0768),
    { -- for Sale Storage Location
        ['cereal'] = vector3(2553.5840, 4676.2227, 33.9264),
        ['milk'] = vector3(2572.3301, 4698.6455, 34.0768),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N11_FARM, 'cereal').price, --random min max
                production = math.random(2,6), -- tonnes
                storageSize = 100,  -- tonnes
                inStock = math.random(10,50), -- tonnes
            },
            ['milk'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N11_FARM, 'milk').price, --random min max
                production = math.random(1,5), -- m3
                storageSize = 50,  -- m3
                inStock = math.random(10,20), -- m3
            }
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.N12_FARM,
    Lang:t('industry_name_n12_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2335.6589, 4859.8193, 41.8025),
    { -- for Sale Storage Location
        ['milk'] = vector3(2345.0295, 4925.7554, 42.0622),
        ['eggs'] = vector3(2414.6946, 4992.2891, 46.2327),
        ['cereal'] = vector3(2297.6255, 4896.0273, 41.2281),
        ['cotton'] = vector3(2476.5645, 4949.9194, 45.0856),
        ['meat'] = vector3(2311.6543, 4891.1777, 41.8082),
        ['fruits'] = vector3(2302.3384, 4884.0459, 41.8082),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['milk'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'milk').price, --random min max
                production = math.random(2,5), -- m3
                storageSize = 200,  -- m3
                inStock = math.random(10,20), -- m3
            },
            ['eggs'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'eggs').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 500,  -- crate
                inStock = math.random(10,20), -- crate
            },
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'cereal').price, --random min max
                production = math.random(3,6), -- tons
                storageSize = 200,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['cotton'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'cotton').price, --random min max
                production = math.random(5,15), -- tonnes
                storageSize = 200,  -- tonnes
                inStock = math.random(10,50), -- tonnes
            },
            ['meat'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'meat').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 200,  -- crate
                inStock = math.random(10,50), -- crate
            },
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N12_FARM, 'fruits').price, --random min max
                production = math.random(5,15), -- crates
                storageSize = 300,  -- crates
                inStock = math.random(10,50), -- crates
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.N13_FARM,
    Lang:t('industry_name_n13_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2433.4119, 4983.8628, 45.9908),
    { -- for Sale Storage Location
        ['eggs'] = vector3(1535.7732, -2098.0173, 77.1174),
        ['cereal'] = vector3(1535.7732, -2098.0173, 77.1174),
        ['cotton'] = vector3(1535.7732, -2098.0173, 77.1174),
        ['meat'] = vector3(1535.7732, -2098.0173, 77.1174),
        ['milk'] = vector3(1535.7732, -2098.0173, 77.1174),
        ['fruits'] = vector3(1535.7732, -2098.0173, 77.1174),
    },
    {} --Wanted Storage Location
)

Industries:AddIndustry(
    config.Industry.Name.N14_FARM,
    Lang:t('industry_name_n14_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2258.1997, 5166.0815, 59.1117),
    { -- for Sale Storage Location
        ['cereal'] = vector3(2225.8896, 5162.6548, 57.9757),
        ['meat'] = vector3(2180.5811, 5071.0791, 44.4158),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N14_FARM, 'cereal').price, --random min max
                production = math.random(1,5), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['meat'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N14_FARM, 'meat').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 100,  -- crate
                inStock = math.random(10,50), -- crate
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.N15_FARM,
    Lang:t('industry_name_n15_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(2030.4678, 4979.8286, 42.0982),
    { -- for Sale Storage Location
        ['cotton'] = vector3(2026.2761, 4967.9912, 41.2629),
        ['fruits'] = vector3(2018.5172, 4978.3643, 41.2469),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['cotton'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N15_FARM, 'cotton').price, --random min max
                production = math.random(5,15), -- tonnes
                storageSize = 200,  -- tonnes
                inStock = math.random(10,50), -- tonnes
            },
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.N15_FARM, 'fruits').price, --random min max
                production = math.random(5,15), -- crates
                storageSize = 100,  -- crates
                inStock = math.random(10,50), -- crates
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

Industries:AddIndustry(
    config.Industry.Name.LA_FUENTE_FARM,
    Lang:t('industry_name_la_fuente_farm'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.FARM,
    vector3(1423.8872, 1121.5966, 114.4927),
    { -- for Sale Storage Location
        ['eggs'] = vector3(1443.7283, 1129.7209, 114.3340),
        ['meat'] = vector3(1429.4451, 1084.7301, 114.2015),
        ['milk'] = vector3(1502.4724, 1096.2672, 114.2981),
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['milk'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_FUENTE_FARM, 'milk').price, --random min max
                production = math.random(1,5), -- m3
                storageSize = 100,  -- m3
                inStock = math.random(10,20), -- m3
            },
            ['eggs'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_FUENTE_FARM, 'eggs').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 100,  -- crate
                inStock = math.random(10,20), -- crate
            },
            ['meat'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_FUENTE_FARM, 'meat').price, --random min max
                production = math.random(5,15), -- crate
                storageSize = 100,  -- crate
                inStock = math.random(10,50), -- crate
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- Mineral
Industries:AddIndustry(
    config.Industry.Name.DAVIS_MINERAL,
    Lang:t('industry_name_davis_mineral'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.MINERAL,
    vector3(2569.4121, 2719.1189, 42.8701),
    { -- for Sale Storage Location
        ['ore'] = vector3(2777.7979, 2809.2473, 41.5213),
        ['aggregate'] = vector3(2695.2415, 2750.9521, 37.5748)
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['ore'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_MINERAL, 'ore').price, --random min max
                production = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['aggregate'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_MINERAL, 'aggregate').price, --random min max
                production = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- Quarry
Industries:AddIndustry(
    config.Industry.Name.DAVIS_QUARRY,
    Lang:t('industry_name_davis_quarry'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.PRIMARY,
    config.Industry.Type.Primary.QUARRY,
    vector3(286.7050, 2842.9561, 44.7041),
    { -- for Sale Storage Location
        ['aggregate'] = vector3(350.5555, 2918.2642, 41.2793)
    },
    {}, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['aggregate'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_QUARRY, 'aggregate').price, --random min max
                production = math.random(5,15), -- tons
                storageSize = 80,  -- tons
                inStock = math.random(10,20), -- tons
            }
        },
        [config.Industry.TradeType.WANTED] = {}
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

