taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 
taxa_dic = {}
for species, order in taxa:
    if order not in taxa_dic:
        taxa_dic[order] = []
    taxa_dic[order].append(species)

for order, species_list in taxa_dic.items():
    print(f"{order}: {', '.join(species_list)}")



# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  


#### Your solution here #### 
taxa_dic = {order: [species for species, o in taxa if o == order] for _, order in taxa}
#dictionary comprehension:
#{key: [value for]} where value is a list comprehension:
#[species for species, o in taxa if o == order] the input taxa is a list of tuples, where each tuple has two elements, species and order
#o == order ensures only taxa whose order matches the order used as the key in the dictionary
# for _, order in taxa: for each tuple in taxa, the second element (order) becomes a key in the dictionary


for order, species_list in taxa_dic.items():
    print(f"{order}: {', '.join(species_list)}")