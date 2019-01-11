function varargout = eval_oaa_knn(varargin)
%Estimates the classes of a test set based on the k-nearest-neighbors
%algorithm.
%
%TestY_eval = EVAL_KNN(models, TestX, k, class, TestY)
%
% INPUTS
%   models      : oaa-knn expert model
%   TestX       : Features of test set to be estimated) array(elements, features)
%   k           : number of nearest neighbors
%   class       : Class to be classified in one-against-all model
%   TestY       : Classes of test set                   (optional, [] if not wanted)
%
% OUTPUT
%   TestY_est   : Estimated classes of test set         cell(elements, 1)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==5,'Wrong number of inputs') ;
models  = varargin{1} ;
TestX   = varargin{2} ;
k       = varargin{3} ;
class   = varargin{4} ;
TestY   = varargin{5} ;

%% VERIFY CONSISTENCY DATASETS
TrainX = models.TrainX ;
TrainY = models.TrainY ;

n_train = size(TrainX,1) ;      % number of elements in the training set
n_test  = size(TestX,1) ;       % number of elements in the test set
n_feat  = size(TestX,2) ;       % number of features in the test set

assert(size(TrainY,1)==n_train, ...
    'Number of elements in the training sets not consistent') ;
assert(n_feat==size(TrainX,2), ...
    'Number of features not consistent between training and test set') ;

%% KNN ALGORITHM
TrainY_bin = strcmp(TrainY,class) ;
TestY_est = zeros(n_test,1);                                     % prealloc

h = waitbar(0,'Initializing') ;                                   % starting waitbar

for idx = 1:n_test                                              % for each element of the test set
    dist = sum((TrainX - ones(n_train,1)*TestX(idx,:)).^2,2) ;  % compute distances with elements of training set
    [~, idx_sortdist] = sort(dist) ;                            % sort the distances
    idx_best = mode(TrainY_bin(idx_sortdist(1:k))) ;
    TestY_est(idx) = idx_best ;                        % assign it to the element of the test set
    
    if mod(idx,100)==0                                          % updating waitbar
        waitbar(idx/n_test,h,'Computing kNN') ;
    end
end
delete(h) ;                                                     % closing waitbar

%% RETURN
assert(nargout==1, 'Sole one output argument needed') ;
varargout{1} = TestY_est ;

%% EVALUATION
if ~isempty(TestY)
    assert(size(TestY,1)==n_test, ...
        'Number of elements not consistent in the test set') ;
    
    % COMPUTE RESULTS
    TestY_bin = (strcmp(TestY,class)) ;
    
    acc = sum(TestY_bin==TestY_est)/n_test ;       % accuracy
    
    % PRINT RESULTS
    fopen(1) ;
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
    fprintf('%%%%%%   SVM TESTING   %%%%%% \n') ;
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
    fprintf(['Class : ' class '\n']) ;
    
    fprintf('TESTING RESULTS\n') ;
    fprintf(['Accuracy = ' num2str(acc*100) '%%\n \n']) ;
end

end
