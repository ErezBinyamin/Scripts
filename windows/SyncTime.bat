@ECHO OFF
COLOR A
:: From: https://answers.microsoft.com/en-us/windows/forum/all/command-to-force-time-to-reset-to-current/46df0934-d6d7-42cd-8ea5-817d61306603
net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /resync