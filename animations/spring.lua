led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    dots = { string.char(0, 0, 255):rep(3), string.char(0, 255, 255):rep(3), string.char(255, 0, 0):rep(3), string.char(0, 255, 0):rep(3) }
    
    tension = { 0.025, 0.015, 0.03, 0.025 }
    dampening = { 0.04, 0.06, 0.02, 0.06 }
    velocity = { 1.5, -1.0, 0.6, -0.5 }
    expected = { math.floor(led_count/2), math.floor(led_count/4), 3*(math.floor(led_count/4)), 10 }
    initial_offset = math.floor(led_count/3)
    height = {}
    for i = 1, #dots do
        height[i] = expected[i] + math.random() * initial_offset
    end
end

function copy_table(orig)
    copy = {}
    for orig_key, orig_value in pairs(orig) do
        copy[orig_key] = orig_value
    end
    return copy
end

function springs()
    for i = 1, #velocity do
        local x = height[i] - expected[i]
        local acceleration = -tension[i] * x - velocity[i]*dampening[i]
        height[i] = height[i] + velocity[i]
        velocity[i] = velocity[i] + acceleration
    end
    
    sorted_heights = copy_table(height)
    table.sort(sorted_heights)
    
    end_of_last_dot = 0
    buffer = ""
    for i = 1, #sorted_heights do
        buffer = buffer .. string.char(0, 0, 0):rep(sorted_heights[i] - end_of_last_dot)
        buffer = buffer .. dots[i]
        end_of_last_dot = sorted_heights[i] + 9
    end
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - (end_of_last_dot + 9))
    return buffer
end

function frame(offset)
    return springs()
end