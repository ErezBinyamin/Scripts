#!/usr/bin/python2.7
from __future__ import print_function
import sys
from pathlib import Path

VALID_ALPHAS=[1,3,5,7,9,11,15,17,19,21,23,25]

def de_affine(filename, ALPHA, BETA):
        # Calculate APLHA INVERSE
        for i in VALID_ALPHAS:
            if( (ALPHA * i) % 26 == 1):
                ALPHA_INVERSE = i
                break;

	# GET CODE
	with open(filename) as f: code = f.read()
	code = code.translate(None, ',. \n')

        message = ""
	for i in range(0,len(code)):
            enc_val = ord(code[i]) - ord('A')
            dec_val = (ALPHA_INVERSE * enc_val - BETA) % 26
            dec_val += ord('A')
            message += chr(dec_val)

        print(message)
# Print usage statement then exit
def usage():
	print("USAGE: "+sys.argv[0]+" <filename>")
	exit()

# ------- PROGRAM START -------
# Validate and get args
if not (len(sys.argv) >= 4):
	usage()
filename=sys.argv[1]
ALPHA	=sys.argv[2]
BETA	=sys.argv[3]

my_file = Path(filename)
if not (my_file.is_file()):
	print("ERROR: "+filename+" does not exist!")
	exit()
if not ALPHA.isdigit():
	print("ERROR: "+ALPHA+" is an invalid length")
	exit()
if not BETA.isdigit():
	print("ERROR: "+BETA+" is an invalid min_occurences specification")
	exit()
# MAIN
de_affine(filename, int(ALPHA), int(BETA))
