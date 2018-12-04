function varargout = cat2freq(varargin)
%Converts a categrocial cell list (of string) to an frequency table
%
%TestY_eval = CAT2FREQ (expert, TestX, TestY)
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
assert(nargin==2) ; assert(nargout==3) ;
train_cat = table2cell(varargin{1}) ;
test_cat = table2cell(varargin{2}) ;

%% CONVERSION
unique_poss = unique(train_cat) ;

l_train = length(train_cat) ;
l_test = length(test_cat) ;

train_num = zeros(l_train,1) ;
test_num = zeros(l_test,1) ;

idx_max = length(unique_poss) ;

for idx = 1:idx_max
    idx_tr_cat = strcmp(train_cat,unique_poss(idx)) ;
    freq_cat = sum(idx_tr_cat)/l_train ;
    
    train_num(idx_tr_cat) = freq_cat ;
    test_num(strcmp(test_cat,unique_poss(idx))) = freq_cat ;
end

%% RETURN
varargout{1} = array2table(train_num,'VariableNames',unique_poss(1)) ;
varargout{2} = array2table(test_num,'VariableNames',unique_poss(1)) ;
varargout{3} = 1 ;

end