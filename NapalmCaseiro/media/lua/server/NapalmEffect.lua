-- Obtém as bibliotecas necessárias
local IsoFireManager = require "IsoFireManager"         -- Para gerenciar o fogo
local Events = require "Events"                         -- Para usar eventos do jogo
local ZombRand = require "ZombRand"                     -- Para gerar números aleatórios
local getCell = require "Cell"                          -- Para obter informações sobre as células do mapa
local IsoParticleManager = require "IsoParticleManager" -- Para criar efeitos de partículas
IsoParticleManager = IsoParticleManager.getInstance()
local getWorld = require "World"                        -- Para obter informações sobre o mundo do jogo

-- Define a tabela Napalm para armazenar as funções do mod
Napalm = {}

-- Função que causa a explosão do Napalm
function Napalm.ExplodeNapalm(square)
    -- Define o raio da explosão em tiles
    local radius = 3
    -- Itera sobre os tiles dentro do raio da explosão
    for x = -radius, radius do
        for y = -radius, radius do
            -- Obtém o tile na posição (x, y) em relação ao centro da explosão
            local tile = getCell():getGridSquare(square:getX() + x, square:getY() + y, square:getZ())
            if tile then
                -- Inicia o fogo no tile
                Napalm.StartFireOnTile(tile)
            end
        end
    end
end

-- Função que inicia o fogo em um tile
function Napalm.StartFireOnTile(tile)
    -- Inicia o fogo no tile
    tile:Burn()

    -- Define a duração base do fogo em segundos (10 minutos)
    local fireDuration = 600

    -- Ajusta a duração do fogo com base na intensidade do vento
    local windIntensity = getWorld():getWindIntensity()
    fireDuration = fireDuration * (1 + windIntensity)

    -- Ajusta a duração do fogo com base na chuva
    if getWorld():isRaining() then
        fireDuration = fireDuration * 0.5
    end

    -- Inicia o fogo no tile usando o IsoFireManager
    local fire = IsoFireManager.StartFire(tile, true, fireDuration)

    -- Propaga o fogo para os tiles vizinhos
    Napalm.SpreadFire(tile)
    -- Aplica dano aos jogadores e zumbis no tile
    Napalm.ApplyNapalmDamage(tile)

    -- Aplica dano contínuo a cada 10 segundos enquanto o fogo estiver ativo
    Events.EveryTenSeconds.Add(function()
        if tile:isBurning() then
            Napalm.ApplyNapalmDamage(tile)
        end
    end)
end

-- Função que propaga o fogo para os tiles vizinhos
function Napalm.SpreadFire(tile)
    -- Define a chance de propagação do fogo
    local chanceToSpread = 0.3
    -- Adiciona um evento que ocorre a cada 10 segundos
    Events.EveryTenSeconds.Add(function()
        -- Verifica se o fogo deve se propagar com base na chance definida
        if ZombRand(100) / 100 < chanceToSpread then
            -- Obtém os tiles vizinhos ao tile atual
            local neighbors = tile:getAdjacentSquares()
            -- Itera sobre os tiles vizinhos
            for i = 0, neighbors:size() - 1 do
                local neighbor = neighbors:get(i)
                -- Verifica se o tile vizinho é válido e se não está em chamas
                if neighbor and not neighbor:isBurning() then
                    -- Inicia o fogo no tile vizinho
                    neighbor:Burn()
                    IsoFireManager.StartFire(neighbor, true, 120)
                end
            end
        end
    end)
end

-- Função que aplica dano aos jogadores e zumbis no tile
function Napalm.ApplyNapalmDamage(tile)
    -- Obtém os jogadores no tile
    local players = tile:getPlayers()
    -- Itera sobre os jogadores
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        -- Verifica se o jogador é válido e se não está usando uma máscara de gás
        if player and not Napalm.IsPlayerWearingGasMask(player) then
            -- Aplica dano de fogo ao jogador
            player:getBodyDamage():AddDamage("Fire", 20)
        end
    end

    -- Obtém os zumbis no tile
    local zombies = tile:getZombies()
    -- Itera sobre os zumbis
    for i = 0, zombies:size() - 1 do
        local zombie = zombies:get(i)
        -- Verifica se o zumbi é válido
        if zombie then
            -- Aplica dano de fogo ao zumbi
            zombie:getBodyDamage():AddDamage("Fire", 40)
        end
    end
end

-- Função que cria a fumaça tóxica
function Napalm.CreateToxicSmoke(square)
    -- Cria o efeito visual da fumaça
    local particle = IsoParticleManager:AddParticle("Smoke", square:getX(), square:getY(), square:getZ())
    particle:setScale(2.0)                -- Ajusta o tamanho da fumaça
    particle:setColor(0.5, 0.5, 0.5, 1.0) -- Ajusta a cor da fumaça

    -- Define o tempo de duração da fumaça
    local smokeTimer = 0
    -- Adiciona um evento que ocorre a cada 10 segundos
    Events.EveryTenSeconds.Add(function()
        -- Incrementa o tempo de duração da fumaça
        smokeTimer = smokeTimer + 10

        -- Verifica se a fumaça ainda deve estar ativa
        if smokeTimer <= 60 then
            -- Obtém os jogadores no tile
            local players = square:getPlayers()
            -- Itera sobre os jogadores
            for i = 0, players:size() - 1 do
                local player = players:get(i)
                -- Verifica se o jogador é válido e se não está usando uma máscara de gás
                if player and not Napalm.IsPlayerWearingGasMask(player) then
                    -- Aplica dano tóxico ao jogador
                    player:getBodyDamage():AddDamage("Toxic", 5)
                end
            end

            -- Obtém os zumbis no tile
            local zombies = square:getZombies()
            -- Itera sobre os zumbis
            for i = 0, zombies:size() - 1 do
                local zombie = zombies:get(i)
                -- Verifica se o zumbi é válido
                if zombie then
                    -- Aplica dano tóxico ao zumbi
                    zombie:getBodyDamage():AddDamage("Toxic", 10)
                end
            end
        else
            -- Remove a fumaça após a duração
            IsoParticleManager:RemoveParticle(particle)
            -- Remove o evento para parar de aplicar dano
            Events.EveryTenSeconds.Remove(Napalm.CreateToxicSmoke)
        end
    end)
end

-- Função que verifica se o jogador está usando uma máscara de gás
function Napalm.IsPlayerWearingGasMask(player)
    -- Obtém o inventário do jogador
    local inventory = player:getInventory()
    -- Verifica se o jogador tem uma máscara de gás no inventário
    local gasMask = inventory:getItemFromType("Base.GasMask")
    -- Retorna true se o jogador tiver a máscara, false caso contrário
    if gasMask then
        return true
    else
        return false
    end
end

-- Adiciona um evento que ocorre quando uma arma atinge um tile
Events.OnWeaponHit.Add(function(weapon, square)
    -- Verifica se a arma é do tipo "NapalmCaseiro"
    if weapon:getType() == "NapalmCaseiro" then
        -- Causa a explosão do Napalm
        Napalm.ExplodeNapalm(square)
    end
end)
