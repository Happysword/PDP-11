import sys


#@TODO
# 1- Check for Different Addressing Modes

#Every String will map to a decimal number that would be added to the
#other valuse of the opcodes and then would be transformed to a hexa string
opcodes_dict = {
   #String : Decimal #Opcode
    #4 BITS OPCODE
    "MOV" : 0,              #0
    "ADD" : 4096,           #1
    "ADC" : 8192,           #2
    "SUB" : 12288,          #3
    "SBC" : 16384,          #4
    "AND" : 20480,          #5
    "OR"  : 24576,          #6
    "XOR" : 28672,          #7
    "CMP" : 32768,          #8
    "HLT" : 45056,          #B
    "NOP" : 49152,          #C
    "RESET" : 53248,        #D

    #8 BITS OPCODE
    "BR" : 40960,           #A0
    "BEQ": 41216,           #A1
    "BNE": 41472,           #A2
    "BLO": 41728,           #A3
    "BLS": 41984,           #A4
    "BHI": 42240,           #A5
    "BHS": 42496,           #A6

    #7 BITS OPCODE
    "JSR" : 57344,           #E0
    "RTS" : 57856,           #E2
    "INT" : 58368,           #E4
    "IRET": 58880,           #E6

    #10 BITS OPCODE
    "INC" : 36864,           #900
    "DEC" : 36928,           #904
    "CLR" : 36992,           #908
    "INV" : 37056,           #90C
    "LSR" : 37120,           #910
    "ROR" : 37184,           #914
    "ASR" : 37248,           #918
    "LSL" : 37312,           #91C
    "ROL" : 37376           #920
}


def secondpass():

    #ٌ########Read and split lines###########
    # get file object
    f = open(sys.argv[1], "r")

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
        split_line = semicolon_removed.split()
        if len(split_line) == 0:
            continue
        split_lines.append(split_line)
    # close file
    f.close

    ##testing
    for i in split_lines:
        print(i)

    ###########Processing############
    #String to Hex Opcode
    hex_codes = []
    for i in split_lines:
        if i[0] in opcodes_dict.keys():
            code_decimal = opcodes_dict[ i[0] ]
            code_hex = format(code_decimal , '04x') 
            hex_codes.append( code_hex.upper() ) 

    return hex_codes




def write_to_file(hex_codes):
    f = open(sys.argv[2],"w")
    for i in hex_codes:
        f.write(i + "\n")

    f.close


hex_codes = secondpass()
write_to_file(hex_codes)
