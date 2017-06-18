function init_animation(_buffer)
    color = {0, 255, 0}
    spread = 3
    direction = 1
    position = spread
    
    buffer = _buffer
    buffer:fill(0, 0, 0)
    
    j = 1
    for i = spread,1,-1 do
        r = math.floor(color[1] * ((spread + 1 - i) / (spread + 1)))
        g = math.floor(color[2] * ((spread + 1 - i) / (spread + 1)))
        b = math.floor(color[3] * ((spread + 1 - i) / (spread + 1)))
        buffer:set(j, r, g, b)
        j = j+1
    end
    buffer:set(j, color[1], color[2], color[3])
    for i = 1,spread do
        r = math.floor(color[1] * ((spread + 1 - i) / (spread + 1)))
        g = math.floor(color[2] * ((spread + 1 - i) / (spread + 1)))
        b = math.floor(color[3] * ((spread + 1 - i) / (spread + 1)))
        buffer:set(j, r, g, b)
        j = j+1
    end
end

function scanner()
    position = position + direction;

    if (position > (buffer:size() - spread)) then
        direction = -1
    end

    if (position < (1 + spread)) then
        direction = 1
    end

    buffer:shift(direction)
end

function frame()
    scanner()
end
