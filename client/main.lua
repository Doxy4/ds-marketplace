QBCore = exports['qb-core']:GetCoreObject()

local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

local function noMoney(enable)
    SendNUIMessage({
        type = 'show',
        enable = enable,
        nomoney = true,
    })
end


local function doAnimation()
    if not isOpen then return end
    -- Animation
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Citizen.Wait(100) end
    -- Model
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Citizen.Wait(100) end

    local plyPed = PlayerPedId()
    local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
    local tabletBoneIndex = GetPedBoneIndex(plyPed, tabletBone)

    AttachEntityToEntity(tabletObj, plyPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    CreateThread(function()
        while isOpen do
            Wait(0)
            if not IsEntityPlayingAnim(plyPed, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(plyPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end

        for k, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(PlayerPedId(), v) then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
                DeleteEntity(v)
                ClearPedSecondaryTask(plyPed)
            end
        end
    end)
end

RegisterNUICallback('removeitem', function(data, cb)
    cb(true)

    local id = data.id
    local item = data.item
    local quantity = data.quantity

    TriggerServerEvent("ds-marketplace:server:removelistingdb", id, item, quantity)
end)

RegisterNUICallback('buyitem', function(data, cb)
    cb(true)

    local price = data.price
    local quantity = data.quantity
    local item = data.item
    local id = data.id
    local citizenid = data.citizenid

    TriggerServerEvent("ds-marketplace:server:buyitem", price, quantity, item, id, citizenid)
end)

RegisterNUICallback('addlisting', function(data, cb)
    cb(true)

    local price = data.price
    local quantity = data.quantity
    local item = data.item
    local image = QBCore.Shared.Items[item].image
    local label = QBCore.Shared.Items[item].label

    TriggerServerEvent("ds-marketplace:server:addlistingdb", price, quantity, item, label, image)
end)


RegisterNUICallback('backnui', function(data, cb)
    cb(true)
    TriggerServerEvent("ds-marketplace:server:getplayer")
end)

local function EnableGUI(enable, items, playerMoney, ownitems)
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = 'show',
        enable = enable,
        nomoney = false,
        items = items,
        back = false,
        playerMoney = playerMoney,
        ownitems = ownitems,
    })
    isOpen = enable
end

RegisterNetEvent("ds-marketplace:client:backnui", function (items, playerMoney, ownitems)
    SendNUIMessage({
        type = 'show',
        enable = true,
        nomoney = false,
        items = items,
        back = true,
        playerMoney = playerMoney,
        ownitems = ownitems,
    })
end)


RegisterNetEvent("ds-marketplace:client:purchase", function (business, price)
    TriggerServerEvent("ds-marketplace:server:purchase", price, business)
end)

RegisterNUICallback('nomoney', function(data, cb)
    cb(true)
    noMoney(true)
end)

RegisterNUICallback('escape', function(data, cb)
    EnableGUI(false)
    cb(true)
end)

RegisterNetEvent('ds-marketplace:client:getmoney', function()
    TriggerServerEvent("ds-marketplace:server:getmoneydb")
end)

RegisterNetEvent('ds-marketplace:client:openui', function(items, playerMoney, ownitems)

    EnableGUI(true, items, playerMoney, ownitems)
    doAnimation()
end)

RegisterCommand(Config.Command, function()

    if Config.CheckForItem then
    local hasItem = Config.HasItem(Config.CheckItem)
    if hasItem then
    TriggerEvent("ds-marketplace:client:getmoney")
    else
        QBCore.Functions.Notify("You dont have a ".. Config.CheckItem, "error")
    end
else
    TriggerEvent("ds-marketplace:client:getmoney")
end
end)

RegisterNetEvent('ds-marketplace:nomoney', function()
    noMoney(true)
end)

RegisterNetEvent('ds-marketplace:closenui', function()
    EnableGUI(false)
end)
