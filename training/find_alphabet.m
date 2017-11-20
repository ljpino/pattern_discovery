function [ Label ] = find_alphabet( X )
%finds integer labels of features and returns cell
%X is a column array of all integer quantized values of the feature

sX=sort(X);
Label=sX(1);
for i=2:length(X)
    B=sX(i);
    flag=0;
    for j=1:size(Label)
        if Label(j)==B
            flag=1;
        end;
    end;
    if flag == 0
        Label=[Label;B];
    end;
end;


