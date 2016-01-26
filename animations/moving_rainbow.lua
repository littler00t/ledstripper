led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    current_r = 255
    current_g = 0
    current_b = 0
    stepsize = math.ceil((256*6)/led_count)

    buffer = ""
    for i=0,led_count do
        if (current_r == 255 and current_g == 0 and current_b < 255) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_b = current_b + stepsize
            current_b = ensure_within_bounds(current_b)
        elseif (current_r > 0 and current_g == 0 and current_b == 255) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_r = current_r - stepsize
            current_r = ensure_within_bounds(current_r)
        elseif (current_r == 0 and current_g < 255 and current_b == 255) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_g = current_g + stepsize
            current_g = ensure_within_bounds(current_g)
        elseif (current_r == 0 and current_g == 255 and current_b > 0) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_b = current_b - stepsize
            current_b = ensure_within_bounds(current_b)
        elseif (current_r < 255 and current_g == 255 and current_b == 0) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_r = current_r + stepsize
            current_r = ensure_within_bounds(current_r)
        elseif (current_r == 255 and current_g > 0 and current_b == 0) then
            buffer = buffer .. string.char(current_r, current_g, current_b)
            current_g = current_g - stepsize
            current_g = ensure_within_bounds(current_g)
        end
    end
    used_offset = 142
end

function ensure_within_bounds(value)
    if value < 0 then value = 0 end
    if value > 255 then value = 255 end
    return value
end

function moving_rainbow(offset)
    current_start = used_offset * 3
    curval = buffer:sub(current_start) .. buffer:sub(0, current_start - 1)
    used_offset = ((used_offset + 1) % (led_count)) + 1
    return curval
end

function frame(offset)
    return moving_rainbow(offset)
end
