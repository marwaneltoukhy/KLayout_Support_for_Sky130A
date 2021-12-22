import sys
#input file
fin = open(sys.argv[1], "rt")
#output file to write the result to
fout = open(sys.argv[2], "wt")
#for each line in the input file
for line in fin:
	#read replace the string and write to output file
    
    if (line.startswith('X')):
        line = line.replace('X', 'M', 1)
    fout.write(line)
#close input and output files
fin.close()
fout.close()
