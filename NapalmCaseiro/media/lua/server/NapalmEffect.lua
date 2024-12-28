-- Certifique-se de que IsoFireManager e Events estão disponíveis
local IsoFireManager = require "IsoFireManager"
local Events = require "Events"
local ZombRand = require "ZombRand"
local getCell = require "Cell"

Napalm = {}

-- Função que é chamada quando o napalm explode
function Napalm.ExplodeNapalm(square)
    local radius = 3  -- Define a área de 3 tiles ao redor
    for x = -radius, radius do
        for y = -radius, radius do
            local tile = getCell():getGridSquare(square:getX() + x, square:getY() + y, square:getZ())
            if tile then
                Napalm.StartFireOnTile(tile)  -- Inicia o fogo no tile
            end
        end
    end
end

-- Função para iniciar o fogo no tile
function Napalm.StartFireOnTile(tile)
    tile:Burn()
    local fire = IsoFireManager.StartFire(tile, true, 120)  -- Fogo inicial dura 120 segundos

    -- Inicia a propagação de fogo e dano
    Napalm.SpreadFire(tile)
    Napalm.ApplyNapalmDamage(tile)
end

-- Função que propaga o fogo nos tiles vizinhos com uma chance de 30%
function Napalm.SpreadFire(tile)
    local chanceToSpread = 0.3
    Events.EveryTenSeconds.Add(function()
        if ZombRand(100) / 100 < chanceToSpread then
            local neighbors = tile:getAdjacentSquares()
            for i = 0, neighbors:size() - 1 do
                local neighbor = neighbors:get(i)
                if neighbor and not neighbor:isBurning() then
                    neighbor:Burn()  -- Começa fogo nos vizinhos
                    IsoFireManager.StartFire(neighbor, true, 120)
                end
            end
        end
    end)
end

-- Função que aplica dano no tile
function Napalm.ApplyNapalmDamage(tile)
    -- Implementação da função de aplicar dano
end

-- Vincula o efeito de explosão ao uso do item
Events.OnWeaponHit.Add(function(weapon, square)
    if weapon:getType() == "NapalmCaseiro" then
        Napalm.ExplodeNapalm(square)  -- Chama a função de explosão
    end
end)
