function [ rule_info ] = disp_calc_rule( train,C,alphabet,combos_c,Ethresh,h0,prior )
%TO BE USED TO DISPLAY RULES ONLY!!!!!!!!!!!!!!

%takes quantized training data and determines rules
% where the first column of train is always the class=f1
%the alphabet is integer; a zero in alphabet is just padding and does not
%indicate a character in the alphbet
% the alphabet of feature 1 (i.e. class) is column 1
% the alphabet of feature 2  is column 2 ande so on
dum=1;% dummy variable used to pad rules to match Andrew's format
maxf=size(alphabet,2);
al=alphabet(:,combos_c);
alphamax=max(al);
rule_info=[];
numf=size(train,2);
N=size(train,1);
A=train;
%find number of bins per feature
q(1:numf)=0;
for i=1:numf
    q(i)=length(find(al(:,i)));
end;

%get rid of zeros in alphabet
for f=1:numf
    evalal=['alpha',int2str(f),'=al(find(al(:,f)),f);'];
    eval(evalal);
end;



% calculate joint pdf with class
switch numf
    case 0
        error('empty training set')
    case 1
        error('need at least two features')
    case 2
        for f2=1:length(alpha2)
            of1=length(find((A(:,1)==C)));
            of2=length(find((A(:,2)==alpha2(f2))));
            e = N * (of1/N) * (of2/N);
            if e >= Ethresh % calc dx
                o=length(find((A(:,1)==C)&(A(:,2)==alpha2(f2))));
                d=calc_dx( o,e,N );
                if abs(d) >= h0  %generate rule
                    owc=length(find((A(:,2)==alpha2(f2))));
                    WOE  = calc_WOE(o,owc,prior,N  );
                    featvalues(1:maxf)=0;
                    for f=1:length(combos_c);
                        switch f
                            case 1
                                featvalues(combos_c(f))=C;
                            case 2
                                featvalues(combos_c(f))=alpha2(f2);
                        end;
                    end;                    
                    rule_info=[rule_info;dum WOE d  dum o e 2 featvalues];
                end;
            end;
        end;
    case 3
        for f2=1:length(alpha2)
            for f3=1:length(alpha3)
                of1=length(find((A(:,1)==C)));
                of2=length(find((A(:,2)==alpha2(f2))));
                of3=length(find((A(:,3)==alpha3(f3))));
                e = N * (of1/N) * (of2/N)* (of3/N);
                if e >= Ethresh % calc dx
                    o=length(find((A(:,1)==C)&(A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))));
                    d=calc_dx( o,e,N );
                    if abs(d) >= h0  %generate rule
                        owc=length(find((A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))));
                        WOE  = calc_WOE(o,owc,prior,N  );
                        featvalues(1:maxf)=0;
                        for f=1:length(combos_c);
                            switch f
                                case 1
                                    featvalues(combos_c(f))=C;
                                case 2
                                    featvalues(combos_c(f))=alpha2(f2);
                                case 3
                                    featvalues(combos_c(f))=alpha3(f3);
                            end;
                        end;
                        rule_info=[rule_info;dum WOE d  dum o e 3 featvalues];
                    end;
                end;
            end;
        end;
    case 4
        for f2=1:length(alpha2)
            for f3=1:length(alpha3)
                for f4=1:length(alpha4)
                    of1=length(find((A(:,1)==C)));
                    of2=length(find((A(:,2)==alpha2(f2))));
                    of3=length(find((A(:,3)==alpha3(f3))));
                    of4=length(find((A(:,4)==alpha4(f4))));
                    e = N * (of1/N) * (of2/N)* (of3/N)* (of4/N);
                    if e >= Ethresh % calc dx
                        o=length(find((A(:,1)==C)&(A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))&(A(:,4)==alpha4(f4))));
                        d=calc_dx( o,e,N );
                        if abs(d) >= h0  %generate rule
                            owc=length(find((A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))&(A(:,4)==alpha4(f4))));
                            WOE  = calc_WOE(o,owc,prior,N  );
                            featvalues(1:maxf)=0;
                            for f=1:length(combos_c);
                                switch f
                                    case 1
                                        featvalues(combos_c(f))=C;
                                    case 2
                                        featvalues(combos_c(f))=alpha2(f2);
                                    case 3
                                        featvalues(combos_c(f))=alpha3(f3);
                                    case 4
                                        featvalues(combos_c(f))=alpha4(f4);
                                end;
                            end;
                            rule_info=[rule_info;dum WOE d  dum o e 4 featvalues];
                        end;
                    end;
                end;
            end;
        end;
    case 5
        for f2=1:length(alpha2)
            for f3=1:length(alpha3)
                for f4=1:length(alpha4)
                    for f5=1:length(alpha5)
                        of1=length(find((A(:,1)==C)));
                        of2=length(find((A(:,2)==alpha2(f2))));
                        of3=length(find((A(:,3)==alpha3(f3))));
                        of4=length(find((A(:,4)==alpha4(f4))));
                        of5=length(find((A(:,5)==alpha5(f5))));
                        e = N * (of1/N) * (of2/N)* (of3/N)* (of4/N)* (of5/N);
                        if e >= Ethresh % calc dx
                            o=length(find((A(:,1)==C)&(A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))&(A(:,4)==alpha4(f4))&...
                            (A(:,5)==alpha5(f5))));
                            d=calc_dx( o,e,N );
                            if abs(d) >= h0  %generate rule
                                owc=length(find((A(:,2)==alpha2(f2))&(A(:,3)==alpha3(f3))&(A(:,4)==alpha4(f4))));
                                WOE  = calc_WOE(o,owc,prior,N  )
                                featvalues(1:maxf)=0;
                                for f=1:length(combos_c);
                                    switch f
                                        case 1
                                            featvalues(combos_c(f))=C;
                                        case 2
                                            featvalues(combos_c(f))=alpha2(f2);
                                        case 3
                                            featvalues(combos_c(f))=alpha3(f3);
                                        case 4
                                            featvalues(combos_c(f))=alpha4(f4);
                                        case 5
                                            featvalues(combos_c(f))=alpha5(f5);
                                    end;
                                end;
                                rule_info=[rule_info;dum WOE d  dum o e 5 featvalues];
                            end;
                        end;
                    end;
                end;
            end;
        end;
    otherwise
        error('5 is the highest number of features inlcuding class calc_rule can handle')
end;

%{
z = (o - e)/sqrt(e);
v = 1 - ((of1/N)*(of2/N));
d = z/sqrt(v);
%}
                    %{
                    if (o~=0)
                        if (o~=owc)
                            WOE=log2((o/N)*(1-prior)/(prior*((owc/N)-o/N)));
                        else
                            WOE=10000;
                        end;
                    else
                        WOE=-10000;
                    end;
                    %}




