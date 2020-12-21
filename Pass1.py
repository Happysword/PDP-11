import sys
import re

def firstPass():
    #ٌ########Read and split lines###########
    # get file object
    f = open(sys.argv[1], "r")

    labelsArr = []
    split_lines = []
    while(True):
        # read next line
        line = f.readline()
        # if line is empty, you are done with all lines in the file
        if not line:
            break
        # you can access the line
        uppercase_line = line.upper()
        semicolon_removed = uppercase_line.strip().split(';')[0]
        if(uppercase_line.find(':') != -1):
            labelsArr.append(uppercase_line.strip().split(':')[0])

        split_line = semicolon_removed.split()
        if len(split_line) == 0:
            continue
        split_lines.append(split_line)
    # close file
    f.close

    ##testing
    for i in labelsArr:
        print(i)
        

    

firstPass()