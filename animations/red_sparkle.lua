function init_animation(_buffer)
    buffer = _buffer
    colors = {{255, 255, 255}, {0, 255, 0}, {52, 224, 52}}
    buffer:fill(0, 0, 0)
    counter = 0
end

function frame()
    counter = counter + 1
    if (counter % 2 == 0) then
        buffer:fade(2)
        for i = 1,buffer:size()/30 do
            if (math.random(100) > 20) then
                color = colors[math.random(#colors)]
                buffer:set(math.random(buffer:size()), color)
            end
        end
    end
end
