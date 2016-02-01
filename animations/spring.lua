led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    local max_initial_offset = math.floor(led_count/3)
    dots = {
        {
            ["color"] = string.char(0, 0, 255):rep(3),
            ["tension"] = 0.025,
            ["dampening"] = 0.04,
            ["velocity"] = 1.5,
            ["expected"] = math.floor(led_count/2),
            ["height"] = math.floor(led_count/2) + math.random() * max_initial_offset
        },
        {
            ["color"] = string.char(0, 255, 255):rep(3),
            ["tension"] = 0.015,
            ["dampening"] = 0.06,
            ["velocity"] = -1.0,
            ["expected"] = math.floor(led_count/4),
            ["height"] = math.floor(led_count/4) + math.random() * max_initial_offset
        },
        {
            ["color"] = string.char(255, 0, 0):rep(3),
            ["tension"] = 0.003,
            ["dampening"] = 0.02,
            ["velocity"] = 0.6,
            ["expected"] = math.floor(led_count/4)*3,
            ["height"] = math.floor(led_count/4)*3 + math.random() * max_initial_offset
        },
        {
            ["color"] = string.char(0, 255, 0):rep(3),
            ["tension"] = 0.025,
            ["dampening"] = 0.06,
            ["velocity"] = -0.5,
            ["expected"] = 10,
            ["height"] = 10 + math.random() * max_initial_offset
        }
    }
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


function springs()
    for i = 1, #dots do
        local x = dots[i]["height"] - dots[i]["expected"]
        local acceleration = -dots[i]["tension"] * x - dots[i]["velocity"]*dots[i]["dampening"]
        dots[i]["height"] = dots[i]["height"] + dots[i]["velocity"]
        dots[i]["velocity"] = dots[i]["velocity"] + acceleration
    end
    
    sorted_dots = dots_by_height(dots)
    
    end_of_last_dot = 0
    buffer = ""
    for i = 1, #dots do
        local current_dot = sorted_dots[i]
        buffer = buffer .. string.char(0, 0, 0):rep(current_dot["height"] - end_of_last_dot)
        buffer = buffer .. current_dot["color"]
        end_of_last_dot = current_dot["height"] + 9
    end
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - (end_of_last_dot + 9))
    return buffer
end

function frame(offset)
    return springs()
end