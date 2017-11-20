function [ Crm ] = find_rules( Crules,test_bins,class )


num_rules=size(Crules,1);
rules_feats=Crules;
rules_feats(:,1:7)=[];
num_feats=size(Crules,2) - 7;
set_rules_match=[];

    for j=1:num_rules
        temp=test_bins;
        for k=1:num_feats
            if rules_feats(j,k)==0
                temp(k)=0;
            end;
        end;
        if rules_feats(j,:)==temp;
            set_rules_match = [set_rules_match j];
        end;
    end;
    %set_rules_match
    Crm=Crules([set_rules_match],:); % set of rules that match test sample
