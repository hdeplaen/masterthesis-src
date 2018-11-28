function varargout = knn_ids(varargin)
%KNN_IDS Trains a kNN
%   Author: HENRI DE PLAEN

%% PRELIMINARIES
assert(nargin==5,'Wrong number of inputs') ;
k = varargin{5} ;
TrainX = varargin{1} ; TrainY = varargin{2} ;
TestX = varargin{3} ; TestY = varargin{4} ;

%% DATASETS
n_train = size(TrainX,1) ;
assert(size(TrainY,1)==n_train,'Training sets not consistent') ;

n_test = size(TestX,1) ;
assert(size(TestY,1)==n_test,'Test sets not consistent') ;

n_param = size(TestX,2) ;
assert(n_param==size(TrainX,2),'Number of input variables not consistent between training and test set') ;

%changing 0 to -1
TrainY = double(TrainY) ;
TestY = double(TestY) ;

TrainY(TrainY==0) = -1 ;
TestY(TestY==0) = -1 ;

%% kNN DESIGN
unique_outputs = [-1 1] ;
Yte_sim = zeros(n_test,1);
for idx = 1:n_test
    dist = sum((TrainX - ones(n_train,1)*TestX(idx,:)).^2,2) ;
    [~, idx_sortdist] = sort(dist) ;
    n = hist(TrainY(idx_sortdist(1:k)), unique_outputs) ;
    [~, idx_best] = max(n) ;
    Yte_sim(idx) = unique_outputs(idx_best) ;
end

%% RETURN
assert(nargout==0, 'No output arguments needed') ;
% varargout{1} = alpha ;
% varargout{2} = b ;

%% TEST
test_acc = sum(TestY==Yte_sim)/numel(TestY) ;
test_adder = TestY+Yte_sim ;
test_tp = sum(test_adder== 2)/numel(TestY) ;
test_tn = sum(test_adder==-2)/numel(TestY) ;
test_substr = TestY-Yte_sim ;
test_fp = sum(test_substr== 2)/numel(TestY) ;
test_fn = sum(test_substr==-2)/numel(TestY) ;

fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
fprintf('%%%%%%  SVM RESULTS  %%%%%% \n') ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
fprintf(['k = ' num2str(k) '\n']) ;

fprintf('TEST RESULTS\n') ;
fprintf(['Total accuracy = ' num2str(test_acc*100) '%%\n']) ;
fprintf(['TP = ' num2str(test_tp*100) '%%    ']) ;
fprintf(['TN = ' num2str(test_tn*100) '%%\n']) ;
fprintf(['FP = ' num2str(test_fp*100) '%%    ']) ;
fprintf(['FN = ' num2str(test_fn*100) '%%\n \n']) ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%