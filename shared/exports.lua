-- Industries Registry
-- Industry Name mean ID of Industry and unique string value
--teste
---AddIndustry
exports('AddIndustry',
    function(_name, _label, _status, _tier, _type, _location, _forSaleLocation, _wantedLocation, _tradeData)
        return Industries:AddIndustry(_name, _label, _status, _tier, _type, _location, _forSaleLocation, _wantedLocation,
            _tradeData)
    end)

exports('GetIndustry', function(_industryName)
    return Industries:GetIndustry(_industryName)
end)

exports('GetAllIndustries', function()
    return Industries:GetIndustries()
end)

exports('GetIndustryTypeListFromTier', function (_industryTier)
    return Industries:GetIndustryTypeList(_industryTier)
end)

exports('GetIndustryLabel', function (_industryName)
    return Industries:GetIndustryLabel(_industryName)
end)

exports('RemoveIndustry', function (_industryName)
    return Industries:RemoveIndustry(_industryName)
end)

exports('UpdateIndustryTradeData', function (_industryName, _tradeData)
    return Industries:UpdateTradeData(_industryName, _tradeData)
end)

exports('GetIndustryStatus', function (_industryName)
    return Industries:GetIndustryStatus(_industryName)
end)

exports('SetIndustryStatus', function (_industryName, _status)
    return Industries:SetIndustryStatus(_industryName, _status)
end)

exports('GetIndustryTradeData', function (_industryName)
    return Industries:GetIndustryTradeData(_industryName)
end)

exports('GetIndustryCount', function ()
    return Industries:GetCounts()
end)

exports('GetIndustryItemPriceData', function (_industryName, _itemName)
    return Industries:GetIndustryItemPriceData(_industryName, _itemName)
end)

exports('IsIndustryStorageFull', function (_industryName, _tradeType, _itemName)
    return Industries:IsIndustryStorageFull(_industryName, _tradeType, _itemName)
end)

exports('GetIndustryInStockAmount', function (_industryName, _tradeType, _itemName)
    return Industries:GetIndustryInStockAmount(_industryName, _tradeType, _itemName)
end)

-- replicate is boolean for server send to all client
exports('AddIndustryItemAmount', function (_industryName, _tradeType, _itemName, _amount, _replicate)
    return Industries:AddIndustryItemAmount(_industryName, _tradeType, _itemName, _amount, _replicate)
end)

exports('RemoveIndustryItemAmount', function (_industryName, _tradeType, _itemName, _amount, _replicate)
    return Industries:RemoveIndustryItemAmount(_industryName, _tradeType, _itemName, _amount, _replicate)
end)
