local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ds-marketplace:server:buyitem', function(price, quantity, item, id, citizenid)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney('bank', price, 'buyitem')
    Player.Functions.AddItem(item, quantity)
    MySQL.rawExecute.await('DELETE FROM marketplace_items WHERE id = ?', { id })

    local PlayerGettingMoney = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    PlayerGettingMoney.Functions.AddMoney('bank', price, 'solditem')

    TriggerEvent("ds-marketplace:server:getmoneydbback", src, Player)
end)

RegisterNetEvent('ds-marketplace:server:addlistingdb', function(price, quantity, item, label, image)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player.Functions.RemoveItem(item, quantity) then

        TriggerEvent("ds-marketplace:server:getmoneydbback", src, Player)

        return
    end

    MySQL.Async.execute('INSERT INTO `marketplace_items` (`citizenid`, `price`, `item`, `label`, `quantity`, `image`) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, price, item, label, quantity, image})

end)

RegisterNetEvent('ds-marketplace:server:removelistingdb', function(id, item, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddItem(item, quantity)

    MySQL.rawExecute.await('DELETE FROM marketplace_items WHERE id = ?', { id })
    TriggerEvent("ds-marketplace:server:getmoneydbback", src, Player)

end)

RegisterNetEvent('ds-marketplace:server:getplayer', function()

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    TriggerEvent("ds-marketplace:server:getmoneydbback", src, Player)

end)

RegisterNetEvent('ds-marketplace:server:getmoneydbback', function(src, Player)

    Wait(100)
    local items = MySQL.query.await('SELECT * FROM marketplace_items', {})
    local ownitems = MySQL.query.await('SELECT * FROM marketplace_items WHERE `citizenid` = ?', {Player.PlayerData.citizenid})

    local playerMoney = Player.PlayerData.money['bank']

    TriggerClientEvent("ds-marketplace:client:backnui", src, items, playerMoney, ownitems)

end)

RegisterNetEvent('ds-marketplace:server:getmoneydb', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local items = MySQL.query.await('SELECT * FROM marketplace_items', {})
    local ownitems = MySQL.query.await('SELECT * FROM marketplace_items WHERE `citizenid` = ?', {Player.PlayerData.citizenid})

    local playerMoney = Player.PlayerData.money['bank']
    TriggerClientEvent("ds-marketplace:client:openui", src, items, playerMoney, ownitems)
end)