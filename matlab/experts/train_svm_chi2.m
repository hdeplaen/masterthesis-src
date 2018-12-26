function varargout = train_svm_chi2(varargin)
%Trains a binary SVM algorithm on a unique class. To construct a
%multi-class classifier, please use one-against-all model or other.
%
%model = TRAIN_LSSVM(TrainX, TrainY,class)
%
% INPUTS
%   TrainX      : Features of training set      array(elements, features)
%   TrainY      : Classes of training set       cell(elements, 1)
%   class       : class to be classified
%   type        : 'linear' or 'rbf'
%
% OUTPUT
%   model       : LS-SVM model
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin>=4,'Wrong number of input arguments (4 or more)') ;
TrainX = varargin{1} ;
TrainY = varargin{2} ;
class  = varargin{3} ;
type = varargin{4} ;

%% DATASETS & CONSISTENCY
n_train = size(TrainX,1) ; % number of training elements

assert(size(TrainY,1)==n_train, ...
    'Number of elements not consistent in the traning set') ;
assert(sum(strcmp(unique(TrainY),class))==1, ...
    'Wanted class does not exist in the training set' ) ;

idx_class = strcmp(TrainY,class) ;
TrainY = ones(n_train,1) ;
TrainY(~idx_class) = 0 ;

%% TUNE LSSVM
gam = 10 ;      % initial regression parameter guess
sig2 = 1 ;      % initial RBF sigma^2 parameter guess

C = 10 ;

if nargin==4
    % features
    num_features = size(TrainX,2) ;
    chi2 = zeros(num_features,1) ;
    
    % crossval
    idx_perm = randperm(size(TrainX,1)) ;
    max_tr = round((1-0.2)*numel(idx_perm)) ;
    idx_tr = idx_perm(1:max_tr) ;
    idx_te = idx_perm(max_tr+1:end) ;
    
    trX = TrainX(idx_tr,:) ;
    trY = TrainY(idx_tr) ;
    teX = TrainX(idx_te,:) ;
    teY = TrainY(idx_te) ;
    
    if strcmp(class,'u2r')
        for idx_f = 1:num_features
            SVMModel = fitcsvm(trX(:,idx_f),trY, 'Standardize', false, ...
                'KernelFunction', type, 'KernelScale', 'auto','BoxConstraint',C) ;
            
            eval_teY = predict(SVMModel,teX(:,idx_f)) ;
            chi2(idx_f) = compute_chi2(teY, eval_teY) ;
        end
    else
        chi2 = ones(num_features,1) ;
    end
    
    save(['chi2_' class{1} '.mat'],'chi2') ;
else
    %chi2 = varargin{5} ;
    chi2 = [1
   1
   1
   1
   1
   1
   1
   1
   0
   1
   1
   1
   1
   1
   1
   1
   0
   1
   0
   1
   0
   0
   0
   1
   1
   1
   1
   1
   1
   0
   1
   1
   1
   1
   1
   0
   1
   1
   1
   1
   1
   0
   1] ;
end

idx_chosen = chi2>1e-2 ;
disp(sum(idx_chosen)) ;

SVMModel = fitcsvm(TrainX(:,idx_chosen),TrainY, 'Standardize', false, ...
    'KernelFunction', type, 'KernelScale', 'auto','BoxConstraint',C) ;

%CVSVMModel = crossval(SVMModel,'KFold',5) ;
%classLoss = 1-kfoldLoss(CVSVMModel, 'lossfun', 'classiferror') ;

%% RETURN
params.gam = [] ;
params.sig2 = SVMModel.KernelParameters.Scale ;

model           = struct ;      % prealloc
model.alpha     = SVMModel.Alpha ;       % assign alpha
model.b         = SVMModel.Bias ;           % assign b
model.class     = class ;       % assign class
model.params    = params ;      % assign problem parameters
model.sv        = SVMModel.SupportVectors ; %TrainX(SVMModel.IsSupportVector,:) ;      % assign support vectors
model.SVMModel  = SVMModel ;
model.idx_chosen = idx_chosen ;

% assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = model ;

alpha = SVMModel.Alpha ;
labels = SVMModel.SupportVectorLabels ;
sv  = SVMModel.SupportVectors ;

%% PERFORMANCE ON TRAINING SET
% classLoss = kfoldLoss(CVSVMModel{idx_min}) ;
%
% %[a,b] = predict(SVMModel,TrainX) ;
%
% % PRINT RESULTS
% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
% fprintf('%%%%%%  SVM TRAINING  %%%%%% \n') ;
% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
% fprintf(['sig2 = ' num2str(params.sig2) '\n \n']) ;
% fprintf(['Class : ' class{1} '\n']) ;
%
% fprintf('TRAINING RESULTS\n') ;
% fprintf(['Generalization rate = ' num2str((classLoss)*100) '%%\n']) ;

disp('SVM trained') ;

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