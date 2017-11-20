function [MUSres] = Classify_Kclass( train,rules,bindef,featset,test_in,mus_set_test,Labels,classifier_name,DO_AVG_MUP_CHAR)


%{
colums of data produced by load_simdata_JAN08( ) are:
Class_label
Muscle Number
Severity
Age
mu_nr
side
MupNo
nr_of_mups_in_avg
PP_amp
PP_risetime
duration
area
thickness
size_index
phases
turns
frequency
spike_dur
%}

%INPUTS
%{
- foldnum: index to patients excluded from training for cross-fold validation
- patnum_validation: [a b] vector of patient numbers exluded from training
but included in validation starting at a and ending in b
- featset: set of features in PODNAR data to include

Feature numbers:
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


OUTPUTS
-------
- train_"foldnum" - used as input to PDtrain
%}


format short g
MUSres=[];

%translate bindef featnumbers into consecutive integers for HORD_calcP
bindefA=[];
for f=1:length(featset)
    bindeftemp=bindef(find(bindef(:,1)==featset(f)),:);
    bindeftemp(1:size(bindeftemp,1),1)=f;
    bindefA=[bindefA;bindeftemp];
end;

Pfill=[];% when no test is done Pfill fills 19 for all probabilities
for c=1:length(Labels) + 1
    Pfill=[Pfill 19];
end;

for cl=1:length(Labels)
    trow=mus_set_test(cl,:);
    testrow=trow(find(trow));
    for k=1:length(testrow)
        [test] = get_KTEST_data( test_in,testrow(k),Labels(cl),featset);
        if ~isempty(test)
            if size(test,1)> 0
                switch classifier_name
                    case 'PD'
                        PTOT=0;
                        P=[];
                        for c=1:length(Labels)
                            evalPa=['[ Pa',int2str(c),' ] = HORD_calcPbase(2,0.5, test, rules,bindefA,Labels(c) );'];
                            eval(evalPa);
                            evalPTOT=['PTOT = PTOT + Pa',int2str(c),';'];
                            eval(evalPTOT);
                        end;
                        for c=1:length(Labels)
                            evalP=['P',int2str(c),'= Pa',int2str(c),'./PTOT;'];
                            eval(evalP);
                            evalPall=['P = [P P',int2str(c),'];'];
                            eval(evalPall);
                        end;
                        if DO_AVG_MUP_CHAR == 1
                            PMUS=mean(P,1); %arithmetic mean of conditional probabilities
                        else
                            [PMUS]=calcK_MUSprob_bayes(P); %bayesian aggregation of conditional probabilities
                        end;
                    case 'LDA_ged'
                        [P]=runGED_LDA_Kclass(train,test);
                        if DO_AVG_MUP_CHAR == 1
                            PMUS=mean(P,1); %arithmetic mean of conditional probabilities
                        else
                            [PMUS]=calcK_MUSprob_bayes(P); %bayesian aggregation of conditional probabilities
                        end;
                    case 'LDA_med'
                        [P]=runLDA_Kclass(train,test);
                        if DO_AVG_MUP_CHAR == 1
                            PMUS=mean(P,1); %arithmetic mean of conditional probabilities
                        else
                            [PMUS]=calcK_MUSprob_bayes(P); %bayesian aggregation of conditional probabilities
                        end;
                    case 'MEAN'
                        [loLIMmean,hiLIMmean,loLIMout,hiLIMout] = calclimits_Kclass_PODNAR(train);
                        test(:,1)=[];%strip off class
                        [class_MEAN,conflict,rf, sumMtestlo, sumMtesthi ] = MEAN_CLASS_bic_fdi( test,loLIMmean,hiLIMmean,featset );
                        if (conflict==1) & (class_MEAN~=13)
                            error('conflict occurred but MEAN class incorrect')
                        end;
                        switch class_MEAN
                            case 1 %MEAN says Normal
                                PMUS=[1 0];
                            case 2 %MEAN says myopathic
                                PMUS=[0 0];
                            case 3 %MEAN says neuropathic
                                PMUS=[0 1];
                            case 13 %MEAN has conflict
                                PMUS=[0 0];
                            otherwise
                                error('unknown CMO voting combination')
                        end;

                    case 'OUTLIER'
                        [loLIMmean,hiLIMmean,loLIMout,hiLIMout] = calclimits_Kclass_PODNAR(train);
                        test(:,1)=[];%strip off class
                        [numlo,numhi] = count_outliers_muscle_bic_fdi(test,loLIMout,hiLIMout,featset);
                        [class_OUT, conflict ] = OUTLIER_CLASS_newCMO( numlo,numhi );

                        if (conflict==1) & (class_OUT~=13)
                            error('conflict occurred but MEAN class incorrect')
                        end;
                        switch class_OUT
                            case 1 %MEAN says Normal
                                PMUS=[1 0];
                            case 2 %MEAN says myopathic
                                PMUS=[0 0];
                            case 3 %MEAN says neuropathic
                                PMUS=[0 1];
                            case 13 %MEAN has conflict
                                PMUS=[0 0];
                            otherwise
                                error('unknown CMO voting combination')
                        end;


                    case 'Combined'
                        [loLIMmean,hiLIMmean,loLIMout,hiLIMout] = calclimits_Kclass_PODNAR(train);
                        test(:,1)=[];%strip off class
                        [class_MEAN,conflictMEAN,rf, sumMtestlo, sumMtesthi ] = MEAN_CLASS_bic_fdi( test,loLIMmean,hiLIMmean,featset );
                        [numlo,numhi] = count_outliers_muscle_bic_fdi(test,loLIMout,hiLIMout,featset);
                        [class_OUT, conflictOUT ] = OUTLIER_CLASS_newCMO( numlo,numhi );

                        if (conflictOUT==1) | (conflictMEAN==1) | (class_MEAN==13) | (class_OUT==13)
                            PMUS=[0 0];
                        else

                            if rf==1
                                switch class_MEAN
                                    case 1 %MEAN says normal
                                        error('rule fired but MEAN = normal')
                                    case 2 %MEAN says myopathic
                                        switch class_OUT
                                            case 1 %Outlier says Normal
                                                 PMUS=[0 0]; %CMO says myopathic
                                            case 2 %Outlier says myopathic
                                                 PMUS=[0 0]; %CMO says myopathic
                                            case 3 %Outlier says neuropathic
                                                 PMUS=[0 0]; %CMO says conflict
                                            case 13 %Outlier says conflict
                                                 PMUS=[0 0]; %CMO says conflict
                                            otherwise
                                                error('unknown CMO voting combination')
                                        end;
                                    case 3 %MEAN says Neuropathic
                                        switch class_OUT
                                            case 1 %Outlier says Normal
                                                PMUS=[0 1]; %CMO says neuropathic
                                            case 2 %Outlier says myopathic
                                                 PMUS=[0 0]; %CMO says conflict
                                            case 3 %Outlier says neuropathic
                                                 PMUS=[0 1]; %CMO says neuropathic
                                            case 13 %Outlier says conflict
                                                PMUS=[0 0]; %CMO says conflict
                                            otherwise
                                                error('unknown CMO voting combination')
                                        end;
                                    case 13 %MEAN says conflict
                                        PMUS=[0 0]; %CMO says conflict
                                    otherwise
                                        error('unknown CMO voting combination')
                                end;
                            else %MEAN says NORMAL
                                if class_MEAN~=1
                                    error('Mean rule did not fire and Mean class does not equal 1')
                                end;
                                switch class_OUT
                                    case 1 %Outlier says Normal
                                        PMUS=[1 0]; %CMO says normal
                                    case 2 %Outlier says myopathic
                                        PMUS=[0 0]; %CMO says myopathic
                                    case 3 %Outlier says neuropathic
                                        PMUS=[0 1]; %CMO says neuropathic
                                    case 13 %Outlier says conflict
                                        PMUS=[0 0]; %CMO says conflict
                                    otherwise
                                        error('unknown CMO voting combination')
                                end;
                            end;
                        end;
                    case 'hybrid'
                        for c=1:length(Labels)
                            HYBRID_calcP(2,0.5,train,test,bindefA,Labels(c));
                            evalP=['[ Pa',int2str(c),' ] = HORD_calcPbase(2,0.5, test, rules,bindefA,Labels(c) );'];
                            eval(evalP);
                        end;
                    otherwise
                        error('a valid classifier name was not specified')
                end;

                %find conditionbal probabilities
                %[PMUS]=calcK_MUSprob_bayes(P); %bayesian aggregation of MUP conditional probabilities
                MUSres=[MUSres; Labels(cl) testrow(k) PMUS ];
            else
                MUSres=[MUSres;Pfill];
            end;
        end;
    end;
end;


