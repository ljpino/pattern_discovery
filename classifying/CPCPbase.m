function [ p ] = CPCPbase( base,prior,W )
%[ p ] = CPCPbase( base,prior,W )
norm=(1 - prior)/prior;
p=1/((norm/(base^W + eps))+1);
end