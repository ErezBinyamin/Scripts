@ECHO OFF
COLOR A
:: Source - https://www.hongkiat.com/blog/5-ways-command-prompt-fix-slow-internet/
:: 1. Renew IP address
ipconfig /release
ipconfig /renew

:: 2. Flush DNS resolver cache
ipconfig /flushdns

:: 3. Reset Winsock
netsh winsock reset

:: 4. Change network configuration settings
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set supplemental
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled

:: 5. Speed up Streaming
netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes

:: Pause
PAUSE