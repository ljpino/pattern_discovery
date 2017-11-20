function [ numint ] = bin_finder(fnum,x,bindef )  
%[ numint ] = bin_finder(fnum,x,bindef ) 
%bin_finder(fnum,x,bindef ) 
%fnum = feature number
%x feature value
%bindef = definition of bin boundaries
numint=[];
intf=bindef(find(bindef(:,1)==fnum),:);
numbins=size(intf,1);
if x>intf(numbins,4)
    fnum
    x
    bindef
    error('binfinder error: feature value exceeds upper bin limit')
end;
if intf(1,2)==1
    %feature is real
    for i=1:numbins
        if (x>intf(i,3))&(x<=intf(i,4))
            numint=i;
            return;
        end;
    end;
else
    %feature is integer
    for i=1:numbins
        if (x>=intf(i,3))&(x<=intf(i,4))
            numint=i;
            return;
        end;
    end;
end;
if isempty(numint)==1
    fnum
    x
    bindef
end;
