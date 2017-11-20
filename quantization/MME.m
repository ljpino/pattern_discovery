function [ intvl ] = MME( column,n )
%[ intvl ] = MME( column,n )
%Marginal maximum entropy quantization of 
%n = number of bins
count=[];
NSI=floor(length(column)/n);
A=sortrows(column);
intvl=[];
        
intvl(1,:)=[-10000 A(NSI)];
for i=2:n-1
    intvl=[intvl;A((i-1)*NSI) A(i*NSI)];
end;
intvl=[intvl; A((n-1)*NSI)  100000];



end
