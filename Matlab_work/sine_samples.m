clc;
w=linspace(0,2*3.14,64)
x=sin(w);
plot(x)
y=100*x+100;
plot(y)
samples_in_int=uint8(y)
samples_in_int';

