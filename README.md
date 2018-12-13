# window-controller-nodemcu
NodeMCU lua scripts for smart window blinds. Allows to control motorized window blinds via http get requests and set alarms to open\close blinds. The following modules are required in NodeMCU firmware: file, gpio, net, node, rtctime, sntp, tmr, uart, wifi.

Change your Wi-Fi hotspot name, password and ip settings in init.lua file.

Based on lightweight HTTP server [NodeMCU-HTTP-Server](https://github.com/wangzexi/NodeMCU-HTTP-Server).