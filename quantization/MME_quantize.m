function [bindef]=MME_quantize(train_data,featindex,Q)
%[bindef]=MME_quantize(train_data,featindex,Q)
%{
    featindex numbers:   
     Column    Feature
     ------     -------
        1       PP_amp
        2       PP_risetime
        3       duration
        4       area
        5       thickness
        6       size_index
        7       phases
        8       turns
        9       frequency
        10      spike_dur
%}
bindef=[];
numfeats=length(featindex);
numfeats_train=size(train_data,2);
if numfeats~=numfeats_train
    error('number of features in training data does not match number of features in featindex')
end
%{
for f=1:numfeats
        [intvl]=MME(train_data(:,f),Q);
        for i=1:size(intvl,1);
            bindef=[bindef;featindex(f) 1 intvl(i,:)];
        end;
end;
%}

%{
for f=1:numfeats
    if (featindex(f)==7)|(featindex(f)==8)
        bindef=[bindef;featindex(f) 0 0 5];
        bindef=[bindef;featindex(f) 0 5 100000];
    else
        [intvl]=MME(train_data(:,f),Q);
        for i=1:size(intvl,1);
            bindef=[bindef;featindex(f) 1 intvl(i,:)];
        end;
    end;
end;
%}

%{
for f=1:numfeats
    if (featindex(f)==7)
        bindef=[bindef;featindex(f) 0 0 2];
        bindef=[bindef;featindex(f) 0 2 100000];
    else if   (featindex(f)==8)
        bindef=[bindef;featindex(f) 0 0 8];
        bindef=[bindef;featindex(f) 0 8 100000];
        else
            [intvl]=MME(train_data(:,f),Q);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        end;
    end;
end;
%}


for f=1:numfeats
    switch featindex(f)
         
        case 2
             bindef=[bindef;featindex(f) 1 -100000 0.4];
            bindef=[bindef;featindex(f) 1 0.4    0.8];
            bindef=[bindef;featindex(f) 1 0.8    100000];

 %{
            bindef=[bindef;featindex(f) 1 -100000 0.2];
            bindef=[bindef;featindex(f) 1 0.2    0.4];
            bindef=[bindef;featindex(f) 1 0.4    0.6];
            bindef=[bindef;featindex(f) 1 0.6    1.2];
            bindef=[bindef;featindex(f) 1 1.2    100000];
            
        case 3
   
            bindef=[bindef;featindex(f) 1 -100000 3.4];
            bindef=[bindef;featindex(f) 1 3.4 5.4];
            bindef=[bindef;featindex(f) 1 5.4   8];
            bindef=[bindef;featindex(f) 1 8   100000];
          %}
        case 7
            bindef=[bindef;featindex(f) 0 0 2];
            bindef=[bindef;featindex(f) 0 3 100000];
        case 8
            bindef=[bindef;featindex(f) 0 0 8];
            bindef=[bindef;featindex(f) 0 9 100000];
        otherwise
            [intvl]=MME(train_data(:,f),Q);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
    end;
end;

%{
for f=1:numfeats
    switch featindex(f)
        case 1
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        case 2
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        case 3
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;

        case 4
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        case 5
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        case 6 
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;    
        case 7
            bindef=[bindef;featindex(f) 0 0 2];
            bindef=[bindef;featindex(f) 0 2 100000];
        case 8
            bindef=[bindef;featindex(f) 0 0 8];
            bindef=[bindef;featindex(f) 0 8 100000];
        case 9
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;
        case 10
            [intvl]=MME(train_data(:,f),5);
            for i=1:size(intvl,1);
                bindef=[bindef;featindex(f) 1 intvl(i,:)];
            end;

        otherwise
            error('wrong feature number')
    end;
end;
%}