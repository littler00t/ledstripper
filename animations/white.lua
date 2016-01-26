led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    
    allwhite = string.char(255, 255, 255):rep(led_count)
end

function white()
    return allwhite
end

function frame(offset)
    return white()
end
