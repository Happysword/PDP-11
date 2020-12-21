import sys
import re
import numpy as np

memory = np.zeros(2048,dtype=np.uint16)

def CheckWords(word,labelsArr):
    pattern1 = re.findall('[0-9]+\(',word)
    pattern2 = re.findall('#[0-9]+',word)
    pattern3 = re.findall('^[0-9]+$',word)
    
    pattern4 = word in labelsArr

    return len(pattern1) or len(pattern2) or len(pattern3) or pattern4

def firstPass():
    #ٌ########Read and split lines###########
    # get file object
    
    branches = ["BR","BEQ","BNE","BLO","BLS","BHI","BHS"]
    labelsArr = []
    addresses = []
    labelsDic = dict()
    
    f = open('test.txt', "r")

    split_lines = []
    while(True):
        # read next line
        line = f.readline()
        # if line is empty, you are done with all lines in the file
        if not line:
            break
        # you can access the line
        uppercase_line = line.upper()
        uppercase_line = uppercase_line.replace(","," ")
        semicolon_removed = uppercase_line.strip().split(';')[0]
        if(semicolon_removed.find(':') != -1):                         
            labelsArr.append(semicolon_removed.strip().split(':')[0])

        split_line = semicolon_removed.split()
        if len(split_line) == 0:
            continue
        split_lines.append(split_line)
    # close file
    f.close

    nextAddres = 0
    deletedLines = []
    for i,line in enumerate(split_lines):

        if len(line) == 1:
            if line[0].replace(':','') not in labelsArr:
                addresses.append(nextAddres)
                nextAddres += 1
            else:
                split_lines[i+1] = line + split_lines[i+1]
                deletedLines.append(line)

        elif len(line) == 2:
            if line[0].replace(':','') in labelsArr:
                addresses.append(nextAddres)
                labelsDic[line[0].replace(":","")] = nextAddres
                nextAddres += 1
                line.remove(line[0])
            elif line[0] in branches:
                addresses.append(nextAddres)
                nextAddres += 1   
            else:   
                addresses.append(nextAddres)
                nextAddres += 1 + CheckWords(line[1],labelsArr)
            
        elif len(line) == 3:
            if line[0].replace(':','') in labelsArr:
                if line[1] == ".WORD":
                    memory[nextAddres] = format(int(line[2]) , '04x')
                    labelsDic[line[0].replace(":","")] = nextAddres
                    nextAddres += 1
                    deletedLines.append(line)
                elif line[1] in branches:
                    addresses.append(nextAddres)
                    labelsDic[line[0].replace(":","")] = nextAddres
                    nextAddres += 1  
                    line.remove(line[0]) 
                else:   
                    addresses.append(nextAddres)
                    labelsDic[line[0].replace(":","")] = nextAddres
                    nextAddres += 1 + CheckWords(line[2],labelsArr)
                    line.remove(line[0])
            else:
                addresses.append(nextAddres)
                nextAddres += 1 + CheckWords(line[1],labelsArr) + CheckWords(line[2],labelsArr)

        elif len(line) == 4:
            addresses.append(nextAddres)
            labelsDic[line[0].replace(":","")] = nextAddres
            nextAddres += 1 + CheckWords(line[2],labelsArr) + CheckWords(line[3],labelsArr)
            line.remove(line[0])

    for line in deletedLines:
        split_lines.remove(line)

    for line in split_lines:
        for i,word in enumerate(line):
            if word in labelsArr:
                line[i] = labelsDic[word]

    return split_lines

print(firstPass())
