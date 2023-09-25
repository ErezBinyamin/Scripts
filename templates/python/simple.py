import logging
import logging.config
import argparse
from datetime import datetime
from pdb import set_trace as bp

# Logging configuration
LOGGING_CONFIG = { 
     'version': 1,
     'disable_existing_loggers': True,
     'formatters': { 
         'standard': { 
             'format': '%(asctime)s [%(levelname)s] [%(filename)s:%(lineno)d]: %(message)s'
         },
     },
     'handlers': { 
         'default': { 
             'level': 'DEBUG',
             'formatter': 'standard',
             'class': 'logging.StreamHandler',
             'stream': 'ext://sys.stderr',  # Default is stderr
         },
     },
     'loggers': { 
         '': {  # root logger
             'handlers': ['default'],
             'level': 'DEBUG',
             'propagate': False
         },
     } 
 }
logging.config.dictConfig(LOGGING_CONFIG)
logger = logging.getLogger(__name__)

class Age():
  def __init__(self, birthdate):
    self.DAYS_IN_YEAR   = 365
    self.DAYS_IN_MONTH  = 12
    self.SECONDS_IN_MIN = 60
    self.MIN_IN_HOUR    = 60
    
    currdate = datetime.today()
    delta = currdate - birthdate
    logger.debug(f"This is a debug message")
    bp()
    
    self.years   = int(delta.days / self.DAYS_IN_YEAR)
    self.days    = int((delta.days % self.DAYS_IN_YEAR))
    self.hours   = int((delta.seconds / self.SECONDS_IN_MIN) / self.MIN_IN_HOUR)
    self.minutes = int((delta.seconds / self.SECONDS_IN_MIN) % self.MIN_IN_HOUR)
    self.seconds = int(delta.seconds % self.SECONDS_IN_MIN)

def main(day,month,year):
  """
  Description of the main function
  @param args: the args
  """
  birthdate = datetime.strptime(f"{day} {month} {year}", '%d %b %Y')
  age = Age(birthdate)
  print(f"""
    Your age is...
      {age.years}   years,
      {age.days}    days,
      {age.hours}   hours,
      {age.minutes} minutes,
      {age.seconds} seconds
  """)
  

if __name__ == "__main__":
  """
  Main if statement
  Parses and validates command line arguments, then calls main function
  """
  # Argument parsing
  cli = argparse.ArgumentParser(description='Calculate current age')
  cli.add_argument('-d', '--day', type=int, required=True)
  cli.add_argument('-m', '--month', choices=['Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'], required=True)
  cli.add_argument('-y', '--year', type=int, required=True)
  args = cli.parse_args()
  
  
  # Argument Checks
  main(args.day, args.month, args.year)
  
