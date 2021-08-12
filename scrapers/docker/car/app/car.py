#!/usr/bin/python
import argparse
import requests
from bs4 import BeautifulSoup
import itertools
from tabulate import tabulate
import logging

from pdb import set_trace as bp
logging.basicConfig()
logger = logging.getLogger(__file__)

def scrape_year(URL, make, model):
    result = None
    head = requests.head(URL)
    if head.ok:
        get = requests.get(URL) 
        soup = BeautifulSoup(get.content, "html.parser")

        years = [ li.find('a') for li in soup.findAll('li') if '/%s/%s' % (make,model) in li.find('a')['href'] ]
        years = [ year.text.strip(' \n\t') for year in years ]
        if len(years) == 0:
            logger.error("No such %s model: %s" % (make, model))

        headers = [ 'year' ]
        table = [ i for i in itertools.zip_longest(years) ]
        result = tabulate(table, headers=headers)
    else:
        logger.error("HTTP %d: %s" % (head.status_code, URL))
    return result

def scrape_model(URL, year, make):
    result = None
    head = requests.head(URL)
    if head.ok:
        get = requests.get(URL) 
        soup = BeautifulSoup(get.content, "html.parser")

        models = [ li.find('a') for li in soup.findAll('li') if '/cars/%s/%s' % (year,make) in li.find('a')['href'] ]
        models = [ model.text.strip(' \n\t') for model in models ]
        if(len(models) == 0):
            logger.error("No %s made in year: %s" % (make, year))

        headers = [ 'model' ]
        table = [ i for i in itertools.zip_longest(models) ]
        result = tabulate(table, headers=headers)
    else:
        logger.error("HTTP %d: %s" % (head.status_code, URL))        
    return result

def scrape_model_year(URL, make):
    result = None
    head = requests.head(URL)
    if head.ok:
        get = requests.get(URL) 
        soup = BeautifulSoup(get.content, "html.parser")

        years = [ li.find('a') for li in soup.findAll('li') if ((li.find('a').text.isnumeric()) and not '/cars/%s' % (make) in li.find('a')['href']) ]
        models = [ li.find('a') for li in soup.findAll('li') if '/cars/%s' % (make) in li.find('a')['href'] ]
        years = [ year.text.strip(' \n\t') for year in years ]
        models = [ model.text.strip(' \n\t') for model in models ]
        if (len(years)==0) or (len(models)==0):
            logger.error("No such car make: %s" % (make))

        headers = [ 'year', 'model' ]
        table = [ i for i in itertools.zip_longest(years, models) ]
        result = tabulate(table, headers=headers)
    else:
        logger.error("HTTP %d: %s" % (head.status_code, URL))
    return result

def scrape_full(URL, year, make, model):
    raise NotImplementedError
    result = None
    head = requests.head(URL)
    if head.ok:
        get = requests.get(URL) 
        soup = BeautifulSoup(get.content, "html.parser")

        #headers = [ ]
        #table = [ i for i in itertools.zip_longest(years, models) ]
        #result = tabulate(table, headers=headers)
    else:
        logger.error("HTTP %d: %s" % (head.status_code, URL))
    return result

def scrape(make, year=None, model=None):
    result = None
    URL = 'https://www.carspecs.us/cars'
    if model and year:
        URL += '/{year}/{make}/{model}'.format(year=year, make=make, model=model)
        result = scrape_full(URL, year, make, model)
    elif model:
        URL += '/{make}/{model}'.format(make=make, model=model)
        result = scrape_year(URL, make, model)
    elif year:
        URL += '/{year}/{make}'.format(year=year, make=make)
        result = scrape_model(URL, year, make)
    else:
        URL += '/{make}'.format(make=make)
        result = scrape_model_year(URL, make)
    print(result)

if __name__ == '__main__':
    cli = argparse.ArgumentParser(description='Scrape some car data')
    cli.add_argument('--make', type=str, help='Make of car ie: [Toyota, Honda, Ford]', required=True)
    cli.add_argument('--model', type=str, help='Model of car ie: [Corolla, Civic, F150]')
    cli.add_argument('--year', type=int, help='year of car ie: [2020, 2001, 1969]')
    #cli.add_argument('--trim', type=str, help='Trim of car ie: sport')
    args = cli.parse_args()

    scrape(args.make, args.year, args.model)
