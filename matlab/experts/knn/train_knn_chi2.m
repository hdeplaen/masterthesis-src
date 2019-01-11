function varargout = train_knn_chi2(varargin)
%Estimates the classes of a test set based on the k-nearest-neighbors
%algorithm.
%
%TrainX = TRAIN_KNN_CHI2(TrainX, TrainY, k)
%
% INPUTS
%   TrainX      : Features of training set              array(elements, features)
%   TrainY      : Classes of training set               cell(elements, 1)
%   k           : number of nearest neighbors
%
% OUTPUT
%   TrainX      : Estimated classes of test set         cell(elements, 1)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==3,'Wrong number of input arguments (3)') ;
TrainX  = varargin{1} ;
TrainY  = varargin{2} ;
k       = varargin{3} ;

%% CHI2 KNN ALGORITHM
n_train = size(TrainX,1) ;      % number of elements in the training set

% features
num_features = size(TrainX,2) ;

% classes
classes = {'normal','dos','probe','r2l','u2r'} ;
chi2 = ones(num_features,numel(classes)) ;

for idx_class = 1:numel(classes)
    pos_class = strcmp(TrainY,classes{idx_class}) ;
    TrainY_bis = ones(n_train,1) ;
    TrainY_bis(~pos_class) = 0 ;
    
    % crossval
    idx_perm = randperm(size(TrainX,1)) ;
    max_tr = round((1-0.2)*numel(idx_perm)) ;
    idx_tr = idx_perm(1:max_tr) ;
    idx_te = idx_perm(max_tr+1:end) ;
    
    trX = TrainX(idx_tr,:) ;
    trY = TrainY_bis(idx_tr) ;
    teX = TrainX(idx_te,:) ;
    teY = TrainY_bis(idx_te) ;
    
    for idx_f = 1:num_features
        model = fitcknn(trX(:,idx_f),trY,'NumNeighbors',k,'Standardize',0) ;
        eval_teY = predict(model,teX(:,idx_f)) ;
        chi2(idx_f,idx_class) = compute_chi2(teY, eval_teY) ;
    end
end

save(['chi2_knn.mat'],'chi2') ;

%% RETURN
threshold = 1e+2 ;
chi2 = logical(mean(chi2,1)>threshold) ;

assert(nargout==1, 'Wrong number of output arguments (1)') ;
%varargout{1} = TrainX(:,chi2) ;
varargout{1} = TrainX ;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chi2_metric = compute_chi2(teY, eval_teY)

t = @(c,e) ((c-e).^2)./e ;

adder = eval_teY + teY ;
TP  = sum(adder== 2) + 1e-4 ;      % true positives
TN  = sum(adder== 0) + 1e-4;      % ture negatives

substr = eval_teY - teY ;
FP  = sum(substr== 1) + 1e-4;     % false positives
FN  = sum(substr==-1) + 1e-4;     % false negatives

PPos = sum(teY==1)/numel(teY) ;
PNeg = sum(teY==0)/numel(teY) ;

chi2_metric = t(TP,(TP+FP)*PPos) + ...
    t(FN,(FN+TN)*PPos) + ...
    t(FP,(TP+FP)*PNeg) + ...
    t(TN,(FN+TN)*PNeg) ;

end
