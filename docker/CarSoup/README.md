# CarSoup
Research stats on cars from the command line!

# Usage
App runs out of a docker container, so use run.sh to run the application "car.py"
```
# ./run.sh --help

usage: car.py [-h] --make MAKE [--model MODEL] [--year YEAR]

Scrape some car data

optional arguments:
  -h, --help     show this help message and exit
  --make MAKE    Make of car ie: [Toyota, Honda, Ford]
  --model MODEL  Model of car ie: [Corolla, Civic, F150]
  --year YEAR    year of car ie: [2020, 2001, 1969]
```

# Example searches
```
# ./run.sh --make subaru                           # Will show all years/models available for suabru
# ./run.sh --make subaru --model baja              # Will show all years available for the subaru baja
# ./run.sh --make subaru --model baja --year 2006  # Will show car statistics on the subaru baja
```
