local NUM_LEDS = 150
local TIME_ALARM = 50
local mqtt_topic = "/esp/1/"
local mqtt_client = nil
local buffer = nil
local brightness_buffer = nil
local brightness = 1
local options = {}

function show_frame()
    frame(options)
    adjust_brightness()
    ws2812.write(brightness_buffer)
end

function adjust_brightness()
    for i = 1, brightness_buffer:size() do
        g, r, b = buffer:get(i)
        g = brightness * g
        r = brightness * r
        b = brightness * b
        brightness_buffer:set(i, g, r, b)
    end
end

function log(message)
    print(message)
end

function trigger_frames()
    tmr.stop(2)
    tmr.alarm(2, TIME_ALARM, 1, show_frame)
end

function animate(animation)
    if pcall(dofile, animation .. ".lua") then
        tmr.stop(2)
        local status, err = pcall(init_animation, buffer) 
        if status then
            trigger_frames()
        else
            log("Init of animation " .. animation .. " failed: " .. err)
        end
    else
        log("Could not find animation: " .. animation)
    end
end

function store_file(serialized)
    lines = serialized:gmatch("[^\r\n]+")

    -- first line is the filename, the rest is the content
    file_name = lines()
    io.remove(file_name);
    file = io.open(file_name, "w+");
    for line in lines do
        file:write(line, "\n")
    end
    file:close()
end

function setup_mqtt()
    mqtt_client = mqtt.Client("esp_1", 120, "", "")

    topic = mqtt_topic

    mqtt_client:lwt("/esp/1/state", "offline", 0, 0)

    mqtt_client:on("connect", function(m)
        mqtt_client:publish( topic .. "state", "online", 0, 0)
        mqtt_client:publish( topic .. "num_lights", NUM_LEDS, 0, 0)
        mqtt_client:publish( topic .. "ip_address", wifi.sta.getip(), 0, 0)
        mqtt_client:subscribe( topic .. "command", 0)
        mqtt_client:subscribe( topic .. "num_lights", 0)
        mqtt_client:subscribe( topic .. "animations", 0)
        mqtt_client:subscribe( topic .. "speed", 0)
        mqtt_client:subscribe( topic .. "brightness", 0)
        mqtt_client:subscribe( topic .. "options", 0)
    end)

    mqtt_client:on("message", function(conn, current_topic, data)
        print("MESSAGE on " .. current_topic .. ":" )
        if (data ~= nil ) then
            print( data )
            if current_topic == (topic .. "command") then
                animate(data)
            elseif current_topic == (topic .. "num_lights") then
                NUM_LEDS = tonumber(data)
                trigger_frames()
            elseif current_topic == (topic .. "speed") then
                TIME_ALARM = tonumber(data)
                trigger_frames()
            elseif current_topic == (topic .. "animations") then
                local status, err = pcall(store_file, data)
                if not status then
                    log("Could not store file: " .. err)
                end
            elseif current_topic == (topic .. "brightness") then
                brightness = tonumber(data) / 100
            elseif current_topic == (topic .. "options") then
                log("Got option:" .. data)
                indexOfEquals = data:find("=")
                if indexOfEquals ~= nil then
                    key = data:sub(1, indexOfEquals - 1)
                    value = data:sub(indexOfEquals + 1)
                    options[key] = value
                    log("Found value '" .. value .. "' for key '" .. key .. "'")
                end
            end
        end
    end)

    mqtt_client:connect("house", 1883, 0)
end

function connect_wifi()
    if wifi.sta.getip() == nil then
        wifi.setmode(wifi.STATION)
        require("wifipassword")
        wifi.sta.config("Bob", get_wifi_password())
    end

    tmr.alarm(1, 2000, 1, function() 
        if wifi.sta.getip() == nil then 
            print("IP unavailable, Waiting...") 
        else
            tmr.stop(1)
            setup_mqtt()
            print("Config done, IP is " .. wifi.sta.getip())
        end
    end)
end

function setup_leds()
    ws2812.init()
    buffer = ws2812.newBuffer(NUM_LEDS, 3)
    brightness_buffer = ws2812.newBuffer(NUM_LEDS, 3)
    buffer:fill(0, 0, 0)
    ws2812.write(buffer)
end

connect_wifi()
setup_leds()
