-- GST is mean Gasman Studio Trucker
spaceconfig = {}
spaceconfig.DropPackageWhenDie = true          --SET = true or false (Need call function OnPlayerDeath() when player die to turn this system)
spaceconfig.ShowTradePointBlipOnMinimap = true --SET = true or false (To enable or disabled Sell & Buy trade point of industries and businesses)
spaceconfig.AddVehicleProps = true             --SET = true or false (To enable or disabled Add vehicle crate/pallet props)

spaceconfig.JobName = 'trucker'           --SET = string name of job you wanted
spaceconfig.JobRequired = true           --SET = true or false (To enable job require or not)
-- Industries spaceconfig
spaceconfig.Company = {
    CreateCost = 50000, -- O custo para criar uma nova empresa
    SellReturnValue = 25000, -- O valor fixo que o jogador recebe ao vender a empresa
}
spaceconfig.Industry = {
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

spaceconfig.NUIVisibleType = {
    NONE = 0,
    MODAL = 1,
    VEHICLE_STORAGE = 2,
    TRUCKER_PDA = 3,
    TRUCK_RENTAL_MENU = 4
}

spaceconfig.NUIModalType = {
    CONFIRM = 0,
    DIALOG = 1
}

spaceconfig.ToggleModalConfirmKvp = {
    key = 'gst_toggle_modal_confirm',
    on = 1,
    off = 2,
}

spaceconfig.IsRequiredForkLiftToBuyItemCargo = false -- This feature will be update soon

spaceconfig.IsAllowToSellCrateByVehicle = true       -- Allow player can sell Crate/Strongbox by vehicle
-- If allow sell by vehicle so player will waiting more time
spaceconfig.DelayTimeWhenSellCrateByVehicle = 5      -- (Seconds) (Progress bar when sell crate/strongbox by vehicle will add more 1seconds per box)

spaceconfig.DelayBuyItemByHandTime = 3000            --3seconds Delay Spam Action button to buy vehicle
spaceconfig.ItemBackRate = 0.95                      --When player back item to industries will lost 5% cash, ANTI SPAM
-- Type of Transport Item, you can't add more type now
spaceconfig.ItemTransportType = {
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
spaceconfig.ItemTransportUnit = {
    [spaceconfig.ItemTransportType.CRATE] = Lang:t('item_transport_unit_crate'),
    [spaceconfig.ItemTransportType.LIQUIDS] = Lang:t('item_transport_unit_liquid'),
    [spaceconfig.ItemTransportType.LOOSE] = Lang:t('item_transport_unit_loose'),
    [spaceconfig.ItemTransportType.VEHICLE] = Lang:t('item_transport_unit_vehicle'),
    [spaceconfig.ItemTransportType.STRONGBOX] = Lang:t('item_transport_unit_strongbox'),
    [spaceconfig.ItemTransportType.PALLET] = Lang:t('item_transport_unit_pallet'),
    [spaceconfig.ItemTransportType.WOODLOG] = Lang:t('item_transport_unit_woodlog'),
    [spaceconfig.ItemTransportType.CONCRETE] = Lang:t('item_transport_unit_concrete'),
}
-- Label Item Transport Type
spaceconfig.VehicleTransportTypeLabel = {
    [spaceconfig.ItemTransportType.CRATE] = Lang:t('vehicle_transport_type_label_crate'),
    [spaceconfig.ItemTransportType.LIQUIDS] = Lang:t('vehicle_transport_type_label_liquid'),
    [spaceconfig.ItemTransportType.LOOSE] = Lang:t('vehicle_transport_type_label_loose'),
    [spaceconfig.ItemTransportType.VEHICLE] = Lang:t('vehicle_transport_type_label_vehicle'),
    [spaceconfig.ItemTransportType.STRONGBOX] = Lang:t('vehicle_transport_type_label_strongbox'),
    [spaceconfig.ItemTransportType.PALLET] = Lang:t('vehicle_transport_type_label_pallet'),
    [spaceconfig.ItemTransportType.WOODLOG] = Lang:t('vehicle_transport_type_label_woodlog'),
    [spaceconfig.ItemTransportType.CONCRETE] = Lang:t('vehicle_transport_type_label_concrete'),
}

-- Define Industries, Businesses Items (NOT RELATED TO ITEMS IN INVENTORY)
spaceconfig.IndustryItems = {
    --terciarias
    -- shared/gst_config.lua (dentro de spaceconfig.IndustryItems)

-- ############### INÍCIO DOS ITENS DAS INDÚSTRIAS TERCIÁRIAS ###############

    ['smartphone'] = {
        label = 'Smartphone',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['tablet'] = {
        label = 'Tablet',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['sofa_modern'] = {
        label = 'Sofá Moderno',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['mesa_vidro'] = {
        label = 'Mesa de Vidro',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['electric_car'] = {
        label = 'Carro Elétrico',
        capacity = 10,
        transType = spaceconfig.ItemTransportType.VEHICLE,
    },
    ['motor_electric'] = {
        label = 'Motor Elétrico',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['perfume'] = {
        label = 'Perfume',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['creme_rejuv'] = {
        label = 'Creme Rejuvenescedor',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['jaqueta_luxo'] = {
        label = 'Jaqueta de Luxo',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['sapato_design'] = {
        label = 'Sapato de Grife',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['smart_tv'] = {
        label = 'Smart TV',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['soundbar'] = {
        label = 'Soundbar',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['scanner_ct'] = {
        label = 'Tomógrafo',
        capacity = 5,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['ventilator'] = {
        label = 'Ventilador Pulmonar',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['router_5g'] = {
        label = 'Roteador 5G',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['antenna_array'] = {
        label = 'Painel de Antenas',
        capacity = 2,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['console_nextgen'] = {
        label = 'Console de Videogame',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['vr_headset'] = {
        label = 'Headset VR',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['robot_arm'] = {
        label = 'Braço Robótico',
        capacity = 3,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['automation_unit'] = {
        label = 'Unidade de Automação',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['watch_gold'] = {
        label = 'Relógio de Ouro',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.STRONGBOX,
    },
    ['watch_silver'] = {
        label = 'Relógio de Prata',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.STRONGBOX,
    },
    ['packaged_software'] = {
        label = 'Software (Caixa)',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['bolsa_couro'] = {
        label = 'Bolsa de Couro',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['oculos_design'] = {
        label = 'Óculos de Grife',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['wine_premium'] = {
        label = 'Vinho Premium',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['whisky_aged'] = {
        label = 'Whisky Envelhecido',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['parfum_exclusive'] = {
        label = 'Perfume Exclusivo',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CRATE,
    },
    ['essence_flower'] = {
        label = 'Essência Floral',
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LIQUIDS,
    },

-- ############### FIM DOS ITENS DAS INDÚSTRIAS TERCIÁRIAS ###############
    -- Crate
    ['gunpowder'] = {                                                             --SET = string unique (id of item)
        label = Lang:t('item_name_gunpowder'),                                    --SET = string (label of item)
        capacity = 1,                                                             --SET = number (Capacity is the space occupied in the vehicle's trunk by the item. If capacity is 2 and there are 2 items, it will be 2x2=4 capacity of the vehicle.)
        transType = spaceconfig.ItemTransportType.CRATE,                            --SET = ItemTransportType Constant (Type of item transport)
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.CRATE,
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
        transType = spaceconfig.ItemTransportType.WOODLOG,
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
        transType = spaceconfig.ItemTransportType.PALLET,
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
        transType = spaceconfig.ItemTransportType.PALLET,
        prop = {
            model = `prop_elecbox_12`
        },
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_appliances')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_powerplant')),
    },
    ['building_materials'] = {
        label = Lang:t('item_name_building_materials'),
        capacity = 6,
        transType = spaceconfig.ItemTransportType.PALLET,
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
        transType = spaceconfig.ItemTransportType.LIQUIDS,
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
        transType = spaceconfig.ItemTransportType.LIQUIDS,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_food_processing_plant')),
    },
    ['dyes'] = { --Done check location clear
        label = Lang:t('item_name_dyes'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LIQUIDS,
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
        transType = spaceconfig.ItemTransportType.LOOSE,
        minPrice = 155,
        maxPrice = 230,
        percentProfit = math.random(9, 14) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_scrapyard')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_steel_mill')),
    },
    ['cotton'] = { --Done check location clear
        label = Lang:t('item_name_cotton'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LOOSE,
        minPrice = 785,
        maxPrice = 1320,
        percentProfit = math.random(2, 6) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_farm')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_textile_factory')),
    },
    ['cereal'] = { --Done check location clear
        label = Lang:t('item_name_cereal'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LOOSE,
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
        transType = spaceconfig.ItemTransportType.LOOSE,
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
        transType = spaceconfig.ItemTransportType.LOOSE,
        buyFromInfo = ('%s, %s'):format(Lang:t('industry_type_label_mineral'), Lang:t('industry_type_label_quarry')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_concrete_plant')),
    },
    ['ore'] = { --Done check location clear
        label = Lang:t('item_name_ore'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LOOSE,
        minPrice = 150,
        maxPrice = 200,
        percentProfit = math.random(8, 16) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_mineral')),
        sellToInfo = ('%s'):format(Lang:t('industry_type_label_metallurgical')),
    },
    ['metal_ores'] = { --Done check location clear
        label = Lang:t('item_name_metal_ores'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.LOOSE,
        minPrice = 450,
        maxPrice = 600,
        percentProfit = math.random(8, 16) / 100,
        buyFromInfo = ('%s'):format(Lang:t('industry_type_label_metallurgical')),
        sellToInfo = ('%s, %s'):format(Lang:t('industry_type_label_mint'), Lang:t('industry_type_label_steel_mill')),
    },
    ['concrete'] = { --Done check location clear
        label = Lang:t('item_name_concrete'),
        capacity = 1,
        transType = spaceconfig.ItemTransportType.CONCRETE,
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
        transType = spaceconfig.ItemTransportType.VEHICLE,
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
        transType = spaceconfig.ItemTransportType.STRONGBOX,
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
        transType = spaceconfig.ItemTransportType.STRONGBOX,
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
spaceconfig.FixCratePropPosZ = {
    [`hei_prop_heist_wooden_box`] = 0.255,
}

spaceconfig.VehicleImageUrl = 'https://docs.fivem.net/vehicles/%s.webp' --%s is name of vehicle
spaceconfig.VehicleRentBaseCost = 200                                   -- If vehicle no have rentPrice -> BaseCost x VehicleCapacity for Rent price
spaceconfig.VehicleRentReturnFeePercent = 60

--Will give back 60% to player when player return vehicle
spaceconfig.VehicleRentLocations = {                            --Trucker Rental
    ['truck_rent_point_1'] = {                                --SET = string (id of rent place)
        id = 'truck_rent_point_1',                            --SET = string (id of rent place)
        title = 'Truck Rental Point No.1',                    --SET = string (Label of rent place will show on marker)
        description = 'Car rental area for Courier trainees',
        location = vector3(754.0601, -1405.5013, 26.5538),    --SET = vector3 (location of rent place)
        spawnPositions = {                                    --Vehicle Spawn Locations (Automatic detect and select slot are clear to spawn)
            vector4(761.0732, -1403.3821, 26.1088, 180.6744), --SET = vector4(x,y,z,w) (location of vehicle spawn)
            vector4(767.4675, -1403.1938, 26.2578, 176.9655),
            vector4(758.9108, -1415.7498, 26.2222, 271.6529),
            vector4(769.5524, -1416.1852, 25.9931, 269.8020),
            vector4(731.8533, -1409.3878, 26.1019, 88.3230),
            vector4(721.5046, -1415.1003, 25.9373, 356.2691),
            vector4(728.6129, -1390.6893, 26.1824, 90.7290),
            vector4(727.8906, -1384.9747, 25.9341, 89.6029)
        },
        vehList = {    --Vehicles pick from spaceconfig.VehicleTransport (Make sure the vehicle is defined in spaceconfig.VehicleTransport)
            `minivan`, --SET = hash (`vehicle_model`)
            `dloader`,
            `rebel`,
            `youga`,
        },
        private = false,                  --SET = true or false (Show on list in trucker PDA)
        showBlip = true,                  --SET = true or false (Show blip of rental place)
        blipLabel = 'Truck Rental Point', --SET = string (Label of rent place will show on blip and marker)
        blipSprite = 477,                 --SET = number (Sprite of rental place)
        blipColor = 8,                    --SET = number (Color id of blip)
    },
    ['truck_rent_point_2'] = {
        id = 'truck_rent_point_2',
        title = 'Truck Rental Point No.2',
        description = 'Car rental area for Courier',
        location = vector3(1224.7738, 2727.0000, 38.0043),
        spawnPositions = {
            vector4(1213.5249, 2731.3855, 37.9584, 181.6919),
            vector4(1204.3994, 2726.0977, 37.7922, 265.0097),
            vector4(1235.5227, 2730.4695, 37.7935, 180.7120),
            vector4(1245.2842, 2733.7407, 38.2344, 182.0788)
        },
        vehList = {
            `bodhi2`,
            `pony`,
            `rumpo`,
            `speedo`,
        },
        private = false,
        showBlip = true,
        blipLabel = 'Truck Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['truck_rent_point_3'] = {
        id = 'truck_rent_point_3',
        title = 'Truck Rental Point No.3',
        description = 'Car rental area for Pro Courier',
        location = vector3(1187.8943, -3252.0137, 6.0288),
        spawnPositions = {
            vector4(1198.4800, -3240.4441, 5.8700, 2.2878),
            vector4(1204.0704, -3240.9846, 5.9770, 359.2072)
        },
        vehList = {
            `boxville2`,
            `boxville3`,
            `boxville4`,
            `paradise`,
        },
        private = false,
        showBlip = true,
        blipLabel = 'Truck Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['truck_rent_point_4'] = {
        id = 'truck_rent_point_4',
        title = 'Truck Rental Point No.4',
        description = 'Car rental area for Trucker Trainees',
        location = vector3(914.6329, -1243.4745, 25.4912),    --SET = vector3 (location of rent place)
        spawnPositions = {                                    --Vehicle Spawn Locations (Automatic detect and select slot are clear to spawn)
            vector4(906.4022, -1229.2695, 25.5701, 181.0857), --SET = vector4(x,y,z,w) (location of vehicle spawn)
            vector4(912.4000, -1229.3610, 25.5795, 181.4931),
            vector4(918.5778, -1228.8955, 25.6179, 180.6292),
            vector4(925.0247, -1228.9755, 25.6519, 180.8017)
        },
        vehList = {
            `benson`,
            `mule2`,
            `vetir`,
            `tiptruck`,
            `rubble`,
            `biff`,
            `mixer`,
            `stockade`
        },
        private = false,
        showBlip = true,
        blipLabel = 'Truck Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['truck_rent_point_5'] = {
        id = 'truck_rent_point_5',
        title = 'Truck Rental Point No.5',
        description = 'Car rental area for Trucker',
        location = vector3(989.0637, -3201.0698, 5.9755),     --SET = vector3 (location of rent place)
        spawnPositions = {                                    --Vehicle Spawn Locations (Automatic detect and select slot are clear to spawn)
            vector4(1001.1896, -3207.1047, 5.9752, 359.2960), --SET = vector4(x,y,z,w) (location of vehicle spawn)
            vector4(1009.4607, -3206.2988, 6.0064, 0.5871),
            vector4(1018.0942, -3185.7512, 5.9891, 178.7883),
            vector4(1009.3785, -3186.4468, 5.9749, 178.6374)
        },
        vehList = {
            `pounder`,
            `pounder2`,
            `trailers`,
            `trailers2`,
            `trailers3`,
            `trailers4`,
            `trflat`,
            `tanker`,
            `tanker2`,
            `tr2`,
            `flatbed`
        },
        private = false,
        showBlip = true,
        blipLabel = 'Truck Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    -- Forklift Rental
    ['forklift_rental_chemical_factory'] = {                   --SET = string (id of rent place)
        id = 'forklift_rental_chemical_factory',               --SET = string (id of rent place)
        title = 'Forklift Rental Point',                       --SET = string (Label of rent place will show on marker)
        description = '',
        location = vector3(3614.7446, 3734.1648, 28.6901),     --SET = vector3 (location of rent place)
        spawnPositions = {                                     --Vehicle Spawn Locations (Automatic detect and select slot are clear to spawn)
            vector4(3619.2842, 3742.1467, 28.1441, 145.5521),  --SET = vector4(x,y,z,w) (location of vehicle spawn)
        },
        vehList = {                                            --Vehicles pick from spaceconfig.VehicleTransport (Make sure the vehicle is defined in spaceconfig.VehicleTransport)
            `forklift`,                                        --SET = hash (`vehicle_model`)
        },
        private = true,                                        --SET = true or false (Show on list in trucker PDA)
        showBlip = true,                                       --SET = true or false (Show blip of rental place)
        blipLabel = 'Forklift Rental Point',                   --SET = string (Label of rent place will show on blip and marker)
        blipSprite = 477,                                      --SET = number (Sprite of rental place)
        blipColor = 8,                                         --SET = number (Color id of blip)
    },
    ['forklift_rental_la_fuente_farm'] = {                     --SET = string (id of rent place)
        id = 'forklift_rental_la_fuente_farm',                 --SET = string (id of rent place)
        title = 'Forklift Rental Point',                       --SET = string (Label of rent place will show on marker)
        description = '',
        location = vector3(1420.2803, 1112.7699, 114.7482),    --SET = vector3 (location of rent place)
        spawnPositions = {                                     --Vehicle Spawn Locations (Automatic detect and select slot are clear to spawn)
            vector4(1421.4524, 1108.5861, 113.8547, 274.8860), --SET = vector4(x,y,z,w) (location of vehicle spawn)
        },
        vehList = {                                            --Vehicles pick from spaceconfig.VehicleTransport (Make sure the vehicle is defined in spaceconfig.VehicleTransport)
            `forklift`,                                        --SET = hash (`vehicle_model`)
        },
        private = true,                                        --SET = true or false (Show on list in trucker PDA)
        showBlip = true,                                       --SET = true or false (Show blip of rental place)
        blipLabel = 'Forklift Rental Point',                   --SET = string (Label of rent place will show on blip and marker)
        blipSprite = 477,                                      --SET = number (Sprite of rental place)
        blipColor = 8,                                         --SET = number (Color id of blip)
    },
    ['forklift_rental_no12_farm'] = {
        id = 'forklift_rental_no12_farm',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(2313.7537, 4899.2241, 41.8082),
        spawnPositions = {
            vector4(2321.1277, 4901.3481, 41.2629, 139.0744),
            vector4(2325.3215, 4898.8257, 41.2659, 129.4943)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_no12_farm_eggs'] = {
        id = 'forklift_rental_no12_farm_eggs',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(2409.9211, 4998.4092, 46.5773),
        spawnPositions = {
            vector4(2406.0334, 4997.3530, 45.9828, 230.1635)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_no14_farm'] = {
        id = 'forklift_rental_no14_farm',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(2183.3850, 5077.1616, 45.0321),
        spawnPositions = {
            vector4(2179.0696, 5082.4819, 44.5151, 146.6874)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_no15_farm'] = {
        id = 'forklift_rental_no15_farm',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(2016.3281, 4970.8633, 41.4174),
        spawnPositions = {
            vector4(2010.0145, 4967.7842, 41.0726, 308.4966)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_steel_mill'] = {
        id = 'forklift_rental_steel_mill',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(-244.2697, 6062.0903, 31.8506),
        spawnPositions = {
            vector4(-242.1141, 6055.1694, 31.4447, 44.5248)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_appliances_sale'] = {
        id = 'forklift_rental_appliances_sale',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(970.7326, -1712.1522, 30.1644),
        spawnPositions = {
            vector4(976.9480, -1712.7141, 29.7249, 86.9948)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_autos_sale'] = {
        id = 'forklift_rental_autos_sale',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(212.3577, -3318.0254, 5.7906),
        spawnPositions = {
            vector4(209.2862, -3317.1746, 5.2414, 177.2176)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_weapon_factory'] = {
        id = 'forklift_rental_weapon_factory',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(830.5513, -2121.7720, 29.3490),
        spawnPositions = {
            vector4(826.2284, -2116.9832, 28.8114, 176.2731),
            vector4(830.0359, -2117.2026, 28.8148, 174.0322)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_textile_factory'] = {
        id = 'forklift_rental_textile_factory',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(752.9787, -956.0695, 24.8270),
        spawnPositions = {
            vector4(749.2408, -952.7939, 24.2302, 178.5955)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_brewery'] = {
        id = 'forklift_rental_brewery',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(833.6230, -1936.7157, 28.9520),
        spawnPositions = {
            vector4(836.2643, -1931.1975, 28.4110, 173.2699)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = false,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_food_process_sale'] = {
        id = 'forklift_rental_food_process_sale',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(-116.5839, 6214.0776, 31.1993),
        spawnPositions = {
            vector4(-116.8702, 6218.4844, 30.6431, 132.7196)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = false,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_distillery'] = {
        id = 'forklift_rental_distillery',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(-1929.1731, 2061.7554, 140.8383),
        spawnPositions = {
            vector4(-1925.3229, 2061.4170, 140.2894, 256.8485)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = false,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    },
    ['forklift_rental_sawmill'] = {
        id = 'forklift_rental_sawmill',
        title = 'Forklift Rental Point',
        description = '',
        location = vector3(-570.5053, 5248.3833, 70.4875),
        spawnPositions = {
            vector4(-569.8289, 5253.0283, 69.9304, 75.3704)
        },
        vehList = {
            `forklift`,
        },
        private = true,
        showBlip = true,
        blipLabel = 'Forklift Rental Point',
        blipSprite = 477,
        blipColor = 8,
    }
}

-- level = 1->9 Courier Trainee can use Vehicle Capacity from 1 -> 10 (Crate)
-- level = 10->19 Courier can use Vehicle Capacity up to  15 (Crate)
-- level = 20->29 Pro Courier can use Vehicle Capacity more 15 (Crate)

-- level = 30->39 Trucker Trainee Can use vehicle Capacity up to 40 (Crate, Pallet, strongbox, loose)
-- level = 40->49 Trucker Can use vehicle capacity up to 50 (Crate, Pallet, strongbox, loose)
-- level = >= 50 Pro Trucker Can use all vehicle (Crate, Pallet, strongbox, loose, liquids, vehicle)
-- Define Vehicles
spaceconfig.VehicleTransport = {
    [`dloader`] = {                                    --SET = hash (`vehicle_model`)
        name = 'dloader',                              --SET = string (vehicle_model)
        label = 'Duneloader',                          --SET = string (Label of vehicle)
        capacity = 6,                                  --SET = number (Vehicle Storage Capacities related with item capacity)
        level = 100,                                     --SET = number (Level Required Player Can Use This Vehicle)
        transType = {                                  --SET = table (Table of transport type)
            [spaceconfig.ItemTransportType.CRATE] = true --SET = [ITEM_TRANSPORT_TYPE] = true or false (Transport type vehicle can handler)
        },
        props = {                                      --Vehicle Prop Offset Defined
            bone = 'chassic',                          --Bone of vehicle Prop default is chassic
            [spaceconfig.ItemTransportType.CRATE] = {    --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
                vector3(-0.335, -0.78, 0.41),
                vector3(0.36, -0.78, 0.41),
                vector3(-0.33, -1.48, 0.41),
                vector3(0.375, -1.48, 0.41),
                vector3(-0.33, -2.14, 0.41),
                vector3(0.37, -2.14, 0.41)
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`kalahari`] = {
        name = 'kalahari',
        label = 'Kalahari',
        capacity = 3,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.35, -0.86, 0.055),
                vector3(0.345, -0.86, 0.055),
                vector3(-0.005, -1.465, 0.055),
            }
        },
        trunkOffset = vector3(0.0, -1.0, 0.0)
    },
    [`caracara2`] = {
        name = 'caracara2',
        label = 'Caracara 4x4',
        capacity = 4,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.27, -1.69, 0.26),
                vector3(0.29, -1.69, 0.26),
                vector3(-0.26, -2.345, 0.26),
                vector3(0.29, -2.345, 0.26),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`dubsta3`] = {
        name = 'dubsta3',
        label = 'Dubsta 6x6',
        capacity = 3,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(0.005, -1.905, 0.095),
                vector3(0.005, -2.455, 0.095),
                vector3(0.005, -2.995, 0.095),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`patriot3`] = {
        name = 'patriot3',
        label = 'Patriot Mil-Spec',
        capacity = 4,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.315, -1.42, 0.21),
                vector3(0.32, -1.42, 0.21),
                vector3(-0.305, -1.98, 0.21),
                vector3(0.315, -1.98, 0.21),
            }
        },
        trunkOffset = vector3(0.0, -1.8, 0.0)
    },
    [`riata`] = {
        name = 'riata',
        label = 'Riata',
        capacity = 6,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.26, -1.04, 0.36),
                vector3(0.26, -1.04, 0.36),
                vector3(-0.26, -1.635, 0.36),
                vector3(0.265, -1.635, 0.36),
                vector3(-0.25, -2.21, 0.36),
                vector3(0.27, -2.21, 0.36),
            }
        },
        trunkOffset = vector3(0.0, -1.8, 0.0)
    },
    [`everon`] = {
        name = 'everon',
        label = 'Everon',
        capacity = 7,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.28, -1.31, 0.1),
                vector3(0.28, -1.31, 0.1),
                vector3(-0.275, -1.83, 0.1),
                vector3(0.275, -1.83, 0.1),
                vector3(-0.5, -2.36, 0.1),
                vector3(0.035, -2.36, 0.1),
                vector3(0.565, -2.36, 0.1)
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.0)
    },
    [`bodhi2`] = {
        name = 'bodhi2',
        label = 'Bodhi',
        capacity = 11,
        level = 200,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.27, -0.815, -0.2),
                vector3(0.26, -0.815, -0.2),
                vector3(-0.515, -1.36, -0.2),
                vector3(0.02, -1.36, -0.2),
                vector3(0.545, -1.36, -0.2),
                vector3(0.545, -1.885, -0.2),
                vector3(0.015, -1.885, -0.2),
                vector3(-0.51, -1.885, -0.2),
                vector3(-0.51, -2.395, -0.2),
                vector3(0.02, -2.395, -0.2),
                vector3(0.55, -2.395, -0.2),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`bobcatxl`] = {
        name = 'bobcatxl',
        label = 'Bobcat XL',
        capacity = 7,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.5, -1.235, 0.0),
                vector3(0.07, -1.24, 0.0),
                vector3(0.615, -1.24, 0.0),
                vector3(0.265, -1.84, 0.0),
                vector3(-0.275, -1.84, 0.0),
                vector3(-0.275, -2.41, 0.0),
                vector3(0.265, -2.41, 0.0),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`yosemite3`] = {
        name = 'yosemite3',
        label = 'Yosemite Rancher',
        capacity = 5,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.255, -1.36, 0.51),
                vector3(0.255, -1.36, 0.51),
                vector3(0.55, -1.99, 0.405),
                vector3(-0.024, -1.99, 0.405),
                vector3(-0.545, -1.99, 0.405),
            }
        },
        trunkOffset = vector3(0.0, -1.8, 0.0)
    },
    [`rebel`] = {
        name = 'rebel',
        label = 'Rusty Rebel',
        capacity = 6,
        level = 150,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.23, -0.795, 0.295),
                vector3(0.28, -0.795, 0.295),
                vector3(0.28, -1.39, 0.295),
                vector3(-0.23, -1.39, 0.295),
                vector3(-0.23, -1.94, 0.295),
                vector3(0.295, -1.94, 0.295),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.0)
    },
    [`rebel2`] = {
        name = 'rebel2',
        label = 'Rebel',
        capacity = 6,
        level = 150,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.23, -0.795, 0.295),
                vector3(0.28, -0.795, 0.295),
                vector3(0.28, -1.39, 0.295),
                vector3(-0.23, -1.39, 0.295),
                vector3(-0.23, -1.94, 0.295),
                vector3(0.295, -1.94, 0.295),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.0)
    },
    [`kamacho`] = {
        name = 'kamacho',
        label = 'Kamacho',
        capacity = 4,
        level = 120,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.31, -1.4, 0.27),
                vector3(0.33, -1.4, 0.27),
                vector3(0.33, -1.935, 0.27),
                vector3(-0.31, -1.935, 0.27),
                vector3(-0.31, -2.475, 0.27),
                vector3(0.32, -2.475, 0.27),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.0)
    },
    [`bison`] = {
        name = 'bison',
        label = 'Bison',
        capacity = 300,
        level = 1,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.005, -1.14, 0.26),
                vector3(0.32, -1.72, 0.26),
                vector3(-0.33, -1.72, 0.26),
                vector3(-0.33, -2.24, 0.26),
                vector3(0.32, -2.24, 0.26),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.0)
    },
    [`bison2`] = {
        name = 'bison2',
        label = 'Bison MC',
        capacity = 250,
        level = 1,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.005, -1.14, 0.26),
                vector3(0.32, -1.72, 0.26),
                vector3(-0.33, -1.72, 0.26),
                vector3(-0.33, -2.24, 0.26),
                vector3(0.32, -2.24, 0.26),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.0)
    },
    [`boxville`] = {
        name = 'boxville',
        label = 'Boxville',
        capacity = 18,
        level = 600,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.655, -0.09, 0.09),
                vector3(0.67, -0.09, 0.09),
                vector3(0.67, -0.62, 0.09),
                vector3(-0.65, -0.62, 0.09),
                vector3(-0.65, -1.145, 0.09),
                vector3(0.68, -1.145, 0.09),
                vector3(0.68, -1.67, 0.09),
                vector3(-0.66, -1.67, 0.09),
                vector3(-0.66, -2.195, 0.09),
                vector3(0.675, -2.195, 0.09),
                vector3(0.675, -2.735, 0.09),
                vector3(-0.66, -2.735, 0.09),
                vector3(4.336808689942e-17, -0.155, -0.305),
                vector3(4.336808689942e-17, -0.685, -0.305),
                vector3(4.336808689942e-17, -1.215, -0.305),
                vector3(4.336808689942e-17, -1.745, -0.305),
                vector3(4.336808689942e-17, -2.285, -0.305),
                vector3(4.336808689942e-17, -2.82, -0.305),
            }
        },
        trunkOffset = vector3(0.0, -3.0, 1.0)
    },
    [`boxville2`] = {
        name = 'boxville2',
        label = 'Boxville',
        capacity = 18,
        level = 650,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.655, -0.09, 0.09),
                vector3(0.67, -0.09, 0.09),
                vector3(0.67, -0.62, 0.09),
                vector3(-0.65, -0.62, 0.09),
                vector3(-0.65, -1.145, 0.09),
                vector3(0.68, -1.145, 0.09),
                vector3(0.68, -1.67, 0.09),
                vector3(-0.66, -1.67, 0.09),
                vector3(-0.66, -2.195, 0.09),
                vector3(0.675, -2.195, 0.09),
                vector3(0.675, -2.735, 0.09),
                vector3(-0.66, -2.735, 0.09),
                vector3(4.336808689942e-17, -0.155, -0.305),
                vector3(4.336808689942e-17, -0.685, -0.305),
                vector3(4.336808689942e-17, -1.215, -0.305),
                vector3(4.336808689942e-17, -1.745, -0.305),
                vector3(4.336808689942e-17, -2.285, -0.305),
                vector3(4.336808689942e-17, -2.82, -0.305),
            }
        },
        trunkOffset = vector3(0.0, -3.0, 1.0)
    },
    [`boxville3`] = {
        name = 'boxville3',
        label = 'Boxville',
        capacity = 18,
        level = 650,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.655, -0.09, 0.09),
                vector3(0.67, -0.09, 0.09),
                vector3(0.67, -0.62, 0.09),
                vector3(-0.65, -0.62, 0.09),
                vector3(-0.65, -1.145, 0.09),
                vector3(0.68, -1.145, 0.09),
                vector3(0.68, -1.67, 0.09),
                vector3(-0.66, -1.67, 0.09),
                vector3(-0.66, -2.195, 0.09),
                vector3(0.675, -2.195, 0.09),
                vector3(0.675, -2.735, 0.09),
                vector3(-0.66, -2.735, 0.09),
                vector3(4.336808689942e-17, -0.155, -0.305),
                vector3(4.336808689942e-17, -0.685, -0.305),
                vector3(4.336808689942e-17, -1.215, -0.305),
                vector3(4.336808689942e-17, -1.745, -0.305),
                vector3(4.336808689942e-17, -2.285, -0.305),
                vector3(4.336808689942e-17, -2.82, -0.305),
            }
        },
        trunkOffset = vector3(0.0, -3.0, 1.0)
    },
    [`boxville4`] = {
        name = 'boxville4',
        label = 'Boxville',
        capacity = 18,
        level = 650,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.655, -0.09, 0.09),
                vector3(0.67, -0.09, 0.09),
                vector3(0.67, -0.62, 0.09),
                vector3(-0.65, -0.62, 0.09),
                vector3(-0.65, -1.145, 0.09),
                vector3(0.68, -1.145, 0.09),
                vector3(0.68, -1.67, 0.09),
                vector3(-0.66, -1.67, 0.09),
                vector3(-0.66, -2.195, 0.09),
                vector3(0.675, -2.195, 0.09),
                vector3(0.675, -2.735, 0.09),
                vector3(-0.66, -2.735, 0.09),
                vector3(4.336808689942e-17, -0.155, -0.305),
                vector3(4.336808689942e-17, -0.685, -0.305),
                vector3(4.336808689942e-17, -1.215, -0.305),
                vector3(4.336808689942e-17, -1.745, -0.305),
                vector3(4.336808689942e-17, -2.285, -0.305),
                vector3(4.336808689942e-17, -2.82, -0.305),
            }
        },
        trunkOffset = vector3(0.0, -3.0, 1.0)
    },
    [`burrito`] = {
        name = 'burrito',
        label = 'Burrito',
        capacity = 10,
        level = 100,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`burrito2`] = {
        name = 'burrito',
        label = 'Bugstars Burrito',
        capacity = 10,
        level = 150,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`burrito3`] = {
        name = 'burrito3',
        label = 'Burrito',
        capacity = 10,
        level = 150,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`burrito4`] = {
        name = 'burrito4',
        label = 'Burrito',
        capacity = 10,
        level = 180,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`burrito5`] = {
        name = 'burrito5',
        label = 'Burrito',
        capacity = 10,
        level = 180,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`gburrito`] = {
        name = 'gburrito',
        label = 'Gang Burrito',
        capacity = 10,
        level = 190,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`gburrito2`] = {
        name = 'gburrito2',
        label = 'Gang Burrito',
        capacity = 10,
        level = 200,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.625, -0.445, -0.285),
                vector3(4.336808689942e-17, -0.445, -0.285),
                vector3(0.605, -0.445, -0.285),
                vector3(0.605, -1.12, -0.285),
                vector3(0.005, -1.12, -0.285),
                vector3(-0.625, -1.12, -0.285),
                vector3(-0.705, -1.935, 0.095),
                vector3(-0.23, -1.935, -0.315),
                vector3(0.26, -1.935, -0.315),
                vector3(0.72, -1.935, 0.06),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`paradise`] = {
        name = 'paradise',
        label = 'Paradise',
        capacity = 12,
        level = 500,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.665, -0.065, -0.435),
                vector3(0.01, -0.065, -0.435),
                vector3(0.645, -0.065, -0.435),
                vector3(0.645, -0.63, -0.435),
                vector3(0.01, -0.63, -0.435),
                vector3(-0.615, -0.63, -0.435),
                vector3(-0.355, -1.175, -0.435),
                vector3(0.3, -1.175, -0.435),
                vector3(0.3, -1.74, -0.435),
                vector3(-0.335, -1.74, -0.435),
                vector3(-0.335, -2.28, -0.435),
                vector3(0.305, -2.28, -0.435),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`minivan`] = {
        name = 'minivan',
        label = 'Minivan',
        capacity = 4,
        level = 300,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.255, -1.375, -0.195),
                vector3(0.245, -1.375, -0.195),
                vector3(0.245, -1.925, -0.195),
                vector3(-0.245, -1.925, -0.195),
            }
        },
        trunkOffset = vector3(0.0, -1.8, 0.5)
    },
    [`minivan2`] = {
        name = 'minivan2',
        label = 'Minivan 2',
        capacity = 4,
        level = 300,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.255, -1.375, -0.195),
                vector3(0.245, -1.375, -0.195),
                vector3(0.245, -1.925, -0.195),
                vector3(-0.245, -1.925, -0.195),
            }
        },
        trunkOffset = vector3(0.0, -1.8, 0.5)
    },
    [`pony`] = {
        name = 'pony',
        label = 'Pony',
        capacity = 13,
        level = 350,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.595, 0.035, -0.21),
                vector3(0.035, 0.035, -0.21),
                vector3(0.63, 0.035, -0.21),
                vector3(0.63, -0.5, -0.21),
                vector3(0.03, -0.5, -0.21),
                vector3(-0.585, -0.5, -0.21),
                vector3(-0.585, -1.06, -0.21),
                vector3(0.02, -1.06, -0.21),
                vector3(0.635, -1.06, -0.21),
                vector3(-0.25, -1.595, -0.21),
                vector3(0.27, -1.585, -0.21),
                vector3(0.27, -2.145, -0.21),
                vector3(-0.245, -2.145, -0.21),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`pony2`] = {
        name = 'pony2',
        label = 'Pony',
        capacity = 13,
        level = 350,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.595, 0.035, -0.21),
                vector3(0.035, 0.035, -0.21),
                vector3(0.63, 0.035, -0.21),
                vector3(0.63, -0.5, -0.21),
                vector3(0.03, -0.5, -0.21),
                vector3(-0.585, -0.5, -0.21),
                vector3(-0.585, -1.06, -0.21),
                vector3(0.02, -1.06, -0.21),
                vector3(0.635, -1.06, -0.21),
                vector3(-0.25, -1.595, -0.21),
                vector3(0.27, -1.585, -0.21),
                vector3(0.27, -2.145, -0.21),
                vector3(-0.245, -2.145, -0.21),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`rumpo`] = {
        name = 'rumpo',
        label = 'Rumpo',
        capacity = 12,
        level = 400,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.585, -0.22, -0.49),
                vector3(-0.02, -0.22, -0.49),
                vector3(0.555, -0.22, -0.49),
                vector3(0.555, -0.77, -0.49),
                vector3(-0.01, -0.77, -0.49),
                vector3(-0.56, -0.77, -0.49),
                vector3(-0.28, -1.3, -0.49),
                vector3(0.28, -1.29, -0.49),
                vector3(0.28, -1.845, -0.49),
                vector3(-0.26, -1.845, -0.49),
                vector3(-0.26, -2.41, -0.49),
                vector3(0.28, -2.41, -0.49),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.5)
    },
    [`rumpo2`] = {
        name = 'rumpo2',
        label = 'Rumpo',
        capacity = 12,
        level = 410,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.585, -0.22, -0.49),
                vector3(-0.02, -0.22, -0.49),
                vector3(0.555, -0.22, -0.49),
                vector3(0.555, -0.77, -0.49),
                vector3(-0.01, -0.77, -0.49),
                vector3(-0.56, -0.77, -0.49),
                vector3(-0.28, -1.3, -0.49),
                vector3(0.28, -1.29, -0.49),
                vector3(0.28, -1.845, -0.49),
                vector3(-0.26, -1.845, -0.49),
                vector3(-0.26, -2.41, -0.49),
                vector3(0.28, -2.41, -0.49),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.5)
    },
    [`rumpo3`] = {
        name = 'rumpo3',
        label = 'Rumpo',
        capacity = 12,
        level = 415,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.585, -0.22, -0.49),
                vector3(-0.02, -0.22, -0.49),
                vector3(0.555, -0.22, -0.49),
                vector3(0.555, -0.77, -0.49),
                vector3(-0.01, -0.77, -0.49),
                vector3(-0.56, -0.77, -0.49),
                vector3(-0.28, -1.3, -0.49),
                vector3(0.28, -1.29, -0.49),
                vector3(0.28, -1.845, -0.49),
                vector3(-0.26, -1.845, -0.49),
                vector3(-0.26, -2.41, -0.49),
                vector3(0.28, -2.41, -0.49),
            }
        },
        trunkOffset = vector3(0.0, -2.5, 0.5)
    },
    [`speedo`] = {
        name = 'speedo',
        label = 'Speedo',
        capacity = 13,
        level = 450,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.52, -0.05, -0.145),
                vector3(0.005, -0.05, -0.145),
                vector3(0.555, -0.05, -0.145),
                vector3(0.555, -0.585, -0.145),
                vector3(0.01, -0.585, -0.145),
                vector3(-0.525, -0.585, -0.145),
                vector3(0.005, -1.13, -0.145),
                vector3(0.005, -1.67, -0.145),
                vector3(0.005, -2.215, -0.145),
                vector3(-0.53, -2.33, -0.145),
                vector3(0.53, -2.33, -0.145),
                vector3(-0.535, -1.66, 0.165),
                vector3(0.57, -1.66, 0.165),
            }
        },
        trunkOffset = vector3(0.0, -2.2, 0.5)
    },
    [`speedo2`] = {
        name = 'speedo2',
        label = 'Speedo',
        capacity = 13,
        level = 450,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.52, -0.05, -0.145),
                vector3(0.005, -0.05, -0.145),
                vector3(0.555, -0.05, -0.145),
                vector3(0.555, -0.585, -0.145),
                vector3(0.01, -0.585, -0.145),
                vector3(-0.525, -0.585, -0.145),
                vector3(0.005, -1.13, -0.145),
                vector3(0.005, -1.67, -0.145),
                vector3(0.005, -2.215, -0.145),
                vector3(-0.53, -2.33, -0.145),
                vector3(0.53, -2.33, -0.145),
                vector3(-0.535, -1.66, 0.165),
                vector3(0.57, -1.66, 0.165),
            }
        },
        trunkOffset = vector3(0.0, -2.2, 0.5)
    },
    [`speedo4`] = {
        name = 'speedo4',
        label = 'Speedo',
        capacity = 13,
        level = 450,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.52, -0.05, -0.145),
                vector3(0.005, -0.05, -0.145),
                vector3(0.555, -0.05, -0.145),
                vector3(0.555, -0.585, -0.145),
                vector3(0.01, -0.585, -0.145),
                vector3(-0.525, -0.585, -0.145),
                vector3(0.005, -1.13, -0.145),
                vector3(0.005, -1.67, -0.145),
                vector3(0.005, -2.215, -0.145),
                vector3(-0.53, -2.33, -0.145),
                vector3(0.53, -2.33, -0.145),
                vector3(-0.535, -1.66, 0.165),
                vector3(0.57, -1.66, 0.165),
            }
        },
        trunkOffset = vector3(0.0, -2.2, 0.5)
    },
    [`youga`] = {
        name = 'youga',
        label = 'Youga',
        capacity = 8,
        level = 120,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.47, 0.095, -0.125),
                vector3(0.515, 0.095, -0.125),
                vector3(0.515, -0.52, -0.125),
                vector3(-0.475, -0.52, -0.125),
                vector3(-0.315, -1.095, 0.165),
                vector3(0.31, -1.095, 0.165),
                vector3(0.31, -1.65, 0.165),
                vector3(-0.335, -1.65, 0.165),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`youga2`] = {
        name = 'youga2',
        label = 'Youga',
        capacity = 8,
        level = 130,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.47, 0.095, -0.125),
                vector3(0.515, 0.095, -0.125),
                vector3(0.515, -0.52, -0.125),
                vector3(-0.475, -0.52, -0.125),
                vector3(-0.315, -1.095, 0.165),
                vector3(0.31, -1.095, 0.165),
                vector3(0.31, -1.65, 0.165),
                vector3(-0.335, -1.65, 0.165),
            }
        },
        trunkOffset = vector3(0.0, -2.0, 0.5)
    },
    [`benson`] = {
        name = 'Benson',
        label = 'Benson',
        capacity = 40,
        level = 700,
        rentPrice = 18000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -5.0, 1.5)
    },
    [`pounder`] = {
        name = 'pounder',
        label = 'Pounder',
        capacity = 46,
        level = 700,
        rentPrice = 20000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -8.0, 2.2)
    },
    [`pounder2`] = {
        name = 'pounder2',
        label = 'Pounder',
        capacity = 46,
        level = 750,
        rentPrice = 20000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -8.0, 2.2)
    },
    [`mule`] = {
        name = 'mule',
        label = 'Mule',
        capacity = 36,
        level = 800,
        rentPrice = 17000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -3.3, 1.6)
    },
    [`mule2`] = {
        name = 'mule2',
        label = 'Mule',
        capacity = 36,
        level = 850,
        rentPrice = 17000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -3.3, 1.6)
    },
    [`mule3`] = {
        name = 'mule3',
        label = 'Mule',
        capacity = 36,
        level = 860,
        rentPrice = 17000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -3.3, 1.6)
    },
    [`mule4`] = {
        name = 'mule4',
        label = 'Mule',
        capacity = 36,
        level = 890,
        rentPrice = 17000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -3.3, 1.6)
    },
    [`vetir`] = {
        name = 'vetir',
        label = 'Vetir',
        capacity = 20,
        level = 900,
        rentPrice = 14000,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true,
            [spaceconfig.ItemTransportType.WOODLOG] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.255, 0.925, 0.0),
                vector3(0.28, 0.925, 0.0),
                vector3(0.28, 0.375, 0.0),
                vector3(-0.26, 0.375, 0.0),
                vector3(-0.26, -0.16, 0.0),
                vector3(0.275, -0.16, 0.0),
                vector3(0.275, -0.7, 0.0),
                vector3(-0.265, -0.7, 0.0),
                vector3(-0.265, -1.235, 0.0),
                vector3(0.26, -1.235, 0.0),
                vector3(0.26, -1.77, 0.0),
                vector3(-0.275, -1.77, 0.0),
                vector3(-0.275, -2.28, 0.0),
                vector3(0.275, -2.28, 0.0),
                vector3(0.275, -2.78, 0.0),
                vector3(-0.28, -2.78, 0.0),
                vector3(0.275, -2.78, 0.0),
                vector3(-0.28, -2.78, 0.0),
                vector3(-0.28, -2.78, 0.0),
                vector3(-0.28, -2.78, 0.0),
            },
            [spaceconfig.ItemTransportType.PALLET] = {
                vector3(0.0, -1.07, -0.005),
                vector3(0.0, 0.27, -0.005),
                vector3(0.0, -2.415, -0.005),
            },
            [spaceconfig.ItemTransportType.WOODLOG] = {
                vector3(-0.285, -0.895, 0.3),
                vector3(0.27, -0.895, 0.3),
                vector3(-0.595, -0.905, 0.74),
                vector3(4.336808689942e-17, -0.905, 0.74),
                vector3(0.595, -0.905, 0.73),
            }
        },
        trunkOffset = vector3(0.0, -3.0, 1.0)
    },
    [`trailers`] = {
        name = 'trailers',
        label = 'Trailer',
        isTrailer = true,
        capacity = 48,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -6.0, 0.6)
    },
    [`trailers2`] = {
        name = 'trailers2',
        label = 'Trailer',
        isTrailer = true,
        capacity = 48,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -6.0, 0.6)
    },
    [`trailers3`] = {
        name = 'trailers3',
        label = 'Trailer',
        isTrailer = true,
        capacity = 48,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -6.0, 0.6)
    },
    [`trailers4`] = {
        name = 'trailers4',
        label = 'Trailer',
        isTrailer = true,
        capacity = 48,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.CRATE] = true,
            [spaceconfig.ItemTransportType.PALLET] = true
        },
        trunkOffset = vector3(0.0, -6.0, 0.6)
    },
    [`trflat`] = {
        name = 'trflat',
        label = 'Trailer',
        isTrailer = true,
        capacity = 48,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.PALLET] = true,
            [spaceconfig.ItemTransportType.WOODLOG] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.PALLET] = {
                vector3(0.0, 0.0, 0.47),
                vector3(0.0, 4.4849999999999, 0.47),
                vector3(0.0, -5.0349999999999, 0.47),
                vector3(0.0, -3.6099999999999, 0.47),
                vector3(0.0, -2.23, 0.47),
                vector3(0.0, 2.88, 0.47),
                vector3(0.0, 1.475, 0.47),
                vector3(0.0, -1.34, 0.47),
            },
            [spaceconfig.ItemTransportType.WOODLOG] = {
                vector3(-0.6, 1.935, 0.695),
                vector3(-0.01, 1.935, 0.695),
                vector3(0.595, 1.935, 0.695),
                vector3(0.285, 1.935, 1.135),
                vector3(-0.3, 1.935, 1.135),
                vector3(0.0, 1.935, 1.59),

                vector3(-0.635, -2.57, 0.645),
                vector3(-0.035, -2.57, 0.645),
                vector3(0.555, -2.57, 0.645),
                vector3(0.22, -2.57, 1.045),
                vector3(-0.305, -2.57, 1.045),
                vector3(0.0, -2.57, 1.54),
            }
        },
        trunkOffset = vector3(0.0, -6.0, 0.6)
    },
    -- LOOSE
    [`tiptruck`] = {
        name = 'tiptruck',
        label = 'Tiptruck',
        capacity = 14,
        level = 900,
        transType = {
            [spaceconfig.ItemTransportType.LOOSE] = true
        }
    },
    [`tiptruck2`] = {
        name = 'tiptruck2',
        label = 'Tiptruck',
        capacity = 14,
        level = 950,
        transType = {
            [spaceconfig.ItemTransportType.LOOSE] = true
        }
    },
    [`rubble`] = {
        name = 'rubble',
        label = 'Rubble',
        capacity = 16,
        level = 950,
        transType = {
            [spaceconfig.ItemTransportType.LOOSE] = true
        }
    },
    [`biff`] = {
        name = 'biff',
        label = 'Biff',
        capacity = 16,
        level = 950,
        transType = {
            [spaceconfig.ItemTransportType.LOOSE] = true
        }
    },
    [`graintrailer`] = {
        name = 'graintrailer',
        label = 'Grain Trailer',
        isTrailer = true,
        capacity = 16,
        level = 0,
        transType = {
            [spaceconfig.ItemTransportType.LOOSE] = true
        }
    },
    [`mixer`] = {
        name = 'mixer',
        label = 'Mixer',
        capacity = 16,
        level = 950,
        transType = {
            [spaceconfig.ItemTransportType.CONCRETE] = true
        }
    },
    [`mixer2`] = {
        name = 'mixer2',
        label = 'Mixer',
        capacity = 16,
        level = 950,
        transType = {
            [spaceconfig.ItemTransportType.CONCRETE] = true
        }
    },
    -- STRONGBOX
    [`stockade`] = {
        name = 'stockade',
        label = 'Stockade',
        capacity = 8,
        level = 600,
        transType = {
            [spaceconfig.ItemTransportType.STRONGBOX] = true,
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        rentPrice = 7000,
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
                vector3(-0.375, -2.315, 0.425),
                vector3(0.385, -2.35, 0.425),
                vector3(0.385, -2.89, 0.425),
                vector3(-0.385, -2.89, 0.425),
            },
            [spaceconfig.ItemTransportType.STRONGBOX] = { --capacity of strongbox is 2 per units
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
            }
        },
        trunkOffset = vector3(0.0, -3.30, 1.5)
    },
    [`stockade3`] = {
        name = 'stockade3',
        label = 'Stockade',
        capacity = 8,
        level = 610,
        transType = {
            [spaceconfig.ItemTransportType.STRONGBOX] = true,
            [spaceconfig.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.CRATE] = {
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
                vector3(-0.375, -2.315, 0.425),
                vector3(0.385, -2.35, 0.425),
                vector3(0.385, -2.89, 0.425),
                vector3(-0.385, -2.89, 0.425),
            },
            [spaceconfig.ItemTransportType.STRONGBOX] = {
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
            }
        },
        trunkOffset = vector3(0.0, -3.30, 1.5)
    },
    -- LIQUIDS
    [`armytanker`] = {
        name = 'armytanker',
        label = 'Armytanker',
        isTrailer = true,
        capacity = 40,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.LIQUIDS] = true
        }
    },
    [`tanker`] = {
        name = 'tanker',
        label = 'Tanker',
        isTrailer = true,
        capacity = 40,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.LIQUIDS] = true
        }
    },
    [`tanker2`] = {
        name = 'tanker2',
        label = 'Tanker',
        isTrailer = true,
        capacity = 40,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.LIQUIDS] = true
        }
    },
    -- VEHICLE
    [`tr4`] = {
        name = 'tr4',
        label = 'Trailer',
        isTrailer = true,
        capacity = 40,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.VEHICLE] = true
        }
    },
    [`tr2`] = {
        name = 'tr2',
        label = 'Trailer',
        isTrailer = true,
        capacity = 60,
        level = 0,
        rentPrice = 0,
        transType = {
            [spaceconfig.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.VEHICLE] = {
                { x = 0.0,   y = 4.8049999999999,  z = 0.425, rx = 0.0,              ry = 0.0, rz = 0.0 },
                { x = 0.0,   y = 0.085,            z = 0.54,  rx = -3.4199999999999, ry = 0.0, rz = 0.0 },
                { x = 0.0,   y = -4.8199999999999, z = 0.45,  rx = 4.1049999999999,  ry = 0.0, rz = 0.0 },
                { x = -0.02, y = 5.0099999999999,  z = 2.405, rx = 4.1049999999999,  ry = 0.0, rz = 0.0 },
                { x = -0.02, y = 0.015,            z = 2.46,  rx = -5.5349999999999, ry = 0.0, rz = 0.0 },
                { x = -0.02, y = -4.9199999999999, z = 2.71,  rx = 0.34,             ry = 0.0, rz = 0.0 },
            }
        }
    },
    [`flatbed`] = {
        name = 'flatbed',
        label = 'Flatbed',
        capacity = 20,
        level = 1000,
        rentPrice = 15000,
        transType = {
            [spaceconfig.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.VEHICLE] = {
                vector3(0.0, -0.95, 0.425),
                vector3(0.01, -4.7699999999999, 0.425),
            }
        }
    },
        [`hauler`] = {
        name = 'hauler',
        label = 'hauler',
        capacity = 0,
        level = 1000,
        rentPrice = 15000,
        transType = {
            [spaceconfig.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.VEHICLE] = {
                vector3(0.0, -0.95, 0.425),
                vector3(0.01, -4.7699999999999, 0.425),
            }
        }
    },
    
            [`phantom`] = {
        name = 'phantom',
        label = 'phantom',
        capacity = 0,
        level = 1000,
        rentPrice = 15000,
        transType = {
            [spaceconfig.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [spaceconfig.ItemTransportType.VEHICLE] = {
                vector3(0.0, -0.95, 0.425),
                vector3(0.01, -4.7699999999999, 0.425),
            }
        }
    },
    -- LIFT
    [`forklift`] = {                                    --SET = hash (`vehicle_model`)
        name = 'forklift',                              --SET = string (vehicle_model)
        label = 'Forklift',                             --SET = string (Label of vehicle)
        capacity = 8,                                   --SET = number (Vehicle Storage Capacities related with item capacity)
        level = 100,                                      --SET = number (Level Required Player Can Use This Vehicle)
        rentPrice = 300,
        transType = {                                   --SET = table (Table of transport type)
            [spaceconfig.ItemTransportType.CRATE] = true, --SET = [ITEM_TRANSPORT_TYPE] = true or false (Transport type vehicle can handler)
            [spaceconfig.ItemTransportType.STRONGBOX] = true
        },
        props = {                                   --Vehicle Prop Offset Defined
            boneIndex = 3,                          --Bone of vehicle Prop default is chassic
            [spaceconfig.ItemTransportType.CRATE] = { --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
                vector3(0.0, 0.565, -0.51),
                vector3(0.0, 1.045, -0.51),
                vector3(0.0, 0.56, -0.04),
                vector3(0.0, 1.03, -0.04),
                vector3(0.0, 0.555, 0.4),
                vector3(0.0, 1.035, 0.4),
                vector3(1.7347234759768e-18, 0.55, 0.915),
                vector3(1.7347234759768e-18, 1.03, 0.915),
            },
            [spaceconfig.ItemTransportType.STRONGBOX] = { --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
                vector3(0.0, 0.585, -0.505),
                vector3(0.0, 1.1, -0.505),
                vector3(0.0, 0.59, 4.336808689942e-17),
                vector3(0.0, 1.115, 4.336808689942e-17),
            }
        }
    },
}

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


spaceconfig.VehicleTransportCount = tablelength(spaceconfig.VehicleTransport)

-- Trucker Handbook, you can add more step or delete something, handbook will show in Menu (c_menu.lua)
spaceconfig.TruckerHandbook = {
    title = 'Become a trucker in 5 step',
    handbook = {
        {
            title = 'Step 1: Rent a truck',
            description =
            'Find the right vehicle for you in the menu F1->TPDA->Vehicles\n\
            and go to the rental place to rent it\n\
            I recommend you choose a vehicle that can carry crates to start'
        },
        {
            title = 'Step 2: Check what industries offer something',
            description = 'Open Trucker PDA Menu with the F1 key\nSelect show all Secondary Industries\n\
            Check a secondary industry, because these ones usually require (want) something from you.\n\
            Because you can only transport crate, let\'s have a look at the Paleto Bay Food Processing Plant.\n\
            Let\'s do it and come back here'
        },
        {
            title = 'Continue',
            description =
            'Okay it seems like this industry wants some eggs! As you can see, so it\'s our time to shine and bring some!'
        },
        {
            title = 'Step 3: Check where to find the commodity you need',
            description = 'Now back to TPDA Menu and select Show All Primary Industries\n\
            There, you can find out that eggs are generated by farms. \n\
            Check some farms. I have decided to check No 12 Farm, because it is the closest egg production place.',
        },
        {
            title = 'Step 4: Load the cargo on your vehicle',
            description = 'In Trucker PDA  navigate through to No 12 Farm dialog and click on the Proceed button.\n\
            And there will be a menu that will give you directions to where No 12 Farm\'s eggs are sold.\n\
            You can buy crate by press `E` at trading point then\n\
            You can place them in the vehicle by press `LALT` on trunk and select `Load Package`  (Vehicle must be UNLOCKED!)\n\
            Repeat as long as there is place in the vehicle or as long as you have money.\n\
            If you want to return the crate back, press `E` at same trading point and sell, your money will be returned.',
        },
        {
            title = 'More Information',
            description = 'Since we\'re buying crates, we have to buy and place them in the vehicle manually.\n\
            If they weren\'t crates, we\'d drive our truck to the marker and use the same action\n'
        },
        {
            title = 'Step 5: Sell the cargo to the next industry',
            description =
            'Now navigate to the Paleto Bay Food Processing Plant → eggs storage using the same way as described in step 4.\n\
            When you get there, step out of your vehicle, go to the back of it and press `LALT` then select `Check Vehicle Storage`.\n\
            That will show you everything that is in the vehicle.\n\
            Pick the egg crate up by clicking on Pick up, goto Arrow and press `E` to sell your crate and take profit'
        }
    }
}

spaceconfig.SkillTable = 'space_trucker_skills'

spaceconfig.SkillTypeField = {
    totalProfit = 'totalProfit',
    totalPackage = 'totalPackage',
    totalDistance = 'totalDistance',
    currentExp = 'exp',
    currentLevel = 'level'
}

spaceconfig.IsPackageMultiplyItemCapacity = true

spaceconfig.RateExp = {
    profit = 100,      -- EX: You get $500 -> 500/100 = 5 Exp
    profitByHand = 10, -- Hand Crate
    package = 1,
    distance = 1000
}
-- Shared Functions, pls don't touch
function math.groupdigits(number, seperator) -- credit http://richard.warburton.it
    local left, num, right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. (seperator or ',')):reverse()) .. right
end

function IsItemTransportTypeCanMix(transType)
    -- With these types of items, the vehicle can carry many different types of goods
    if transType == spaceconfig.ItemTransportType.CRATE or
        transType == spaceconfig.ItemTransportType.STRONGBOX then
        return true
    end
    return false
end

function IsVehicleModelCanDoGSTrucker(vehicleModelHash)
    if spaceconfig.VehicleTransport[vehicleModelHash] then return true end
    return false
end

function IsVehicleModelCanTransportType(vehicleModelHash, transType)
    if not spaceconfig.VehicleTransport[vehicleModelHash] then return false end
    for key, value in pairs(spaceconfig.VehicleTransport[vehicleModelHash].transType) do
        if key == transType then return true end
    end

    return false
end

-- Industry Global Function
function GetIndustryTierLabel(_tier)
    if _tier == spaceconfig.Industry.Tier.PRIMARY then
        return Lang:t('industry_tier_label_primary')
    elseif _tier == spaceconfig.Industry.Tier.SECONDARY then
        return Lang:t('industry_tier_label_secondary')
    elseif _tier == spaceconfig.Industry.Tier.TERTIARY then -- ADICIONADO
        return Lang:t('industry_tier_label_tertiary')      -- ADICIONADO (Você precisará adicionar esta tradução no seu arquivo de localidade)
    elseif _tier == spaceconfig.Industry.Tier.BUSINESS then
        return Lang:t('industry_tier_label_business')
    end
end

function GetIndustryTypeLabel(_tier, _type)
    local typeLabel = {
        -- Primary
        [spaceconfig.Industry.Tier.PRIMARY] = {
            [spaceconfig.Industry.Type.Primary.OILFIELD] = Lang:t('industry_type_label_oilfield'),
            [spaceconfig.Industry.Type.Primary.CHEMICAL] = Lang:t('industry_type_label_chemical'),
            [spaceconfig.Industry.Type.Primary.SCRAPYARD] = Lang:t('industry_type_label_scrapyard'),
            [spaceconfig.Industry.Type.Primary.FOREST] = Lang:t('industry_type_label_forest'),
            [spaceconfig.Industry.Type.Primary.FARM] = Lang:t('industry_type_label_farm'),
            [spaceconfig.Industry.Type.Primary.MINERAL] = Lang:t('industry_type_label_mineral'),
            [spaceconfig.Industry.Type.Primary.QUARRY] = Lang:t('industry_type_label_quarry'),
        },
        [spaceconfig.Industry.Tier.SECONDARY] = {
            --] Secondary
            [spaceconfig.Industry.Type.Secondary.MINT] = Lang:t('industry_type_label_mint'), -- Federal Mint
            [spaceconfig.Industry.Type.Secondary.WEAPON_FACTORY] = Lang:t('industry_type_label_weapon_factory'),
            [spaceconfig.Industry.Type.Secondary.STEEL_MILL] = Lang:t('industry_type_label_steel_mill'),
            [spaceconfig.Industry.Type.Secondary.SAWMILL] = Lang:t('industry_type_label_sawmill'),
            [spaceconfig.Industry.Type.Secondary.TEXTILE_FACTORY] = Lang:t('industry_type_label_textile_factory'),
            [spaceconfig.Industry.Type.Secondary.BREWERY] = Lang:t('industry_type_label_brewery'),
            [spaceconfig.Industry.Type.Secondary.FOOD_PROCESSING_PLANT] = Lang:t(
                'industry_type_label_food_processing_plant'),
            [spaceconfig.Industry.Type.Secondary.CONCRETE_PLANT] = Lang:t('industry_type_label_concrete_plant'),
            [spaceconfig.Industry.Type.Secondary.DISTILLERY] = Lang:t('industry_type_label_distillery'),
            [spaceconfig.Industry.Type.Secondary.MALT_HOUSE] = Lang:t('industry_type_label_malt_house'),
            [spaceconfig.Industry.Type.Secondary.APPLIANCES] = Lang:t('industry_type_label_appliances'),
            [spaceconfig.Industry.Type.Secondary.AUTOS] = Lang:t('industry_type_label_autos'),
            [spaceconfig.Industry.Type.Secondary.METALLURGICAL] = Lang:t('industry_type_label_metallurgical'),
        },
        [spaceconfig.Industry.Tier.BUSINESS] = {
            --] BUSINESS
            [spaceconfig.Industry.Type.Business.CONSTRUCTIONS] = Lang:t('industry_type_label_constructions'),
            [spaceconfig.Industry.Type.Business.POWERPLANT] = Lang:t('industry_type_label_powerplant'),
            [spaceconfig.Industry.Type.Business.AMMUNATION] = Lang:t('industry_type_label_ammunation'),
            [spaceconfig.Industry.Type.Business.RETAIL_STORE] = Lang:t('industry_type_label_retail_store'),
            [spaceconfig.Industry.Type.Business.AUTOMOTIVE_SHOP] = Lang:t('industry_type_label_automotive_shop'), --car_parts, dyes
            [spaceconfig.Industry.Type.Business.FOOD_N_DRINK] = Lang:t('industry_type_label_food_n_drink'),
            [spaceconfig.Industry.Type.Business.CLOTHING_STORE] = Lang:t('industry_type_label_clothing_store'),
            [spaceconfig.Industry.Type.Business.DEALERSHIP] = Lang:t('industry_type_label_dealership'),
            [spaceconfig.Industry.Type.Business.GAS_STATION] = Lang:t('industry_type_label_gas_station'),
            [spaceconfig.Industry.Type.Business.FURNITURE_SHOP] = Lang:t('industry_type_label_furniture_shop'),
            [spaceconfig.Industry.Type.Business.OFFICE] = Lang:t('industry_type_label_office'),
            [spaceconfig.Industry.Type.Business.BANK] = Lang:t('industry_type_label_bank'),
            [spaceconfig.Industry.Type.Business.FRUIT_STAND] = Lang:t('industry_type_label_fruit_stand'),
        },
    }
    return typeLabel[_tier][_type]
end

local RockstarRanks = {
    800, 2100, 3800, 6100, 9500, 12500, 16000, 19800, 24000, 28500, 33400, 38700, 44200, 50200, 56400, 63000, 69900, 77100, 84700, 92500,
    100700, 109200, 118000, 127100, 136500, 146200, 156200, 166500, 177100, 188000, 199200, 210700, 222400, 234500, 246800, 259400, 272300,
    285500, 299000, 312700, 326800, 341000, 355600, 370500, 385600, 401000, 416600, 432600, 448800, 465200, 482000, 499000, 516300, 533800,
    551600, 569600, 588000, 606500, 625400, 644500, 663800, 683400, 703300, 723400, 743800, 764500, 785400, 806500, 827900, 849600, 871500,
    893600, 916000, 938700, 961600, 984700, 1008100, 1031800, 1055700, 1079800, 1104200, 1128800, 1153700, 1178800, 1204200, 1229800, 1255600,
    1281700, 1308100, 1334600, 1361400, 1388500, 1415800, 1443300, 1471100, 1499100, 1527300, 1555800, 1584350 }

function GetTruckerNextEXP(currentLevel)
    if RockstarRanks[currentLevel] then
        return RockstarRanks[currentLevel]
    end
    return 15584350
end
