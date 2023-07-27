local SPAWN_X, SPAWN_Y, SPAWN_Z = -2668, -6, 6.5;

-- create an account
addEvent('auth:register-attempt', true)
addEventHandler('auth:register-attempt', root, function(username, password)

    --check if an account with that username already exists
    if getAccount(username) then 
        return outputChatBox('An account already exists with that username', source, 255, 100, 100)
    end

    --create a hash of the password
    player = source
    passwordHash(password, 'bcrypt', {}, function(hashedPassword) 
        -- create the account
        local account = addAccount(username, hashedPassword)
        setAccountData(account, 'hashed_password', hashedPassword)

        -- login user
        if logIn(player, account, hashedPassword) then 
            spawnPlayer(player, SPAWN_X, SPAWN_Y, SPAWN_Z)
            setCameraTarget(player, player)

            return triggerClientEvent(player, 'login-menu:close', player)
        end
    end)
end)
-- ---------------------------------------------------------------------

-- login to their account
addEvent('auth:login-attempt', true)
addEventHandler('auth:login-attempt', root, function(username, password) 

    local account = getAccount(username)
    local hashedPassword = getAccountData(account, 'hashed_password')

    if not account then 
        return outputChatBox('No account exists with that username or password', player, 255, 100, 100)
    end

    local player = source
    passwordVerify(password, hashedPassword, function(isValid) 
        if not isValid then 
            return outputChatBox('No account exists with that username or password', player, 255, 100, 100)
        end

        if logIn(player, account, hashedPassword) then 
            local x = getAccountData(account, 'last_x')
            local y = getAccountData(account, 'last_y')
            local z = getAccountData(account, 'last_z')
            local interior = getAccountData(account, 'last_interior')
            local dimension = getAccountData(account, 'last_dimension')
            
            spawnPlayer(player, x, y, z)
            setElementInterior(player, interior)
            setElementDimension(player, dimension)

            setCameraTarget(player, player)
            return triggerClientEvent(player, 'login-menu:close', player)
        end

        return outputChatBox('An unknown error occured while attempting to authenticate', player, 255, 100, 100)
    end)

end)
-- ---------------------------------------------------------------------

--logout to their account
addCommandHandler('accountlogout', function(player) 
    logOut(player)
end, false, false)