QBCore.Functions.CreateCallback('cpl-cleanmoney:server:getmoneyprice', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local markedbills = Ply.Functions.GetItemByName("markedbills")

    if markedbills ~= nil then
        local src = source
        local Player = QBCore.Functions.GetPlayer(source)
        local totalvalue = 0
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k].name == 'markedbills' then
                totalvalue = totalvalue + Player.PlayerData.items[k].info.worth
                Player.Functions.RemoveItem(Player.PlayerData.items[k].name, 1)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
            end
        end
        cb(totalvalue)
    else
        cb(0)
    end
end)

QBCore.Functions.CreateCallback('cpl-cleanmoney:server:getpdcount', function(source, cb)
    local PoliceCount = 0

    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end
        end
    end

    cb(PoliceCount)
end)

RegisterServerEvent('cpl-cleanmoney:server:givemoneyclean')
AddEventHandler('cpl-cleanmoney:server:givemoneyclean', function(amount)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	xPlayer.Functions.AddMoney("cash", amount)
end)