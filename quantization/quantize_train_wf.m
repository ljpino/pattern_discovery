function [ trainQ ] = quantize_train_wf( train, featset,bindef )
%quantize training data without generating text file

train_woC=train;
class_col=train_woC(:,1);
train_woC(:,1)=[];

%quantize training data
trainQA=[];
for i=1:size(train_woC,1)
    for f=1:length(featset)
        trainQA(i,f)=bin_finder(featset(f),train_woC(i,f),bindef );
    end;
end;
trainQ=[class_col trainQA];