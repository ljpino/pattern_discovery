%TRY_ME is a script that outputs a set of rules
train_data=load('example_train_data.txt'); % load quatized training data 2 classes, two features
E=5; %minimum expected value in a hypercell
h0=1.96; %significance level
rules=train_rules( train_data,E,h0 );

%rules has the following format that is consistent with Andrew's code
%There are unused parameters that are there to be consistent
%{
column    definition
------    ----------
1         rule # - always set to 1 never used in Matlab code
2         WOE using base 2
3         d - adjusted residual
4         event # -  always set to 1 never used in Mtalab code
5         # of occurrences (never used I think)
6         order of rule
7         class
8         quantized value, i.e. bin # of feature value comprising this rule if this column is zero then this feature does not belong to the rule
....
....
n+7       repeat for each feature set used in training
%}

%{
IF everything is working this is what rules looks like when you run this script

rules =

            1       1.5289       6.1981            1          202            2            1            1            0
            1      -1.7737      -7.0227            1           62            2            1            3            0
            1      -1.5289      -6.1981            1           70            2            2            1            0
            1       1.7737       7.0227            1          212            2            2            3            0
            1       1.5497       6.4234            1          202            3            1            1            1
            1      -1.8108      -7.1576            1           59            3            1            3            1
            1      -1.5497       -6.141            1           69            3            2            1            1
            1       1.8108       6.7827            1          207            3            2            3            1
%}