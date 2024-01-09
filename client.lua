local player = {
    count = 0,
    inJail = false,
    initialCoords = nil
}

local selectedAction = {
    time = 0,
    count = 0,
    text = nil,
    blip = nil,
    emote = nil,
    coords = nil,
    active = false
}

local SetPlayerInJail = function()
    local playerPed = PlayerPedId()
    local jail = Config.Spawn
    SetEntityCoords(playerPed, jail.coords)
    SetEntityHeading(playerPed, jail.heading)
end

local ExitPlayerFromJail = function()
    SetEntityCoords(PlayerPedId(), player.initialCoords)

    if selectedAction.blip then
        RemoveBlip(selectedAction.blip)
    end
    
    player = {
        count = 0,
        inJail = false,
        initialCoords = nil
    }
    
    selectedAction = {
        time = 0,
        count = 0,
        text = nil,
        blip = nil,
        emote = nil,
        coords = nil,
        active = false
    }
    
    ESX.ShowNotification("Vous avez quitté la prison. Faites attention à votre comportement.")
end

local IsPlayerInJail = function(coords)
    local jailCoords = Config.Spawn.coords
    local distance = GetDistanceBetweenCoords(coords, jailCoords, true)
    return distance < Config.Data.distance
end

local SetPlayerAction = function()
    local randomAction = math.random(1, #Config.Actions)
    local randomCoords = math.random(1, #Config.Coords)
    local random = Config.Actions[randomAction]

    selectedAction.text = random.text
    selectedAction.emote = random.emote
    selectedAction.time = Config.Data.duration
    selectedAction.coords = Config.Coords[randomCoords]

    if selectedAction.blip then
        RemoveBlip(selectedAction.blip)
        selectedAction.blip = nil
    end

    selectedAction.blip = AddBlipForCoord(selectedAction.coords)

    SetBlipSprite(selectedAction.blip, Config.Blip.sprite)
    SetBlipScale(selectedAction.blip, Config.Blip.scale)
    SetBlipColour(selectedAction.blip, Config.Blip.color)
    SetBlipAsShortRange(selectedAction.blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Point d'action")
    EndTextCommandSetBlipName(selectedAction.blip)
end

local AddAction = function(nb)
    player.count = player.count + nb
    local text = GetText("action", nb)
    ESX.ShowNotification(("Vous avez reçu %s %s en plus pour avoir essayé de quitter la prison sans réaliser vos actions."):format(nb, text))
end

local PlayEmote = function()
    TaskStartScenarioInPlace(PlayerPedId(), selectedAction.emote, 0, true)
end

local IsPlayerPlayAnim = function()
    return IsPedUsingScenario(PlayerPedId(), selectedAction.emote)
end

local IsPlayerCloseAction = function()

    if player.count > 0
        and selectedAction.blip
        and selectedAction.text
        and selectedAction.time
        and selectedAction.emote
        and selectedAction.coords
        and not selectedAction.active then
        
        local coords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords, selectedAction.coords, true)
        return distance < 1.5
    else
        return false
    end
end

local SetPlayerCurrentAction = function()
    PlayEmote()

    selectedAction.active = true
    Wait(selectedAction.time * 1000)
    selectedAction.active = false

    ClearPedTasks(PlayerPedId())
    player.count = player.count - 1

    if player.count == 0 then
        ExitPlayerFromJail()
    else
        SetPlayerAction()
    end
end

local ShowData = function()
    local text = GetText("action", player.count)
    local text2 = GetText("seconde", selectedAction.time)

    if selectedAction.active then
        ESX.ShowHelpNotification(("%s pendant encore %s %s."):format(selectedAction.text, selectedAction.time, text2))
    else
        DrawMarker(1, selectedAction.coords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 155, 0, 255)
        ESX.ShowHelpNotification(("Il vous reste %s %s à réaliser avant de sortir de prison. Dirigez-vous vers le point d'action."):format(player.count, text))
    end
end

RegisterNetEvent("esx_admin_jail:jail")
AddEventHandler("esx_admin_jail:jail", function(count)
    local playerPed = PlayerPedId()

    if player.inJail then
        ExitPlayerFromJail()
    end

    player.count = count
    player.inJail = true
    player.initialCoords = GetEntityCoords(playerPed)

    SetPlayerInJail()
    SetPlayerAction()
end)

CreateThread(function()
    while true do
        local playerWait = 1000

        if player.inJail then
            playerWait = 5

            ShowData()

            local coords = GetEntityCoords(PlayerPedId())

            if not IsPlayerInJail(coords) then
                SetPlayerInJail()
                AddAction(2)
            end

            if selectedAction.active and not IsPlayerPlayAnim() then
                PlayEmote()
            end
        end

        Wait(playerWait)
    end
end)

CreateThread(function()
    while true do

        local playerWait = 1000

        if player.inJail then
            playerWait = 5

            if IsPlayerCloseAction() then
                SetPlayerCurrentAction()
            end
        end

        Wait(playerWait)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)

        if player.inJail and selectedAction.active then
            selectedAction.time = selectedAction.time - 1
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if player.inJail then
            ExitPlayerFromJail()
        end
    end
end)