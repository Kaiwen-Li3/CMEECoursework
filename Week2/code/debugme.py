def buggyfunc(x):
    """This function aims to divide x by y. With each iteration, y decreases by 1, until y becomes 0, causing a zerodivisionerror."""
    y = x
    
    for i in range(x):
        try: 
            y = y-1
            z = x/y

        #error handling
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work;{x = }; {y = }")
        else:
            print(f"OK; {x = }; {y = }, {z = };")
    return z

buggyfunc(20)