settings = {}

function settings:save_setting(name, value)
  file.open(name, 'w') -- you don't need to do file.remove if you use the 'w' method of writing
  file.writeline(value)
  file.close()
end

function settings:read_setting(name)
  if (file.open(name)~=nil) then
      result = string.sub(file.readline(), 1, -2) -- to remove newline character
      file.close()
      return true, result
  else
      return false, nil
  end
end

function settings:get_position()
    exists,value = settings:read_setting("position")
    if exists then
        return value
    else
        return "up"
    end
end

function settings:set_position(position)
    settings:save_setting("position", position)
end

function settings:get_schedule(direction)
    exists,value = settings:read_setting("schedule" .. direction)
    if exists then
        return value
    else
        return -1
    end
end

function settings:set_schedule(direction, time)
    settings:save_setting("schedule" .. direction, time)
end

function settings:get_timeout(motor, direction)
    key = "time_" .. motor .. "_" .. direction
    exists,value = settings:read_setting(key)
    if exists then
        return value
    else
        return 1000
    end
end

function settings:save_timeout(motor, direction, time)
    key = "time_" .. motor .. "_" .. direction
    settings:save_setting(key, time)
    print("timeout saved for key " .. key .. ", value is " .. time)
end