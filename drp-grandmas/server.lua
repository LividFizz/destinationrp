ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('drp-grandmas:payBill')
AddEventHandler('drp-grandmas:payBill', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	--change price here for revive
	xPlayer.removeBank(1000)
    TriggerClientEvent('esx:showNotification', src, '~w~You Were Billed For ~r~$1,000~w~.')
end)