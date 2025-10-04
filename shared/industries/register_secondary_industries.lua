-- METALLURGICAL
Industries:AddIndustry(
    config.Industry.Name.LOS_SANTOS_METALLURGICAL,
    Lang:t('industry_name_los_santos_metallurgical'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.METALLURGICAL,
    vector3(1054.3702, -1953.0300, 32.0949),
    { -- for Sale Storage Location
        ['metal_ores'] = vector3(1062.3563, -1973.6201, 31.0146)
    },
    {
        ['ore'] = vector3(1074.3619, -1950.9128, 31.0142)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['metal_ores'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_METALLURGICAL, 'metal_ores').price, --random min max
                production = 8, -- tons, per resource consumption
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['ore'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_METALLURGICAL, 'ore').profitPrice, --random min max
                consumption = 10, -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- MINT

Industries:AddIndustry(
    config.Industry.Name.SA_FEDERAL_MINT,
    Lang:t('industry_name_sa_federal_mint'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.MINT,
    vector3(2523.7119, -387.5529, 92.4591),
    { -- for Sale Storage Location
        ['coins'] = vector3(2499.8105, -332.1153, 92.9928),
    },
    {
        ['metal_ores'] = vector3(2523.9309, -463.3430, 92.4666),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SA_FEDERAL_MINT, 'coins').price, --random min max
                production = 5, -- tons, per resource consumption
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['metal_ores'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SA_FEDERAL_MINT, 'metal_ores').profitPrice, --random min max
                consumption = 10, -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO


-- STEEL FEDERAL FACTORY
Industries:AddIndustry(
    config.Industry.Name.FEDERAL_STEEL_MILL,
    Lang:t('industry_name_federal_steel_mill'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.STEEL_MILL,
    vector3(-264.9231, 6083.8315, 31.4114),
    { -- for Sale Storage Location
        ['steel_shapes'] = vector3(-250.9579, 6063.4272, 31.7384)
    },
    {
        ['scrap_metal'] = vector3(-271.8398, 6063.3975, 31.4646),
        ['metal_ores'] = vector3(-263.5433, 6054.8887, 31.7076)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['steel_shapes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_STEEL_MILL, 'steel_shapes').price, --random min max
                production = 5, -- tons, per resource consumption
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['scrap_metal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_STEEL_MILL, 'scrap_metal').profitPrice, --random min max
                consumption = 10, -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['metal_ores'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_STEEL_MILL, 'metal_ores').profitPrice, --random min max
                consumption = 10, -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- WEAPON FEDERAL FACTORY
Industries:AddIndustry(
    config.Industry.Name.FEDERAL_WEAPON_FACTORY,
    Lang:t('industry_name_federal_weapon_factory'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.WEAPON_FACTORY,
    vector3(843.9730, -2118.1660, 30.5211),
    { -- for Sale Storage Location
        ['weapons'] = vector3(821.6835, -2138.8210, 29.1480)
    },
    {
        ['gunpowder'] = vector3(812.8181, -2118.1289, 28.8177),
        ['steel_shapes'] = vector3(832.3459, -2139.9341, 28.9138)
    },
    {
        [config.Industry.TradeType.FORSALE] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_WEAPON_FACTORY, 'weapons').price, --random min max
                production = 7, --, per resource consumption
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['gunpowder'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_WEAPON_FACTORY, 'gunpowder').profitPrice, --random min max
                consumption = 10, --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            },
            ['steel_shapes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.FEDERAL_WEAPON_FACTORY, 'steel_shapes').profitPrice, --random min max
                consumption = 10,
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO

-- SAWMILL FACTORY
Industries:AddIndustry(
    config.Industry.Name.SAWMILL_FACTORY,
    Lang:t('industry_name_sawmill_factory'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.SAWMILL,
    vector3(-566.0605, 5326.0601, 73.5929),
    { -- for Sale Storage Location
        ['paper'] = vector3(-580.3348, 5247.5566, 70.4658),
        ['furniture'] = vector3(-516.3372, 5246.0410, 80.0830),
        ['wood_plank'] = vector3(-588.7365, 5303.6816, 70.2144)
    },
    {
        ['wood_log'] = vector3(-563.2211, 5370.7798, 70.2145)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SAWMILL_FACTORY, 'paper').price, --random min max
                production = 15, --, per resource consumption
                storageSize = 100,  --
                inStock = math.random(10,20), --
            },
            ['furniture'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SAWMILL_FACTORY, 'furniture').price, --random min max
                production = 10, --, per resource consumption
                storageSize = 100,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SAWMILL_FACTORY, 'wood_plank').price, --random min max
                production = 10, --, per resource consumption
                storageSize = 300,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['wood_log'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SAWMILL_FACTORY, 'wood_log').profitPrice, --random min max
                consumption = 20, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- BROS TEXTILE FACTORY
Industries:AddIndustry(
    config.Industry.Name.BROS_TEXTILE_FACTORY,
    Lang:t('industry_name_bros_textile_factory'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.TEXTILE_FACTORY,
    vector3(715.0296, -963.8358, 30.3953),
    { -- for Sale Storage Location
        ['clothes'] = vector3(750.9177, -948.1213, 25.6326)
    },
    {
        ['cotton'] = vector3(746.5177, -968.0457, 24.6763),
        ['dyes'] = vector3(759.3189, -966.7310, 25.3627)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BROS_TEXTILE_FACTORY, 'clothes').price, --random min max
                production = 10, --, per resource consumption
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['cotton'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BROS_TEXTILE_FACTORY, 'cotton').profitPrice, --random min max
                consumption = 5, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BROS_TEXTILE_FACTORY, 'dyes').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- PIßWASSER BREWERY
Industries:AddIndustry(
    config.Industry.Name.PIBWASSER_BREWERY,
    Lang:t('industry_name_pibwasser_brewery'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.BREWERY,
    vector3(901.2327, -1852.3667, 31.3970),
    { -- for Sale Storage Location
        ['beverages'] = vector3(837.9378, -1943.2960, 28.54990)
    },
    {
        ['malt'] = vector3(843.1260, -1840.2421, 29.1039)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PIBWASSER_BREWERY, 'beverages').price, --random min max
                production = 22, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['malt'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PIBWASSER_BREWERY, 'malt').profitPrice, --random min max
                consumption = 8, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- PALETO BAY FOOD PROCESSING PLANT
Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT,
    Lang:t('industry_name_paleto_bay_food_processing_plant'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.FOOD_PROCESSING_PLANT,
    vector3(-68.5297, 6270.1255, 31.3385),
    { -- for Sale Storage Location
        ['meal'] = vector3(-122.9500, 6213.6997, 31.2017)
    },
    {
        -- ['fruits'] = vector3(35.8954, 6293.1719, 31.2350),
        ['eggs'] = vector3(44.3613, 6297.1172, 31.2370),
        ['meat'] = vector3(55.6064, 6302.5977, 31.2344),
        ['cereal'] = vector3(67.7476, 6304.7529, 31.2495),
        ['milk'] = vector3(70.5302, 6328.5083, 31.2256)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'meal').price, --random min max
                production = 5, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            -- ['fruits'] = {
            --     price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'fruits').profitPrice, --random min max
            --     consumption = 5, --200$
            --     storageSize = 200,  --
            --     inStock = math.random(10,20), --
            -- },
            ['eggs'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'eggs').profitPrice, --random min max
                consumption = 5, --680$
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['meat'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'meat').profitPrice, --random min max
                consumption = 5, --1250$
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'cereal').profitPrice, --random min max
                consumption = 2, --4000$
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['milk'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_FOOD_PROCESSING_PLANT, 'milk').profitPrice, --random min max
                consumption = 2, -- 2000$
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- LOS SANTOS CONCRETE PLANT
Industries:AddIndustry(
    config.Industry.Name.LOS_SANTOS_CONCRETE_PLANT,
    Lang:t('industry_name_los_santos_concrete_plant'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.CONCRETE_PLANT,
    vector3(1219.0985, 1872.6376, 78.9219),
    { -- for Sale Storage Location
        ['building_materials'] = vector3(1202.6948, 1859.9675, 78.6887),
        ['concrete'] = vector3(1234.9785, 1902.1229, 78.3419)
    },
    {
        ['aggregate'] = vector3(1246.2220, 1862.0360, 79.4229),
        -- ['wood_log'] = vector3(1223.5735, 1840.2642, 79.4352),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_CONCRETE_PLANT, 'building_materials').price, --random min max
                production = 15, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_CONCRETE_PLANT, 'concrete').price, --random min max
                production = 10, --, per resource consumption
                storageSize = 500,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['aggregate'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_CONCRETE_PLANT, 'aggregate').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            -- ['wood_log'] = {
            --     price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_CONCRETE_PLANT, 'wood_log').profitPrice, --random min max
            --     consumption = 10, --
            --     storageSize = 200,  --
            --     inStock = math.random(10,20), --
            -- },
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- THE MOUNT DISTILLERY
Industries:AddIndustry(
    config.Industry.Name.THE_MOUNT_DISTILLERY,
    Lang:t('industry_name_the_mount_distillery'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.DISTILLERY,
    vector3(-1895.6581, 2049.9819, 140.7593),
    { -- for Sale Storage Location
        ['beverages'] = vector3(-1921.0453, 2054.6165, 140.7352)
    },
    {
        ['fruits'] = vector3(-1923.4646, 2041.0973, 140.7351)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.THE_MOUNT_DISTILLERY, 'beverages').price, --random min max
                production = 15, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.THE_MOUNT_DISTILLERY, 'fruits').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- TRADITION MALT HOUSE
Industries:AddIndustry(
    config.Industry.Name.TRADITION_MALT_HOUSE,
    Lang:t('industry_name_tradition_malt_house'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.MALT_HOUSE,
    vector3(-3027.9536, 503.3690, 6.8945),
    { -- for Sale Storage Location
        ['malt'] = vector3(-3029.3845, 496.8322, 6.8252)
    },
    {
        ['cereal'] = vector3(-3030.9707, 490.2504, 6.7515)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['malt'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TRADITION_MALT_HOUSE, 'malt').price, --random min max
                production = 15, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        },
        [config.Industry.TradeType.WANTED] = {
            ['cereal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TRADITION_MALT_HOUSE, 'cereal').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- APPLIANCES FACTORY
Industries:AddIndustry(
    config.Industry.Name.APPLIANCES_FACTORY,
    Lang:t('industry_name_appliances_factory'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.APPLIANCES,
    vector3(897.0044, -1724.3298, 32.1595),
    { -- for Sale Storage Location
        ['appliances'] = vector3(975.6829, -1718.5686, 30.5642),
        ['transformer'] = vector3(962.2137, -1709.4587, 30.2040)
    },
    {
        ['steel_shapes'] = vector3(908.1226, -1732.5598, 30.5926)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.APPLIANCES_FACTORY, 'appliances').price, --random min max
                production = 15, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['transformer'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.APPLIANCES_FACTORY, 'transformer').price, --random min max
                production = 5, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
        },
        [config.Industry.TradeType.WANTED] = {
            ['steel_shapes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.APPLIANCES_FACTORY, 'steel_shapes').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
-- LOS SANTOS AUTOS
Industries:AddIndustry(
    config.Industry.Name.LOS_SANTOS_AUTOS,
    Lang:t('industry_name_los_santos_autos'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.SECONDARY,
    config.Industry.Type.Secondary.AUTOS,
    vector3(270.9318, -3248.0979, 5.7903),
    { -- for Sale Storage Location
        ['vehicle'] = vector3(234.2402, -3327.3293, 5.7980),
        ['car_parts'] = vector3(209.1192, -3326.5425, 5.7929)
    },
    {
        ['steel_shapes'] = vector3(224.3200, -3110.9202, 5.7901),
        ['dyes'] = vector3(211.2470, -3124.5588, 5.7903)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {
            ['vehicle'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_AUTOS, 'vehicle').price, --random min max
                production = 1, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_AUTOS, 'car_parts').price, --random min max
                production = 5, --, per resource consumption
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
        },
        [config.Industry.TradeType.WANTED] = {
            ['steel_shapes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_AUTOS, 'steel_shapes').profitPrice, --random min max
                consumption = 10, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LOS_SANTOS_AUTOS, 'dyes').profitPrice, --random min max
                consumption = 20, --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
        }
    }
):SetPurchasePrice(1500000) -- <<<<<<< ADICIONE ESTA LINHA COM O PREÇO DESEJADO
