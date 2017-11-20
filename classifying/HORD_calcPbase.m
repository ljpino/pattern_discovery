function [ Pout ] = HORD_calcPbase( base,prior,test, rules,bindef,class )
num_feats=size(rules,2) - 7;
    
for i=1:size(test,1)
%    i
test_bins=[];  
    for j=1:num_feats
        interval_nums = ['a = bin_finder(',int2str(j),', test(i,',int2str(j+1),'),bindef);'];
        eval(interval_nums);
        test_bins=[test_bins a]; %bins that the test sample falls into
    end;
    W=HORD_Class(rules,test_bins,class);
    %{
    if abs(Wo) < 0.2
        W=0;
    else
        W=Wo;
    end;
    %}
    [P(i)]=CPCPbase(base,prior,W);
end;
Pout=P';
