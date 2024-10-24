"""
This code saves numbers 1-100 to a txt file, each number being a line
"""

list_to_save = range(100)

f = open("../sandbox/testout.txt", "w")
for i in list_to_save:
    f.write(str(i) + '\n')

f.close()