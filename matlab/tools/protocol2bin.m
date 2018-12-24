function varargout = protocol2bin(varargin)
%CAT2BIN Converts a categrocial cell list (of string) to a binary table
%   Author: HENRI DE PLAEN


%% PRELIMINARIES
assert(nargin==2) ; assert(nargout==3) ;
train_cat = table2cell(varargin{1}) ;
test_cat = table2cell(varargin{2}) ;

%% CONVERSION
unique_poss = {'icmp','tcp','udp'} ;

l_train = length(train_cat) ;
l_test = length(test_cat) ;

idx_max = length(unique_poss) ;

%prealloc
train_bin = zeros(l_train,idx_max) ;
test_bin = zeros(l_test,idx_max) ;

for idx = 1:idx_max
    train_bin(:,idx) = strcmp(train_cat,unique_poss(idx)) ;
    test_bin(:,idx) = strcmp(test_cat,unique_poss(idx)) ;
end

%% RETURN
varargout{1} = array2table(train_bin,'VariableNames',unique_poss) ;
varargout{2} = array2table(test_bin,'VariableNames',unique_poss) ;
varargout{3} = idx_max ;

end