import sys
import re
import numpy as np

memory = ['0000'] * 2048
addresses = []
orig_lines = []


def CheckWords(word, labelsArr):
    pattern1 = re.findall(r'[0-9]+\(', word)
    pattern2 = re.findall(r'#[0-9]+', word)
    pattern3 = re.findall(r'^[0-9]+$', word)

    pattern4 = word in labelsArr

    return len(pattern1) or len(pattern2) or len(pattern3) or pattern4


def firstPass():
    #ٌ########Read and split lines###########
    # get file object

    branches = ["BR", "BEQ", "BNE", "BLO", "BLS", "BHI", "BHS"]
    labelsArr = []
    labelsDic = dict()

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
        uppercase_line = uppercase_line.replace(",", " ")
        semicolon_removed = uppercase_line.strip().split(';')[0]
        if(semicolon_removed.find(':') != -1):
            labelsArr.append(semicolon_removed.strip().split(':')[0])

        if(semicolon_removed.split(" ")[0] == "DEFINE"):
            labelsArr.append(semicolon_removed.split(" ")[1])    

        split_line = semicolon_removed.split()
        if len(split_line) == 0:
            continue
        split_lines.append(split_line)
        orig_lines.append(line)
    # close file
    f.close()

    nextAddres = 0
    deletedLines = []
    for i, line in enumerate(split_lines):
        if line[0] == '.=':
            nextAddres = int(line[1])
            deletedLines.append(line)
            continue
        if len(line) == 1:
            if line[0].replace(':', '') not in labelsArr:
                addresses.append(nextAddres)
                nextAddres += 1
            else:
                split_lines[i+1] = line + split_lines[i+1]
                deletedLines.append(line)

        elif len(line) == 2:
            if line[0].replace(':', '') in labelsArr:
                addresses.append(nextAddres)
                labelsDic[line[0].replace(":", "")] = nextAddres
                nextAddres += 1
                line.remove(line[0])
            elif line[0] in branches:
                addresses.append(nextAddres)
                nextAddres += 1
            else:
                addresses.append(nextAddres)
                nextAddres += 1 + CheckWords(line[1], labelsArr)

        elif len(line) == 3:
            if line[0] == "DEFINE":
                    memory[nextAddres] = format(int(line[2]), '04x')
                    labelsDic[line[1]] = nextAddres
                    nextAddres += 1
                    deletedLines.append(line)
            elif line[0].replace(':', '') in labelsArr:
                if line[1] in branches:
                    addresses.append(nextAddres)
                    labelsDic[line[0].replace(":", "")] = nextAddres
                    nextAddres += 1
                    line.remove(line[0])
                else:
                    addresses.append(nextAddres)
                    labelsDic[line[0].replace(":", "")] = nextAddres
                    nextAddres += 1 + CheckWords(line[2], labelsArr)
                    line.remove(line[0])
            else:
                addresses.append(nextAddres)
                nextAddres += 1 + \
                    CheckWords(line[1], labelsArr) + \
                    CheckWords(line[2], labelsArr)

        elif len(line) == 4:
            addresses.append(nextAddres)
            labelsDic[line[0].replace(":", "")] = nextAddres
            nextAddres += 1 + \
                CheckWords(line[2], labelsArr) + CheckWords(line[3], labelsArr)
            line.remove(line[0])

    for line in deletedLines:
        split_lines.remove(line)

    for line in split_lines:
        for i, word in enumerate(line):
            if word in labelsArr:
                line[i] = labelsDic[word]

    return split_lines

# print(firstPass())
# print(addresses)
# print(memory[0:30])

# @TODO
# 1- Add offset to branch instructions

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


def secondpass(split_lines):

    # addressing modes
    codeArr = []
    for cnt, i in enumerate(split_lines):
        tempMem = []
        if i[0] not in operand_nums.keys():
            print('Syntax error in line', cnt+1, orig_lines[cnt])
            break
        if len(i) != operand_nums[i[0]] + 1:
            print('Syntax error in line', cnt+1, orig_lines[cnt])
            break

        code = 0
        if len(i) == 3:

            i[1] = str(i[1])
            i[2] = str(i[2])
           # SOURCE
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
                temp = int(i[1][1:])
                code_hex = format(temp, '04x')
                tempMem.append(code_hex.upper())
            else:  # PC and indexed
                code += 3072
                if 'R' in i[1]:
                    code += RSource[i[1].split('R')[1][0]]
                    temp = int(i[1].split('(')[0])
                    code_hex = format(temp, '04x')
                    tempMem.append(code_hex.upper())
                    
                else:
                    code += RSource['7']
                    temp = int(i[1])
                    code_hex = format(temp, '04x')
                    tempMem.append(code_hex.upper())
                    

            # DEST
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
                temp = int(i[2][1:])
                code_hex = format(temp, '04x')
                tempMem.append(code_hex.upper())
            else:  # PC and indexed
                code += 48
                if 'R' in i[2]:
                    code += RDest[i[2].split('R')[1][0]]
                    temp = int(i[2].split('(')[0])
                    code_hex = format(temp, '04x')
                    tempMem.append(code_hex.upper())
                    
                else:
                    code += RDest['7'] 
                    temp = int(i[2])
                    code_hex = format(temp, '04x')
                    tempMem.append(code_hex.upper())

        elif len(i) == 2:
            
            i[1] = str(i[1])
            if i[0][0] == 'B':
                offset = int(i[1]) - addresses[cnt]
                if offset > 127 or offset < -128:
                    print('Logical error cannot jump to location in line', cnt+1, orig_lines[cnt])
                    break
                #SEE HOW TO PUT THE NEGATIVE
                if offset < 0:
                    offset = 255 + offset
                code += offset
            else:
                # DEST
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
                    temp = int(i[1][1:])
                    code_hex = format(temp, '04x')
                    tempMem.append(code_hex.upper())
                else:  # PC and indexed
                    code += 48
                    if 'R' in i[1]:
                        code += RDest[i[1].split('R')[1][0]]
                        temp = int(i[1].split('(')[0])
                        code_hex = format(temp, '04x')
                        tempMem.append(code_hex.upper())
                        
                    else:
                        code += RDest['7']
                        temp = int(i[1])
                        code_hex = format(temp, '04x')
                        tempMem.append(code_hex.upper())

        codeArr.append(code)
        if i[0] in opcodes_dict.keys():
            code_decimal = opcodes_dict[i[0]] + codeArr[cnt]
            code_hex = format(code_decimal, '04x')
            memory[addresses[cnt]] = code_hex.upper()

        for i, obj in enumerate(tempMem):
            memory[addresses[cnt]+i+1] = tempMem[i]

    return


def write_to_file():
    f = open('memory.mem', "w")
    f.write("// instance=/ram/ram\n")
    f.write("// format=mti addressradix=d dataradix=h version=1.0 wordsperline=1\n")
    for index, i in enumerate(memory):
        f.write(str(index) + ": "+ i + "\n")

    f.close()


first_pass_lines = firstPass()
secondpass(first_pass_lines)
write_to_file()
