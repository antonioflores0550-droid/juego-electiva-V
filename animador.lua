local Animador = {}

function Animador.nueva(columnas, filas, tiempoFrame)
    local obj = {tiras = {}, actualTira = 1, actualFrame = 1, timer = 0, tiempo = tiempoFrame or 0.1, cols = columnas, filas = filas}

    function obj:agregarTira(ruta)
        local img = love.graphics.newImage(ruta)
        local fw, fh = img:getWidth() / obj.cols, img:getHeight() / obj.filas
        local quads = {}
        for f = 0, obj.filas - 1 do
            for c = 0, obj.cols - 1 do
                table.insert(quads, love.graphics.newQuad(c * fw, f * fh, fw, fh, img:getDimensions()))
            end
        end
        table.insert(obj.tiras, {img = img, quads = quads})
    end

    function obj:update(dt, mov, tira)
        obj.actualTira = tira or obj.actualTira
        if mov then
            obj.timer = obj.timer + dt
            if obj.timer >= obj.tiempo then
                obj.timer, obj.actualFrame = 0, (obj.actualFrame % #obj.tiras[obj.actualTira].quads) + 1
            end
        else obj.actualFrame = 1 end
    end

    function obj:draw(x, y)
        local t = obj.tiras[obj.actualTira]
        if t then love.graphics.draw(t.img, t.quads[obj.actualFrame], x, y) end
    end
    return obj
end

return Animador
