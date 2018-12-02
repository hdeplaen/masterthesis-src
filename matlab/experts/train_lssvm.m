function varargout = train_lssvm(varargin)
%Trains a binary LS-SVM algorithm on a unique class. To construct a
%multi-class classifier, please use one-against-all model.
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
method = 'crossvalidatelssvm' ;

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

lab_model = {TrainX,TrainY_bin,'c',gam,sig2, 'RBF_kernel'} ;
[gam,sig2,~] = tunelssvm(lab_model,'simplex', method, {10,'misclass'}) ;

params.gam = gam ;
params.sig2 = sig2 ;


lab_model = {TrainX,TrainY_bin,'c',gam,sig2, 'RBF_kernel'} ;
[alpha,b] = trainlssvm(lab_model) ;

%% RETURN
model           = struct ;      % prealloc
model.alpha     = alpha ;       % assign alpha
model.b         = b ;           % assign b
model.class     = class ;       % assign class
model.params    = params ;      % assign problem parameters
model.sv        = TrainX ;      % assign support vectors

%assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = model ;

%% PERFORMANCE ON TRAINING SET
[TrainY_est,~] = simlssvm(lab_model,{alpha,b},TrainX) ;

% COMPUTE RESULTS
adder   = TrainY_bin+TrainY_est ;
tp      = sum(adder== 2)/n_train ;      % true positives rate
tn      = sum(adder==-2)/n_train ;      % ture negatives rate

substr  = TrainY_bin-TrainY_est ;
fp      = sum(substr== 2)/n_train ;     % false positives rate
fn      = sum(substr==-2)/n_train ;     % false negatives rate

acc     = (tp+tn)/(tp+tn+fp+fn) ;       % accuracy

% PRINT RESULTS
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
fprintf('%%%%%%  SVM RESULTS  %%%%%% \n') ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
fprintf(['gam = ' num2str(gam) '\n']) ;
fprintf(['sig2 = ' num2str(sig2) '\n \n']) ;

fprintf('TRAINING RESULTS\n') ;
fprintf(['Accuracy = ' num2str(acc*100) '%%\n']) ;
fprintf(['TP = ' num2str(tp*100) '%%   ']) ;
fprintf(['TN = ' num2str(tn*100) '%%\n']) ;
fprintf(['FP = ' num2str(fp*100) '%%   ']) ;
fprintf(['FN = ' num2str(fn*100) '%%\n \n']) ;

end
