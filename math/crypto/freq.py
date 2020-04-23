#!/usr/bin/python2.7
from __future__ import print_function
import sys
from pathlib import Path
import operator

"""
Print all substrings of specified length that occur more than a specified number of times
"""
def freq_string_len_n(filename, length, min_occurences):
	# GET CODE
	with open(filename) as f: code = f.read()
	code = code.translate(None, ',. \n')

	# Create dict of all substrings of length 'length':
	#		key = substring
	#		val = num_occurences
	words={}
	sub_str=''
	for i in range(0,len(code)):
		if(i+length+1 < len(code)+1):
			sub_str=code[i:i+length]
			if sub_str in words.keys():
				words[sub_str] += 1
			else:
				words[sub_str] =  1

	# Use tuple trick to sort dict, print greatest to least occurences
	sorted_words = sorted(words.items(), key=operator.itemgetter(1))

	gram=[]
	freq=[]
	for t in sorted_words[::-1]:
		if t[1] >= min_occurences:
			gram.append(t[0])
			freq.append(t[1])
			#print(str(t[1]) + " | " + t[0])
			#print(str(t[1]) + " | " + t[0] + " | " + "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
		'''
		# FIND DOUBLLES
		if t[0][0] == t[0][1]:
			gram.append(t[0])
			freq.append(t[1])
			#print(str(t[1]) + " | " + t[0])
		'''
	print(gram)
	print(freq)
# Print usage statement then exit
def usage():
	print("USAGE: "+sys.argv[0]+" <filename> <length> <min_occurences>")
	exit()

# ------- PROGRAM START -------
# Validate and get args
if not (len(sys.argv) >= 4):
	usage()
filename	=sys.argv[1]
length		=sys.argv[2]
min_occurences	=sys.argv[3]
my_file = Path(filename)
if not (my_file.is_file()):
	print("ERROR: "+filename+" does not exist!")
	exit()
if not length.isdigit():
	print("ERROR: "+length+" is an invalid length")
	exit()
if not min_occurences.isdigit():
	print("ERROR: "+min_occurences+" is an invalid min_occurences specification")
	exit()

# MAIN CALL
freq_string_len_n(filename, int(length), int(min_occurences))
