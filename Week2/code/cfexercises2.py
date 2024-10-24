x = 5
y = 2

def hello_1(x):
    """goes from 0 to x, printing hello whenever j/3 has remainder 0
    
    args:
        x (int)"""
    for j in range(x):
        if j % 3 == 0:
            print('hello')
    print(' ')

hello_1(6)


#==================================================================================================


def hello_2(x):
    """goes from 0 to x, printing hello whenever j/5 or j/4 has remainder 0
    
    args:
        x (int)
        y (int)"""
    for j in range(x):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    print(' ')


hello_2(12)

#==================================================================================================

def hello_3(x, y):
    """goes from x to y, printing hello each iteration
    
    args:
        x (int)
        y (int)"""
    for i in range(x, y):
        print('hello')
    print(' ')

hello_3(3, 5)

#==================================================================================================

def hello_4(x):
    """if x is not 15, print hello then increase by 3
    
    args:
        x (int)"""
    while x != 15:
        print('hello')
        x = x + 3
    print(' ')

hello_4(0)

#==================================================================================================

def hello_5(x):
    """
    When x reaches 18, print hello
    When x reaches 31, print hello 7 times
    While x is less than 100, increase it by 1

    args:
        x (int)
    """
    while x < 100:
        if x == 31:
            for k in range(7):
                print('hello')
        elif x == 18:
            print('hello')
        x = x + 1
    print(' ')

#==================================================================================================

def hello_6(x, y):
    """
    Runs while x != 0
    If y is not 6, print "hello!" and y, then increase y by 1

    args:
        x (int)
        y (int)
    """
    while x: 
        print("hello! " + str(y))
        y += 1
        if y == 6:
            break
    print(' ')

hello_6(1, 3)