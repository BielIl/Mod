-- Certifique-se de que Events e RecipeManager estão disponíveis
local Events = require "Events"
local RecipeManager = require "RecipeManager"

local NapalmRecipe = {
    Recipe = {
        Name = "Fabricar Napalm Caseiro",
        Description = "Misture ingredientes simples para criar um explosivo perigoso.",
        RequiredItems = {
            { "Base.Gasoline", 1 },        -- Gasolina
            { "Base.OrangeSoda", 1 },     -- Suco de laranja
            { "Base.Bleach", 1 },         -- Detergente (alvejante)
            { "Base.WaterBottleEmpty", 1 } -- Garrafa plástica vazia
        },
        ResultItem = "NapalmCaseiro.NapalmCaseiro", -- O item resultante
        SkillRequired = { "Cooking", 3 },
        TimeToCraft = 200,  -- Tempo de crafting em segundos (ajustável conforme necessidade)
        OnCreate = function(player)
            -- Ação extra que pode ser realizada quando o item for criado
            player:Say("Napalm Caseiro fabricado com sucesso!")
        end
    }
}

-- Registrando a receita no sistema de crafting
Events.OnGameBoot.Add(function()
    RecipeManager.addRecipe(NapalmRecipe.Recipe)
end)

return NapalmRecipe
