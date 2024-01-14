Config = {

    Control = {
        id = 38,
        name = "~INPUT_PICKUP~"
    },

    Spawn = {
        coords = vector3(-2167.819, 5190.817, 16.271),
        heading = 11.338
    },

    Data = {
        distance = 140.0,
        duration = 20,
        maxActions = 80
    },

    Blip = {
        sprite = 1,
        scale = 0.8,
        color = 69
    },

    Coords = {
        vector3(-2184.184, 5121.046, 9.238),
        vector3(-2204.914, 5097.006, 8.683),
        vector3(-2220.435, 5100.883, 9.087),
        vector3(-2210.004, 5182.694, 15.288),
        vector3(-2183.551, 5218.008, 20.714),
        vector3(-2167.622, 5269.529, 17.158),
        vector3(-2158.246, 5236.377, 16.771),
        vector3(-2141.156, 5240.426, 14.294),
        vector3(-2151.322, 5207.314, 13.401),
        vector3(-2157.481, 5159.143, 11.227),
        vector3(-2200.259, 5142.316, 11.093),
        vector3(-2190.052, 5176.681, 14.227),
        vector3(-2204.716, 5116.298, 10.891)
    },

    Actions = {
        { emote = "WORLD_HUMAN_YOGA", text = "Vous faites du yoga" },
        { emote = "WORLD_HUMAN_SIT_UPS", text = "Vous faites des abdos" },
        { emote = "WORLD_HUMAN_PUSH_UPS", text = "Vous faites des pompes" },
        { emote = "CODE_HUMAN_MEDIC_KNEEL", text = "Vous regardez le sol" },
        { emote = "WORLD_HUMAN_MUSCLE_FLEX", text = "Vous montrez vos muscles" },
        { emote = "WORLD_HUMAN_TOURIST_MAP", text = "Vous regardez une carte" },
        { emote = "WORLD_HUMAN_GARDENER_PLANT", text = "Vous faites du jardinage" }
    }
}

GetText = function(text, nb)

    if nb > 1 then
        text = ("%ss"):format(text)
    end

    return text
end
