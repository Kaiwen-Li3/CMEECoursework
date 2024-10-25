import ipdb
import csv
import sys

#==================================================================================================
#orders sequences

def orderseqs(seq1,seq2):
    """Takes two sequences and orders them, shorter becoming s1, longer becoming s2
    
    args:
        seq1 (str)
        seq2 (str)
        
    returns:
        s1 (str): shorter sequence
        s2 (str): longer sequence
        l1 (int): length of s1
        l2 (int): length of s2"""
    

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
    """
    Calculate the alignment score of the two sequences, and provide visual representations
    
    args:
        s1 (str): shorter sequence
        s2 (str): longer sequence
        l1 (int): length of s1
        l2 (int): length of s2
        startpoint (int): the starting index for the alignments
        
    return:
        aligned_matched (str): a string representing where s2 / s1 match
        aligned_s2 (str): the longer sequence
        aligned_s1 (str): the shorter sequence, plus startpoint leading dots
        score (int): the number of matching bases in this alignment"""



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
    aligned_matched = ("." * startpoint + matched)     #first prints 'startpoint' amount of dots      
    aligned_s2 = ("." * startpoint + s2)
    aligned_s1 = (s1)
    print(score) 
    print(" ")
    
    return aligned_matched, aligned_s2, aligned_s1, score

#==================================================================================================
#main

def main(argv): 
    """
    Main function to read sequence data, calculate alignments and output results
    
    args:
        argv (list): list of command-line arguments
        
    outputs:
        writes best alignment result to align_seqs_result.csv"""

    seqs = []
    f = open('../data/align_seqs_data.csv','r')
    g = open('../results/align_seqs_result.csv','w',newline='')
    seqs = csv.reader(f)
    csvwrite = csv.writer(g)
    next(seqs) #skips header line

    for row in seqs: #for each row in _data.csv

        rowordered = (orderseqs(row[0],row[1])) #runs orderseqs on the current row

        #set up best variables for match, alignment, score 
        best_matched = None
        best_align = None
        best_score = -1
        

        for i in range(rowordered[2]): #tries all startpoints
            z = calculate_score(rowordered[0],rowordered[1],rowordered[2],rowordered[3],i) #runs calculate_score on the current startpoint
            if z[3] > best_score: #if the current startpoint surpasses the best score, make it the new best
                best_matched = z[0]
                best_align = "." * i + rowordered[1]
                best_score = z[3]

            #import ipdb; ipdb.set_trace()
                        

        final_result = (best_matched, best_align, rowordered[0], best_score)

        print("The highest score alignment is: ")
        for entry in final_result: #writes out each entry in final_result, line by line
            csvwrite.writerow([entry])
            print(entry)

    f.close()
    g.close()


#==================================================================================================

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)


