led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    colors = { string.char(0, 0, 255):rep(3), string.char(255, 0, 255):rep(3), string.char(255, 0, 0):rep(3) }
    dots = {}
end

function dots_by_height(dots)
    local copy = {}
    for orig_key, orig_value in pairs(dots) do
        copy[orig_key] = orig_value
    end

    table.sort(copy, function(a, b)
        return(a["height"] < b["height"])
    end)

    return copy
end


function fountain()
    if math.random() < (1/10) then
        table.insert(dots, {
            ["color"] = colors[math.random(#colors)],
            ["height"] = 0,
            ["velocity"] = led_count/2 * math.random()
            })
    end
    
    for i = 1, #dots do
        local current_dot = dots[i];
        local acceleration = -(1/2)
        current_dot["height"] = current_dot["height"] + current_dot["velocity"];
        current_dot["velocity"] = current_dot["velocity"] + acceleration
        if current_dot["height"] < 0 then
            table.remove(dots, i)
        end 
    end
    
    sorted_dots = dots_by_height(dots)
    
    end_of_last_dot = 0
    buffer = ""
    for i = 1, #dots do
        local current_dot = sorted_dots[i];
        buffer = buffer .. string.char(0, 0, 0):rep(current_dot["height"] - end_of_last_dot)
        buffer = buffer .. current_dot["color"];
        end_of_last_dot = current_dot["height"] + 9
    end
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - (end_of_last_dot + 9))
    return buffer
end

function frame()
    return fountain()
end
