birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 




latin_names = [species[0] for species in birds]
common_names = [species[1] for species in birds]
mean_body_masses = [species[2] for species in birds]
print("Latin names: ", latin_names, "\n Common names: ", common_names, "\n Mean body masses: ", mean_body_masses)


# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

print("\n")

latin_loop = []
common_loop = []
mass_loop = []

for species in birds:
    latin_loop.append(species[0])
for species in birds:
    common_loop.append(species[1])
for species in birds:
    mass_loop.append(species[2])


print("Latin names: ", latin_loop, "\n Common names: ", common_loop, "\n Mean body masses: ", mass_loop)



# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 