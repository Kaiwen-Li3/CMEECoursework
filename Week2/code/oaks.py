taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
       ]

def is_an_oak(name):
    return name.lower().startswith('quercus ')

oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

#list comprehension
oaks_lc = set ([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())

oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)