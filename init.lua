LEFT_MOTOR_PIN_1 = 1
LEFT_MOTOR_PIN_2 = 2
RIGHT_MOTOR_PIN_1 = 3
RIGHT_MOTOR_PIN_2 = 4
DIR_UP = "up"
DIR_DOWN = "down"
MOTOR_LEFT = "left"
MOTOR_RIGHT = "right"
POSITION = "position"

print('Setting up WIFI...')

ip_cfg = {
  ip = "192.168.1.100",
  netmask = "255.255.255.0",
  gateway = "192.168.1.1"
}
wifi.sta.setip(ip_cfg)

station_cfg={}
station_cfg.ssid="Your Wi-Fi spot name"
station_cfg.pwd="Your Wi-Fi password"
station_cfg.save=true
wifi.sta.config(station_cfg)

dofile("settings.lc")
dofile("motors.lc")
dofile("scheduler.lc")
dofile("httpServer.lc")
dofile("webapi.lc")

motors:initPins()
scheduler:start()
httpServer:listen(80)
