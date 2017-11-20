function [ rules ] = train_rules( train,Ethresh,h0 )
%determines rule set from quantized set of training data
% train: first column of train is the class, other columns are quantized
% feature values

%the alphabet is integer

%Ethresh = E threshold, if number of expected values in a cell is greater
%than or equal to Ethresh then generate rule;otherwise do not

%h0 = confidence level for adjusted residual; if dx > h0 then generate rule

numf=size(train,2);
N=size(train,1);
maxalpha=max(max(train));
A=train;

%find alphabet for each feature
%alpha is the alphabet of each feature
% the alphabet of feature 1 (i.e. class) is column 1
% the alphabet of feature 2  is column 2 ande so on
X(:,1:N)=0;
alpha=[];
for col=1:numf
    X=A(:,col);
    alphafeatS=find_alphabet(X);
    if length(alphafeatS)<maxalpha
        pad=maxalpha-length(alphafeatS);
        pad0(1:pad,1)=0;
        alphafeatL=[alphafeatS;pad0];
    else
        alphafeatL=alphafeatS;
    end;
    alpha=[alpha alphafeatL];
    pad0=[];
end;

%find rules
rules=[];
for order=2:numf
    combos=combntns(2:numf,order-1);
    for i=1:size(combos,1)
        numc=length(find(alpha(:,1))); %number of classes
        for c=1:numc
            s_train=[];
            pdf_wc=[];
            CLASS=alpha(c,1);
            s_train=[A(:,1) A(:,combos(i,:))];
            combos_c=[1 combos(i,:)]; %always include class as feature for rule generation
            prior=length(find(A(:,1)==CLASS))/N;
            rX=calc_rule(s_train,CLASS,alpha,combos_c,Ethresh,h0,prior); %pdf of features with class
            rules=[rules;rX];
        end;
    end;
end;














