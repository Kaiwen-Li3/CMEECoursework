#Variable_scope


i = 1
x = 0
for i in range(10):
    x += 1
print(i)
print(x)


i=1
x=0
def a_function(y):
    x = 0
    for i in range(y):
        x += 1
a_function(10)
print(i)
print(x)
# 1, 0
#i and x did not get updated in your workspace despite the fact they were within the function
#scope of variables inside a function is restricted to within that function



#==================================================================
#global_variables

_a_global = 10

if _a_global >= 5:
    _b_global = _a_global + 5

print("Before calling a_function, outside the function, the value of _a_global is", _a_global)
print("Before calling a_function, outside the function, the value of _b_global is", _b_global)

def a_function():
    _a_global = 4 # a local variable
    
    if _a_global >= 4:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 3
    
    print("Inside the function, the value of _a_global is", _a_global)
    print("Inside the function, the value of _b_global is", _b_global)
    print("Inside the function, the value of _a_local is", _a_local)
    
a_function()

print("After calling a_function, outside the function, the value of _a_global is (still)", _a_global)
print("After calling a_function, outside the function, the value of _b_global is (still)", _b_global)
print("After calling a_function, outside the function, the value of _a_local is ", _a_local)


#==================================================================
#return_directive

def modify_list_1(some_list):
    print('got', some_list)
    some_list = [1,2,3,4]
    print('set to', some_list)

my_list = [1,2,3]
print('before, my_list = ', my_list)

modify_list_1(my_list)
print('after, my_list = ', my_list)
#original list remains the same even though it's changed inside the function

def modify_list_2(some_list):
    print('got', some_list)
    some_list = [1,2,3,4]
    print('set to', some_list)
    return some_list

my_list = modify_list_2(my_list)
print('after, my_list = ', my_list)
#returns changed list 


#==================================================================
#input_output

#############################
# FILE INPUT
#############################
# Open a file for reading
f = open('../sandbox/test.txt', 'r')
# use "implicit" for loop:
# if the object is a file, python will cycle over lines
for line in f:
    print(line)

# close the file
f.close()

# Same example, skip blank lines
f = open('../sandbox/test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()



##List_Comprehensions

## Finds just those taxa that are oak trees from a list of species

taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
       ]

def is_an_oak(name):
    return name.lower().startswith('quercus ')

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehensions   
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
