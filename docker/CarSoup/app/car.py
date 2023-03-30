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

class CarParser():
    """
    Scrape carspecs.us for car data
    """
    def __init__(self, make, year=None, model=None):
        """
        CarParser constructor

        @param make: Required string
        @param year: Optional string
        @param model: Optional string
        """
        self.URL   = 'https://www.carspecs.us/cars'
        self.year  = year
        self.make  = make
        self.model = model

    def scrape(self):
        """
        Based on supplied year/model/make
            - Generate URL
            - Call appropriate scraper helper function
            - Return result
        """
        result = None
        if self.model and self.year:
            self.URL += '/{year}/{make}/{model}'.format(year=self.year, make=self.make, model=self.model)
            soup = self._brew_soup()
            result = self._scrape_full(soup)
        elif self.model:
            self.URL += '/{make}/{model}'.format(make=self.make, model=self.model)
            soup = self._brew_soup()
            result = self._scrape_year(soup)
        elif self.year:
            self.URL += '/{year}/{make}'.format(year=self.year, make=self.make)
            soup = self._brew_soup()
            result = self._scrape_model(soup)
        else:
            self.URL += '/{make}'.format(make=self.make)
            soup = self._brew_soup()
            result = self._scrape_model_year(soup)
        return result

    def _scrape_year(self, soup):
        """
        Scrape years when make and model are given
        Search pattern = <li> <a href="/make/model"> YEAR
        @param soup
        @return table of years
        """
        result = None

        # <li> <a href="/make/model"> YEAR
        aTags = [ li.find('a') for li in soup.findAll('li') ]
        pattern = '/{make}/{model}'.format(make=self.make, model=self.model)
        years = [ a.text.strip(' \r\n\t') for a in aTags if pattern in a['href'] ]
        if len(years) == 0:
            logger.error("No years found for {make} {model}: {url}".format(make=self.make, model=self.model, url=self.URL) )
    
        headers = [ 'year' ]
        table = [ i for i in itertools.zip_longest(years) ]
        result = tabulate(table, headers=headers)

        return result
    
    def _scrape_model(self, soup):
        """
        Scrape models when make and year are given
        Search pattern = <li> <a href="/cars/year/make"> MODEL 
        @param soup
        @return table of models
        """
        result = None

        # <li> <a href="/cars/year/make"> MODEL 
        aTags = [ li.find('a') for li in soup.findAll('li') ]
        pattern = '/cars/{year}/{make}'.format(year=self.year, make=self.make) 
        models = [ a.text.strip(' \r\n\t') for a in aTags if pattern in a['href'] ]
        if(len(models) == 0):
            logger.error("No models found for {make} {year}: {url}".format(make=self.make, year=self.year, url=self.URL) )
    
        headers = [ 'model' ]
        table = [ i for i in itertools.zip_longest(models) ]
        result = tabulate(table, headers=headers)

        return result
    
    def _scrape_model_year(self, soup):
        """
        Scrape model and year when only make is given
        Search pattern = <li> <a href!="/cars/make"> YEAR 
        Search pattern = <li> <a href="/cars/make"> MODEL
        @param soup
        @return table of models/years
        """
        result = None

        aTags = [ li.find('a') for li in soup.findAll('li') ]
        # <li> <a href!="/cars/make"> YEAR
        pattern = '/cars/{make}'.format(make=self.make)
        years = [ a.text.strip(' \r\n\t') for a in aTags if (a.text.isnumeric()) and not pattern in a['href'] ]
        # <li> <a href="/cars/make"> MODEL 
        pattern = '/cars/{make}'.format(make=self.make)
        models = [ a.text.strip(' \r\n\t') for a in aTags if pattern in a['href'] ]
        if (len(years)==0):
            logger.error("No years found for {make}: {url}".format(make=self.make, url=self.URL) )
        if (len(models)==0):
            logger.error("No models found for {make}: {url}".format(make=self.make, url=self.URL) )
    
        headers = [ 'year', 'model' ]
        table = [ i for i in itertools.zip_longest(years, models) ]
        result = tabulate(table, headers=headers)

        return result
    
    def _scrape_full(self, soup):
        """
        The Real Deal
        Search pattern = <div class="main-car-details"> <span> PRICE
        Search pattern = <div class="main-car-details"> <div class="main-car-details"> <span> TXT ...  MILEAGE
        Search pattern = <div class="main-car-details"> MILEAGE
        Search pattern = <div class="car-details"> <div class="pure-u-1 pure-u-md-1-2"> <h4> KEY </h4> VALUE 
        @param soup
        @return table of models/years
        """
        result = None
        keys = []
        values = []

        # Get price and mileage
        if soup.find('div', class_="main-car-details"):
            blob = soup.find('div', class_="main-car-details")
            if blob.find('span'):
                # <div class="main-car-details"> <span> PRICE 
                price = blob.find('span').text.strip()
                keys.append('price')
                values.append(price)
                if blob.find('span').next_sibling.next_sibling:
                    # <div class="main-car-details"> <span> TXT ...  MILEAGE
                    mileage = blob.find('span').next_sibling.next_sibling.strip()
                    keys.append('mileage')
                    values.append(mileage)
            elif blob.text:
                # <div class="main-car-details"> MILEAGE
                mileage = blob.text.strip()
                keys.append('mileage')
                values.append(mileage)

        if soup.find('div', class_="car-details"):
            # <div class="car-details"> <div class="pure-u-1 pure-u-md-1-2"> <h4> KEY </h4> VALUE
            blob = soup.find('div', class_="car-details").findAll('div', class_="pure-u-1 pure-u-md-1-2")
            keys.extend([ d.findNext('h4').text.strip(' \r\n\t') for d in blob ])
            values.extend([ d.findNext('h4').next_sibling.strip(' \r\n\t') for d in blob ])

        if len(values) > 0:
            headers = [ 'key', 'value']
            table = [ i for i in itertools.zip_longest(keys, values) ]
            result = tabulate(table, headers=headers)
        else:
            logger.error("Bad URL: {url}".format(url=self.URL))

        return result    

    def _brew_soup(self):
        head = requests.head(self.URL)
        if head.ok:
            get = requests.get(self.URL) 
            soup = BeautifulSoup(get.content, "html.parser")
        else:
            raise RuntimeError("HTTP {code}: {url}".format(code=head.status_code, url=self.URL))
        return soup

if __name__ == '__main__':
    cli = argparse.ArgumentParser(description='Scrape some car data')
    cli.add_argument('--make', type=str, help='Make of car ie: [Toyota, Honda, Ford]', required=True)
    cli.add_argument('--model', type=str, help='Model of car ie: [Corolla, Civic, F150]')
    cli.add_argument('--year', type=int, help='year of car ie: [2020, 2001, 1969]')
    #cli.add_argument('--trim', type=str, help='Trim of car ie: sport')
    args = cli.parse_args()

    car_parser = CarParser(args.make, args.year, args.model)
    result = car_parser.scrape()
    print(result)
