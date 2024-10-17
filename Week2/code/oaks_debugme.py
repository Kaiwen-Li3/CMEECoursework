import csv
import sys
import doctest

#==================================================================================================


#Define function
def is_an_oak(name):
    """ Returns True if name starts with 'quercus' 
    >>> is_an_oak('Fagus sylvatica')
    False
    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('Quercuss robur')
    False
    """
    name = name.lower()
    return name.startswith('quercus') and (len(name) == len('quercus') or name[len('quercus')] == ' ')
    #checks name starts with 'quercus'
    #also checks if the name is 'quercus' exactly or the character after 'quercus' is a space
    
 #==================================================================================================


def main(argv): 
    f = open('../data/TestOaksData.csv','r')
    g = open('../results/oaks_debugme_results.csv','w')

    taxa = csv.reader(f)
    csvwrite = csv.writer(g)

    next(taxa) #skip header row
    oaks = set() #oaks will be a set of unique species

    for row in taxa:
        print(row)
        print ("The genus is: ", row[0]) 

        if is_an_oak(row[0]):
            rowfullname = row[0] + " " + row[1]
            if rowfullname not in oaks: #prevents duplicate oak species from showing up
                print(rowfullname, " is an oak! \n")
                csvwrite.writerow([row[0], row[1]])
                oaks.add(rowfullname) 
        else:
            rowfullname = row[0] + " " + row[1]
            print(rowfullname, "is not an oak! \n")    

    return 0

#==================================================================================================
    
if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)



doctest.testmod()