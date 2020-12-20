import sys



def secondpass():
    #get file object
    f = open(sys.argv[1], "r")

    while(True):
    	#read next line
    	line = f.readline()
    	#if line is empty, you are done with all lines in the file
    	if not line:
    		break
    	#you can access the line
    	print(line.strip())

    #close file
    f.close


secondpass()