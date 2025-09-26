-- gs_trucker/shared/class/industries.lua

-- INDUSTRIES CONTAINER

Industries = {}
Industries.__index = Industries

function Industries.new()
    local o = setmetatable({}, Industries)
    o.industries_by_name = {}
    o.primary_count = 0
    o.secondary_count = 0
    o.business_count = 0
    o.industriesItemsPriceData = {}
    return o
end
-- Getter
---GetIndustry
---@param _name string
---@return Industry|nil
function Industries:GetIndustry(_name)
    if self.industries_by_name[_name] then
        return self.industries_by_name[_name]
    end
    return nil
end

function Industries:GetIndustries()
    return self.industries_by_name
end

function Industries:GetIndustryTypeList(_tier)
    if _tier == spaceconfig.Industry.Tier.PRIMARY then
        return spaceconfig.Industry.Type.Primary
    elseif _tier == spaceconfig.Industry.Tier.SECONDARY then
        return spaceconfig.Industry.Type.Secondary
    elseif _tier == spaceconfig.Industry.Tier.BUSINESS then
        return spaceconfig.Industry.Type.Business
    end
end

function Industries:GetIndustryLabel(_name)
    if self.industries_by_name[_name] then
        return self.industries_by_name[_name].label
    end
    return 'undefined_industry'
end

-- Function
---AddIndustry
---@param _name string
---@param _label string
---@param _status number
---@param _tier number
---@param _type number
---@param _location vector3
---@param _forSaleLocation table
---@param _wantedLocation table
---@param _tradeData table
---@return Industry
function Industries:AddIndustry(_name, _label, _status, _tier, _type, _location, _forSaleLocation, _wantedLocation,
                                _tradeData)
    local industry = Industry.new(_name, _label, _status, _tier, _type, _location, _forSaleLocation, _wantedLocation,
        _tradeData)
    self.industries_by_name[_name] = industry
    if _tier == spaceconfig.Industry.Tier.PRIMARY then
        self.primary_count = self.primary_count + 1
    elseif _tier == spaceconfig.Industry.Tier.SECONDARY then
        self.secondary_count = self.secondary_count + 1
    elseif _tier == spaceconfig.Industry.Tier.BUSINESS then
        self.business_count = self.business_count + 1
    end

    return industry
end

---RemoveIndustry
---@param _name string
---@return boolean
function Industries:RemoveIndustry(_name)
    if self.industries_by_name[_name] then
        self.industries_by_name[_name] = nil
        return true
    end
    return false
end

function Industries:UpdateTradeData(_name, _tradeData)
    self.industries_by_name[_name].tradeData = _tradeData
end

---GetIndustryStatus
---@param _name string
---@return number|boolean
function Industries:GetIndustryStatus(_name)
    if self.industries_by_name[_name] then
        return self.industries_by_name[_name]:GetStatus()
    end
    return false
end

---SetIndustryStatus
---@param _name string
---@param _status number
---@return boolean
function Industries:SetIndustryStatus(_name, _status)
    if self.industries_by_name[_name] then
        self.industries_by_name[_name]:SetStatus(_status)
        return true
    end
    return false
end

function Industries:GetIndustryTradeData(_name)
    if self.industries_by_name[_name] then
        return self.industries_by_name[_name]:GetTradeData()
    end
    return nil
end

function Industries:GetCounts()
    return {
        primary = self.primary_count,
        secondary = self.secondary_count,
        business = self.business_count
    }
end

function Industries:generateIndustryItemPrice(_industryName, _itemName)
    local randPrice = math.random(spaceconfig.IndustryItems[_itemName].minPrice,
        spaceconfig.IndustryItems[_itemName].maxPrice)

    self.industriesItemsPriceData[_industryName][_itemName] = {
        price = randPrice,
        profitPrice = randPrice + (randPrice * spaceconfig.IndustryItems[_itemName].percentProfit)
    }

    return self.industriesItemsPriceData[_industryName][_itemName]
end


---Global GetIndustryItemPriceData
---@param _itemName string
---@return table
function Industries:GetIndustryItemPriceData(_industryName, _itemName)
    if not spaceconfig.IndustryItems[_itemName] then
        return {
            price = 0,
            profitPrice = 0,
        }
    end

    if not self.industriesItemsPriceData[_industryName] then
        self.industriesItemsPriceData[_industryName] = {}
    end
    if not self.industriesItemsPriceData[_industryName][_itemName] then
        local data = Industries:generateIndustryItemPrice(_industryName, _itemName)
        return data
    end

    return self.industriesItemsPriceData[_industryName][_itemName]
end

function Industries:IsIndustryStorageFull(_industryName, _tradeType, _itemName)
    if self.industries_by_name[_industryName] then
        return self.industries_by_name[_industryName]:IsStorageFull(_tradeType, _itemName)
    end
    return false
end

function Industries:GetIndustryInStockAmount(_industryName, _tradeType, _itemName)
    if self.industries_by_name[_industryName] then
        return self.industries_by_name[_industryName]:GetInStockAmount(_tradeType, _itemName)
    end
    return 0
end

function Industries:AddIndustryItemAmount(_industryName, _tradeType, _itemName, _amount, _replicate)
    if self.industries_by_name[_industryName] then
        return self.industries_by_name[_industryName]:AddItemAmount(_tradeType, _itemName, _amount, _replicate)
    end
    return false
end

function Industries:RemoveIndustryItemAmount(_industryName, _tradeType, _itemName, _amount, _replicate)
    if self.industries_by_name[_industryName] then
        return self.industries_by_name[_industryName]:RemoveItemAmount(_tradeType, _itemName, _amount, _replicate)
    end
    return false
end

-- Create Instance
Industries = Industries.new()

-- ## CORREÇÃO APLICADA AQUI ##
--- Encontra a primeira indústria que produz um determinado item
---@param _itemName string
---@return Industry|nil
function Industries:GetIndustryThatProduces(_itemName)
    -- A correção é usar "self.industries_by_name", que é a tabela correta neste script.
    for _, industry in pairs(self.industries_by_name) do
        if industry.tradeData and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE] and industry.tradeData[spaceconfig.Industry.TradeType.FORSALE][_itemName] then
            return industry
        end
    end
    return nil
end