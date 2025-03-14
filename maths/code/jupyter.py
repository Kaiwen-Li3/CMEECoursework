from sympy import *
x = var('x', real=True)
type(x)
x.is_imaginary



MyFun = (pi + x)**2; MyFun

MyFun = N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((N_max - N_0) * log(10)) + 1))