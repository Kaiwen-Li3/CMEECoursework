import numpy as np
#sudo apt install python3-numpy


a = np.array(range(5)) # a one-dimensional array
a

print(type(a))

print(type(a[0]))

a = np.array(range(5), float)
a
a.dtype

x = np.arange(5.) #directly specify float using decimal
x

x.shape

b = np.array([i for i in range(10) if i % 2 == 1])
b

c = b.tolist()
c

mat = np.array([[0,1],[2,3]])
mat
mat.shape

mat[1]
mat[:,1]

mat[0,0]
mat[1,0]

mat[:,0]
mat[0,1]
mat[0,-1]
mat[-1,0]

mat[0,0] = -1
mat
mat[:,0]

