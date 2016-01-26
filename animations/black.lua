led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    
    allblack = string.char(0, 0, 0):rep(led_count)
end

function black()
    return allblack
end

function frame(offset)
    return black()
end
