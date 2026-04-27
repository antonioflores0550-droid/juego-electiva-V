local Animador = require("animador")

local sonidoActivo = true

function love.load()

    imgFondo = love.graphics.newImage("fondo.png")
    musica = love.audio.newSource("musica.mp3", "stream")
    if musica then musica:setLooping(true); musica:play() end

    
    p1_anim = Animador.nueva(4, 2, 0.1)
    p1_anim:agregarTira("minero1.png") 
    p1_anim:agregarTira("IMG-20260426-WA0066(1).png")

    p2_anim = Animador.nueva(4, 2, 0.1)
    p2_anim:agregarTira("minero2.png")
    p2_anim:agregarTira("IMG-20260426-WA0064(1).png")

    oro_anim = Animador.nueva(8, 1, 0.08)
    oro_anim:agregarTira("oro.png")


    p1 = { x = 100, y = 300, score = 0, speed = 300, tira = 1, w = 45, h = 45 }
    p2 = { x = 650, y = 300, score = 0, speed = 300, tira = 1, w = 45, h = 45 }
    oro = { x = 400, y = 300, w = 32, h = 32 }
    gameTimer = 60
    isGameOver = false

    shaderTransparencia = love.graphics.newShader[[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            vec4 pixel = Texel(texture, texture_coords);
            if ((pixel.r + pixel.g + pixel.b) < 0.1) { discard; }
            return pixel * color;
        }
    ]]
end

function love.update(dt)
    if gameTimer > 0 then
        gameTimer = gameTimer - dt
    else
        gameTimer = 0
        isGameOver = true
    end

    local movP1, movP2 = false, false

    if not isGameOver then

        local limite_izq = 40
        local limite_der = 720
        local limite_sup = 180 
        local limite_inf = 520


        if love.keyboard.isDown("d") and p1.x < limite_der then p1.x = p1.x + p1.speed*dt; p1.tira = 1; movP1 = true end
        if love.keyboard.isDown("a") and p1.x > limite_izq then p1.x = p1.x - p1.speed*dt; p1.tira = 2; movP1 = true end
        if love.keyboard.isDown("w") and p1.y > limite_sup then p1.y = p1.y - p1.speed*dt; movP1 = true end
        if love.keyboard.isDown("s") and p1.y < limite_inf then p1.y = p1.y + p1.speed*dt; movP1 = true end


        if love.keyboard.isDown("right") and p2.x < limite_der then p2.x = p2.x + p2.speed*dt; p2.tira = 1; movP2 = true end
        if love.keyboard.isDown("left") and p2.x > limite_izq then p2.x = p2.x - p2.speed*dt; p2.tira = 2; movP2 = true end
        if love.keyboard.isDown("up") and p2.y > limite_sup then p2.y = p2.y - p2.speed*dt; movP2 = true end
        if love.keyboard.isDown("down") and p2.y < limite_inf then p2.y = p2.y + p2.speed*dt; movP2 = true end

        if checkCollision(p1, oro) then p1.score = p1.score + 1; respawnOro(limite_izq, limite_der, limite_sup, limite_inf) end
        if checkCollision(p2, oro) then p2.score = p2.score + 1; respawnOro(limite_izq, limite_der, limite_sup, limite_inf) end
    end

    p1_anim:update(dt, movP1, p1.tira)
    p2_anim:update(dt, movP2, p2.tira)
    oro_anim:update(dt, true, 1)
end

function checkCollision(a, b)
    return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end

function respawnOro(minX, maxX, minY, maxY)
    oro.x = math.random(minX, maxX)
    oro.y = math.random(minY, maxY)
end

function love.draw()

    love.graphics.clear(0, 0, 0)

    love.graphics.setColor(1, 1, 1) 


    if imgFondo then
        love.graphics.draw(imgFondo, 0, 0, 0, 800/imgFondo:getWidth(), 600/imgFondo:getHeight())
    end

    love.graphics.setShader(shaderTransparencia)
        p1_anim:draw(p1.x, p1.y)
        p2_anim:draw(p2.x, p2.y)
        oro_anim:draw(oro.x, oro.y)
    love.graphics.setShader()

    love.graphics.print("P1: "..p1.score, 20, 20, 0, 1.5)
    love.graphics.print("P2: "..p2.score, 720, 20, 0, 1.5)
    love.graphics.printf("TIEMPO: "..math.ceil(gameTimer), 0, 20, 800, "center", 0, 1.5)

    if isGameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("¡TIEMPO AGOTADO!\n'R' Reiniciar | 'M' Sonido", 0, 280, 800, "center", 0, 2)
    end
end

function love.keypressed(k)
    if k == "r" then love.event.quit("restart") end
    if k == "m" then
        sonidoActivo = not sonidoActivo
        love.audio.setVolume(sonidoActivo and 1 or 0)
    end
end
