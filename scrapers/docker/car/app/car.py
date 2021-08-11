#!/usr/bin/python
import argparse
import requests
from bs4 import BeautifulSoup
from tabulate import tabulate
import logging

from pdb import set_trace as bp
logging.basicConfig()
logger = logging.getLogger(__file__)

def scrape(make, model):
    URL = "https://www.caranddriver.com/%s/%s/specs" % (make, model)
    head = requests.head(URL)
    if head.ok:
        get = requests.get(URL) 
        soup = BeautifulSoup(get.content, "html.parser")

        keys = soup.select("h3[class='spec-section-title-name']")
        vals = soup.select("div[class='spec-section-title-value']")
        keys = [ key.text.strip(' \n\t') for key in keys ]
        vals = [ val.text.strip(' \n\t') for val in vals ]

        headers = [ 'keys', 'values' ]
        table=zip(keys,vals)
        print(tabulate(table, headers=headers))
    else:
        logger.error("HTTP %d: %s" % (head.status_code, URL))

if __name__ == '__main__':
    cli = argparse.ArgumentParser(description='Scrape some car data')
    cli.add_argument('--make', type=str, help='Make of car ie: [Toyota, Honda, Ford]', required=True)
    cli.add_argument('--model', type=str, help='Model of car ie: [Corolla, Civic, F150]', required=True)
    #cli.add_argument('--year', type=int, help='year of car ie: [2020, 2001, 1969]')
    #cli.add_argument('--trim', type=str, help='Trim of car ie: sport')
    #cli.add_argument('--', type=, help='')
    args = cli.parse_args()

    scrape(args.make, args.model)
