function init_animation(_buffer)
    buffer = _buffer
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

function frame()
    if (current_r == 255 and current_g == 0 and current_b < 255) then
        buffer:fill(current_g, current_r, current_b)
        current_b = current_b + stepsize
        current_b = ensure_within_bounds(current_b)
    end

    if (current_r > 0 and current_g == 0 and current_b == 255) then
        buffer:fill(current_g, current_r, current_b)
        current_r = current_r - stepsize
        current_r = ensure_within_bounds(current_r)
    end

    if (current_r == 0 and current_g < 255 and current_b == 255) then
        buffer:fill(current_g, current_r, current_b)
        current_g = current_g + stepsize
        current_g = ensure_within_bounds(current_g)
    end

    if (current_r == 0 and current_g == 255 and current_b > 0) then
        buffer:fill(current_g, current_r, current_b)
        current_b = current_b - stepsize
        current_b = ensure_within_bounds(current_b)
    end

    if (current_r < 255 and current_g == 255 and current_b == 0) then
        buffer:fill(current_g, current_r, current_b)
        current_r = current_r + stepsize
        current_r = ensure_within_bounds(current_r)
    end

    if (current_r == 255 and current_g > 0 and current_b == 0) then
        buffer:fill(current_g, current_r, current_b)
        current_g = current_g - stepsize
        current_g = ensure_within_bounds(current_g)
    end
end
