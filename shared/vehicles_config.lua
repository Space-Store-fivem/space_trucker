config.VehicleTransport = {
    [`dloader`] = {                                    --SET = hash (`vehicle_model`)
        name = 'dloader',                              --SET = string (vehicle_model)
        label = 'Duneloader',                          --SET = string (Label of vehicle)
        capacity = 6,                                  --SET = number (Vehicle Storage Capacities related with item capacity)
        level = 100,
        rentPrice = 17000,--SET = number (Level Required Player Can Use This Vehicle)
        transType = {                                  --SET = table (Table of transport type)
            [config.ItemTransportType.CRATE] = true --SET = [ITEM_TRANSPORT_TYPE] = true or false (Transport type vehicle can handler)
        },
        props = {                                      --Vehicle Prop Offset Defined
            bone = 'chassic',                          --Bone of vehicle Prop default is chassic
            [config.ItemTransportType.CRATE] = {    --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true,
            [config.ItemTransportType.WOODLOG] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
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
            [config.ItemTransportType.PALLET] = {
                vector3(0.0, -1.07, -0.005),
                vector3(0.0, 0.27, -0.005),
                vector3(0.0, -2.415, -0.005),
            },
            [config.ItemTransportType.WOODLOG] = {
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.CRATE] = true,
            [config.ItemTransportType.PALLET] = true
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
            [config.ItemTransportType.PALLET] = true,
            [config.ItemTransportType.WOODLOG] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.PALLET] = {
                vector3(0.0, 0.0, 0.47),
                vector3(0.0, 4.4849999999999, 0.47),
                vector3(0.0, -5.0349999999999, 0.47),
                vector3(0.0, -3.6099999999999, 0.47),
                vector3(0.0, -2.23, 0.47),
                vector3(0.0, 2.88, 0.47),
                vector3(0.0, 1.475, 0.47),
                vector3(0.0, -1.34, 0.47),
            },
            [config.ItemTransportType.WOODLOG] = {
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
            [config.ItemTransportType.LOOSE] = true
        }
    },
    [`tiptruck2`] = {
        name = 'tiptruck2',
        label = 'Tiptruck',
        capacity = 14,
        level = 950,
        transType = {
            [config.ItemTransportType.LOOSE] = true
        }
    },
    [`rubble`] = {
        name = 'rubble',
        label = 'Rubble',
        capacity = 16,
        level = 950,
        transType = {
            [config.ItemTransportType.LOOSE] = true
        }
    },
    [`biff`] = {
        name = 'biff',
        label = 'Biff',
        capacity = 16,
        level = 950,
        transType = {
            [config.ItemTransportType.LOOSE] = true
        }
    },
    [`graintrailer`] = {
        name = 'graintrailer',
        label = 'Grain Trailer',
        isTrailer = true,
        capacity = 16,
        level = 0,
        transType = {
            [config.ItemTransportType.LOOSE] = true
        }
    },
    [`mixer`] = {
        name = 'mixer',
        label = 'Mixer',
        capacity = 16,
        level = 950,
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CONCRETE] = true
        }
    },
    [`mixer2`] = {
        name = 'mixer2',
        label = 'Mixer',
        capacity = 16,
        level = 950,
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.CONCRETE] = true
        }
    },
    -- STRONGBOX
    [`stockade`] = {
        name = 'stockade',
        label = 'Stockade',
        capacity = 8,
        level = 600,
        transType = {
            [config.ItemTransportType.STRONGBOX] = true,
            [config.ItemTransportType.CRATE] = true
        },
        rentPrice = 7000,
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
                vector3(-0.375, -2.315, 0.425),
                vector3(0.385, -2.35, 0.425),
                vector3(0.385, -2.89, 0.425),
                vector3(-0.385, -2.89, 0.425),
            },
            [config.ItemTransportType.STRONGBOX] = { --capacity of strongbox is 2 per units
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
        rentPrice = 17000,
        transType = {
            [config.ItemTransportType.STRONGBOX] = true,
            [config.ItemTransportType.CRATE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.CRATE] = {
                vector3(-0.37, -1.22, 0.425),
                vector3(0.365, -1.22, 0.425),
                vector3(0.365, -1.77, 0.425),
                vector3(-0.375, -1.77, 0.425),
                vector3(-0.375, -2.315, 0.425),
                vector3(0.385, -2.35, 0.425),
                vector3(0.385, -2.89, 0.425),
                vector3(-0.385, -2.89, 0.425),
            },
            [config.ItemTransportType.STRONGBOX] = {
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
            [config.ItemTransportType.LIQUIDS] = true
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
            [config.ItemTransportType.LIQUIDS] = true
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
            [config.ItemTransportType.LIQUIDS] = true
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
            [config.ItemTransportType.VEHICLE] = true
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
            [config.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.VEHICLE] = {
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
            [config.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.VEHICLE] = {
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
            [config.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.VEHICLE] = {
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
            [config.ItemTransportType.VEHICLE] = true
        },
        props = {
            bone = 'chassic',
            [config.ItemTransportType.VEHICLE] = {
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
            [config.ItemTransportType.CRATE] = true, --SET = [ITEM_TRANSPORT_TYPE] = true or false (Transport type vehicle can handler)
            [config.ItemTransportType.STRONGBOX] = true
        },
        props = {                                   --Vehicle Prop Offset Defined
            boneIndex = 3,                          --Bone of vehicle Prop default is chassic
            [config.ItemTransportType.CRATE] = { --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
                vector3(0.0, 0.565, -0.51),
                vector3(0.0, 1.045, -0.51),
                vector3(0.0, 0.56, -0.04),
                vector3(0.0, 1.03, -0.04),
                vector3(0.0, 0.555, 0.4),
                vector3(0.0, 1.035, 0.4),
                vector3(1.7347234759768e-18, 0.55, 0.915),
                vector3(1.7347234759768e-18, 1.03, 0.915),
            },
            [config.ItemTransportType.STRONGBOX] = { --SET = [ITEM_TRANSPORT_TYPE] = table of position offset prop will put on vehicle
                vector3(0.0, 0.585, -0.505),
                vector3(0.0, 1.1, -0.505),
                vector3(0.0, 0.59, 4.336808689942e-17),
                vector3(0.0, 1.115, 4.336808689942e-17),
            }
        }
    },
}

config.VehicleTransportCount = tablelength(config.VehicleTransport)