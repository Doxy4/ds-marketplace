Config = {}

Config.Command = "marketplace" -- do /marketplace to open menu

Config.CheckForItem = false -- if you want to have it check for item to open
Config.CheckItem = "phone" -- your item you have to have to be able to open market

function Config.HasItem(items, amount)
        return QBCore.Functions.HasItem(items, amount)
end
