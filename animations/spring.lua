led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    num_dots = 10
    local max_initial_offset = math.floor(led_count/3)

    colors = {string.char(0, 0, 255), string.char(255, 0, 0), string.char(0, 255, 0), string.char(0, 255, 255), string.char(255, 0, 255), string.char(255, 255, 0)}

    dots = {}
    
    for i = 1, num_dots do
        table.insert(dots, {
            ["color"] = colors[math.random(#colors)]:rep(3),
            ["tension"] = 0.005 + 0.002*(i/2),
            ["dampening"] = 0.025,
            ["velocity"] = (4 * math.random())-2,
            ["expected"] = led_count / (num_dots+2),
            ["height"] = 3
        })
    end
end

same_count = 0
function springs()
    for i = 1, #dots do
        local current_dot = dots[i];
        local x = current_dot["height"] - current_dot["expected"];
        local acceleration = -current_dot["tension"] * x - current_dot["velocity"]*dots[i]["dampening"];
        current_dot["height"] = current_dot["height"] + current_dot["velocity"];
        current_dot["velocity"] = current_dot["velocity"] + acceleration
    end
    
    
    if (dots[num_dots/2]["height"] - dots[num_dots/2]["expected"]) < 0.2 then
        same_count = same_count + 1
    else
        same_count = 0
    end

    if same_count > 50 then
        for i=1, #dots do
            dots[i]["height"] = 3
        end
        same_count = 0
    end
    
    buffer = ""
    for i = 1, #dots do
        local current_dot = dots[i];
        buffer = buffer .. string.char(0, 0, 0):rep(current_dot["height"])
        buffer = buffer .. current_dot["color"];
    end
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - buffer:len())
    return buffer
end

function frame()
    return springs()
end
