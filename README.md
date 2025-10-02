# space-trucker

## Install Tutorial
- import space_trucker_skills.sql to your database
- For Locale | setr gstrucker:locale en

# HOW TO ADD NEW INDUSTRY TYPE
- Step 1: Open gst_config and find spaceconfig.Industry -> Type = {...}
- Step 2: In Type = {...} at the end you will add your new Type of idustry or biz. Ex: FRUIT_STAND = 33 , FRUIT_STAND is Constand and 33 is id of type (unique)
- Step 3: Find Function function GetIndustryTypeLabel(_tier, _type) and add your type add the end of table. Ex: [spaceconfig.Industry.Type.Business.FRUIT_STAND] = 'Fruit Stand',
# HOW TO ADD NEW INDUSTRY, BUSINESS
- Step 1: Open gst_config and find spaceconfig.Industry -> Name = {...}
- Step 2: In Name = {...} at the end you need to define your industry name like: JOSHUA_RD_GRAND_SENORA_FRUIT_STAND = 'joshua_rd_grand_senora_fruit_stand',
- Step 3: Open file register_primary_industries if you want define Primary Industry, register_secondary_industries if you want define Secondary Industry or register_businesses if you want a biz
- Step 4: Here i will add an biz

```
Industries:AddIndustry(
    spaceconfig.Industry.Name.JOSHUA_RD_GRAND_SENORA_FRUIT_STAND, -- This is industry/business name define above
    'Joshua RD Grand Seonra Fruid Stand',                       -- This is label of business
    spaceconfig.Industry.Status.OPEN,                             -- Status default is Open
    spaceconfig.Industry.Tier.BUSINESS,                           -- Tier: PRIMARY, SECONDARY, BUSINESS
    spaceconfig.Industry.Type.Business.FRUIT_STAND,                        -- Type: FRUIT_STAND define above
    vector3(2475.0962, 4449.8687, 35.3404),                     -- vector3: Main Location of biz
    {
        --For sale location, in this case this is business and not sell anything of resources, so we will leave it blank
    },
    {
        --Wanted location
        ['fruits'] = vector3(2475.0962, 4449.8687, 35.3404) -- This fruit stand will need ['fruits'] = vector3 is location storage of fruits
    },
    {
        -- This is Trade Data of industry
        [spaceconfig.Industry.TradeType.FORSALE] = {}, -- No have for sale
        [spaceconfig.Industry.TradeType.WANTED] = {
            ['fruits'] = { -- Item name 
                -- use func GetIndustryItemPriceData(industryName, itemName) to get price of item (Will random when restart sv)
                -- for forsale we will use ().price for wanted we will use ().profitPrice
                price = GetIndustryItemPriceData(spaceconfig.Industry.Name.GRAPESEED_FRUIT_STAND, 'fruits').profitPrice,
                consumption = 10, --Number of product consumption per hour
                storageSize = 100,  --Number of storage size
                inStock = math.random(10,20), --Number of in stock storage
            }
        }
    }
)
```

# HOW TO ADD NEW ITEM
- Step 1: Open gst_config and find spaceconfig.IndustryItems = {...}
- Step 2: We will define new item is Concrete and transport type is LOOSE
```
['concrete'] = { --id of item
        label = Lang:t('item_name_concrete'), -- You need define in locale file. Ex: open en.json and add 'item_name_concrete' = 'Concrete'
        capacity = 1,   -- Capacity per amount
        minPrice = 111, -- Min price of item
        maxPrice = 200, -- Max price of item
        percentProfit = math.random(8, 14) / 100, -- Random profit percentage of item
        transType = spaceconfig.ItemTransportType.LOOSE --Transport Item Type is Loose
    },
```
- Step 3: Now you can add item concrete to Concrete Plant Industry at For Sale
- Step 4: Then you can add item concrete to Business Constructions ar Wanted