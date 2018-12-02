function varargout = ids_expert(varargin)
%IDS_EXPERT creates an expert classifier
%   Author: HENRI DE PLAEN
%
%[Ytest_est] = ids_expert(Xtr,Ytr,Xtest,Ytest,type,param)

%% PRELIMINARIES
assert(nargin==6,'Wrong number of inputs') ;

type = varargin{5} ;
param = varargin{6} ;

Xtr = varargin{1} ;
Ytr = varargin{2} ;
Xtest = varargin{3} ;
Ytest = varargin{4} ;

n_train = size(Xtr,1) ;
assert(size(Ytr,1)==n_train,'Training sets not consistent') ;

n_test = size(Xtest,1) ;
assert(size(Ytest,1)==n_test,'Test sets not consistent') ;

assert(size(Xtest,2)==size(Xtr,2),'Number of input variables not consistent between training and test set') ;

%% EXPERT
unique_output = unique(Ytr) ;
n_unique = numel(unique_output) ;
Ytest_unique = zeros(n_test,n_unique) ;

switch type
    case 'lssvm'
        parfor idx_unique = 1:n_unique
            loc_unique = unique_output(idx_unique) ;
            Ytr_unique = double(strcmp(Ytr,loc_unique)) ;
            Ytr_unique(Ytr_unique==0) = -1 ;
            Ytest_unique(:,idx_unique) = lssvm_ids(Xtr,Ytr_unique,Xtest,param) ;
        end
        [~,idx_best] = max(Ytest_unique,[],2) ;
        Ytest_est = unique_output(idx_best) ;
        
    case 'svm'
        error('SVM expert not well developped') ;
        
    case 'knn'
        for idx_unique = 1:n_unique
            loc_unique = unique_output(idx_unique) ;
            Ytr_unique = double(strcmp(Ytr,loc_unique)) ;
            Ytr_unique(Ytr_unique==0) = -1 ;
            Ytest_unique(:,idx_unique) = knn_ids(Xtr,Ytr_unique,Xtest,param) ;
        end
        [~,idx_best] = max(Ytest_unique,[],2) ;
        Ytest_est = unique_output(idx_best) ;
        
    otherwise
        error('Expert type not recongized') ;
end

%% RESULTS
%% TEST
test_acc = sum(strcmp(Ytest,Ytest_est))/numel(Ytest) ;
% test_adder = Ytest+Yte_sim_bis ;
% test_tp = sum(test_adder== 2)/numel(Ytest) ;
% test_tn = sum(test_adder==-2)/numel(Ytest) ;
% test_substr = Ytest-Yte_sim_bis ;
% test_fp = sum(test_substr== 2)/numel(Ytest) ;
% test_fn = sum(test_substr==-2)/numel(Ytest) ;

fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
fprintf('%%%%%%  EXPERT RESULTS  %%%%%% \n') ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
fprintf(['param = ' num2str(param) '\n']) ;

fprintf('TEST RESULTS\n') ;
fprintf(['Total accuracy = ' num2str(test_acc*100) '%%\n']) ;
% fprintf(['TP = ' num2str(test_tp*100) '%%    ']) ;
% fprintf(['TN = ' num2str(test_tn*100) '%%\n']) ;
% fprintf(['FP = ' num2str(test_fp*100) '%%    ']) ;
% fprintf(['FN = ' num2str(test_fn*100) '%%\n \n']) ;

%% RETURN
assert(nargout==1, 'Wrong number of output arguments') ;
varargout{1} = Ytest_est ;

end

