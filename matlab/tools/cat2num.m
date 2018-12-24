function varargout = cat2num(varargin)
%Converts a categrocial cell list (of string) to an integer table
%
%[TrainY_num,TestY_num,num_classes] = CAT2NUM (TrainY_cat, TestY_cat)
%
% INPUTS
%   TrainY_cat      : Cell of string classes of training set
%   TestY_cat       : Cell of string classes of test set
%
% OUTPUT
%   TrainY_num      : Integer table of classes of training set
%   TestY_num       : Integer table of classes of test set
%   num_classes     : Number of different classes found (maximum integer)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018


%% PRELIMINARIES
assert(nargin>=2) ; assert(nargout==3) ;
train_cat = table2cell(varargin{1}) ;
test_cat = table2cell(varargin{2}) ;

%% CONVERSION
if nargin==2
    unique_poss = unique(train_cat) ;
else
    unique_poss = varargin{3} ;
end

l_train = length(train_cat) ;
l_test = length(test_cat) ;

train_num = zeros(l_train,1) ;
test_num = zeros(l_test,1) ;

idx_max = length(unique_poss) ;

for idx = 1:idx_max
    train_num(strcmp(train_cat,unique_poss(idx))) = idx ;
    test_num(strcmp(test_cat,unique_poss(idx))) = idx ;
end

%% RETURN
varargout{1} = array2table(train_num,'VariableNames',unique_poss(1)) ;
varargout{2} = array2table(test_num,'VariableNames',unique_poss(1)) ;
varargout{3} = 1 ;

end