local locations = {
    {
        coords = vector3(-1081.13, 328.48, 56.12),
        title = "Rohdes Testing",
        discordText = "Burr",
        range = 50.0 -- Specific range for this location
    },
    {
        coords = vector3(219.45, -2547.156, 6.203),
        title = "Another Location",
        discordText = "",
        range = 50.0 -- Specific range for this location
    },
    {
        coords = vector3(-246.4827, -1610.57, 33.6316),
        title = "Another",
        discordText = "",
        range = 50.0 -- Specific range for this location
    },
}

local displayText = false
local inGreenZone = false

function RemoveText()
    displayText = false
    SendNUIMessage({ type = "displayText", display = false })
end

function SetPlayerPvP(enabled)
    local player = PlayerId()
    NetworkSetFriendlyFireOption(enabled)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playerPed = PlayerId()
        local playerCoords = GetEntityCoords(PlayerPedId())

        local nearestLocation = nil
        local nearestDistance = nil

        for _, location in ipairs(locations) do
            local distance = #(playerCoords - location.coords)
            if (not nearestDistance or distance < nearestDistance) and distance <= location.range then
                nearestDistance = distance
                nearestLocation = location
            end
        end

        if nearestLocation then
            displayText = true
            inGreenZone = true
            SetPlayerPvP(false)
            local message = {
                type = "displayText",
                display = true,
                text = nearestLocation.title,
                discordText = nearestLocation.discordText,
            }
            SendNUIMessage(message)
        else
            if inGreenZone then
                inGreenZone = false
                SetPlayerPvP(true)
            end
            RemoveText()
        end
    end
end)
