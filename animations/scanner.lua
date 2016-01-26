led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    color = {0,255,0}
    spread = 3
    direction = 1
    position = 1
    
    dot = ""
    for i = spread,1 do
        r = math.floor(color[1] * ((spread + 1 - i) / (spread + 1)))
        g = math.floor(color[2] * ((spread + 1 - i) / (spread + 1)))
        b = math.floor(color[3] * ((spread + 1 - i) / (spread + 1)))
        dot = dot .. string.char(r, g, b)
    end
    dot = dot .. string.char(color[1], color[2], color[3])
    for i = 1,spread do
        r = math.floor(color[1] * ((spread + 1 - i) / (spread + 1)))
        g = math.floor(color[2] * ((spread + 1 - i) / (spread + 1)))
        b = math.floor(color[3] * ((spread + 1 - i) / (spread + 1)))
        dot = dot .. string.char(r, g, b)
    end
    dotwidth = (2 * spread) + 1
end

function scanner()
    startofdot = position - spread
    buffer = string.char(0, 0, 0):rep(startofdot)
    
    position = position + direction;

    if (position > led_count) then
        position = position - 2
        direction = -1
    end
    
    if (position < 1) then
        position = position + 2
        direction = 1
    end
    
    buffer = buffer .. dot
    
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - (startofdot + dotwidth))
    return buffer
end

function frame(offset)
    return scanner()
end
