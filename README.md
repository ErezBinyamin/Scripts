# BashScripts
Random Misc Bash scripts I use for stuff

## netcat_fun
I am a bigfan of codegolf, oneliners, and netcat is really fun

### colorfullChat
Everybody knows the netcat chatting trick.  
```bash
# Server
nc -l 1234
#Client
nc ${IP_ARRD} 1234
```
But colors make things much more fun!

![](img/colorfullChat.gif)

### portScanner
nmap actually only sometimes works, I've found that netcat can find things nmap misses

![](img/portScanner.gif)
