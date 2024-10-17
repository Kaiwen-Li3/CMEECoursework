# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

print("\n")

hundred_plus_months = [month for month in rainfall if month[1] > 100]
print("Months and rainfall values when rainfall was less than 100mm: ", hundred_plus_months)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

print("\n")

fifty_less_months = [month[0] for month in rainfall if month[1] < 50]
print("Months when rainfall was less than 50mm: ", fifty_less_months)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

print("\n")

hundred_loops = []
for month in rainfall:
    if month[1] > 100:
        hundred_loops.append(month)
print("Months and rainfall values when rainfall was less than 100mm: ", hundred_loops)

fifty_loops = []
for month in rainfall:
    if month[1] < 50:
        fifty_loops.append(month[0])
print("Months when rainfall was less than 50mm: ", fifty_loops)



# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

