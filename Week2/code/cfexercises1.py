#!/usr/bin/env python3

"""Functions demonstrating control flow with if statements"""

__appname__ = "Cfexercises1"
__author__ = 'Kaiwen Li (kl2621@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = "Cool License"

import sys

#===============================================================================================================================
#All the foo_x functions should take arguments from the user 

#==================================================================================================


def foo_1(x=2):
    """returns x ^0.5 """
    return x ** 0.5

#==================================================================================================


def foo_2(x, y):
    """if x is more than y, return x, else return y"""
    if x > y:
        return x
    return y

#==================================================================================================


def foo_3(x=5, y=4, z=3):
    """if x is more than y, they switch values
if y is more than z, they switch values"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

#==================================================================================================


def foo_4(x=5):
    """1*2*3*4...*x = result"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

#==================================================================================================

#1*2*3*4...*x = result

def foo_5(x=5):
    """recursive function that calculates factorial of x"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     
#==================================================================================================


def foo_6(x): 
    """calculates factorial but with no if statements"""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto


#==================================================================================================


def main(argv):
    print(foo_1(2))
    print("\n")
    print(foo_2(4,5))
    print(foo_2(5,4))
    print("\n")
    print(foo_3(1,2,3))
    print(foo_3(5,4,6))
    print(foo_3(5,4,3))
    print("\n")
    print(foo_4(1))
    print(foo_4(5))
    print("\n")
    print(foo_5(1))
    print(foo_5(5))
    print("\n")
    print(foo_5(1))
    print(foo_6(5))
    return 0

#==================================================================================================

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)