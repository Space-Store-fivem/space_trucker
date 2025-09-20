-- This function will call when player nearby trade point
function ShowHelpNotify(msg)
    ShowHelpNotification(msg) --built-in scaleform help notification
end

-- BUILT_IN FUNCTIONS
function AttachProp(ped, model, boneId, x, y, z, xR, yR, zR, vertex)
    local modelHash = type(model) == 'string' and GetHashKey(model) or model
    local bone = GetPedBoneIndex(ped, boneId)
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end

    local prop = CreateObject(modelHash, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(prop, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 1, not vertex and 2 or 0, 1)
    SetModelAsNoLongerNeeded(modelHash)
    return prop
end

function PlayCarryAnim()
    RequestAnimDict("anim@heists@box_carry@")
    while not HasAnimDictLoaded("anim@heists@box_carry@") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.CreateThread(function()
        Wait(5000)
        while HasPlayerCarryItem() do
            local playerPed = PlayerPedId()
            if not IsEntityPlayingAnim(playerPed, "anim@heists@box_carry@", "idle", 3) then
                TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
            end
            -- if IsPedDeadOrDying(playerPed, true) then
            --     -- Need change for your Framework
            --     OnPlayerDeath()
            --     return
            -- end

            if IsPedInAnyVehicle(playerPed, true) then
                TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 1)
            end
            Wait(5000)
        end
    end)
end

function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255) -- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z + 2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function ShowHelpNotification(msg, thisFrame, beep, duration)
    AddTextEntry('HelpNotification', msg)
    if thisFrame then
        DisplayHelpTextThisFrame('HelpNotification', false)
    else
        if beep == nil then
            beep = true
        end
        BeginTextCommandDisplayHelp('HelpNotification')
        EndTextCommandDisplayHelp(0, false, beep, duration or -1)
    end
end

function GetMarkerForItemTransType(_tradeType, _itemName)
    local transType = GetItemTransportType(_itemName)
    if transType == spaceconfig.ItemTransportType.CRATE or transType == spaceconfig.ItemTransportType.STRONGBOX then
        if _tradeType == spaceconfig.Industry.TradeType.FORSALE then
            return 21, 0.0
        else
            return 22, 180.0
        end
    else
        return 39, 0.0
    end
end

---getTradePointDescription
---@param _industryName string
---@param _tradeType string
---@param _tradeItem string
---@return string
function GetTradePointDescription(_industryName, _tradeType, _tradeItem)
    local tradeData = Industries:GetIndustryTradeData(_industryName)
    if not tradeData or not tradeData[_tradeType] or not tradeData[_tradeType][_tradeItem] then return '~r~Error' end
    if not spaceconfig.IndustryItems[_tradeItem] then return 'item_undefined' end

    local itemTradeData = tradeData[_tradeType][_tradeItem]
    local description = string.format("%s%s~w~~n~[%s]~n~%s~n~%s/%s",
        _tradeType == spaceconfig.Industry.TradeType.FORSALE and "~y~" or "~g~",
        Lang:t(_tradeType == spaceconfig.Industry.TradeType.FORSALE and "trade_point_for_sale_label" or
            "trade_point_wanted_label"), spaceconfig.IndustryItems[_tradeItem].label,
        Lang:t("trade_point_storage_label", { current = itemTradeData.inStock, max = itemTradeData.storageSize }),
        Lang:t("trade_point_price_label", { price = math.groupdigits(itemTradeData.price) }),
        GetItemTransportUnit(_tradeItem))

    return description
end

function GetItemTransportUnit(_itemName)
    local itemTransportType = GetItemTransportType(_itemName)
    if not itemTransportType then return 'undefined' end

    return spaceconfig.ItemTransportUnit[itemTransportType]
end

function GetItemLabel(_itemName)
    if not spaceconfig.IndustryItems[_itemName] then return 'undefined' end
    return spaceconfig.IndustryItems[_itemName].label
end

function GetItemTransportType(_itemName)
    if not spaceconfig.IndustryItems[_itemName] then return nil end
    return spaceconfig.IndustryItems[_itemName].transType
end

function GetVehicleTransportTypeLabel(_transType)
    local str = ''
    for k, v in pairs(_transType) do
        if str ~= '' then str = str .. ', ' end
        str = str .. spaceconfig.VehicleTransportTypeLabel[k]
    end
    return str
end
