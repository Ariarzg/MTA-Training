local window

local function isUsernameValid(username)
    return type(username) == 'string' and string.len(username) >= 1
end

local function isPasswordValid(password)
    return type(password) == 'string' and string.len(password) >= 6
end

local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    return x, y, width, height
end

addEvent('login-menu:open', true)

addEventHandler('login-menu:open', root, function() 
    -- fade their camera in
    setCameraMatrix(0, 0, 100, 0, 100, 50)
    fadeCamera(true)
    

    -- make players cursor show
    showCursor(true, true)
    guiSetInputMode('no_binds')

    -- open the menu
    local x, y, width, height = getWindowPosition(400, 230)
    window = guiCreateWindow(x, y, width, height, 'Login To Our Server', false)
    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)

    local usernameLabel = guiCreateLabel(15, 30, width - 30, 20, 'Username :', false, window)
    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)
 
    local usernameErrorLabel =  guiCreateLabel(width - 130, 30, 140, 20, 'Username is requierd',false, window)
    guiLabelSetColor(usernameErrorLabel, 255, 50, 50)
    guiSetVisible(usernameErrorLabel, false)
    
    local passwordLabel = guiCreateLabel(15, 90, width - 30, 20, 'Password :', false, window)
    local passwordInput = guiCreateEdit(10, 110, width - 20, 30, '', false, window)
    guiEditSetMasked(passwordInput, true)

    local passwordErrorLabel =  guiCreateLabel(width - 120, 90, 140, 20, 'Password is invalid',false, window)
    guiLabelSetColor(passwordErrorLabel, 255, 50, 50)
    guiSetVisible(passwordErrorLabel, false)

    

    local loginButton = guiCreateButton(10, 150, width - 20, 30, 'Log In', false, window)
    addEventHandler('onClientGUIClick', loginButton, function(button, state) 
        if button ~= 'left' or state ~= 'up' then 
            return 
        end

        guiSetVisible(usernameErrorLabel, false)
        guiSetVisible(passwordErrorLabel, false)

        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local inputValid = true

        if not isUsernameValid(username) then 
            -- invalid username
            inputValid = false
            guiSetVisible(usernameErrorLabel, true)
        end

        if not isPasswordValid(password) then 
            inputValid = false
            guiSetVisible(passwordErrorLabel, true)
        end

        if not inputValid then 
            return
        end

        triggerServerEvent('auth:login-attempt', localPlayer, username, password)
    end, false)
    
    local registerButton = guiCreateButton(10, 190, (width / 2) - 15, 30, 'Sign Up', false, window)
    addEventHandler('onClientGUIClick', registerButton, function(button, state) 
        if button ~= 'left' or state ~= 'up' then 
            return 
        end

        guiSetVisible(usernameErrorLabel, false)
        guiSetVisible(passwordErrorLabel, false)

        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local inputValid = true

        if not isUsernameValid(username) then 
            -- invalid username
            inputValid = false
            guiSetVisible(usernameErrorLabel, true)
        end

        if not isPasswordValid(password) then 
            inputValid = false
            guiSetVisible(passwordErrorLabel, true)
        end


        if not inputValid then 
            return
        end

        triggerServerEvent('auth:register-attempt', localPlayer, username, password)
    end, false)

    local forgotPasswordButton = guiCreateButton((width / 2) + 5, 190, (width / 2) - 15, 30, 'Forgot Password', false, window)
end, true)

addEvent('login-menu:close', true)

addEventHandler('login-menu:close', root, function() 
    destroyElement(window)
    showCursor(false)
    guiSetInputMode('allow_binds')
end)