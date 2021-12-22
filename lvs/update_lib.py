#! usr/bin/python

import sys

lib = open(sys.argv[1], "r")
lib2 = open(sys.argv[1], "r")
design = open(sys.argv[2], "r")

design_std_cells = []
for i in design:
    if i[0] == 'X':
        words = i.split()
        last_word = words[-1]
        if last_word not in design_std_cells:
            design_std_cells.append(last_word)

lines_to_delete = []
lines_to_delete2 = []

for num, i in enumerate(lib, 1):
    words = i.split()
    if words:
        if words[0] == '.subckt':
            if words[1].upper() in design_std_cells:
                lines_to_delete.append(num)

for lines in lines_to_delete:
    for num2, i2 in enumerate(lib2, lines):
        words = i2.split()
        if words:
            if words[0] == '.ends':
                lines_to_delete2.append(num2)
                break

with open('temp.txt', 'w') as fp:
    for i in range(len(lines_to_delete)):
        print(lines_to_delete[i], lines_to_delete2[i])

# print(len(lines_to_delete))
# print(len(lines_to_delete2))


# print(design_std_cells)