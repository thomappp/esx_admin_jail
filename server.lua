local CanUseCommand = function(player, target, args, nbAction)

    if player.getGroup() ~= "admin" then
        player.showNotification("Vous devez être modérateur pour utiliser cette commande.")
        return false
    elseif #args < 2 then
        player.showNotification("Pour utiliser cette commande, faites /jail [playerId] [nbAction]")
        return false
    elseif not target then
        player.showNotification("Le joueur n'est pas connecté.")
        return false
    elseif nbAction > Config.Data.maxActions or nbAction < 0 then
        player.showNotification(("Vous devez choisir un nombre d'action compris entre 1 et %s"):format(Config.Data.maxActions))
        return false
    end

    return true
end

RegisterCommand("jail", function(source, args)
    local player = ESX.GetPlayerFromId(source)
    local targetId = tonumber(args[1])
    local nbAction = tonumber(args[2])
    local target = ESX.GetPlayerFromId(targetId)

    if CanUseCommand(player, target, args, nbAction) then
        local targetName = target.getName()
        local text = GetText("action", nbAction)

        target.triggerEvent("esx_admin_jail:jail", nbAction)
        player.showNotification(("Vous avez placé %s en prison pour %s %s."):format(targetName, nbAction, text))
    end
end)