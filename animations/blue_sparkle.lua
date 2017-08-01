function init_animation(_buffer)
    buffer = _buffer
    colors = {{255, 255, 255}, {0, 0, 255}, {170, 86, 255}, {179, 17, 255}}
    buffer:fill(0, 0, 0)
    counter = 0
end

function frame()
    if counter > 100 then counter = 0 end
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
