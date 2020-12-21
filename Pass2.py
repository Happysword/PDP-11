import sys


# @TODO
# 1- Add values to memory
# 2- Add offset to branch instructions 

# Every String will map to a decimal number that would be added to the
# other valuse of the opcodes and then would be transformed to a hexa string
opcodes_dict = {
    # String : Decimal #Opcode
    # 4 BITS OPCODE
    "MOV": 0,      # 0
    "ADD": 4096,   # 1
    "ADC": 8192,   # 2
    "SUB": 12288,  # 3
    "SBC": 16384,  # 4
    "AND": 20480,  # 5
    "OR": 24576,   # 6
    "XOR": 28672,  # 7
    "CMP": 32768,  # 8
    "HLT": 45056,  # B
    "NOP": 49152,  # C
    "RESET": 53248,  # D

    # 8 BITS OPCODE
    "BR": 40960,   # A0
    "BEQ": 41216,  # A1
    "BNE": 41472,  # A2
    "BLO": 41728,  # A3
    "BLS": 41984,  # A4
    "BHI": 42240,  # A5
    "BHS": 42496,  # A6

    # 7 BITS OPCODE
    "JSR": 57344,  # E0
    "RTS": 57856,  # E2
    "INT": 58368,  # E4
    "IRET": 58880,  # E6

    # 10 BITS OPCODE
    "INC": 36864,  # 900
    "DEC": 36928,  # 904
    "CLR": 36992,  # 908
    "INV": 37056,  # 90C
    "LSR": 37120,  # 910
    "ROR": 37184,  # 914
    "ASR": 37248,  # 918
    "LSL": 37312,  # 91C
    "ROL": 37376   # 920
}

operand_nums = {
    # String : Decimal #Opcode
    # 4 BITS OPCODE
    "MOV": 2,
    "ADD": 2,
    "ADC": 2,
    "SUB": 2,
    "SBC": 2,
    "AND": 2,
    "OR":  2,
    "XOR": 2,
    "CMP": 2,
    "HLT": 0,
    "NOP": 0,
    "RESET": 0,

    # 8 BITS OPCODE
    "BR":  1,
    "BEQ": 1,
    "BNE": 1,
    "BLO": 1,
    "BLS": 1,
    "BHI": 1,
    "BHS": 1,

    # 7 BITS OPCODE
    "JSR": 1,
    "RTS": 0,
    "INT": 0,
    "IRET": 0,

    # 10 BITS OPCODE
    "INC": 1,
    "DEC": 1,
    "CLR": 1,
    "INV": 1,
    "LSR": 1,
    "ROR": 1,
    "ASR": 1,
    "LSL": 1,
    "ROL": 1
}

RSource = {
    '0': 0, 
    '1': 64, 
    '2': 128, 
    '3': 192, 
    '4': 256, 
    '5': 320, 
    '6': 384, 
    '7': 448, 
}

RDest = {
    '0': 0, 
    '1': 1, 
    '2': 2, 
    '3': 3, 
    '4': 4, 
    '5': 5, 
    '6': 6, 
    '7': 7, 
}

def secondpass():

    #ٌ########Read and split lines###########
    # get file object
    f = open(sys.argv[1], "r")

    split_lines = []
    orig_lines = []
    while(True):
        # read next line
        line = f.readline()
        # if line is empty, you are done with all lines in the file
        if not line:
            break
        # you can access the line
        uppercase_line = line.upper()
        semicolon_removed = uppercase_line.strip().split(';')[0].replace(',', ' ')
        split_line = semicolon_removed.split()
        if len(split_line) == 0:
            continue
        split_lines.append(split_line)
        orig_lines.append(line)
    # close file
    f.close

    # addressing modes
    hex_codes = []
    codeArr = []
    for cnt, i in enumerate(split_lines):
        tempMem = []
        print(i)
        if i[0] not in operand_nums.keys():
            print('Syntax error in line', cnt, orig_lines[cnt])
            break
        if len(i) != operand_nums[i[0]] + 1:
            print('Syntax error in line', cnt, orig_lines[cnt])
            break
        if(len(i) == 1):
            codeArr.append(0)
            continue

        code = 0
        if len(i) == 3:

            #SOURCE
            if('@' in i[1]):
                # indirect
                code += 512
                i[1] = i[1].replace('@', '')

            if '+' in i[1]:
                code += 1024
                code += RSource[i[1].split('R')[1][0]]
            elif '-' in i[1]:
                code += 2048
                code += RSource[i[1].split('R')[1][0]]
            elif i[1][0] == 'R':
                code += 0
                code += RSource[i[1][1]]
            elif i[1][0] == '#':
                code += 1024
                code += RSource['7']
                temp = int(i[1][1: ])
                code_hex = format(temp, '04x')
                tempMem.append(code_hex.upper())
            else: #PC and indexed
                code += 3072 
                if 'R' in i[1]:
                    code += RSource[i[1].split('R')[1][0]]
                    pass
                    #????  
                else:
                    code += RSource['7']
                    pass
                    #????!!


            #DEST
            if('@' in i[2]):
                # indirect
                code += 8
                i[2] = i[2].replace('@', '')

            if '+' in i[2]:
                code += 16
                code += RDest[i[2].split('R')[1][0]]
            elif '-' in i[2]:
                code += 32
                code += RDest[i[2].split('R')[1][0]]
            elif i[2][0] == 'R':
                code += 0
                code += RDest[i[2][1]]
            elif i[2][0] == '#':
                code += 16
                code += RDest['7']
                temp = int(i[2][1: ])
                code_hex = format(temp, '04x')
                tempMem.append(code_hex.upper())
            else: #PC and indexed
                code += 48  
                if 'R' in i[2]: 
                    code += RDest[i[2].split('R')[1][0]]
                    pass
                else:
                    code += RDest['7']
                    pass 

        elif len(i) == 2:

            if i[0][0] == 'B':
                pass
            #DEST
            if '@' in i[1]:
                # indirect
                code += 8
                i[1] = i[1].replace('@', '')

            if '+' in i[1]:
                code += 16
                code += RDest[i[1].split('R')[1][0]]
            elif '-' in i[1]:
                code += 32
                code += RDest[i[1].split('R')[1][0]]
            elif i[1][0] == 'R':
                code += 0
                code += RDest[i[1][1]]
            elif i[1][0] == '#':
                code += 16
                code += RDest['7']
                temp = int(i[1][1: ])
                code_hex = format(temp, '04x')
                tempMem.append(code_hex.upper())
            else: #PC and indexed
                code += 48  
                if 'R' in i[1]: 
                    code += RDest[i[1].split('R')[1][0]]
                    pass
                else:
                    code += RDest['7']
                    pass 
        
        codeArr.append(code)

        if i[0] in opcodes_dict.keys():
            code_decimal = opcodes_dict[i[0]] + codeArr[cnt]
            code_hex = format(code_decimal, '04x')
            hex_codes.append(code_hex.upper())
            hex_codes = hex_codes + tempMem

    return hex_codes


def write_to_file(hex_codes):
    f = open(sys.argv[2], "w")
    for i in hex_codes:
        f.write(i + "\n")

    f.close


hex_codes = secondpass()
write_to_file(hex_codes)
