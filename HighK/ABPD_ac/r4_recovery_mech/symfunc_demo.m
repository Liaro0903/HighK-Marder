clear; close all;

fun_handle = @(V,Ca)1.0./(1.0+exp((V+25.5+0)./-5.29));
syms x y;
f_symbolic = symfun(fun_handle(x, y), [x, y]);
eqn = f_symbolic == 0.5;
S = solve(eqn, x);
