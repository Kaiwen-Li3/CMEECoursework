#!/usr/bin/env python3
__appname__ = "Boilerplate"
__author__ = "Kaiwen Li (kl2621@ic.ac.uk)"
__version__ = "0.0.1"
__license__ = "Cheese burger"

import sys

def main(argv):
    """ Main entry point of the program """
    print('This is a boilerplate')
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)





