led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    values = {}
    current_r = 255
    current_g = 0
    current_b = 0
    stepsize = 10
end

function ensure_within_bounds(value)
    if value < 0 then value = 0 end
    if value > 255 then value = 255 end
    return value
end

function rainbow(offset)
    buffer = ""
    
    if (current_r == 255 and current_g == 0 and current_b < 255) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_b = current_b + stepsize
        current_b = ensure_within_bounds(current_b)
    end

    if (current_r > 0 and current_g == 0 and current_b == 255) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_r = current_r - stepsize
        current_r = ensure_within_bounds(current_r)
    end

    if (current_r == 0 and current_g < 255 and current_b == 255) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_g = current_g + stepsize
        current_g = ensure_within_bounds(current_g)
    end

    if (current_r == 0 and current_g == 255 and current_b > 0) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_b = current_b - stepsize
        current_b = ensure_within_bounds(current_b)
    end

    if (current_r < 255 and current_g == 255 and current_b == 0) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_r = current_r + stepsize
        current_r = ensure_within_bounds(current_r)
    end

    if (current_r == 255 and current_g > 0 and current_b == 0) then
        buffer = string.char(current_r, current_g, current_b):rep(led_count)
        current_g = current_g - stepsize
        current_g = ensure_within_bounds(current_g)
    end

    return buffer
end

function frame(offset)
    return rainbow(offset)
end
