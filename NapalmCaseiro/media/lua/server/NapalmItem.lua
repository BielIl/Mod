-- Obtém as bibliotecas necessárias
local InventoryItemFactory = require "InventoryItemFactory" -- Para criar itens no jogo
local Events = require "Events"                             -- Para usar eventos do jogo
local getScriptManager = require "getScriptManager"         -- Para registrar o item no jogo

-- Define a tabela NapalmCaseiro para armazenar as propriedades do item
NapalmCaseiro = {}

-- Define as propriedades do item Napalm Caseiro
NapalmCaseiro.Type = "InventoryItem"         -- Tipo de item
NapalmCaseiro.DisplayName = "Napalm Caseiro" -- Nome que será exibido no jogo
NapalmCaseiro.Icon = "Molotov"               -- Ícone do item (pode ser alterado)
NapalmCaseiro.Weight = 1.5                   -- Peso do item
NapalmCaseiro.ImpactSound = "BreakObject"    -- Som que será reproduzido ao usar o item
NapalmCaseiro.CustomContextMenu = true       -- Permite adicionar um menu de contexto customizado
NapalmCaseiro.IsExplosive = true             -- Define que o item é explosivo
NapalmCaseiro.ExplosionTimer = 1             -- Tempo em segundos até a explosão após o uso

-- Função que define o que acontece quando o item é usado
function NapalmCaseiro.UseNapalmCaseiro(player)
    -- Chama a função ExplodeNapalm do NapalmEffect para causar a explosão
    Napalm.ExplodeNapalm(player:getSquare())
end

-- Função que cria o item Napalm Caseiro no jogo
function NapalmCaseiro.CreateNapalmCaseiroItem()
    -- Cria o item usando o InventoryItemFactory
    local item = InventoryItemFactory.CreateItem("NapalmCaseiro")
    -- Define as propriedades do item
    item:setWeight(NapalmCaseiro.Weight)
    item:setIcon(NapalmCaseiro.Icon)
    item:setImpactSound(NapalmCaseiro.ImpactSound)
    -- Retorna o item criado
    return item
end

-- Adiciona um evento que ocorre quando o jogo inicia
Events.OnGameBoot.Add(function()
    -- Registra o item Napalm Caseiro no jogo usando o getScriptManager
    getScriptManager():AddItem("NapalmCaseiro", NapalmCaseiro)
end)
