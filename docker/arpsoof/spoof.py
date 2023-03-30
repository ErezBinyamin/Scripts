#!/usr/bin/python
import argparse
import requests
import logging
import time

from pdb import set_trace as bp
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__file__)

LHOST="localhost"
LPORT=7022
action=None

if __name__ == '__main__':
    cli = argparse.ArgumentParser(description='Interact with Home-Assistant ARP spoof API')
    cli.add_argument('--rhost', type=str, required=True, help="IP address of remote host to interact with")
    cli.add_argument('--status', action='store_true', help='Check if currently blocking specified ip address')
    cli.add_argument('--start', action='store_true', help='Start ARP poisoning specified rhost')
    cli.add_argument('--stop', action='store_true', help='Stop ARP poisoning specified rhost')
    args = cli.parse_args()

    if args.status:
        action="status"
    elif args.start:
        action="disconnect"
    elif args.stop:
        action="reconnect"
    else:
        raise RuntimeError("Must specifiy an action: [ status, start, stop ]")

    URL="http://{LHOST}:{LPORT}/{action}?ip={RHOST}".format(LHOST=LHOST, LPORT=LPORT, action=action, RHOST=args.rhost)
    req = requests.get(url=URL)

    # Status/Start log messages
    if args.status or args.start:
        if req.text == '0':
            logger.info("Status: {RHOST} not being spoofed".format(RHOST=args.rhost))
        elif req.text == '1':
            logger.info("Status: {RHOST} is being spoofed".format(RHOST=args.rhost))
    # Stop command log messages
    elif args.stop:
        URL="http://{LHOST}:{LPORT}/{action}?ip={RHOST}".format(LHOST=LHOST, LPORT=LPORT, action='status', RHOST=args.rhost)
        logger.info("Stopping spoofing on {RHOST}...".format(RHOST=args.rhost))
        while requests.get(url=URL).text == '1':
            time.sleep(1)
        logger.info("Spoofing stopped on {RHOST}".format(RHOST=args.rhost))
        
