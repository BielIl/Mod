-- Certifique-se de que InventoryItemFactory, Events e getScriptManager estão disponíveis
local InventoryItemFactory = require "InventoryItemFactory"
local Events = require "Events"
local getScriptManager = require "getScriptManager"

-- Definindo o item Napalm Caseiro
NapalmCaseiro = {}

NapalmCaseiro.Type = "InventoryItem"          -- Tipo de item (Item de inventário)
NapalmCaseiro.DisplayName = "Napalm Caseiro"  -- Nome do item
NapalmCaseiro.Icon = "Molotov"                -- Ícone do item (você pode personalizar o ícone)
NapalmCaseiro.Weight = 1.5                    -- Peso do item
NapalmCaseiro.ImpactSound = "BreakObject"     -- Som do impacto
NapalmCaseiro.CustomContextMenu = true        -- Permite adicionar um menu de contexto customizado
NapalmCaseiro.IsExplosive = true              -- Define que o item é explosivo
NapalmCaseiro.ExplosionTimer = 1              -- Tempo de explosão em segundos

-- Função que é chamada quando o item é usado
function NapalmCaseiro.UseNapalmCaseiro(player)
    -- Função que chama a explosão do napalm (você pode integrar com a função OnExplode do seu código anterior)
    Napalm.OnExplode(player:getSquare())
end

-- Função para criar o item no jogo
function NapalmCaseiro.CreateNapalmCaseiroItem()
    -- Registrando o item no sistema de itens do Project Zomboid
    local item = InventoryItemFactory.CreateItem("NapalmCaseiro")  -- Usa o ID do item
    item:setWeight(NapalmCaseiro.Weight)
    item:setIcon(NapalmCaseiro.Icon)
    
    -- Se precisar configurar algum som ou outras propriedades
    item:setImpactSound(NapalmCaseiro.ImpactSound)
    
    -- Retorna o item
    return item
end

-- Registrando o item para que ele seja reconhecido no jogo
Events.OnGameBoot.Add(function()
    -- Adiciona o item ao sistema quando o jogo iniciar
    getScriptManager():AddItem("NapalmCaseiro", NapalmCaseiro)
end)
