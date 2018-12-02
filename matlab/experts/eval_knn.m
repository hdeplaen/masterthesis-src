function varargout = eval_knn(varargin)
%Estimates the classes of a test set based on the k-nearest-neighbors
%algorithm.
%
%TestY_eval = EVAL_KNN(TrainX, TrainY, TestX, k)
%
% INPUTS
%   TrainX      : Features of training set              array(elements, features)
%   TrainY      : Classes of training set               cell(elements, 1)
%   TestX       : Features of test set to be estimated) array(elements, features)
%   k           : number of nearest neighbors
%
% OUTPUT
%   TestY_est   : Estimated classes of test set         cell(elements, 1)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==4,'Wrong number of inputs') ;
TrainX  = varargin{1} ; 
TrainY  = varargin{2} ;
TestX   = varargin{3} ;
k       = varargin{4} ;

%% VERIFY CONSISTENCY DATASETS
n_train = size(TrainX,1) ;      % number of elements in the training set
n_test  = size(TestX,1) ;       % number of elements in the test set
n_feat  = size(TestX,2) ;       % number of features in the test set

assert(size(TrainY,1)==n_train, ...
    'Number of elements in the training sets not consistent') ;
assert(n_feat==size(TrainX,2), ...
    'Number of features not consistent between training and test set') ;

%% KNN ALGORITHM
TestY_est = cell(n_test,1);                                     % prealloc
classes = unique(TrainY) ;                                      % different classes in char format
[TrainY_num, ~, ~] = cat2num( ...
    cell2table(TrainY), cell2table(TrainY)) ;
TrainY_num = table2array(TrainY_num) ;

h = waitbar(0,'Initializing') ;                                   % starting waitbar

for idx = 1:n_test                                              % for each element of the test set
    dist = sum((TrainX - ones(n_train,1)*TestX(idx,:)).^2,2) ;  % compute distances with elements of training set
    [~, idx_sortdist] = sort(dist) ;                            % sort the distances
    occ = histcounts(TrainY_num(idx_sortdist(1:k))) ;           % classify the k first ones
    [~, idx_best] = max(occ) ;                                  % evaluate which is the most present
    TestY_est(idx) = classes(idx_best) ;                        % assign it to the element of the test set
    
    if mod(idx,100)==0                                          % updating waitbar
        waitbar(idx/n_test,h,'Computing kNN') ;
    end
end
delete(h) ;                                                     % closing waitbar

%% RETURN
assert(nargout==1, 'Sole one output argument needed') ;
varargout{1} = TestY_est ;

end
