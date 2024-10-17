import ipdb
import csv
import sys

#==================================================================================================

def orderseqs(seq1,seq2):
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths



    return s1,s2,l1,l2

#==================================================================================================
#calculate_score: 

def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    import ipdb; ipdb.set_trace()

    # some formatted output
    aligned_matched = ("." * startpoint + matched)           
    aligned_s2 = ("." * startpoint + s2)
    aligned_s1 = (s1)
    print(score) 
    print(" ")
    

    return aligned_matched, aligned_s2, aligned_s1, score

#==================================================================================================

def main(argv): 
    seqs = []
    f = open('../data/align_seqs_data.csv','r')
    g = open('../results/align_seqs_result.csv','w',newline='')
    seqs = csv.reader(f)
    csvwrite = csv.writer(g)
    next(seqs)

    for row in seqs:
        rowordered = (orderseqs(row[0],row[1]))

        #set up best variables for match, alignment, score 
        best_matched = None
        best_align = None
        best_score = -1
        



        for i in range(rowordered[2]):
            z = calculate_score(rowordered[0],rowordered[1],rowordered[2],rowordered[3],i)
            if z[3] > best_score:
                best_matched = z[0]
                best_align = "." * i + rowordered[1]
                best_score = z[3]

            #import ipdb; ipdb.set_trace()
                
                

        final_result = (best_matched, best_align, rowordered[0], best_score)

        print("The highest score alignment is: ")
        for entry in final_result:
            csvwrite.writerow([entry])
            print(entry)

    f.close()
    g.close()


#==================================================================================================

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)


