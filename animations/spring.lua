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
            ["expected"] = led_count / (num_dots+1),
            ["height"] = 3
        })
    end
end

function springs()
    for i = 1, #dots do
        local x = dots[i]["height"] - dots[i]["expected"]
        local acceleration = -dots[i]["tension"] * x - dots[i]["velocity"]*dots[i]["dampening"]
        dots[i]["height"] = dots[i]["height"] + dots[i]["velocity"]
        dots[i]["velocity"] = dots[i]["velocity"] + acceleration
    end
    
    count_velocity_too_low = 0
    for i = 1, #dots do
        if math.abs(dots[i]["velocity"]) < 0.1 then
            count_velocity_too_low = count_velocity_too_low + 1
        end
    end
    
    if count_velocity_too_low > (#dots/2) then
        print("too low for " .. count_velocity_too_low .. " dots. Resetting")
        for i = 1, #dots do
            dots[i]["height"] = 3
        end
    end
    
    buffer = ""
    for i = 1, #dots do
        local current_dot = dots[i]
        buffer = buffer .. string.char(0, 0, 0):rep(current_dot["height"])
        buffer = buffer .. current_dot["color"]
    end
    buffer = buffer .. string.char(0, 0, 0):rep(led_count - buffer:len())
    return buffer
end

function frame(offset)
    return springs()
end