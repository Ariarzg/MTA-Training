db = exports.db:getConnection()


-- -----------------------------------------------------------------------------------------

function laodAllVehicles(queryHandle)
    local result = dbPoll(queryHandle, 0)

    for index, vehicle in pairs(result) do
        local vehicleObject = createVehicle(vehicle.model, vehicle.x, vehicle.y, vehicle.z, vehicle.rotate_x,
            vehicle.rotate_y, vehicle.rotate_z)

        setElementData(vehicleObject, "id", vehicle.id)
    end
end

-- -------------------

function createVehicleForPlayer(player, command, model)
    local x, y, z = getElementPosition(player)
    x = x + 2
    y = y + 2
    local vehicleObject = createVehicle(model, x, y, z)
    local rx, ry, rz = getElementRotation(vehicleObject)

    dbExec(db, "INSERT INTO vehicles (model, x, y, z, rotate_x, rotate_y, rotate_z) VALUES (?, ?, ?, ?, ?, ?, ?)", model,
        x, y, z, rx, ry, rz)

    dbQuery(function(queryHandle)
        local results = dbPoll(queryHandle, 0)
        local vehicle = results[1]

        setElementData(vehicleObject, "id", vehicle.id)
    end, db, "SELECT id FROM vehicles ORDER BY id DESC LIMIT 1")
end

-- -----------------------------------------------------------------------------------------

addEventHandler('onResourceStart', resourceRoot, function()
    dbQuery(laodAllVehicles, db, "SELECT * FROM vehicles")
end)

-- ------------

addEventHandler('onResourceStop', resourceRoot, function()
    local vehicles = getElementsByType('vehicle')

    for index, vehicle in pairs(vehicles) do
        local id = getElementData(vehicle, "id")
        local x, y, z = getElementPosition(vehicle)
        local rx, ry, rz = getElementRotation(vehicle)

        dbExec(db, "UPDATE vehicles SET x = ?, y = ?, z = ?, rotate_x = ?, rotate_y = ?, rotate_z = ? WHERE id = ?", x, y,
            z, rx, ry, rz, id)
    end
end)

-- -------------

addCommandHandler('veh', createVehicleForPlayer, false, false)
