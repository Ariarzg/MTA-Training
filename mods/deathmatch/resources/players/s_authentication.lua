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
        triggerEvent('auth:login-attempt', player, username, password)
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
            spawnPlayer(player, 0, 0, 10)
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