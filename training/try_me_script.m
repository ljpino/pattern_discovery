%TRY_ME is a script that outputs a set of rules
%{
Information-theory based statistical inference can be used for the detection of significant patterns.
Wong and Wang describe the use of information theory based pattern discovery (PD) for
classification. Their classification algorithm is composed of three parts: discovery of significant
patterns, rule selection and classification.

A significant pattern is said to occur when a set of feature values occurs together more often than
expected assuming a random occurrence. For continuous data, a range of feature values is quantized
into a natural language label as is used in the clinic: e.g. small, medium or large. A statistical test of
significance determines if a significant pattern has occurred. Patterns that include a category label can
be used as rules for classification. The order of a rule is determined by the number of features,
including the category label, found in a pattern. An example of a 4th order rule is a MUP 1:labeled
myopathic with 2: low amplitude, 3: low duration and 4: high number of turns.
An information theoretic measure called weight of evidence (WOE) represents the discriminatory
power of a rule. A rule may be statistically significant but the WOE is needed to determine if the rule
provides negative, neutral or positive evidence to refute or support a classification. A large negative
WOE score means that the category suggested by the rule is highly unlikely to occur. A large positive
WOE score means that the category suggested by the rule is highly likely to occur. Rules with WOE
scores near zero neither support nor refute the likelihood of the classification. Section 4.1 will discuss
this technique in more detail.
The rules used for classifying an observation are selected starting with the highest order rule first
and accumulating its WOE. The features used in the highest order rule are then excluded and the rule
with an equal or lower order is found and its WOE is added to the total. This process is continued
until no more rules are found or all of the features have been considered. PD is a flexible
classification system because a prediction of a category can be made on any subset of the features
describing an observation. The system can also classify new observations that have missing data.
%}


%Inputs
 %train_data = quantized training data
 % E =  %minimum expected value in a hypercell
 % h0 = significance level required to establish a rule
%Outputs:
% - rules has the following format that is consistent with Andrew's code
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
train_data=load('example_train_data.txt'); % load quantized training data 2 classes, two features
E=5; %minimum expected value in a hypercell
h0=1.96; %significance level
rules=train_rules( train_data,E,h0 );
