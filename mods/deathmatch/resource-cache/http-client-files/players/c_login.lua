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
    local window = guiCreateWindow(x, y, width, height, 'Login To Our Server', false)

    local usernameLabel = guiCreateLabel(15, 30, width - 30, 20, 'Username :', false, window)
    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)

    local passwordLabel = guiCreateLabel(15, 90, width - 30, 20, 'Password :', false, window)
    local passwordInput = guiCreateEdit(10, 110, width - 20, 30, '', false, window)

    local loginButton = guiCreateButton(10, 150, width - 20, 30, 'Log In', false, window)
    
    local registerButton = guiCreateButton(10, 190, (width / 2) - 15, 30, 'Sign Up', false, window)

    local forgotPasswordButton = guiCreateButton((width / 2) + 5, 190, (width / 2) - 15, 30, 'Forgot Password', false, window)
end, true)

triggerEvent('login-menu:open', localPlayer)