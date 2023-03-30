"""
OEIS.py
@author Erez Binyamin (github.com/ErezBinyamin)
@author Philp Wesley (github.com/phly95)

Search 'https://oeis.org/' for an integer sequence
Implementation of the OEIS internal format: https://oeis.org/eishelp1.html
"""
import argparse, logging
from requests import get as curl
from pdb import set_trace as bp

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger()

sections = {
  'I' : False,
  'S' : True,
  'T' : False,
  'U' : False,
  'N' : True,
  'D' : False,
  'H' : False,
  'F' : False,
  'Y' : False,
  'A' : False,
  'O' : False,
  'E' : False,
  'e' : False,
  'p' : False,
  't' : False,
  'o' : False,
  'K' : False,
  'C' : False
}

def main(query):
  """
  @param  : query : String of colon separated keys
  @return : Text to print to command line for query result

  Example CLI:   --lines 2 --author --program 1 1 2 3 5 8 13
  Example Query: 1+1+2+3+5+8+13:lines=2:author:program
  """
  # Construct URL
  sequence = query.split(':')[0]
  options  = query.split(':')[1:]

  url_opts = '&fmt=text&language=english&go=Search'
  for opt in options:
    if 'start' in opt:
      url_opts += '&{}'.format(opt)
    if 'lines' in opt:
      n = int(opt.split('=')[1])
      if n > 0:
        sections['S'] = True
      if n > 1:
        sections['T'] = True
      if n > 2:
        sections['U'] = True
    if 'ref' in opt:
      sections['D'] = True
    if 'link' in opt:
      sections['H'] = True
    if 'formula' in opt:
      sections['F'] = True
    if 'xref' in opt:
      sections['Y'] = True
    if 'author' in opt:
      sections['A'] = True
    if 'offset' in opt:
      sections['O'] = True
    if 'extentions' in opt:
      sections['E'] = True
    if 'examples' in opt:
      sections['e'] = True
    if 'program' in opt:
      sections['p'] = True
      sections['t'] = True
      sections['o'] = True
    if 'keywords' in opt:
      sections['K'] = True
    if 'comments' in opt:
      sections['C'] = True

  url = 'http://oeis.org/search?q=' + sequence + url_opts
  
  logger.debug("URL {}".format(url))
  response = curl(url=url)
  response.close()

  # Parse response into sheet
  sheet = {}
  for line in response.text.split('\n'):
    key = line.split(' ')[0]
    if '%' in key:
      seq = line.split(' ')[1]
      key = key.replace('%', '')
      line = line.replace("%{} {}".format(key, seq), '')
      if seq in sheet and key in sheet[seq]:
        sheet[seq][key] += '\n*  ' + line
      elif not seq in sheet:
        sheet[seq] = {}
        sheet[seq][key] = line
      else:
        sheet[seq][key] = line

  # Print sheet in C style block comment
  shouldPrintAuthor = False
  for seq in sheet:
    print("/* Sequence ID: " + seq)
    # 1. Name of sequence
    if 'N' in sheet[seq]:
      print("*  Name: " + sheet[seq]['N'])
      sheet[seq].pop('N')
    if 'A' in sheet[seq]:
      seq_author = sheet[seq]['A']
      sheet[seq].pop('A') 
      shouldPrintAuthor = True
    for key in sheet[seq]:
      if not key in sections:
        logger.error("Unrecognized OEIS key: %{}. Explore docs: https://oeis.org/eishelp1.html")
      if key in sections and sections[key]:
        print("*  %" + key + ": " + sheet[seq][key])
    # Author of sequence should go last
    if shouldPrintAuthor:
      print("*  Author: " + seq_author)
    print("*/")
    
if __name__ == "__main__":
  """
  CLI interface to oeis.py

  Will build a cheat.sh formatted URL string and pass off to main parsing function
  """
  parser = argparse.ArgumentParser(description='OEIS search and parsing tool')
  parser.add_argument('query'        , type=str, nargs='+', help='Search query for OEIS')
  parser.add_argument('-s', '--start'    , type=int, help='Sequence result pager start index', default=0)
  parser.add_argument('-l', '--lines'    , type=int, help='Number of lines to show [1-3]', default=1)
  parser.add_argument('-D', '--ref'    , action='store_true', help='Show detailed reference line', default=False)
  parser.add_argument('-H', '--link'     , action='store_true', default=False, help='Show links to other site (papers/articles)')
  parser.add_argument('-F', '--formula'  , action='store_true', default=False, help='Show sequence formula')
  parser.add_argument('-Y', '--xref'     , action='store_true', default=False, help='Show cross-references to other sequences')
  parser.add_argument('-A', '--author'   , action='store_true', default=False, help='Show author')
  parser.add_argument('-O', '--offset'   , action='store_true', default=False, help='Show offset')
  parser.add_argument('-E', '--extentions' , action='store_true', default=False, help='Show extensions, errors, etc')
  parser.add_argument('-e', '--examples'   , action='store_true', default=False, help='Show examples to illustrate initial terms')
  parser.add_argument('-o', '--program'  , action='store_true', default=False, help='Show misc other language programs')
  parser.add_argument('-K', '--keywords'   , action='store_true', default=False, help='Show keywords')
  parser.add_argument('-C', '--comments'   , action='store_true', default=False, help='Show Comments')
  args = parser.parse_args()
  query = '+'.join(args.query)

  if args.start:
    query += ':start={}'.format(args.start)
  if args.lines:
    query += ':lines={}'.format(args.lines)
  if args.ref:
    query += ':ref'
  if args.link:
    query += ':link'
  if args.formula:
    query += ':formula'
  if args.xref:
    query += ':xref'
  if args.author:
    query += ':author'
  if args.offset:
    query += ':offset'
  if args.extentions:
    query += ':extentions'
  if args.examples:
    query += ':examples'
  if args.program:
    query += ':program'
  if args.keywords:
    query += ':keywords'
  if args.comments:
    query += ':comments'
  logger.debug(query)
  main(query)
