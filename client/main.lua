RegisterNetEvent('cpl-cleanmoney:client:cleanmoney')
AddEventHandler('cpl-cleanmoney:client:cleanmoney', function()
	local total_cops = 0
	local total_reduction = 0

	QBCore.Functions.TriggerCallback('cpl-cleanmoney:server:getpdcount', function(count)
		total_cops = count
		total_reduction = Config.base_reduction - ( Config.reduction_per_cop * total_cops ) 
	end)

	QBCore.Functions.TriggerCallback('cpl-cleanmoney:server:getmoneyprice', function(value)
		if value ~= 0 then
			local pos = GetEntityCoords(PlayerPedId())

			newvalue = value - (value * total_reduction)
			
			if newvalue <= .01 then
				newvalue = value
			end

			QBCore.Functions.Progressbar("marked_bills", "Handing over marked bills", 10000, false, true, {
				disableMovement = true,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
			}, {}, {}, {}, function()
				
				QBCore.Functions.Notify('Total Value: $' .. newvalue, 'success')
				TriggerServerEvent('cpl-cleanmoney:server:givemoneyclean', newvalue)
				if math.random(0, 50) <= 25 and not IsWearingHandshoes() then
					TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
				end
			end, function()
				QBCore.Functions.Notify("Failed!", "error")
			end)
        else
            QBCore.Functions.Notify('No bills', 'error')
        end
	end)
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end