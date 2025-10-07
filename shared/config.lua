function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

config = {}

-- Industries config
config.Company = {
    CreateCost = 50000, -- O custo para criar uma nova empresa
    SellReturnValue = 25000, -- O valor fixo que o jogador recebe ao vender a empresa
}
config.Industry = {
    UpdateTime = 3600, -- (seconds) Update Industries Every hour
    -- Status of industries, Open or Close
    Status = {
        CLOSE = 0,
        OPEN = 1,
    },
    -- Tier of Industries
Tier = {
    PRIMARY = 1,
    SECONDARY = 2,
    TERTIARY = 3, -- ADICIONADO
    BUSINESS = 4, -- ALTERADO
},
    -- Trade Type of industries and businesses
    TradeType = {
        FORSALE = 'forsale',
        WANTED = 'wanted',
    },
    -- Type of Industries and Businesses, you can add More Types
    Type = {
        -- Primary
        Primary = {
            OILFIELD = 1,
            CHEMICAL = 2,
            SCRAPYARD = 3,
            FOREST = 4,
            FARM = 5,
            MINERAL = 6,
            QUARRY = 7,
        },
        Secondary = {
            -- Secondary
            MINT = 1, -- Federal Mint
            WEAPON_FACTORY = 2,
            STEEL_MILL = 3,
            SAWMILL = 4,
            TEXTILE_FACTORY = 5,
            BREWERY = 6,
            FOOD_PROCESSING_PLANT = 7,
            CONCRETE_PLANT = 8,
            DISTILLERY = 9,
            MALT_HOUSE = 10,
            APPLIANCES = 11,
            AUTOS = 12,
            METALLURGICAL = 13,
        },
        Business = {
            -- BUSINESS
            CONSTRUCTIONS = 1,
            POWERPLANT = 2,
            AMMUNATION = 3,
            RETAIL_STORE = 4,
            AUTOMOTIVE_SHOP = 5,
            FOOD_N_DRINK = 6,
            CLOTHING_STORE = 7,
            DEALERSHIP = 8,
            GAS_STATION = 9,
            FURNITURE_SHOP = 10,
            OFFICE = 11,
            BANK = 12,
            FRUIT_STAND = 13
        }
    },
    -- Define List Name of Industry, name is unique variable, this script use name to replace Id
    Name = {
        -- Primary Industries
        OILFIELD_MURRIETA = 'oilfield_murrieta',
        CHEMICAL_FACTORY = 'chemical_factory',
        ROGERS_SCRAPYARD = 'rogers_scrapyard',
        THOMSON_SCRAPYARD = 'thomson_scrapyard',
        FOREST_CENTER = 'forest_center',
        ZANCUDO_FARM = 'zancudo_farm',
        PALETO_BAY_FARM = 'paleto_bay_farm',
        N10_FARM = 'n10_farm',
        N11_FARM = 'n11_farm',
        N12_FARM = 'n12_farm',
        N13_FARM = 'n13_farm',
        N14_FARM = 'n14_farm',
        N15_FARM = 'n15_farm',
        LA_FUENTE_FARM = 'la_fuente_farm',
        DAVIS_MINERAL = 'davis_mineral',
        DAVIS_QUARRY = 'davis_quarry',
        -- Secondary Industries
        SA_FEDERAL_MINT = 'sa_federal_mint',
        FEDERAL_WEAPON_FACTORY = 'federal_weapon_factory',
        FEDERAL_STEEL_MILL = 'federal_steel_mill',
        SAWMILL_FACTORY = 'sawmill_factory',
        BROS_TEXTILE_FACTORY = 'bros_textile_factory',
        PIBWASSER_BREWERY = 'pibwasser_brewery',
        PALETO_BAY_FOOD_PROCESSING_PLANT = 'paleto_bay_food_processing_plant',
        LOS_SANTOS_CONCRETE_PLANT = 'los_santos_concrete_plant',
        THE_MOUNT_DISTILLERY = 'the_mount_distillery',
        TRADITION_MALT_HOUSE = 'tradition_malt_house',
        APPLIANCES_FACTORY = 'appliances_factory',
        LOS_SANTOS_AUTOS = 'los_santos_autos',
        LOS_SANTOS_METALLURGICAL = 'los_santos_metallurgical',
        -- Secondary Special Industries
        REDWOOD_CONSTRUCTIONS = 'redwood_constructions',
        ALTA_CONSTRUCTIONS = 'alta_constructions',
        PALETO_BAY_STUNNING_CONSTRUCTIONS = 'paleto_bay_stunning_constructions',
        PALETO_BAY_CLUCKIN_BELLE_CONSTRUCTIONS = 'paleto_bay_cluckin_belle_constructions',
        ROCKFORD_HILLS_HOUSE_CONSTRUCTIONS = 'rockford_hills_house_constructions',
        PILLBOX_HILLS_CONSTRUCTIONS = 'pillbox_hills_constructions',
        LITTLE_SEOUL_STD_CONSTRUCTIONS = 'little_seoul_std_constructions',
        MIRROR_PARK_LUXURY_HOME_CONSTRUCTIONS = 'mirror_park_luxury_home_constructions',
        PALMER_POWERPLANT = 'palmer_powerplant',
        SHERMAN_POWERPLANT = 'sherman_powerplant',
        PORT_OF_LOS_SANTOS = 'port_of_los_santos',
        -- Business
        -- ammunation
        HAWICK_AMMUNATION = 'hawick_ammunation',
        SANDY_SHORES_AMMUNATION = 'sandy_shores_ammunation',
        MORNING_WOOD_AMMUNATION = 'morning_wood_ammunation',
        LA_MESA_AMMUNATION = 'la_mesa_ammunation',
        PILLBOX_HILL_AMMUNATION = 'pillbox_hill_ammunation',
        LITTLE_SEOUL_AMMUNATION = 'little_seoul_ammunation',
        CHUMASH_AMMUNATION = 'chumash_ammunation',
        TATAVIAM_AMMUNATION = 'tataviam_ammunation',
        ZANCUDO_RIVER_AMMUNATION = 'zancudo_river_ammunation',
        PALETO_BAY_AMMUNATION = 'paleto_bay_ammunation',
        -- retail
        MOUNT_CHILIAD_RETAIL_STORE = 'mount_chiliad_retail_store',
        GRAPESEED_RETAIL_STORE = 'grapeseed_retail_store',
        SANDY_SHORES_RETAIL_STORE = 'sandy_shores_retail_store',
        SANDY_SHORES_LIQUOR_RETAIL_STORE = 'sandy_shores_liquor_retail_store',
        GRAND_SENORA_RETAIL_STORE = 'grand_senora_retail_store',
        GRAND_SENORA_NO2_RETAIL_STORE = 'grand_senora_retail_store',
        GRAND_SENORA_LIQUOR_RETAIL_STORE = 'grand_senora_liquor_retail_store',
        TATAVIAM_RETAIL_STORE = 'tataviam_retail_store',
        DOWNTOWN_RETAIL_STORE = 'downtown_retail_store',
        MIRROR_PARK_RETAIL_STORE = 'mirror_park_retail_store',
        MURRIETA_HEIGHTS_RETAIL_STORE = 'murrieta_heights_retail_store',
        RICHMAN_GLEN_RETAIL_STORE = 'richman_glen_retail_store',
        CHUMASH_RETAIL_STORE = 'chumash_retail_store',
        BANHAM_CANYON_INESENO_RETAIL_STORE = 'banham_canyon_ineseno_retail_store',
        BANHAM_CANYON_LIQUOR_RETAIL_STORE = 'banham_canyon_liquor_retail_store',
        MORNINGWOOD_LIQUOR_RETAIL_STORE = 'morningwood_liquor_retail_store',
        VESPUCCI_LIQUOR_RETAIL_STORE = 'vespucci_liquor_retail_store',
        LITTLE_SEOUL_RETAIL_STORE = 'little_seoul_retail_store',
        STRAWBERRY_RETAIL_STORE = 'strawberry_retail_store',
        DAVIS_RETAIL_STORE = 'davis_retail_store',
        -- automotive
        PALETO_BAY_AUTOMOTIVE_SHOP = 'paleto_bay_automotive_shop',
        GRAND_SENORA_AUTOMOTIVE_SHOP = 'grand_senora_automotive_shop',
        BURTON_AUTOMOTIVE_SHOP = 'burton_automotive_shop',
        LSIA_AUTOMOTIVE_SHOP = 'lsia_automotive_shop',
        LA_MESA_AUTOMOTIVE_SHOP = 'la_mesa_automotive_shop',
        STRAWBERRY_AUTOMOTIVE_SHOP = 'strawberry_automotive_shop',
        -- food_n_drink
        MOUNT_GORDO_FOOD_N_DRINK = 'mount_gordo_food_n_drink',
        ALAMO_SEA_FOOD_N_DRINK = 'alamo_sea_food_n_drink',
        TATAVIAM_FOOD_N_DRINK = 'tataviam_food_n_drink',
        MIRROR_PARK_FOOD_N_DRINK = 'mirror_park_food_n_drink',
        LA_MESA_FOOD_N_DRINK = 'la_mesa_food_n_drink',
        DOWNTOWN_VINEWOOD_FOOD_N_DRINK = 'downtown_vinewood_food_n_drink',
        BURTON_FOOD_N_DRINK = 'burton_food_n_drink',
        LITTLE_SEOUL_FOOD_N_DRINK = 'little_seoul_food_n_drink',
        PILLBOX_FOOD_N_DRINK = 'pillbox_food_n_drink',
        VESPUCCI_CANALS_FOOD_N_DRINK = 'vespucci_canals_food_n_drink',
        VESPUCCI_CANALS_NO2_FOOD_N_DRINK = 'vespucci_canals_no2_food_n_drink',
        STRAWBERRY_FOOD_N_DRINK = 'strawberry_food_n_drink',
        DAVIS_FOOD_N_DRINK = 'davis_food_n_drink',
        DEL_PERRO_FOOD_N_DRINK = 'del_perro_food_n_drink',
        PACIFIC_OCEAN_FOOD_N_DRINK = 'pacific_ocean_food_n_drink',
        -- clothing_store
        PALETO_BAY_CLOTHING_STORE = 'paleto_bay_clothing_store',
        GAPESEED_CLOTHING_STORE = 'gapeseed_clothing_store',
        GRAND_SENORA_CLOTHING_STORE = 'grand_senora_clothing_store',
        HARMONY_CLOTHING_STORE = 'harmony_clothing_store',
        ZANCUDO_RIVER_CLOTHING_STORE = 'zancudo_river_clothing_store',
        CHUMASH_CLOTHING_STORE = 'chumash_clothing_store',
        MORNINGWOOD_CLOTHING_STORE = 'morningwood_clothing_store',
        DEL_PERRO_CLOTHING_STORE = 'del_perro_clothing_store',
        VESPUCCI_CLOTHING_STORE = 'vespucci_clothing_store',
        SAN_ANDREAS_CLOTHING_STORE = 'san_andreas_clothing_store',
        ROCKFORD_HILLS_CLOTHING_STORE = 'rockford_hills_clothing_store',
        BURTON_CLOTHING_STORE = 'burton_clothing_store',
        ALTA_CLOTHING_STORE = 'alta_clothing_store',
        TEXTILE_CLOTHING_STORE = 'textile_clothing_store',
        STRAWBERRY_CLOTHING_STORE = 'strawberry_clothing_store',
        -- dealership
        GRAND_SENORA_DEALERSHIP = 'grand_senora_dealership',
        PILLBOX_HILL_DEALERSHIP = 'pillbox_hill_dealership',
        ROCKFORD_HILLS_DEALERSHIP = 'rockford_hills_dealership',
        -- gas_station
        PALETO_BAY_GAS_STATION = 'paleto_bay_gas_station',
        PALETO_BAY_NO2_GAS_STATION = 'paleto_bay_no2_gas_station',
        MOUNT_CHILIAD_GAS_STATION = 'mount_chiliad_gas_station',
        GAPESEED_GAS_STATION = 'gapeseed_gas_station',
        SANDY_SHORES_GAS_STATION = 'sandy_shores_gas_station',
        GRAND_SENORA_GAS_STATION = 'grand_senora_gas_station',
        GRAND_SENORA_NO2_GAS_STATION = 'grand_senora_no2_gas_station',
        GRAND_SENORA_NO3_GAS_STATION = 'grand_senora_no3_gas_station',
        GRAND_SENORA_NO4_GAS_STATION = 'grand_senora_no4_gas_station',
        GRAND_SENORA_NO5_GAS_STATION = 'grand_senora_no5_gas_station',
        DAVIS_QUARTZ_GAS_STATION = 'davis_quartz_gas_station',
        HARMONY_GAS_STATION = 'harmony_gas_station',
        LAGO_ZANCUDO_GAS_STATION = 'lago_zancudo_gas_station',
        RICHMAN_GLEN_GAS_STATION = 'richman_glen_gas_station',
        TATAVIAM_GAS_STATION = 'tataviam_gas_station',
        DOWNTOWN_VINEWOOD_GAS_STATION = 'downtown_vinewood_gas_station',
        MIRROR_PARK_GAS_STATION = 'mirror_park_gas_station',
        LA_MESA_GAS_STATION = 'la_mesa_gas_station',
        EL_BURRO_GAS_STATION = 'el_burro_gas_station',
        STRAWBERRY_GAS_STATION = 'strawberry_gas_station',
        DAVIS_GAS_STATION = 'davis_gas_station',
        DAVIS_NO2_GAS_STATION = 'davis_no2_gas_station',
        LITTLE_SEOUL_GAS_STATION = 'little_seoul_gas_station',
        LITTLE_SEOUL_NO2_GAS_STATION = 'little_seoul_no2_gas_station',
        MORNINGWOOD_GAS_STATION = 'morningwood_gas_station',
        PACIFIC_BLUFFS_GAS_STATION = 'pacific_bluffs_gas_station',
        LA_PUERTA_GAS_STATION = 'la_puerta_gas_station',
        ELYSIAN_ISLAND_GAS_STATION = 'elysian_island_gas_station',
        -- furniture_shop
        STRAWBERRY_FURNITURE_SHOP = 'strawberry_furniture_shop',
        DAVIS_FURNITURE_SHOP = 'davis_furniture_shop',
        CYPRESS_FLATS_FURNITURE_SHOP = 'cypress_flats_furniture_shop',
        -- office
        ROCKFORD_HILLS_OFFICE = 'rockford_hills_office',
        DEL_PERRO_OFFICE = 'del_perro_office',
        DEL_PERRO_NO2_OFFICE = 'del_perro_no2_office',
        PILLBOX_HILL_OFFICE = 'pillbox_hill_office',
        PILLBOX_HILL_NO2_OFFICE = 'pillbox_hill_no2_office',
        -- Bank
        PALETO_BAY_BANK = 'paleto_bay_bank',
        PILLBOX_HILL_BANK = 'pillbox_hill_bank',
        ALTA_BANK = 'alta_bank',
        BURTON_BANK = 'burton_bank',
        ROCKFORD_HILLS_BANK = 'rockford_hills_bank',
        BANHAM_CANYON_BANK = 'banham_canyon_bank',
        GRAND_SENORA_BANK = 'grand_senora_bank',
        DOWNTOWN_VINEWOOD_BANK = 'downtown_vinewood_bank',
        -- Fruit Stand
        JOSHUA_RD_GRAND_SENORA_FRUIT_STAND = 'joshua_rd_grand_senora_fruit_stand',
        ROUTE_68_GRAND_SENORA_FRUIT_STAND = 'route_68_grand_senora_fruit_stand',
        MOUNT_CHILIAD_FRUIT_STAND = 'mount_chiliad_fruit_stand',
        VINEWOOD_HILLS_FRUIT_STAND = 'vinewood_hills_fruit_stand',
        VINEWOOD_HILLS_NO2_FRUIT_STAND = 'vinewood_hills_no2_fruit_stand',
        ZANCUDO_GRANDE_FRUIT_STAND = 'zancudo_grande_fruit_stand',
        TONGVA_VALLEY_FRUIT_STAND = 'tongva_valley_fruit_stand',
        CHILIAD_MOUNTAIN_STATE_FRUIT_STAND = 'chiliad_mountain_state_fruit_stand',
        NORTH_CHUMASH_FRUIT_STAND = 'north_chumash_fruit_stand',
        BANHAM_CANYON_FRUIT_STAND = 'banham_canyon_fruit_stand',
        GRAPESEED_FRUIT_STAND = 'grapeseed_fruit_stand',
    },
    TradeState = {
        onFoot = 1,
        onVehicle = 2
    },
}

config.NUIVisibleType = {
    NONE = 0,
    MODAL = 1,
    VEHICLE_STORAGE = 2,
    TRUCKER_PDA = 3,
    TRUCK_RENTAL_MENU = 4
}

config.NUIModalType = {
    CONFIRM = 0,
    DIALOG = 1
}

config.ToggleModalConfirmKvp = {
    key = 'gst_toggle_modal_confirm',
    on = 1,
    off = 2,
}


config.DelayBuyItemByHandTime = 3000            --3seconds Delay Spam Action button to buy vehicle
config.ItemBackRate = 0.95                      --When player back item to industries will lost 5% cash, ANTI SPAM
-- Type of Transport Item, you can't add more type now
config.ItemTransportType = {
    CRATE = 0,     --load/unload by hand
    LIQUIDS = 1,   --load/unload by vehicle
    LOOSE = 2,     --load/unload by vehicle
    VEHICLE = 3,   --load/unload by vehicle
    STRONGBOX = 4, --load/unload by hand
    PALLET = 5,    --load/unload by vehicle
    WOODLOG = 6,   --load/unload by vehicle (Get From Forest)
    CONCRETE = 7   --load/unload by vehicle (Get From Concrete Plant)
}

-- Unit Label Transport Item
config.ItemTransportUnit = {
    [config.ItemTransportType.CRATE] = Lang:t('item_transport_unit_crate'),
    [config.ItemTransportType.LIQUIDS] = Lang:t('item_transport_unit_liquid'),
    [config.ItemTransportType.LOOSE] = Lang:t('item_transport_unit_loose'),
    [config.ItemTransportType.VEHICLE] = Lang:t('item_transport_unit_vehicle'),
    [config.ItemTransportType.STRONGBOX] = Lang:t('item_transport_unit_strongbox'),
    [config.ItemTransportType.PALLET] = Lang:t('item_transport_unit_pallet'),
    [config.ItemTransportType.WOODLOG] = Lang:t('item_transport_unit_woodlog'),
    [config.ItemTransportType.CONCRETE] = Lang:t('item_transport_unit_concrete'),
}
-- Label Item Transport Type
config.VehicleTransportTypeLabel = {
    [config.ItemTransportType.CRATE] = Lang:t('vehicle_transport_type_label_crate'),
    [config.ItemTransportType.LIQUIDS] = Lang:t('vehicle_transport_type_label_liquid'),
    [config.ItemTransportType.LOOSE] = Lang:t('vehicle_transport_type_label_loose'),
    [config.ItemTransportType.VEHICLE] = Lang:t('vehicle_transport_type_label_vehicle'),
    [config.ItemTransportType.STRONGBOX] = Lang:t('vehicle_transport_type_label_strongbox'),
    [config.ItemTransportType.PALLET] = Lang:t('vehicle_transport_type_label_pallet'),
    [config.ItemTransportType.WOODLOG] = Lang:t('vehicle_transport_type_label_woodlog'),
    [config.ItemTransportType.CONCRETE] = Lang:t('vehicle_transport_type_label_concrete'),
}

-- Define Industries, Businesses Items (NOT RELATED TO ITEMS IN INVENTORY)
config.IndustryItems = {
    --terciarias
    -- shared/config.lua (dentro de config.IndustryItems)

-- ############### INÍCIO DOS ITENS DAS INDÚSTRIAS TERCIÁRIAS ###############

    ['smartphone'] = {
        label = 'Smartphone',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['tablet'] = {
        label = 'Tablet',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['sofa_modern'] = {
        label = 'Sofá Moderno',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['mesa_vidro'] = {
        label = 'Mesa de Vidro',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['electric_car'] = {
        label = 'Carro Elétrico',
        capacity = 10,
        transType = config.ItemTransportType.VEHICLE,
    },
    ['motor_electric'] = {
        label = 'Motor Elétrico',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['perfume'] = {
        label = 'Perfume',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['creme_rejuv'] = {
        label = 'Creme Rejuvenescedor',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['jaqueta_luxo'] = {
        label = 'Jaqueta de Luxo',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['sapato_design'] = {
        label = 'Sapato de Grife',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['smart_tv'] = {
        label = 'Smart TV',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['soundbar'] = {
        label = 'Soundbar',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['scanner_ct'] = {
        label = 'Tomógrafo',
        capacity = 5,
        transType = config.ItemTransportType.CRATE,
    },
    ['ventilator'] = {
        label = 'Ventilador Pulmonar',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['router_5g'] = {
        label = 'Roteador 5G',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['antenna_array'] = {
        label = 'Painel de Antenas',
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
    },
    ['console_nextgen'] = {
        label = 'Console de Videogame',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['vr_headset'] = {
        label = 'Headset VR',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['robot_arm'] = {
        label = 'Braço Robótico',
        capacity = 3,
        transType = config.ItemTransportType.CRATE,
    },
    ['automation_unit'] = {
        label = 'Unidade de Automação',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['watch_gold'] = {
        label = 'Relógio de Ouro',
        capacity = 1,
        transType = config.ItemTransportType.STRONGBOX,
    },
    ['watch_silver'] = {
        label = 'Relógio de Prata',
        capacity = 1,
        transType = config.ItemTransportType.STRONGBOX,
    },
    ['packaged_software'] = {
        label = 'Software (Caixa)',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['bolsa_couro'] = {
        label = 'Bolsa de Couro',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['oculos_design'] = {
        label = 'Óculos de Grife',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['wine_premium'] = {
        label = 'Vinho Premium',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['whisky_aged'] = {
        label = 'Whisky Envelhecido',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['parfum_exclusive'] = {
        label = 'Perfume Exclusivo',
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
    },
    ['essence_flower'] = {
        label = 'Essência Floral',
        capacity = 1,
        transType = config.ItemTransportType.LIQUIDS,
    },

-- ############### FIM DOS ITENS DAS INDÚSTRIAS TERCIÁRIAS ###############
    -- Crate
    ['gunpowder'] = {                                                             --SET = string unique (id of item)
        label = Lang:t('item_name_gunpowder'),                                    --SET = string (label of item)
        capacity = 1,                                                             --SET = number (Capacity is the space occupied in the vehicle's trunk by the item. If capacity is 2 and there are 2 items, it will be 2x2=4 capacity of the vehicle.)
        transType = config.ItemTransportType.CRATE,                            --SET = ItemTransportType Constant (Type of item transport)
        minPrice = 30,                                                            --SET = number (Min Price of item)
        maxPrice = 50,                                                            --SET = number (Max Price of item)
        percentProfit = math.random(2, 10) / 100,                                 --SET = number (Profit percentage Trucker will get when sell item to businesses or secondary industries)
        prop = {                                                                  --Prop Of Item
            model = `gr_prop_gr_bulletscrate_01a`,                                --SET = `hash` (Model of object)
            boneId = 28422,                                                       --SET = number (Bone id of ped)
            x = -0.05,                                                            --SET = number (x of offset)
            y = 0.0,                                                              --SET = number (y of offset)
            z = -0.10,                                                            --SET = number (z of offset)
            rx = 0.0,                                                             --SET = number (rx of offset)
            ry = 0.0,                                                             --SET = number (ry of offset)
            rz = 0.0                                                              --SET = number (rz of offset)
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_chemical')),      --SET = string (Where Player Can buy this item)
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_weapon_factory')), --SET = string (Where Player can sell this item)
    },
    ['steel_shapes'] = {
        label = Lang:t('item_name_steel_shapes'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 300,
        maxPrice = 500,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `gr_prop_gr_rsply_crate03a`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_steel_mill')),
        sellToInfo = ('%s, %s, %s'):format(Lang:t('industry_type_label_weapon_factory'),
            Lang:t('industry_type_label_appliances'), Lang:t('industry_type_label_autos')),
    },
    ['clothes'] = {
        label = Lang:t('item_name_clothes'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 200,
        maxPrice = 250,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_textile_factory')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_clothing_store')),
    },
    ['beverages'] = {
        label = Lang:t('item_name_beverages'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 280,
        maxPrice = 300,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `prop_crate_11e`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s, %s'):format(Lang:t('industry_type_label_brewery'), Lang:t('industry_type_label_distillery')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_retail_store')),
    },
    ['meal'] = {
        label = Lang:t('item_name_meal'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 480,
        maxPrice = 530,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_food_processing_plant')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_food_n_drink')),
    },
    ['car_parts'] = {
        label = Lang:t('item_name_car_parts'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 300,
        maxPrice = 330,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `hei_prop_heist_wooden_box`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_autos')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_automotive_shop')),
    },
    ['appliances'] = {
        label = Lang:t('item_name_appliances'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 300,
        maxPrice = 330,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `hei_prop_heist_wooden_box`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_appliances')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_retail_store')),
    },
    ['fruits'] = {
        label = Lang:t('item_name_fruits'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 28,
        maxPrice = 40,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s, %s'):format(Lang:t('industry_type_label_distillery'),
            Lang:t('industry_type_label_fruit_stand')),
    },
    ['meat'] = {
        label = Lang:t('item_name_meat'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 236,
        maxPrice = 249,
        percentProfit = math.random(7, 16) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_food_processing_plant')),
    },
    ['eggs'] = {
        label = Lang:t('item_name_eggs'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 136,
        maxPrice = 149,
        percentProfit = math.random(2, 10) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_food_processing_plant')),
    },
    ['paper'] = {
        label = Lang:t('item_name_paper'),
        capacity = 1,
        transType = config.ItemTransportType.CRATE,
        minPrice = 100,
        maxPrice = 149,
        percentProfit = math.random(8, 12) / 100,
        prop = {
            model = `v_ind_cf_chckbox1`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_sawmill')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_office')),
    },
    ['furniture'] = {
        label = Lang:t('item_name_furniture'),
        capacity = 2,
        transType = config.ItemTransportType.CRATE,
        minPrice = 800,
        maxPrice = 949,
        percentProfit = math.random(8, 12) / 100,
        prop = {
            model = `hei_prop_heist_wooden_box`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_sawmill')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_furniture_shop')),
    },
    ['wood_log'] = {
        label = Lang:t('item_name_wood_log'),
        capacity = 4,
        minPrice = 2300,
        maxPrice = 2500,
        percentProfit = math.random(25, 35) / 100,
        transType = config.ItemTransportType.WOODLOG,
        prop = {
            model = `prop_log_01`
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_forest')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_sawmill')),
    },
    ['wood_plank'] = {
        label = Lang:t('item_name_wood_plank'),
        capacity = 12,
        minPrice = 3800,
        maxPrice = 4200,
        percentProfit = math.random(25, 35) / 100,
        transType = config.ItemTransportType.PALLET,
        prop = {
            model = `prop_woodpile_01a`
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_sawmill')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_constructions')),
    },
    ['transformer'] = {
        label = Lang:t('item_name_transformer'),
        capacity = 6, --1 pallet need 18 slots
        minPrice = 3300,
        maxPrice = 3500,
        percentProfit = math.random(15, 25) / 100,
        transType = config.ItemTransportType.PALLET,
        prop = {
            model = `prop_elecbox_12`
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_appliances')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_powerplant')),
    },
    ['building_materials'] = {
        label = Lang:t('item_name_building_materials'),
        capacity = 6,
        transType = config.ItemTransportType.PALLET,
        minPrice = 911,
        maxPrice = 1250,
        percentProfit = math.random(8, 14) / 100,
        prop = {
            model = `prop_cons_cements01`
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_concrete_plant')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_constructions')),
    },
    -- LIQUIDS
    ['fuel'] = { --Done check location clear
        label = Lang:t('item_name_fuel'),
        capacity = 1,
        transType = config.ItemTransportType.LIQUIDS,
        minPrice = 528,
        maxPrice = 792,
        percentProfit = math.random(2, 10) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_oilfield')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_gas_station')),
    },
    ['milk'] = { --Done check location clear
        label = Lang:t('item_name_milk'),
        capacity = 1,
        minPrice = 811,
        maxPrice = 1050,
        percentProfit = math.random(5, 15) / 100,
        transType = config.ItemTransportType.LIQUIDS,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_food_processing_plant')),
    },
    ['dyes'] = { --Done check location clear
        label = Lang:t('item_name_dyes'),
        capacity = 1,
        transType = config.ItemTransportType.LIQUIDS,
        minPrice = 70,
        maxPrice = 100,
        percentProfit = math.random(15, 18) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_chemical')),
        sellToInfo = ('%s, %s, %s'):format(Lang:t('industry_type_label_textile_factory'),
            Lang:t('industry_type_label_autos'), Lang:t('industry_type_label_automotive_shop')),
    },
    -- Loose
    ['scrap_metal'] = { --Done check location clear
        label = Lang:t('item_name_scrap_metal'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 155,
        maxPrice = 230,
        percentProfit = math.random(9, 14) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_scrapyard')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_steel_mill')),
    },
    ['cotton'] = { --Done check location clear
        label = Lang:t('item_name_cotton'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 785,
        maxPrice = 1320,
        percentProfit = math.random(2, 6) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_textile_factory')),
    },
    ['cereal'] = { --Done check location clear
        label = Lang:t('item_name_cereal'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 1254,
        maxPrice = 2000,
        percentProfit = math.random(2, 6) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s, %s'):format(Lang:t('industry_type_label_food_processing_plant'),
            Lang:t('industry_type_label_malt_house')),
    },
    ['malt'] = { --Done check location clear
        label = Lang:t('item_name_malt'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 600,
        maxPrice = 700,
        percentProfit = math.random(8, 14) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_malt_house')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_brewery')),
    },
    ['aggregate'] = { --Done check location clear
        label = Lang:t('item_name_aggregate'),
        capacity = 1,
        minPrice = 111,
        maxPrice = 200,
        percentProfit = math.random(8, 14) / 100,
        transType = config.ItemTransportType.LOOSE,
        buyFromInfo = ('%s, %s'):format(Lang:t('industry_type_label_mineral'), Lang:t('industry_type_label_quarry')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_concrete_plant')),
    },
    ['ore'] = { --Done check location clear
        label = Lang:t('item_name_ore'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 150,
        maxPrice = 200,
        percentProfit = math.random(8, 16) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_mineral')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_metallurgical')),
    },
    ['metal_ores'] = { --Done check location clear
        label = Lang:t('item_name_metal_ores'),
        capacity = 1,
        transType = config.ItemTransportType.LOOSE,
        minPrice = 450,
        maxPrice = 600,
        percentProfit = math.random(8, 16) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_metallurgical')),
        sellToInfo = ('%s, %s'):format(Lang:t('industry_type_label_mint'), Lang:t('industry_type_label_steel_mill')),
    },
    ['concrete'] = { --Done check location clear
        label = Lang:t('item_name_concrete'),
        capacity = 1,
        transType = config.ItemTransportType.CONCRETE,
        minPrice = 550,
        maxPrice = 620,
        percentProfit = math.random(12, 20) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_concrete_plant')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_constructions')),
    },
    -- Vehicles
    ['vehicle'] = { --Done check location clear
        label = Lang:t('item_name_vehicle'),
        capacity = 10,
        transType = config.ItemTransportType.VEHICLE,
        minPrice = 7450,
        maxPrice = 8600,
        percentProfit = math.random(8, 16) / 100,
        prop = {
            model = `imp_prop_covered_vehicle_02a`,
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_autos')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_dealership')),
    },
    -- Strong Box
    ['weapons'] = {
        label = Lang:t('item_name_weapons'),
        capacity = 2,
        transType = config.ItemTransportType.STRONGBOX,
        minPrice = 2500,
        maxPrice = 3000,
        percentProfit = math.random(8, 18) / 100,
        prop = {
            model = `gr_prop_gr_rsply_crate01a`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_weapon_factory')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_ammunation')),
    },
    ['coins'] = {
        label = Lang:t('item_name_coins'),
        capacity = 2,
        transType = config.ItemTransportType.STRONGBOX,
        minPrice = 1500,
        maxPrice = 2000,
        percentProfit = math.random(8, 16) / 100,
        prop = {
            model = `sm_prop_smug_rsply_crate02a`,
            boneId = 28422,
            x = -0.05,
            y = 0.0,
            z = -0.10,
            rx = 0.0,
            ry = 0.0,
            rz = 0.0
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_mint')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_bank')),
    },

}

-- Define Fix Pos Z of crate when attach to vehicle, now you don't need care of it
config.FixCratePropPosZ = {
    [`hei_prop_heist_wooden_box`] = 0.255,
}



config.SkillTypeField = {
    totalProfit = 'totalProfit',
    totalPackage = 'totalPackage',
    totalDistance = 'totalDistance',
    currentExp = 'exp',
    currentLevel = 'level'
}

config.IsPackageMultiplyItemCapacity = true


-- Shared Functions, pls don't touch
function math.groupdigits(number, seperator) -- credit http://richard.warburton.it
    local left, num, right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. (seperator or ',')):reverse()) .. right
end

function IsItemTransportTypeCanMix(transType)
    -- With these types of items, the vehicle can carry many different types of goods
    if transType == config.ItemTransportType.CRATE or
        transType == config.ItemTransportType.STRONGBOX then
        return true
    end
    return false
end

function IsVehicleModelCanDospacetrucker(vehicleModelHash)
    if config.VehicleTransport[vehicleModelHash] then return true end
    return false
end

function IsVehicleModelCanTransportType(vehicleModelHash, transType)
    if not config.VehicleTransport[vehicleModelHash] then return false end
    for key, value in pairs(config.VehicleTransport[vehicleModelHash].transType) do
        if key == transType then return true end
    end

    return false
end

-- Industry Global Function
function GetIndustryTierLabel(_tier)
    if _tier == config.Industry.Tier.PRIMARY then
        return Lang:t('industry_tier_label_primary')
    elseif _tier == config.Industry.Tier.SECONDARY then
        return Lang:t('industry_tier_label_secondary')
    elseif _tier == config.Industry.Tier.TERTIARY then -- ADICIONADO
        return Lang:t('industry_tier_label_tertiary')      -- ADICIONADO (Você precisará adicionar esta tradução no seu arquivo de localidade)
    elseif _tier == config.Industry.Tier.BUSINESS then
        return Lang:t('industry_tier_label_business')
    end
end

function GetIndustryTypeLabel(_tier, _type)
    local typeLabel = {
        -- Primary
        [config.Industry.Tier.PRIMARY] = {
            [config.Industry.Type.Primary.OILFIELD] = Lang:t('industry_type_label_oilfield'),
            [config.Industry.Type.Primary.CHEMICAL] = Lang:t('industry_type_label_chemical'),
            [config.Industry.Type.Primary.SCRAPYARD] = Lang:t('industry_type_label_scrapyard'),
            [config.Industry.Type.Primary.FOREST] = Lang:t('industry_type_label_forest'),
            [config.Industry.Type.Primary.FARM] = Lang:t('industry_type_label_farm'),
            [config.Industry.Type.Primary.MINERAL] = Lang:t('industry_type_label_mineral'),
            [config.Industry.Type.Primary.QUARRY] = Lang:t('industry_type_label_quarry'),
        },
        [config.Industry.Tier.SECONDARY] = {
            --] Secondary
            [config.Industry.Type.Secondary.MINT] = Lang:t('industry_type_label_mint'), -- Federal Mint
            [config.Industry.Type.Secondary.WEAPON_FACTORY] = Lang:t('industry_type_label_weapon_factory'),
            [config.Industry.Type.Secondary.STEEL_MILL] = Lang:t('industry_type_label_steel_mill'),
            [config.Industry.Type.Secondary.SAWMILL] = Lang:t('industry_type_label_sawmill'),
            [config.Industry.Type.Secondary.TEXTILE_FACTORY] = Lang:t('industry_type_label_textile_factory'),
            [config.Industry.Type.Secondary.BREWERY] = Lang:t('industry_type_label_brewery'),
            [config.Industry.Type.Secondary.FOOD_PROCESSING_PLANT] = Lang:t(
                'industry_type_label_food_processing_plant'),
            [config.Industry.Type.Secondary.CONCRETE_PLANT] = Lang:t('industry_type_label_concrete_plant'),
            [config.Industry.Type.Secondary.DISTILLERY] = Lang:t('industry_type_label_distillery'),
            [config.Industry.Type.Secondary.MALT_HOUSE] = Lang:t('industry_type_label_malt_house'),
            [config.Industry.Type.Secondary.APPLIANCES] = Lang:t('industry_type_label_appliances'),
            [config.Industry.Type.Secondary.AUTOS] = Lang:t('industry_type_label_autos'),
            [config.Industry.Type.Secondary.METALLURGICAL] = Lang:t('industry_type_label_metallurgical'),
        },
        [config.Industry.Tier.BUSINESS] = {
            --] BUSINESS
            [config.Industry.Type.Business.CONSTRUCTIONS] = Lang:t('industry_type_label_constructions'),
            [config.Industry.Type.Business.POWERPLANT] = Lang:t('industry_type_label_powerplant'),
            [config.Industry.Type.Business.AMMUNATION] = Lang:t('industry_type_label_ammunation'),
            [config.Industry.Type.Business.RETAIL_STORE] = Lang:t('industry_type_label_retail_store'),
            [config.Industry.Type.Business.AUTOMOTIVE_SHOP] = Lang:t('industry_type_label_automotive_shop'), --car_parts, dyes
            [config.Industry.Type.Business.FOOD_N_DRINK] = Lang:t('industry_type_label_food_n_drink'),
            [config.Industry.Type.Business.CLOTHING_STORE] = Lang:t('industry_type_label_clothing_store'),
            [config.Industry.Type.Business.DEALERSHIP] = Lang:t('industry_type_label_dealership'),
            [config.Industry.Type.Business.GAS_STATION] = Lang:t('industry_type_label_gas_station'),
            [config.Industry.Type.Business.FURNITURE_SHOP] = Lang:t('industry_type_label_furniture_shop'),
            [config.Industry.Type.Business.OFFICE] = Lang:t('industry_type_label_office'),
            [config.Industry.Type.Business.BANK] = Lang:t('industry_type_label_bank'),
            [config.Industry.Type.Business.FRUIT_STAND] = Lang:t('industry_type_label_fruit_stand'),
        },
    }
    return typeLabel[_tier][_type]
end


