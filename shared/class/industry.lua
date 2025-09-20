local IS_SERVER = IsDuplicityVersion()
---@class Industry
---@field name string
---@field label string
---@field status number
---@field tier number
---@field type number
---@field location vector3
---@field forSaleLocation table
---@field wantedLocation table
---@field tradeData table
Industry = {}
Industry.__index = Industry

---New Instance 
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
function Industry.new(_name, _label, _status, _tier, _type, _location, _forSaleLocation, _wantedLocation, _tradeData)
    local self = setmetatable({}, Industry)
    self.name = _name --unique variable
    self.label = _label
    self.status = _status
    self.tier = _tier
    self.type = _type
    self.location = _location
    self.forSaleLocation = _forSaleLocation
    self.wantedLocation = _wantedLocation
    self.tradeData = _tradeData
    return self
end

-- Status
---@param _status number
function Industry:SetStatus(_status)
    if _status >= 0 and _status <= 1 then
        self.status = _status
        -- Update To All Client Industry Status
    end
end

function Industry:GetStatus()
    return self.status
end

-- Trade Data
function Industry:SetTradeData(_data)
    self.tradeData = _data
end

function Industry:GetTradeData()
    return self.tradeData
end

function Industry:IsStorageFull(_tradeType, _itemName)
    if self.tradeData[_tradeType][_itemName].inStock >= self.tradeData[_tradeType][_itemName].storageSize then 
        return true 
    end
    return false
end

function Industry:GetInStockAmount(_tradeType, _itemName)
    return self.tradeData[_tradeType][_itemName].inStock
end


function Industry:AddItemAmount(_tradeType, _itemName, _amount, _replicate)
    if self:IsStorageFull(_tradeType, _itemName) then
        return false 
    end

    self.tradeData[_tradeType][_itemName].inStock = self.tradeData[_tradeType][_itemName].inStock + _amount

    if self.tradeData[_tradeType][_itemName].inStock > self.tradeData[_tradeType][_itemName].storageSize then 
        self.tradeData[_tradeType][_itemName].inStock = self.tradeData[_tradeType][_itemName].storageSize
    end
    -- Trigger client to all update amount again
    if IS_SERVER and _replicate then 
        TriggerClientEvent('gs_trucker:client:industry:addItemAmount', -1, self.name, _tradeType, _itemName, _amount)
    end
    return true
end

function Industry:RemoveItemAmount(_tradeType, _itemName, _amount, _replicate)
    -- if self:GetInStockAmount(_tradeType, _itemName) < _amount then 
    --     return false 
    -- end

    self.tradeData[_tradeType][_itemName].inStock = self.tradeData[_tradeType][_itemName].inStock - _amount
    -- Trigger client to all update amount again
    if self.tradeData[_tradeType][_itemName].inStock < 0 then 
        self.tradeData[_tradeType][_itemName].inStock = 0 
    end
    
    if IS_SERVER and _replicate then 
        TriggerClientEvent('gs_trucker:client:industry:removeItemAmount', -1, self.name, _tradeType, _itemName, _amount)
    end
    return true
end

function Industry:Destroy()
    self = nil
end

-- ADICIONE ESTAS DUAS NOVAS FUNÇÕES AO FINAL DO FICHEIRO shared/class/industry.lua

---Define o preço de compra para esta indústria
---@param _price number
function Industry:SetPurchasePrice(_price)
    self.purchase_price = _price
    return self -- Importante para permitir o encadeamento de funções (ex: AddIndustry(...):SetPurchasePrice(...))
end

---Obtém o preço de compra desta indústria
---@return number|nil
function Industry:GetPurchasePrice()
    return self.purchase_price
end