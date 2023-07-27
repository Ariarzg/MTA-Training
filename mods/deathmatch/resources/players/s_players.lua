addEventHandler('onPlayerJoin', root, function()
    triggerClientEvent(source, 'login-menu:open', source)
end)

addEventHandler('onPlayerQuit', root, function() 
    local account = getPlayerAccount(source)
    
    if not account then 
        return 
    end

    local x, y, z = getElementPosition(source)
    local interior = getElementInterior(source)
    local dimension = getElementDimension(source)

    setAccountData(account, 'last_x', x)
    setAccountData(account, 'last_y', y)
    setAccountData(account, 'last_z', z)
    setAccountData(account, 'last_interior', interior)
    setAccountData(account, 'last_dimension', dimension)
    
end)

addCommandHandler('pos', function(player, command) 
    x, y, z = getElementPosition(player)
    outputChatBox('x : ' .. x)
    outputChatBox('y : ' .. y)
    outputChatBox('z : ' .. z)
    return
end, false, false)