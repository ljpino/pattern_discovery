function [ WOE ] = calc_WOE(o,owc,prior,N  )
if (o~=0)
    if (o~=owc)
        WOE=log2((o/N)*(1-prior)/(prior*((owc/N)-o/N)));
    else
        WOE=10000;
    end;
else
    WOE=-10000;
end;
