function [ sr ] = convert_ln( rule )
sr=sortrows(rule,5);
for i=1:size(rule,1)
    sr2=2^sr(i,1);
    if abs(sr(i,1))<100
        srln=log(sr2);
        sr(i,1)=srln;
    end;
end;