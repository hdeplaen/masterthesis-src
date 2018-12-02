function varargout = train_svm(varargin)
%Trains a binary SVM algorithm on a unique class. To construct a
%multi-class classifier, please use one-against-all model or other.
%
%model = TRAIN_LSSVM(TrainX, TrainY,class)
%
% INPUTS
%   TrainX      : Features of training set      array(elements, features)
%   TrainY      : Classes of training set       cell(elements, 1)
%   class       : class to be classified
%
% OUTPUT
%   model       : LS-SVM model
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==3,'Wrong number of input arguments (3)') ;
TrainX = varargin{1} ;
TrainY = varargin{2} ;
class  = varargin{3} ;

%% DATASETS & CONSISTENCY
n_train = size(TrainX,1) ; % number of training elements

assert(size(TrainY,1)==n_train, ...
    'Number of elements not consistent in the traning set') ;
assert(sum(strcmp(unique(TrainY),class))==1, ...
    'Wanted class does not exist in the training set' ) ;

idx_class = strcmp(TrainY,class) ;
TrainY_bin = ones(n_train,1) ;
TrainY_bin(~idx_class) = -1 ;

%% TUNE LSSVM
gam = 10 ;      % initial regression parameter guess
sig2 = 1 ;      % initial RBF sigma^2 parameter guess

SVMModel = fitcsvm(TrainX,TrainY_bin, 'Standardize', false, ...
    'KernelFunction', 'RBF', 'KernelScale', 'auto') ;

CVSVMModel = crossval(SVMModel) ;

params.gam = [] ;
params.sig2 = SVMModel.KernelParameters.Scale ;

%% RETURN
model           = struct ;      % prealloc
model.alpha     = SVMModel.Alpha ;       % assign alpha
model.b         = SVMModel.Bias ;           % assign b
model.class     = class ;       % assign class
model.params    = params ;      % assign problem parameters
model.sv        = TrainX(SVMModel.IsSupportVector,:) ;      % assign support vectors

% assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = model ;

%% PERFORMANCE ON TRAINING SET
classLoss = kfoldLoss(CVSVMModel) ;

% PRINT RESULTS
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
fprintf('%%%%%%  SVM RESULTS  %%%%%% \n') ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
fprintf(['sig2 = ' num2str(params.sig2) '\n \n']) ;

fprintf('TRAINING RESULTS\n') ;
fprintf(['Generalization rate = ' num2str((classLoss)*100) '%%\n']) ;

end

