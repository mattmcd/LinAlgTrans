function x=fooSolve( A, b)
x=A\b
end

A=rand(10);
b=rand(10,1);
x=fooSolve( A, b);
