import xlsxwriter 

SrcDicClk = {
    'R0'        : 3,
    '@R0'       : 4,
    '(R0)+'     : 5,
    '@(R0)+'    : 6,
    '-(R0)'     : 5,
    '@-(R0)'    : 6,
    'X(R0)'     : 7,
    '@X(R0)'    : 8
}

DestDicClk = {
    'R0'        : 5,
    '@R0'       : 7,
    '(R0)+'     : 8,
    '@(R0)+'    : 9,
    '-(R0)'     : 8,
    '@-(R0)'    : 9,
    'X(R0)'     : 10,
    '@X(R0)'    : 11
}

SrcDic = {
    'R0'        : 0,
    '@R0'       : 1,
    '(R0)+'     : 1,
    '@(R0)+'    : 2,
    '-(R0)'     : 1,
    '@-(R0)'    : 2,
    'X(R0)'     : 2,
    '@X(R0)'    : 3
}

DestDic = {
    'R0'        : 0,
    '@R0'       : 2,
    '(R0)+'     : 2,
    '@(R0)+'    : 3,
    '-(R0)'     : 2,
    '@-(R0)'    : 3,
    'X(R0)'     : 3,
    '@X(R0)'    : 4
}


workbook = xlsxwriter.Workbook('PDP_11.xlsx') 
worksheet = workbook.add_worksheet("Memory Accesses") 
row, col = 0, 0
worksheet.write(row, col, 'Instruction') 
worksheet.write(row, col + 1, 'Source')
worksheet.write(row, col + 2, 'Destination')
worksheet.write(row, col + 3, 'Num Accesses')
worksheet.write(row, col + 4, 'Clock Cycles')

for i in SrcDic.keys():
    for j in DestDic.keys(): 
        row += 1
        worksheet.write(row, col, 'MOV') 
        worksheet.write(row, col + 1, i)
        worksheet.write(row, col + 2, j)
        worksheet.write(row, col + 3, SrcDic[i]+DestDic[j] + 1)
        worksheet.write(row, col + 4, SrcDicClk[i]+DestDicClk[j] + 4)

row += 1
for j in DestDic.keys(): 
    row += 1
    worksheet.write(row, col, 'INC') 
    worksheet.write(row, col + 2, j)
    worksheet.write(row, col + 3, DestDic[j] + 1)
    worksheet.write(row, col + 4, DestDicClk[j] + 4)

workbook.close() 