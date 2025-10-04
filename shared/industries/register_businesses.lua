
-- REDWOOD CONSTRUCTIONS
Industries:AddIndustry(
    config.Industry.Name.REDWOOD_CONSTRUCTIONS,
    Lang:t('industry_name_redwood_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(853.5978, 2381.1575, 54.2444),
    {},
    {
        ['building_materials'] = vector3(991.9453, 2390.2505, 51.6323),
        ['wood_plank'] = vector3(967.6069, 2404.9990, 51.8210),
        ['concrete'] = vector3(888.5733, 2432.0530, 49.8633)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.REDWOOD_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.REDWOOD_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.REDWOOD_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
)
-- ALTA CONSTRUCTIONS
Industries:AddIndustry(
    config.Industry.Name.ALTA_CONSTRUCTIONS,
    Lang:t('industry_name_alta_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(139.4140, -380.5334, 43.2569),
    {},
    {
        ['building_materials'] = vector3(92.8294, -385.2263, 41.2789),
        ['wood_plank'] = vector3(118.3571, -430.1888, 41.0947),
        ['concrete'] = vector3(126.7764, -399.1218, 41.2689)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALTA_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALTA_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALTA_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_STUNNING_CONSTRUCTIONS,
    Lang:t('industry_name_paleto_bay_stunning_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(107.0830, 6548.6094, 31.6023),
    {},
    {
        ['building_materials'] = vector3(79.6832, 6557.9087, 31.1155),
        ['wood_plank'] = vector3(57.0442, 6517.7622, 31.1329),
        ['concrete'] = vector3(59.0097, 6553.3218, 29.3983)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_STUNNING_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_STUNNING_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_STUNNING_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            }
        }
    }
)


Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_CLUCKIN_BELLE_CONSTRUCTIONS,
    Lang:t('industry_name_paleto_bay_cluckin_belle_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(151.1919, 6447.4487, 30.9202),
    {},
    {
        ['building_materials'] = vector3(151.1919, 6447.4487, 30.9202),
        ['wood_plank'] = vector3(131.7647, 6429.5073, 30.9905),
        ['concrete'] = vector3(125.2767, 6452.3569, 31.3833)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_CLUCKIN_BELLE_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 150,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_CLUCKIN_BELLE_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 150,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_CLUCKIN_BELLE_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 150,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ROCKFORD_HILLS_HOUSE_CONSTRUCTIONS,
    Lang:t('industry_name_rockford_hills_house_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(-982.2668, 399.9152, 74.2378),
    {},
    {
        ['building_materials'] = vector3(-982.2668, 399.9152, 74.2378),
        ['wood_plank'] = vector3(-965.8174, 404.6141, 76.1289),
        ['concrete'] = vector3(-974.4264, 394.7308, 74.6497)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_HOUSE_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_HOUSE_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_HOUSE_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 50,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILLS_CONSTRUCTIONS,
    Lang:t('industry_name_pillbox_hills_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(-103.4939, -1045.6713, 26.9231),
    {},
    {
        ['building_materials'] = vector3(-103.4939, -1045.6713, 26.9231),
        ['wood_plank'] = vector3(-136.3053, -1043.3981, 27.0159),
        ['concrete'] = vector3(-179.0794, -1034.3568, 26.8649)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILLS_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILLS_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILLS_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_STD_CONSTRUCTIONS,
    Lang:t('industry_name_little_seoul_std_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(-490.8513, -965.8513, 23.1720),
    {},
    {
        ['building_materials'] = vector3(-490.8513, -965.8513, 23.1720),
        ['wood_plank'] = vector3(-500.5004, -943.9609, 23.5789),
        ['concrete'] = vector3(-453.6955, -985.7295, 23.1721)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_STD_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_STD_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_STD_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MIRROR_PARK_LUXURY_HOME_CONSTRUCTIONS,
    Lang:t('industry_name_mirror_park_luxury_home_constructions'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CONSTRUCTIONS,
    vector3(1315.0502, -727.8927, 64.7286),
    {},
    {
        ['building_materials'] = vector3(1315.0502, -727.8927, 64.7286),
        ['wood_plank'] = vector3(1349.4314, -728.6263, 66.5942),
        ['concrete'] = vector3(1394.1782, -744.9858, 66.8190)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['building_materials'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_LUXURY_HOME_CONSTRUCTIONS, 'building_materials').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            },
            ['wood_plank'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_LUXURY_HOME_CONSTRUCTIONS, 'wood_plank').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            },
            ['concrete'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_LUXURY_HOME_CONSTRUCTIONS, 'concrete').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 250,  --
                inStock = math.random(10,20), --
            }
        }
    }
)
-- PALMER POWERPLANT
Industries:AddIndustry(
    config.Industry.Name.PALMER_POWERPLANT,
    Lang:t('industry_name_palmer_powerplant'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.POWERPLANT,
    vector3(2663.3040, 1640.0424, 24.6436),
    {},
    {
        ['transformer'] = vector3(2780.9246, 1477.4154, 24.5212)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['transformer'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALMER_POWERPLANT, 'transformer').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
)
-- SHERMAN POWERPLANT
Industries:AddIndustry(
    config.Industry.Name.SHERMAN_POWERPLANT,
    Lang:t('industry_name_sherman_powerplant'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.POWERPLANT,
    vector3(1533.4506, 822.6318, 77.4297),
    {},
    {
        ['transformer'] = vector3(1526.8955, 828.6978, 77.4509)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['transformer'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SHERMAN_POWERPLANT, 'transformer').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 200,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

-- PORT

-- Industries:AddIndustry(
--     config.Industry.Name.PORT_OF_LOS_SANTOS,
--     Lang:t('industry_name_port_of_los_santos'),
--     config.Industry.Status.OPEN,
--     config.Industry.Tier.BUSINESS,
--     config.Industry.Type.PORT,
--     vector3(1207.6649, -2993.9106, 5.8677),
--     {},
--     {
--         ['all'] = vector3(1207.6649, -2993.9106, 5.8677)
--     }, --Wanted Storage Location
--     {
--         [config.Industry.TradeType.WANTED] = {
--             ['transformer'] = {
--                 price = Industries:GetIndustryItemPriceData(config.Industry.Name.SHERMAN_POWERPLANT, 'transformer').profitPrice, --random min max
--                 consumption = math.random(5,15), --
--                 storageSize = 200,  --
--                 inStock = math.random(10,20), --
--             }
--         }
--     }
-- )
-- AMMUNATION
Industries:AddIndustry(
    config.Industry.Name.HAWICK_AMMUNATION,
    Lang:t('business_name_hawick_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(245.0138, -41.5357, 69.8965),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(245.0138, -41.5357, 69.8965)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.HAWICK_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.SANDY_SHORES_AMMUNATION,
    Lang:t('business_name_sandy_shores_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(1687.6783, 3755.5981, 34.5655),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(1687.6783, 3755.5981, 34.5655)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SANDY_SHORES_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MORNING_WOOD_AMMUNATION,
    Lang:t('business_name_morning_wood_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-1316.0438, -393.1887, 36.5902),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-1316.0438, -393.1887, 36.5902)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MORNING_WOOD_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LA_MESA_AMMUNATION,
    Lang:t('business_name_la_mesa_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(846.9286, -1020.3028, 27.5313),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(846.9286, -1020.3028, 27.5313)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_MESA_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILL_AMMUNATION,
    Lang:t('business_name_pillbox_hill_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-6.5789, -1107.7729, 28.9482),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-6.5789, -1107.7729, 28.9482)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILL_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_AMMUNATION,
    Lang:t('business_name_little_seoul_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-654.4268, -940.6837, 22.0611),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-654.4268, -940.6837, 22.0611)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.CHUMASH_AMMUNATION,
    Lang:t('business_name_chumash_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-3180.0488, 1093.1865, 20.8407),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-3180.0488, 1093.1865, 20.8407)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHUMASH_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TATAVIAM_AMMUNATION,
    Lang:t('business_name_tataviam_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(2578.9507, 285.3587, 108.6069),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(2578.9507, 285.3587, 108.6069)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TATAVIAM_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ZANCUDO_RIVER_AMMUNATION,
    Lang:t('business_name_zancudo_river_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-1130.4530, 2699.8799, 18.8004),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-1130.4530, 2699.8799, 18.8004)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ZANCUDO_RIVER_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_AMMUNATION,
    Lang:t('business_name_paleto_bay_ammunation'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AMMUNATION,
    vector3(-342.5292, 6098.1079, 31.3149),
    { -- for Sale Storage Location
    },
    {
        ['weapons'] = vector3(-342.5292, 6098.1079, 31.3149)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['weapons'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_AMMUNATION, 'weapons').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

-- RETAIL_STORE

Industries:AddIndustry(
    config.Industry.Name.MOUNT_CHILIAD_RETAIL_STORE,
    Lang:t('business_name_mount_chiliad_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1741.7788, 6419.9287, 35.0420),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(1741.7788, 6419.9287, 35.0420),
        ['beverages'] = vector3(1722.8743, 6418.1973, 35.0007),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MOUNT_CHILIAD_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MOUNT_CHILIAD_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAPESEED_RETAIL_STORE,
    Lang:t('business_name_grapeseed_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1702.5758, 4917.0889, 42.0781),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(1702.5758, 4917.0889, 42.0781),
        ['beverages'] = vector3(1711.1659, 4929.5674, 42.0781),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAPESEED_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAPESEED_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.SANDY_SHORES_RETAIL_STORE,
    Lang:t('business_name_sandy_shores_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1961.4187, 3742.5601, 32.3438),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(1961.1208, 3753.4438, 32.2574),
        ['beverages'] = vector3(1963.8235, 3749.6936, 32.2603),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SANDY_SHORES_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SANDY_SHORES_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.SANDY_SHORES_LIQUOR_RETAIL_STORE,
    Lang:t('business_name_sandy_shores_liquor_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1408.2147, 3619.8721, 34.8943),
    { -- for Sale Storage Location
    },
    {
        ['beverages'] = vector3(1408.2147, 3619.8721, 34.8943),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SANDY_SHORES_LIQUOR_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_RETAIL_STORE,
    Lang:t('business_name_grand_senora_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(2663.0457, 3272.2874, 55.2405),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(2663.0457, 3272.2874, 55.2405),
        ['beverages'] = vector3(2665.2942, 3276.4846, 55.2405),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_NO2_RETAIL_STORE,
    Lang:t('business_name_grand_senora_no2_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(543.2355, 2659.1892, 42.1779),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(543.2355, 2659.1892, 42.1779),
        ['beverages'] = vector3(550.8824, 2655.4771, 42.2241),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO2_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO2_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_LIQUOR_RETAIL_STORE,
    Lang:t('business_name_grand_senora_liquor_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1169.3452, 2701.2595, 38.1769),
    { -- for Sale Storage Location
    },
    {
        ['beverages'] = vector3(1169.3452, 2701.2595, 38.1769),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_LIQUOR_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TATAVIAM_RETAIL_STORE,
    Lang:t('business_name_tataviam_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(2546.6084, 382.1569, 108.6185),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(2546.6084, 382.1569, 108.6185),
        ['beverages'] = vector3(2546.2302, 385.9966, 108.6179),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TATAVIAM_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TATAVIAM_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DOWNTOWN_RETAIL_STORE,
    Lang:t('business_name_downtown_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(372.1256, 341.1780, 103.2150),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(372.1256, 341.1780, 103.2150),
        ['beverages'] = vector3(370.5577, 337.4678, 103.3145),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DOWNTOWN_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DOWNTOWN_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MIRROR_PARK_RETAIL_STORE,
    Lang:t('business_name_mirror_park_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1160.8375, -312.1042, 69.2777),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(1160.8375, -312.1042, 69.2777),
        ['beverages'] = vector3(1156.4966, -312.4938, 69.2354),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MURRIETA_HEIGHTS_RETAIL_STORE,
    Lang:t('business_name_murrieta_heights_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(1118.7880, -984.1256, 46.2934),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(1118.7880, -984.1256, 46.2934),
        ['beverages'] = vector3(1130.2206, -989.5052, 45.9662),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MURRIETA_HEIGHTS_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MURRIETA_HEIGHTS_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.RICHMAN_GLEN_RETAIL_STORE,
    Lang:t('business_name_richman_glen_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-1824.5325, 784.6678, 138.2247),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(-1824.5325, 784.6678, 138.2247),
        ['beverages'] = vector3(-1819.3593, 789.9213, 138.1367),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.RICHMAN_GLEN_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.RICHMAN_GLEN_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.CHUMASH_RETAIL_STORE,
    Lang:t('business_name_chumash_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-3237.0869, 1001.3798, 12.5162),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(-3237.0869, 1001.3798, 12.5162),
        ['beverages'] = vector3(-3237.4260, 1007.7726, 12.3822),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHUMASH_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHUMASH_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BANHAM_CANYON_INESENO_RETAIL_STORE,
    Lang:t('business_name_banham_canyon_ineseno_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-3047.2988, 590.0582, 7.7842),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(-3047.2988, 590.0582, 7.7842),
        ['beverages'] = vector3(-3051.0669, 589.8620, 7.6110),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BANHAM_CANYON_INESENO_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BANHAM_CANYON_INESENO_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BANHAM_CANYON_LIQUOR_RETAIL_STORE,
    Lang:t('business_name_banham_canyon_liquor_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-2959.9631, 396.7191, 15.0284),
    { -- for Sale Storage Location
    },
    {
        ['beverages'] = vector3(-2959.9631, 396.7191, 15.0284)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BANHAM_CANYON_LIQUOR_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MORNINGWOOD_LIQUOR_RETAIL_STORE,
    Lang:t('business_name_morningwood_liquor_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-1492.8568, -382.5958, 40.1441),
    { -- for Sale Storage Location
    },
    {
        ['beverages'] = vector3(-1492.8568, -382.5958, 40.1441),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MORNINGWOOD_LIQUOR_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VESPUCCI_LIQUOR_RETAIL_STORE,
    Lang:t('business_name_vespucci_liquor_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-1225.7295, -901.4227, 12.3213),
    { -- for Sale Storage Location
    },
    {
        ['beverages'] = vector3(-1225.7295, -901.4227, 12.3213),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VESPUCCI_LIQUOR_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_RETAIL_STORE,
    Lang:t('business_name_little_seoul_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-702.3959, -916.8562, 19.2139),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(-702.3959, -916.8562, 19.2139),
        ['beverages'] = vector3(-698.4898, -917.3995, 19.2056),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_RETAIL_STORE,
    Lang:t('business_name_strawberry_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(31.8275, -1315.8616, 29.5230),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(31.8275, -1315.8616, 29.5230),
        ['beverages'] = vector3(26.4246, -1315.3741, 29.6228),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DAVIS_RETAIL_STORE,
    Lang:t('business_name_davis_retail_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.RETAIL_STORE,
    vector3(-41.4497, -1747.8674, 29.5140),
    { -- for Sale Storage Location
    },
    {
        ['appliances'] = vector3(-41.4497, -1747.8674, 29.5140),
        ['beverages'] = vector3(-43.8570, -1745.6021, 29.3551),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['appliances'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_RETAIL_STORE, 'appliances').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['beverages'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_RETAIL_STORE, 'beverages').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

-- AUTOMOTIVE_SHOP

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_AUTOMOTIVE_SHOP,
    Lang:t('business_name_paleto_bay_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(120.4627, 6625.6235, 31.9556),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(120.4627, 6625.6235, 31.9556),
        ['dyes'] = vector3(102.0006, 6637.3477, 31.4190),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_AUTOMOTIVE_SHOP,
    Lang:t('business_name_grand_senora_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(1178.5396, 2647.8682, 37.7933),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(1178.5396, 2647.8682, 37.7933),
        ['dyes'] = vector3(1189.5172, 2658.9480, 37.8231),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BURTON_AUTOMOTIVE_SHOP,
    Lang:t('business_name_burton_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(-356.6489, -114.2568, 38.6967),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(-356.6489, -114.2568, 38.6967),
        ['dyes'] = vector3(-376.4286, -133.0934, 38.6858),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BURTON_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BURTON_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LSIA_AUTOMOTIVE_SHOP,
    Lang:t('business_name_lsia_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(-1141.5275, -1991.9707, 13.1641),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(-1141.5275, -1991.9707, 13.1641),
        ['dyes'] = vector3(-1138.2894, -1983.2931, 13.1646),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LSIA_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LSIA_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LA_MESA_AUTOMOTIVE_SHOP,
    Lang:t('business_name_la_mesa_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(720.3189, -1082.7791, 22.2547),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(720.3189, -1082.7791, 22.2547),
        ['dyes'] = vector3(710.3497, -1082.3136, 22.3674),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_MESA_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_MESA_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_AUTOMOTIVE_SHOP,
    Lang:t('business_name_strawberry_automotive_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.AUTOMOTIVE_SHOP,
    vector3(-211.0578, -1309.0847, 31.2916),
    { -- for Sale Storage Location
    },
    {
        ['car_parts'] = vector3(-211.0578, -1309.0847, 31.2916),
        ['dyes'] = vector3(-204.3967, -1302.5631, 31.2960),
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['car_parts'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_AUTOMOTIVE_SHOP, 'car_parts').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            },
            ['dyes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_AUTOMOTIVE_SHOP, 'dyes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

-- FOOD_N_DRINK
Industries:AddIndustry(
    config.Industry.Name.MOUNT_GORDO_FOOD_N_DRINK,
    Lang:t('business_name_mount_gordo_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(1592.5764, 6463.1514, 25.3171),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(1592.5764, 6463.1514, 25.3171)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MOUNT_GORDO_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ALAMO_SEA_FOOD_N_DRINK,
    Lang:t('business_name_alamo_sea_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(917.4056, 3656.4185, 32.4848),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(917.4056, 3656.4185, 32.4848)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALAMO_SEA_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TATAVIAM_FOOD_N_DRINK,
    Lang:t('business_name_tataviam_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(2571.4863, 480.0062, 108.6767),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(2571.4863, 480.0062, 108.6767)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TATAVIAM_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MIRROR_PARK_FOOD_N_DRINK,
    Lang:t('business_name_mirror_park_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(1247.4738, -348.0293, 69.0822),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(1247.4738, -348.0293, 69.0822)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LA_MESA_FOOD_N_DRINK,
    Lang:t('business_name_la_mesa_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(811.6462, -750.7936, 26.7322),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(811.6462, -750.7936, 26.7322)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_MESA_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DOWNTOWN_VINEWOOD_FOOD_N_DRINK,
    Lang:t('business_name_downtown_vinewood_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(91.6316, 300.6619, 110.0013),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(91.6316, 300.6619, 110.0013)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DOWNTOWN_VINEWOOD_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BURTON_FOOD_N_DRINK,
    Lang:t('business_name_burton_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-137.9100, -253.8090, 43.5374),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-137.9100, -253.8090, 43.5374)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BURTON_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_FOOD_N_DRINK,
    Lang:t('business_name_little_seoul_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-592.7728, -892.4600, 25.9213),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-592.7728, -892.4600, 25.9213)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(15,25), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_FOOD_N_DRINK,
    Lang:t('business_name_pillbox_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-261.5045, -901.2905, 32.3108),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-261.5045, -901.2905, 32.3108)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VESPUCCI_CANALS_FOOD_N_DRINK,
    Lang:t('business_name_vespucci_canals_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-842.0731, -1127.8007, 6.9829),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-842.0731, -1127.8007, 6.9829)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VESPUCCI_CANALS_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VESPUCCI_CANALS_NO2_FOOD_N_DRINK,
    Lang:t('business_name_vespucci_canals_no2_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-1177.1699, -891.1215, 13.7926),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-1177.1699, -891.1215, 13.7926)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VESPUCCI_CANALS_NO2_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_FOOD_N_DRINK,
    Lang:t('business_name_strawberry_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-296.1499, -1342.6371, 31.3108),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-296.1499, -1342.6371, 31.3108)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DAVIS_FOOD_N_DRINK,
    Lang:t('business_name_davis_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(180.7223, -1640.1541, 29.2918),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(180.7223, -1640.1541, 29.2918)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DEL_PERRO_FOOD_N_DRINK,
    Lang:t('business_name_del_perro_food_n_drink'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FOOD_N_DRINK,
    vector3(-1541.1116, -437.0354, 35.5967),
    { -- for Sale Storage Location
    },
    {
        ['meal'] = vector3(-1541.1116, -437.0354, 35.5967)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['meal'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DEL_PERRO_FOOD_N_DRINK, 'meal').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)
-- CLOTHING_STORE

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_CLOTHING_STORE,
    Lang:t('business_name_paleto_bay_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(19.4971, 6510.4995, 31.4922),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(19.4971, 6510.4995, 31.4922)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GAPESEED_CLOTHING_STORE,
    Lang:t('business_name_gapeseed_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(1703.5007, 4829.5884, 42.0131),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(1703.5007, 4829.5884, 42.0131)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GAPESEED_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_CLOTHING_STORE,
    Lang:t('business_name_grand_senora_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(1190.3851, 2724.4124, 38.0041),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(1190.3851, 2724.4124, 38.0041)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.HARMONY_CLOTHING_STORE,
    Lang:t('business_name_harmony_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(619.3852, 2786.1362, 43.4812),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(619.3852, 2786.1362, 43.4812)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.HARMONY_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ZANCUDO_RIVER_CLOTHING_STORE,
    Lang:t('business_name_zancudo_river_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-1108.9077, 2723.8242, 18.8004),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-1108.9077, 2723.8242, 18.8004)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ZANCUDO_RIVER_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.CHUMASH_CLOTHING_STORE,
    Lang:t('business_name_chumash_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-3179.5715, 1029.6115, 20.8307),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-3179.5715, 1029.6115, 20.8307)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHUMASH_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MORNINGWOOD_CLOTHING_STORE,
    Lang:t('business_name_morningwood_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-1443.9617, -258.2108, 46.2078),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-1443.9617, -258.2108, 46.2078)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MORNINGWOOD_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DEL_PERRO_CLOTHING_STORE,
    Lang:t('business_name_del_perro_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-1171.5402, -752.5428, 19.2310),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-1171.5402, -752.5428, 19.2310)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DEL_PERRO_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VESPUCCI_CLOTHING_STORE,
    Lang:t('business_name_vespucci_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-823.9045, -1064.8508, 11.6132),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-823.9045, -1064.8508, 11.6132)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VESPUCCI_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.SAN_ANDREAS_CLOTHING_STORE,
    Lang:t('business_name_san_andreas_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-1206.5243, -1456.3052, 4.3785),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-1206.5243, -1456.3052, 4.3785)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SAN_ANDREAS_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ROCKFORD_HILLS_CLOTHING_STORE,
    Lang:t('business_name_rockford_hills_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-700.3335, -147.0155, 37.8456),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-700.3335, -147.0155, 37.8456)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BURTON_CLOTHING_STORE,
    Lang:t('business_name_burton_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(-152.9534, -303.1317, 38.9780),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(-152.9534, -303.1317, 38.9780)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BURTON_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ALTA_CLOTHING_STORE,
    Lang:t('business_name_alta_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(117.9942, -239.5293, 53.3560),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(117.9942, -239.5293, 53.3560)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALTA_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TEXTILE_CLOTHING_STORE,
    Lang:t('business_name_textile_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(417.2646, -803.6225, 29.3941),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(417.2646, -803.6225, 29.3941)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TEXTILE_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_CLOTHING_STORE,
    Lang:t('business_name_strawberry_clothing_store'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.CLOTHING_STORE,
    vector3(67.3513, -1398.4589, 29.3647),
    { -- for Sale Storage Location
    },
    {
        ['clothes'] = vector3(67.3513, -1398.4589, 29.3647)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['clothes'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_CLOTHING_STORE, 'clothes').profitPrice, --random min max
                consumption = math.random(5,15), -- tons
                storageSize = 100,  -- tons
                inStock = math.random(10,20), -- tons
            }
        }
    }
)

-- DEALERSHIP

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_DEALERSHIP,
    Lang:t('business_name_grand_senora_dealership'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.DEALERSHIP,
    vector3(1222.4666, 2708.2961, 38.0057),
    { -- for Sale Storage Location
    },
    {
        ['vehicle'] = vector3(1222.4666, 2708.2961, 38.0057)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['vehicle'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_DEALERSHIP, 'vehicle').profitPrice, --random min max
                consumption = math.random(2,6),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILL_DEALERSHIP,
    Lang:t('business_name_pillbox_hill_dealership'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.DEALERSHIP,
    vector3(-16.6324, -1103.4871, 26.6762),
    { -- for Sale Storage Location
    },
    {
        ['vehicle'] = vector3(-16.6324, -1103.4871, 26.6762)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['vehicle'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILL_DEALERSHIP, 'vehicle').profitPrice, --random min max
                consumption = math.random(2,6),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ROCKFORD_HILLS_DEALERSHIP,
    Lang:t('business_name_rockford_hills_dealership'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.DEALERSHIP,
    vector3(-1249.7892, -331.0493, 37.1310),
    { -- for Sale Storage Location
    },
    {
        ['vehicle'] = vector3(-1249.7892, -331.0493, 37.1310)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['vehicle'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_DEALERSHIP, 'vehicle').profitPrice, --random min max
                consumption = math.random(2,6),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
)

-- gas_station

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_GAS_STATION,
    Lang:t('business_name_paleto_bay_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-82.7276, 6430.8086, 31.4905),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-82.7276, 6430.8086, 31.4905)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_NO2_GAS_STATION,
    Lang:t('business_name_paleto_bay_no2_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(158.7153, 6616.4028, 31.9339),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(158.7153, 6616.4028, 31.9339)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_NO2_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MOUNT_CHILIAD_GAS_STATION,
    Lang:t('business_name_mount_chiliad_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1715.4274, 6406.9014, 33.7100),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1715.4274, 6406.9014, 33.7100)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MOUNT_CHILIAD_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GAPESEED_GAS_STATION,
    Lang:t('business_name_gapeseed_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1681.2382, 4937.7573, 42.1094),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1681.2382, 4937.7573, 42.1094)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GAPESEED_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.SANDY_SHORES_GAS_STATION,
    Lang:t('business_name_sandy_shores_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1983.6542, 3771.9749, 32.1815),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1983.6542, 3771.9749, 32.1815)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.SANDY_SHORES_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_GAS_STATION,
    Lang:t('business_name_grand_senora_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(2684.4741, 3260.9934, 55.2405),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(2684.4741, 3260.9934, 55.2405)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_NO2_GAS_STATION,
    Lang:t('business_name_grand_senora_no2_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1209.9670, 2666.5789, 37.8100),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1209.9670, 2666.5789, 37.8100)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO2_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_NO3_GAS_STATION,
    Lang:t('business_name_grand_senora_no3_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(66.0707, 2782.0923, 57.8783),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(66.0707, 2782.0923, 57.8783)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO3_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_NO4_GAS_STATION,
    Lang:t('business_name_grand_senora_no4_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1055.0797, 2672.0945, 39.5512),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1055.0797, 2672.0945, 39.5512)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO4_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_NO5_GAS_STATION,
    Lang:t('business_name_grand_senora_no5_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1779.1575, 3333.4937, 41.1825),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1779.1575, 3333.4937, 41.1825)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_NO5_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)


Industries:AddIndustry(
    config.Industry.Name.DAVIS_QUARTZ_GAS_STATION,
    Lang:t('business_name_davis_quartz_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(2531.2219, 2610.3735, 37.9448),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(2531.2219, 2610.3735, 37.9448)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_QUARTZ_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.HARMONY_GAS_STATION,
    Lang:t('business_name_harmony_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(250.0540, 2606.3391, 45.0696),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(250.0540, 2606.3391, 45.0696)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.HARMONY_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LAGO_ZANCUDO_GAS_STATION,
    Lang:t('business_name_lago_zancudo_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-2555.0435, 2322.5627, 33.0603),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-2555.0435, 2322.5627, 33.0603)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LAGO_ZANCUDO_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.RICHMAN_GLEN_GAS_STATION,
    Lang:t('business_name_richman_glen_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-1812.9606, 811.8502, 138.5537),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-1812.9606, 811.8502, 138.5537)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.RICHMAN_GLEN_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TATAVIAM_GAS_STATION,
    Lang:t('business_name_tataviam_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(2566.9592, 363.4492, 108.4595),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(2566.9592, 363.4492, 108.4595)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TATAVIAM_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DOWNTOWN_VINEWOOD_GAS_STATION,
    Lang:t('business_name_downtown_vinewood_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(624.1505, 283.4482, 103.0894),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(624.1505, 283.4482, 103.0894)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DOWNTOWN_VINEWOOD_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MIRROR_PARK_GAS_STATION,
    Lang:t('business_name_mirror_park_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(624.1505, 283.4482, 103.0894),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(624.1505, 283.4482, 103.0894)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MIRROR_PARK_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LA_MESA_GAS_STATION,
    Lang:t('business_name_la_mesa_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(812.8596, -1036.1926, 26.4190),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(812.8596, -1036.1926, 26.4190)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_MESA_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.EL_BURRO_GAS_STATION,
    Lang:t('business_name_el_burro_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(1198.9027, -1401.9960, 35.2241),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(1198.9027, -1401.9960, 35.2241)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.EL_BURRO_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_GAS_STATION,
    Lang:t('business_name_strawberry_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(255.4090, -1277.4396, 29.1738),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(255.4090, -1277.4396, 29.1738)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DAVIS_GAS_STATION,
    Lang:t('business_name_davis_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-71.5456, -1773.6373, 28.7657),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-71.5456, -1773.6373, 28.7657)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DAVIS_NO2_GAS_STATION,
    Lang:t('business_name_davis_no2_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(183.9424, -1552.2256, 29.1949),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(183.9424, -1552.2256, 29.1949)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_NO2_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_GAS_STATION,
    Lang:t('business_name_little_seoul_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-519.9875, -1199.3297, 18.7890),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-519.9875, -1199.3297, 18.7890)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LITTLE_SEOUL_NO2_GAS_STATION,
    Lang:t('business_name_little_seoul_no2_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-727.1858, -921.1838, 19.0140),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-727.1858, -921.1838, 19.0140)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LITTLE_SEOUL_NO2_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MORNINGWOOD_GAS_STATION,
    Lang:t('business_name_morningwood_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-1420.4270, -285.9951, 46.2605),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-1420.4270, -285.9951, 46.2605)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MORNINGWOOD_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PACIFIC_BLUFFS_GAS_STATION,
    Lang:t('business_name_pacific_bluffs_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-2083.3953, -332.9612, 13.0581),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-2083.3953, -332.9612, 13.0581)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PACIFIC_BLUFFS_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.LA_PUERTA_GAS_STATION,
    Lang:t('business_name_la_puerta_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-315.8010, -1484.3921, 30.5487),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-315.8010, -1484.3921, 30.5487)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.LA_PUERTA_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ELYSIAN_ISLAND_GAS_STATION,
    Lang:t('business_name_elysian_island_gas_station'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.GAS_STATION,
    vector3(-62.5464, -2528.2188, 6.0100),
    { -- for Sale Storage Location
    },
    {
        ['fuel'] = vector3(-62.5464, -2528.2188, 6.0100)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fuel'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ELYSIAN_ISLAND_GAS_STATION, 'fuel').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

-- furniture_shop

Industries:AddIndustry(
    config.Industry.Name.STRAWBERRY_FURNITURE_SHOP,
    Lang:t('business_name_strawberry_furniture_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FURNITURE_SHOP,
    vector3(164.7265, -1282.8868, 29.2845),
    { -- for Sale Storage Location
    },
    {
        ['furniture'] = vector3(164.7265, -1282.8868, 29.2845)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['furniture'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.STRAWBERRY_FURNITURE_SHOP, 'furniture').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DAVIS_FURNITURE_SHOP,
    Lang:t('business_name_davis_furniture_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FURNITURE_SHOP,
    vector3(89.4915, -1745.4153, 30.0873),
    { -- for Sale Storage Location
    },
    {
        ['furniture'] = vector3(89.4915, -1745.4153, 30.0873)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['furniture'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DAVIS_FURNITURE_SHOP, 'furniture').profitPrice, --random min max
                consumption = math.random(15,25),
                storageSize = 200,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.CYPRESS_FLATS_FURNITURE_SHOP,
    Lang:t('business_name_cypress_flats_furniture_shop'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FURNITURE_SHOP,
    vector3(1038.9648, -2177.6594, 31.4980),
    { -- for Sale Storage Location
    },
    {
        ['furniture'] = vector3(1038.9648, -2177.6594, 31.4980)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['furniture'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CYPRESS_FLATS_FURNITURE_SHOP, 'furniture').profitPrice, --random min max
                consumption = math.random(10,20),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

-- Office

Industries:AddIndustry(
    config.Industry.Name.ROCKFORD_HILLS_OFFICE,
    Lang:t('business_name_rockford_hills_office'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.OFFICE,
    vector3(-1041.4100, -241.0509, 37.9596),
    { -- for Sale Storage Location
    },
    {
        ['paper'] = vector3(-1041.4100, -241.0509, 37.9596)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_OFFICE, 'paper').profitPrice, --random min max
                consumption = math.random(30,50),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DEL_PERRO_OFFICE,
    Lang:t('business_name_del_perro_office'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.OFFICE,
    vector3(-1586.2529, -571.2742, 34.9789),
    { -- for Sale Storage Location
    },
    {
        ['paper'] = vector3(-1586.2529, -571.2742, 34.9789)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DEL_PERRO_OFFICE, 'paper').profitPrice, --random min max
                consumption = math.random(30,50),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.DEL_PERRO_NO2_OFFICE,
    Lang:t('business_name_del_perro_no2_office'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.OFFICE,
    vector3(-1371.4099, -458.4443, 34.4775),
    { -- for Sale Storage Location
    },
    {
        ['paper'] = vector3(-1371.4099, -458.4443, 34.4775)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DEL_PERRO_NO2_OFFICE, 'paper').profitPrice, --random min max
                consumption = math.random(30,50),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILL_OFFICE,
    Lang:t('business_name_pillbox_hill_office'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.OFFICE,
    vector3(-144.1810, -575.9774, 32.4245),
    { -- for Sale Storage Location
    },
    {
        ['paper'] = vector3(-144.1810, -575.9774, 32.4245)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILL_OFFICE, 'paper').profitPrice, --random min max
                consumption = math.random(30,50),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILL_NO2_OFFICE,
    Lang:t('business_name_pillbox_hill_no2_office'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.OFFICE,
    vector3(-145.2870, -846.2899, 30.5678),
    { -- for Sale Storage Location
    },
    {
        ['paper'] = vector3(-145.2870, -846.2899, 30.5678)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['paper'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILL_NO2_OFFICE, 'paper').profitPrice, --random min max
                consumption = math.random(30,50),
                storageSize = 300,
                inStock = math.random(10,20),
            }
        }
    }
)

--Bank

Industries:AddIndustry(
    config.Industry.Name.PALETO_BAY_BANK,
    Lang:t('business_name_paleto_bay_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(-104.2931, 6471.4277, 31.6267),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(-104.2931, 6471.4277, 31.6267)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PALETO_BAY_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.PILLBOX_HILL_BANK,
    Lang:t('business_name_pillbox_hill_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(147.2341, -1045.0657, 29.3680),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(147.2341, -1045.0657, 29.3680)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.PILLBOX_HILL_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.ALTA_BANK,
    Lang:t('business_name_alta_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(310.9186, -283.0924, 54.1745),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(310.9186, -283.0924, 54.1745)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ALTA_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.BURTON_BANK,
    Lang:t('business_name_burton_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(-353.7701, -54.1140, 49.0373),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(-353.7701, -54.1140, 49.0373)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BURTON_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.ROCKFORD_HILLS_BANK,
    Lang:t('business_name_rockford_hills_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(-1211.6569, -336.1620, 37.7908),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(-1211.6569, -336.1620, 37.7908)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROCKFORD_HILLS_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.BANHAM_CANYON_BANK,
    Lang:t('business_name_banham_canyon_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(-2957.5955, 481.2937, 15.7068),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(-2957.5955, 481.2937, 15.7068)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BANHAM_CANYON_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.GRAND_SENORA_BANK,
    Lang:t('business_name_grand_senora_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(1176.3654, 2711.6047, 38.0969),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(1176.3654, 2711.6047, 38.0969)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAND_SENORA_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
) 

Industries:AddIndustry(
    config.Industry.Name.DOWNTOWN_VINEWOOD_BANK,
    Lang:t('business_name_downtown_vinewood_bank'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.BANK,
    vector3(257.0228, 220.0060, 106.2863),
    { -- for Sale Storage Location
    },
    {
        ['coins'] = vector3(257.0228, 220.0060, 106.2863)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['coins'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.DOWNTOWN_VINEWOOD_BANK, 'coins').profitPrice, --random min max
                consumption = math.random(5,15),
                storageSize = 100,
                inStock = math.random(10,20),
            }
        }
    }
)
-- FRUIT STAND
Industries:AddIndustry(
    config.Industry.Name.JOSHUA_RD_GRAND_SENORA_FRUIT_STAND,
    Lang:t('business_name_joshua_rd_grand_senora_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(1263.1132, 3545.9670, 35.1565),
    {},
    {
        ['fruits'] = vector3(1266.8416, 3549.1206, 35.2072)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.JOSHUA_RD_GRAND_SENORA_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ROUTE_68_GRAND_SENORA_FRUIT_STAND,
    Lang:t('business_name_route_68_grand_senora_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(1473.0837, 2720.2297, 37.7378),
    {},
    {
        ['fruits'] = vector3(1473.0837, 2720.2297, 37.7378)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ROUTE_68_GRAND_SENORA_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.MOUNT_CHILIAD_FRUIT_STAND,
    Lang:t('business_name_mount_chiliad_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(1091.8846, 6510.5850, 21.1041),
    {},
    {
        ['fruits'] = vector3(1091.8846, 6510.5850, 21.1041)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.MOUNT_CHILIAD_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VINEWOOD_HILLS_FRUIT_STAND,
    Lang:t('business_name_vinewood_hills_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(1043.2225, 694.0150, 158.8544),
    {},
    {
        ['fruits'] = vector3(1043.2225, 694.0150, 158.8544)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VINEWOOD_HILLS_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.VINEWOOD_HILLS_NO2_FRUIT_STAND,
    Lang:t('business_name_vinewood_hills_no2_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-1384.8882, 734.4938, 182.9969),
    {},
    {
        ['fruits'] = vector3(-1384.8882, 734.4938, 182.9969)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.VINEWOOD_HILLS_NO2_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.ZANCUDO_GRANDE_FRUIT_STAND,
    Lang:t('business_name_zancudo_grande_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-454.5936, 2863.6611, 35.4076),
    {},
    {
        ['fruits'] = vector3(-454.5936, 2863.6611, 35.4076)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.ZANCUDO_GRANDE_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.TONGVA_VALLEY_FRUIT_STAND,
    Lang:t('business_name_tongva_valley_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-1556.3621, 1370.9060, 127.1495),
    {},
    {
        ['fruits'] = vector3(-1556.3621, 1370.9060, 127.1495)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.TONGVA_VALLEY_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.CHILIAD_MOUNTAIN_STATE_FRUIT_STAND,
    Lang:t('business_name_chiliad_mountain_state_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-1046.5093, 5324.1997, 44.8411),
    {},
    {
        ['fruits'] = vector3(-1046.5093, 5324.1997, 44.8411)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.CHILIAD_MOUNTAIN_STATE_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.NORTH_CHUMASH_FRUIT_STAND,
    Lang:t('business_name_north_chumash_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-2508.6677, 3618.8931, 13.6924),
    {},
    {
        ['fruits'] = vector3(-2508.6677, 3618.8931, 13.6924)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.NORTH_CHUMASH_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.BANHAM_CANYON_FRUIT_STAND,
    Lang:t('business_name_banham_canyon_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(-3025.0754, 373.5449, 14.7600),
    {},
    {
        ['fruits'] = vector3(-3025.0754, 373.5449, 14.7600)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.BANHAM_CANYON_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)

Industries:AddIndustry(
    config.Industry.Name.GRAPESEED_FRUIT_STAND,
    Lang:t('business_name_grapeseed_fruit_stand'),
    config.Industry.Status.OPEN,
    config.Industry.Tier.BUSINESS,
    config.Industry.Type.Business.FRUIT_STAND,
    vector3(2475.0962, 4449.8687, 35.3404),
    {},
    {
        ['fruits'] = vector3(2475.0962, 4449.8687, 35.3404)
    }, --Wanted Storage Location
    {
        [config.Industry.TradeType.FORSALE] = {},
        [config.Industry.TradeType.WANTED] = {
            ['fruits'] = {
                price = Industries:GetIndustryItemPriceData(config.Industry.Name.GRAPESEED_FRUIT_STAND, 'fruits').profitPrice, --random min max
                consumption = math.random(5,15), --
                storageSize = 100,  --
                inStock = math.random(10,20), --
            }
        }
    }
)