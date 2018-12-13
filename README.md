# window-controller-nodemcu
NodeMCU lua scripts for smart window blinds. Allows to control motorized window blinds via http get requests and set alarms to open\close blinds. The following modules are required in NodeMCU firmware: file, gpio, net, node, rtctime, sntp, tmr, uart, wifi.

Change your Wi-Fi hotspot name, password and ip settings in init.lua file.

Based on lightweight HTTP server [NodeMCU-HTTP-Server](https://github.com/wangzexi/NodeMCU-HTTP-Server).

## API

### http://nodemcu-ip-address/settings
Returns settings JSON object with up\down timings for each motor: 
> {"status": "success", "downLeft": 12000, "downRight": 12000, "upLeft": 15000, "upRight": 15000}

### http://nodemcu-ip-address/settings?motor=right&direction=up&time=1000
Setup timings for motors
##### motor
Left or right
##### direction
Up or down
##### time
Integer, time in ms

### http://nodemcu-ip-address/up
Command for opening window blinds

### http://nodemcu-ip-address/down
Command for closing window blinds

### http://nodemcu-ip-address/stop
Command for stopping window blinds

### http://nodemcu-ip-address/status
Returns the current position of blinds
> {"status": "success","position":"up"}

##### position
up or down

### http://nodemcu-ip-address/position?direction=up 
Resets current position of blinds
##### direction
up or down

### http://nodemcu-ip-address/tasks
Returns JSON object containing alarms for opening\closing blinds
> {"status": "success", "up": "-1", "down": "-1"})

##### up
##### down
-1 if alarm is not set or seconds since the Unix epoch otherwise. Alarm is repeated daily after it is triggered.

### http://nodemcu-ip-address/schedule?direction=up&time=1543199280
Setup the alarm for opening\closing blinds
##### direction
up or down
##### time
Time is seconds since the Unix epoch. Alarm is repeated daily. If time is in past then it will be triggered tomorrow.