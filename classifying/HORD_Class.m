function [ W ] = HORD_Class(rules,test_bins,class);

%calculate WOE starting with highest order pattern first
MSP=[];
a_patterns=[];
W=0;
num_feats=size(rules,2) - 7;
ord=num_feats;

if size(rules,1)==0
    W=0;
    disp('HORD_Class: no rules found')
    return;
end;
Crules=rules(find(rules(:,7)==class),:);
Crm=find_rules( Crules,test_bins,class ); % set of rules that match test sample
if length(Crm)==0
    W=0;
   % display(['no rules fired for test data: ',int2str(class),'  ',int2str(test_bins)])
    return;
end;

%while ord > 1
while (1)
    Crm=find_rules( Crules,test_bins,class ); % set of rules that match test sample
    %    therules=Crm(:,[1 6])
    if length(Crm) > 0
        %sort on order
        sortC=sortrows(Crm,6);
        h_order_C=sortC(end,6);
        
        %find probability for highest order pattern match for class
        %for patterns of the same order choose probability with pattern with highest d
        for order=h_order_C:-1:1
            patterns=sortC(find(sortC(:,6)==order),:);
            s_patterns=sortrows(patterns,2);
            if length(s_patterns) > 0
                beg_d=abs(s_patterns(1,2));
                end_d=abs(s_patterns(end,2));
                if end_d > beg_d
                    W= W + s_patterns(end,2);
                    MSP=[MSP;s_patterns(end,:)];
                    temp_pat=s_patterns(end,:);
                else
                    W= W + s_patterns(1,2);
                    MSP=[MSP;s_patterns(1,:)];
                    temp_pat=s_patterns(1,:);
                end;
                break;
            end;
        end;
    else
        break;
    end;
    temp_pat(:,1:7)=[];
    for k=1:num_feats
        if temp_pat(k)~=0
            test_bins(k)=0;
        end;
    end;
    set_rules_match=[];
    ord=length(find(temp_pat));
end;
