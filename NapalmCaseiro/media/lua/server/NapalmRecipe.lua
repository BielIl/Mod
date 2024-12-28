-- Obtém as bibliotecas necessárias
local Events = require "Events"               -- Para usar eventos do jogo
local RecipeManager = require "RecipeManager" -- Para adicionar receitas de crafting

-- Define a tabela NapalmRecipe para armazenar a receita do Napalm Caseiro
local NapalmRecipe = {
    -- Define a receita
    Recipe = {
        Name = "Fabricar Napalm Caseiro",                                               -- Nome da receita
        Description = "Misture ingredientes simples para criar um explosivo perigoso.", -- Descrição da receita
        RequiredItems = {                                                               -- Itens necessários para fabricar o Napalm Caseiro
            { "Base.Gasoline",         1 },                                             -- Gasolina
            { "Base.OrangeSoda",       1 },                                             -- Refrigerante de laranja
            { "Base.Bleach",           1 },                                             -- Água sanitária
            { "Base.WaterBottleEmpty", 1 }                                              -- Garrafa de água vazia
        },
        ResultItem = "NapalmCaseiro.NapalmCaseiro",                                     -- Item resultante da receita
        SkillRequired = { "Cooking", 3 },                                               -- Habilidade e nível necessários para fabricar
        TimeToCraft = 200,                                                              -- Tempo em segundos para fabricar o item
        OnCreate = function(player)                                                     -- Função que é executada quando o item é fabricado
            -- Exibe uma mensagem para o jogador
            player:Say("Napalm Caseiro fabricado com sucesso!")
        end
    }
}

-- Adiciona um evento que ocorre quando o jogo inicia
Events.OnGameBoot.Add(function()
    -- Adiciona a receita do Napalm Caseiro ao jogo
    RecipeManager.addRecipe(NapalmRecipe.Recipe)
end)

-- Retorna a tabela NapalmRecipe
return NapalmRecipe
