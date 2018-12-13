scheduler = {    
}

lastSync = -1

function scheduler:start()    
    print("Scheduler start")
    tmr.create():alarm(10000, tmr.ALARM_SINGLE, sync)
    tmr.create():alarm(60000, tmr.ALARM_AUTO, periodicalCheck)
end

function periodicalCheck()
    sec, usec, rate = rtctime.get()
    if (sec > 0) then
        scheduler:check(DIR_UP) 
        scheduler:check(DIR_DOWN)             
    end
    now = tmr.time()
    elapsed = now - lastSync
    if lastSync < 0 or elapsed > 3600 then
        print("Last SNTP sync was too long ago at " .. lastSync ..  ", elapsed " .. elapsed)
        sync()
    else
        print("No need to SNTP sync now, elapsed only " .. elapsed ..  " seconds")
    end
    collectgarbage()
end

function scheduler:check(direction)    
    scheduled = tonumber(settings:get_schedule(direction))
    if scheduled > 0 then             
        sec, usec, rate = rtctime.get()
        left = scheduled - sec
        print(direction .. " is scheduled after " .. left .. " seconds")
        if left < 0 then
            scheduled = scheduled + 86400
            settings:set_schedule(direction, scheduled)
            print("Scheduler triggered, wants to move to " .. direction)
            if not motorsRunning then
                position = settings:get_position()
                if position ~= direction then
                    if direction == DIR_DOWN then
                        motors:rotateDown()
                    elseif direction == DIR_UP then
                        motors:rotateUp()
                    end
                else            
                    print("Already in correct position")
                end
            else                
                print("Motors already running")
            end 
        end
    else
        print(direction .. " does not have scheduler")
    end
end

function sync()
    print("Scheduler starting sntp sync")    
    sntp.sync("0.europe.pool.ntp.org",
        function(sec, usec, server, info)
            print('scheduler SNTP sync succeed', sec, usec, server)
            now = tmr.time()
            lastSync = now
            collectgarbage()
        end,
        function()
            print('scheduler SNTP sync failed!')
            lastSync = -1
            collectgarbage()
        end)   
end