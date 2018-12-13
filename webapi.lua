httpServer:use('/up', function(req, res)
    res:type('application/json')      
    if not motorsRunning then
        position = settings:get_position()
        if position ~= DIR_UP then
            res:send('{"status": "success", "msg": "Motors started"}')
            motors:rotateUp()
        else
            res:send('{"status": "error", "msg": "Position is already up"}')
        end        
    else
        res:send('{"status": "error", "msg": "Motors already running"}')
    end    
end)

httpServer:use('/down', function(req, res)
    res:type('application/json')      
    if not motorsRunning then
        position = settings:get_position()
        if position ~= DIR_DOWN then
            res:send('{"status": "success", "msg": "Motors started"}')
            motors:rotateDown()
        else
            res:send('{"status": "error", "msg": "Position is already down"}') 
        end
    else
        res:send('{"status": "error", "msg": "Motors already running"}')
    end    
end)

httpServer:use('/stop', function(req, res)
    res:type('application/json')
    res:send('{"status": "success"}')
    motors:stop()
end)

httpServer:use('/status', function(req, res)
    res:type('application/json')
    position = settings:get_position()
    res:send('{"status": "success","position":"' .. position .. '"}')    
end)

httpServer:use('/position', function(req, res)
    res:type('application/json')
    if req.query["direction"] == DIR_UP or req.query["direction"] == DIR_DOWN then
        settings:set_position(req.query["direction"])
    else
        res:send('{"status": "error", "msg":"Position should be up or down"}')
    end
    res:send('{"status": "success"}')    
end)

httpServer:use('/tasks', function(req, res)
    res:type('application/json')
    scheduledUp = settings:get_schedule(DIR_UP)
    scheduledDown = settings:get_schedule(DIR_DOWN)
    message = '{"status": "success", "up": "'.. scheduledUp .. '", "down": "' .. 
        scheduledDown .. '"}'
    res:send(message)
end)

httpServer:use('/schedule', function(req, res)
    res:type('application/json')
    if req.query["direction"] == DIR_UP or req.query["direction"] == DIR_DOWN then
        timeParam = req.query["time"]
        if timeParam ~= nil and tonumber(timeParam) ~= nil then
            time = tonumber(timeParam)
            if time > 1543198344 then
                sec, usec, rate = rtctime.get()    
                while time < sec do
                    time = time + 86400
                end                
                settings:set_schedule(req.query["direction"], time)            
                res:send('{"status": "success", "msg":"Schedule was set"}')
            else
                res:send('{"status": "error", "msg":"Time should be linux epoch seconds"}')    
            end            
        else 
            res:send('{"status": "error", "msg":"Incorrect time"}')
        end
    else
        res:send('{"status": "error", "msg":"Schedule should have direction"}')
    end
    res:send('{"status": "success"}')    
end)

httpServer:use('/settings', function(req, res)
    res:type('application/json')
    if req.query["motor"] == MOTOR_LEFT or req.query["motor"] == MOTOR_RIGHT then
        if req.query["direction"] == DIR_UP or req.query["direction"] == DIR_DOWN then
            motor = req.query["motor"]
            direction = req.query["direction"]
            time = req.query["time"]
            if time ~= nil and tonumber(time) ~= nil then
                settings:save_timeout(motor, direction, time)
                res:send('{"status": "success", "msg":"Timeout saved"}')
            else 
                res:send('{"status": "error", "msg":"Incorrect time"}')
            end
        else
            res:send('{"status": "error", "msg":"Direction is not up or down"}')
        end        
    else
		timeoutDownLeft = settings:get_timeout(MOTOR_LEFT, DIR_DOWN)
		timeoutDownRight = settings:get_timeout(MOTOR_RIGHT, DIR_DOWN)
		timeoutUpLeft = settings:get_timeout(MOTOR_LEFT, DIR_UP)
		timeoutUpRight = settings:get_timeout(MOTOR_RIGHT, DIR_UP)
		message = '{"status": "success", "downLeft": ' .. timeoutDownLeft .. ', "downRight": ' .. timeoutDownRight .. ', "upLeft": ' .. timeoutUpLeft .. ', "upRight": ' .. timeoutUpRight .. '}'
        res:send(message)
    end    
end)
