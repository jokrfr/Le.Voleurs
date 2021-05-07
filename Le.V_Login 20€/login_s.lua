ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('Le.V:GetEntityPosition', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local TableTarace = {}
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {["@identifier"] = xPlayer.identifier}, function(result)
        TriggerClientEvent('Le.V:GetEntityPosition', source, json.decode(result[1].position), result[1].vie)
    end)
end)