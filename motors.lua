motors = {
    motorsRunning = false
}

function motors:initPins()
    gpio.mode(LEFT_MOTOR_PIN_1, gpio.OUTPUT)
    gpio.mode(LEFT_MOTOR_PIN_2, gpio.OUTPUT)
    gpio.mode(RIGHT_MOTOR_PIN_1, gpio.OUTPUT)
    gpio.mode(RIGHT_MOTOR_PIN_2, gpio.OUTPUT)
end

function motors:rotateUp()
    motorsRunning = true
    timeoutLeft = settings:get_timeout(MOTOR_LEFT, DIR_UP)
    timeoutRight = settings:get_timeout(MOTOR_RIGHT, DIR_UP)
    message = "Left motor timeout is " .. timeoutLeft .. ", right motor timeout is "
        .. timeoutRight
    print(message)    
    motors:rotate(MOTOR_LEFT, DIR_UP, timeoutLeft)
    motors:rotate(MOTOR_RIGHT, DIR_UP, timeoutRight)
    settings:set_position(DIR_UP)
end

function motors:rotateDown()
    motorsRunning = true
    timeoutLeft = settings:get_timeout(MOTOR_LEFT, DIR_DOWN)
    timeoutRight = settings:get_timeout(MOTOR_RIGHT, DIR_DOWN)
    message = "Left motor timeout is " .. timeoutLeft .. ", right motor timeout is "
        .. timeoutRight
    print(message)
    motors:rotate(MOTOR_LEFT, DIR_DOWN, timeoutLeft)
    motors:rotate(MOTOR_RIGHT, DIR_DOWN, timeoutRight)
    settings:set_position(DIR_DOWN)
end

function motors:rotate(motor, direction, time)    
    pin1 = 0
    pin2 = 0
    if direction == DIR_UP then
        pin1 = 1
    elseif direction == DIR_DOWN then
        pin2 = 1
    end        
    if motor == MOTOR_LEFT then
        gpio.write(LEFT_MOTOR_PIN_1, pin1)
        gpio.write(LEFT_MOTOR_PIN_2, pin2)        
        tmr.create():alarm(time, tmr.ALARM_SINGLE, function() motors:stopLeft() end)
        print("Left motor started")
    elseif motor == MOTOR_RIGHT then
        gpio.write(RIGHT_MOTOR_PIN_1, pin1)
        gpio.write(RIGHT_MOTOR_PIN_2, pin2)    
        tmr.create():alarm(time, tmr.ALARM_SINGLE, function() motors:stopRight() end)
        print("Right motor started")
    end
end

function motors:stopLeft()
    motorsRunning = false
    gpio.write(LEFT_MOTOR_PIN_1, 0)
    gpio.write(LEFT_MOTOR_PIN_2, 0)
    print("Left motor control pins set to zero")
end

function motors:stopRight()
    motorsRunning = false
    gpio.write(RIGHT_MOTOR_PIN_1, 0)
    gpio.write(RIGHT_MOTOR_PIN_2, 0)
    print("Right motor control pins set to zero")
end

function motors:stop()    
    motors:stopLeft()
    motors:stopRight()
    print("All motor control pins set to zero")
end