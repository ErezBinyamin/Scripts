# Apr Spoof

## How to:
### 1. To start arpspoof container
```
./arpspoof-docker.sh [ROUTER_IP]
```

### 2. To start/stop spoofing
```
./spoof.py --rhost RHOST [--action]
```

### 3. To view outbound traffic from RHOST
```
sudo tcpdump -X src ${RHOST}
```
