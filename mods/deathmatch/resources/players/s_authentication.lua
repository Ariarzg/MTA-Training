local MINIMUM_PASSWORD_LENGHT = 6

local function isPasswordValid(password)
    return string.len(password) >= MINIMUM_PASSWORD_LENGHT
end
-- create an account
addCommandHandler('register', function(player, command, username, password) 
    if not username or not password then 
        return outputChatBox('Syntax :#F54848 /' .. command .. ' [username] [password]', player, 255, 255, 255, true)
    end
    
    --check if an account with that username already exists
    if getAccount(username) then 
        return outputChatBox('An account already exists with that username', player, 255, 100, 100)
    end

    -- is the password valid
    if not isPasswordValid(password) then 
        return outputChatBox('Your provided password is not valid', player, 255, 100, 100)
    end

    --create a hash of the password
    passwordHash(password, 'bcrypt', {}, function(hashedPassword) 
        -- create the account
        local account = addAccount(username, hashedPassword)
        setAccountData(account, 'hashed_password', hashedPassword)

        -- let the user know of our success
        outputChatBox('Your account has successfully registered! You may now login via /accountLogin', player, 100, 225, 100)
    end)
end, false, false)
-- ---------------------------------------------------------------------

-- login to their account
addCommandHandler('accountLogin', function(player, command, username, password) 
    if not username or not password then 
        return outputChatBox('Syntax :#F54848 /' .. command .. ' [username] [password]', player, 255, 255, 255, true)
    end

    local account = getAccount(username)
    local hashedPassword = getAccountData(account, 'hashed_password')

    if not account then 
        return outputChatBox('No account exists with that username or password', player, 255, 100, 100)
    end


    passwordVerify(password, hashedPassword, function(isValid) 
        if not isValid then 
            return outputChatBox('No account exists with that username or password', player, 255, 100, 100)
        end

        if logIn(player, account, hashedPassword) then 
            return outputChatBox('You have successfully logged in', player, 100, 225, 100)
        end

        return outputChatBox('An unknown error occured while attempting to authenticate', player, 255, 100, 100)
    end)

end, false, false)
-- ---------------------------------------------------------------------

--logout to their account
addCommandHandler('accountlogout', function(player) 
    logOut(player)
end, false, false)