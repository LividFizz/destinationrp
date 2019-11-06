ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('fine', function(source, args, raw)
    local src = source
    local myPed = GetPlayerPed(src)
    local myPos = GetEntityCoords(myPed)
    local players = ESX.GetPlayers()

    for k, v in ipairs(players) do
        if v ~= src then
            local xTarget = GetPlayerPed(v)
            local xPlayer = ESX.GetPlayerFromId(v)
            local tPos = GetEntityCoords(xTarget)
            local dist = #(vector3(tPos.x, tPos.y, tPos.z) - myPos)
            local xSource = ESX.GetPlayerFromId(source)
        
            if dist < 1 and xSource.job.name == 'police' then
                if tonumber(args[1]) ~= nil then
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You have fined ID - [' .. v .. '] for $' .. tonumber(args[1]) .. '.' })
                    TriggerClientEvent('mythic_notify:client:SendAlert', v, { type = 'inform', text = 'You have been sent a Fine for $' .. tonumber(args[1]) .. '.'})
                    TriggerClientEvent('drp-fines:Anim', source)
                    xPlayer.removeAccountMoney('bank', tonumber(args[1]))
                end
            end
        end
    end
end)