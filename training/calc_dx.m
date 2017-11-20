function [ d ] = calc_dx( o,e,N )
z = (o - e)/sqrt(e);
v = 1 - (e/N);
d = z/sqrt(v);

