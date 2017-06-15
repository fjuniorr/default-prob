import openpyxl

wb = openpyxl.load_workbook('data-raw/pge_exec_orc_estados_1995_2013.xlsx')

type(wb)

sheets = wb.get_sheet_names()

sheet = wb.get_sheet_by_name(sheets[0])

sheet['A10'].value
sheet['A10'].row
sheet['A10'].column
sheet['A10'].coordinate

sheet.cell(row = 10, column = 10)


tuple(sheet['A1':'C3'])

for rowOfCellObjects in sheet['A1':'C3']:
    for cellObj in rowOfCellObjects:
        print(cellObj.coordinate, cellObj.value)