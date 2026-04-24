function love.load()

    function safeLoad(archivo, tipo)
        local status, asset = pcall(function()
            if tipo == "image" then return love.graphics.newImage(archivo) end
            if tipo == "audio" then return love.audio.newSource(archivo, "stream") end
        end)
        return status and asset or nil
    end

    imgFondo = safeLoad("fondo.png", "image")
    imgP1    = safeLoad("minero1.jpg", "image")
    imgP2    = safeLoad("minero2.png", "image")
    imgOro   = safeLoad("oro.png", "image")
    
    musicaFondo = safeLoad("musica.mp3", "audio")
    if musicaFondo then
        musicaFondo:setLooping(true)
        musicaFondo:setVolume(0.5)
        musicaFondo:play()
    end

    p1 = { x = 100, y = 100, w = 45, h = 45, score = 0, speed = 300 }
    p2 = { x = 650, y = 450, w = 45, h = 45, score = 0, speed = 300 }
    
    oro = { x = 400, y = 300, w = 32, h = 32 }
    
    gameTimer = 60
    isGameOver = false
end

function love.update(dt)
    if isGameOver then return end

    gameTimer = gameTimer - dt
    if gameTimer <= 0 then isGameOver = true end

    if love.keyboard.isDown("w") and p1.y > 0 then p1.y = p1.y - p1.speed * dt end
    if love.keyboard.isDown("s") and p1.y < 555 then p1.y = p1.y + p1.speed * dt end
    if love.keyboard.isDown("a") and p1.x > 0 then p1.x = p1.x - p1.speed * dt end
    if love.keyboard.isDown("d") and p1.x < 755 then p1.x = p1.x + p1.speed * dt end

    if love.keyboard.isDown("up") and p2.y > 0 then p2.y = p2.y - p2.speed * dt end
    if love.keyboard.isDown("down") and p2.y < 555 then p2.y = p2.y + p2.speed * dt end
    if love.keyboard.isDown("left") and p2.x > 0 then p2.x = p2.x - p2.speed * dt end
    if love.keyboard.isDown("right") and p2.x < 755 then p2.x = p2.x + p2.speed * dt end

    if checkCollision(p1, oro) then
        p1.score = p1.score + 1
        respawnOro()
    elseif checkCollision(p2, oro) then
        p2.score = p2.score + 1
        respawnOro()
    end
end

function checkCollision(p, o)
    return p.x < o.x + o.w and p.x + p.w > o.x and p.y < o.y + o.h and p.y + p.h > o.y
end

function respawnOro()
    oro.x = math.random(50, 750)
    oro.y = math.random(50, 550)
end

function love.draw()
    love.graphics.setColor(1, 1, 1) -- Reset de color
    if imgFondo then
        love.graphics.draw(imgFondo, 0, 0, 0, 800/imgFondo:getWidth(), 600/imgFondo:getHeight())
    else
        love.graphics.clear(0.2, 0.3, 0.2) -- Verde oscuro si falla
    end

    if imgP1 then
        love.graphics.draw(imgP1, p1.x, p1.y)
    else
        love.graphics.setColor(0, 0.4, 1)
        love.graphics.rectangle("fill", p1.x, p1.y, p1.w, p1.h)
    end

    love.graphics.setColor(1, 1, 1)
    if imgP2 then
        love.graphics.draw(imgP2, p2.x, p2.y)
    else
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.rectangle("fill", p2.x, p2.y, p2.w, p2.h)
    end

    love.graphics.setColor(1, 1, 1)
    if imgOro then
        love.graphics.draw(imgOro, oro.x, oro.y)
    else
        love.graphics.setColor(1, 0.9, 0)
        love.graphics.circle("fill", oro.x + 16, oro.y + 16, 16)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("P1: " .. p1.score, 30, 20, 0, 1.5, 1.5)
    love.graphics.print("P2: " .. p2.score, 700, 20, 0, 1.5, 1.5)
    love.graphics.printf("TIEMPO: " .. math.ceil(gameTimer), 0, 20, 800, "center", 0, 1.5, 1.5)

    if isGameOver then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("FIN DEL JUEGO\nPresiona 'R' para reiniciar", 0, 280, 800, "center", 0, 2, 2)
    end
end

function love.keypressed(key)
    if key == "r" then love.event.quit("restart") end
end
