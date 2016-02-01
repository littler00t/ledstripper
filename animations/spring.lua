led_count = 0
function init_animation(_led_count)
    led_count = _led_count
    num_dots = 4
    local max_initial_offset = math.floor(led_count/3)
    dots = {
        {
            ["color"] = string.char(0, 0, 255):rep(3),
            ["tension"] = 0.025,
            ["dampening"] = 0.04,
            ["velocity"] = (4 * math.random())-2,
            ["expected"] = led_count / (num_dots+1),
            ["height"] = led_count / (num_dots+1)
        },
        {
            ["color"] = string.char(0, 255, 255):rep(3),
            ["tension"] = 0.015,
            ["dampening"] = 0.06,
            ["velocity"] = (4 * math.random())-2,
            ["expected"] = led_count / (num_dots+1)*2,
            ["height"] = led_count / (num_dots+1)*2
        },
        {
            ["color"] = string.char(255, 0, 0):rep(3),
            ["tension"] = 0.003,
            ["dampening"] = 0.02,
            ["velocity"] = (4 * math.random())-2,
            ["expected"] = led_count / (num_dots+1)*3,
            ["height"] = led_count / (num_dots+1)*3
        },
        {
            ["color"] = string.char(0, 255, 0):rep(3),
            ["tension"] = 0.025,
            ["dampening"] = 0.06,
            ["velocity"] = (4 * math.random())-2,
            ["expected"] = led_count / (num_dots+1)*4,
            ["height"] = led_count / (num_dots+1)*4
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
    
    count_velocity_too_low = 0
    for i = 1, #dots do
        if math.abs(dots[i]["velocity"]) < 0.1 then
            count_velocity_too_low = count_velocity_too_low + 1
        end
    end
    
    if count_velocity_too_low > (#dots/2) then
        print("too low for " .. count_velocity_too_low .. " dots. Resetting")
        for i = 1, #dots do
            dots[i]["velocity"] = (4 * math.random())-2
        end
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