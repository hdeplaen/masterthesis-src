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
%   type        : 'linear' or 'rbf'
%
% OUTPUT
%   model       : LS-SVM model
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==4,'Wrong number of input arguments (4)') ;
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
TrainY_bin = ones(n_train,1) ;
TrainY_bin(~idx_class) = -1 ;

%% TUNE LSSVM
gam = 10 ;      % initial regression parameter guess
sig2 = 1 ;      % initial RBF sigma^2 parameter guess

%C = 10.^(-2:.5:3) ;
%C = 10 ;
C = 1000 ;

% prealloc
SVMModel = cell(numel(C),1) ;
CVSVMModel = cell(numel(C),1) ;
classLoss = zeros(numel(C),1) ;

%c_opts = cvpartition(n_train,'KFold',5) ;
%opts = struct('Optimizer', 'gridsearch', 'ShowPlots', true, 'Verbose', 2, 'UseParallel', true, 'CVPartition', c_opts) ;

%h = waitbar(0,'Support Vectors') ;
for idx_C = 1:numel(C)
    %     SVMModel{idx_C} = fitcsvm(TrainX,TrainY_bin, 'Standardize', false, ...
    %         'KernelFunction', 'RBF', 'OptimizeHyperparameters', {'KernelScale','BoxConstraint'}, ... %'BoxConstraint',C(idx_C), ...
    %         'HyperparameterOptimizationOptions', opts) ;
    
    SVMModel{idx_C} = fitcsvm(TrainX,TrainY_bin, 'Standardize', false, ...
        'KernelFunction', type, 'KernelScale', 'auto','BoxConstraint',C(idx_C)) ;
    
    %CVSVMModel{idx_C} = crossval(SVMModel{idx_C},'KFold',5) ;
    %classLoss(idx_C) = 1-kfoldLoss(CVSVMModel{idx_C}, 'lossfun', 'classiferror') ;
    %disp(classLoss(idx_C)) ;
    %waitbar(idx_C/numel(C),h,'Support Vectors') ;
end
%delete(h) ;

%um_sv = mean_sv(CVSVMModel) ;
num_sv = 0 ;

%% PLOT
% figure ;
% subplot(2,1,1) ;
% loglog(C,classLoss,'-k','LineWidth',2) ;
% ylabel('Class. error') ;
% ax = gca ;
% %ax.XAxisLocation = 'origin' ;
% %ax.YAxisLocation = 'origin' ;
% set(0,'DefaultLineColor','k') ;
% set(gca,'box','off') ;
% set(gca, 'FontName', 'Baskervald ADF Std') ;
% set(gca, 'FontSize', 23) ;
% set(gca,'LineWidth',2) ;
% %axis([0 it(end) -20 5]) ;
% leg = legend() ;
% set(leg,'visible','off') ;
% 
% subplot(2,1,2) ;
% loglog(C,num_sv,'-k','LineWidth',2) ;
% xlabel('C') ;
% ylabel('#SV') ;
% ax = gca ;
% %ax.XAxisLocation = 'origin' ;
% %ax.YAxisLocation = 'origin' ;
% set(0,'DefaultLineColor','k') ;
% set(gca,'box','off') ;
% set(gca, 'FontName', 'Baskervald ADF Std') ;
% set(gca, 'FontSize', 23) ;
% set(gca,'LineWidth',2) ;
% %axis([0 it(end) -20 5]) ;
% leg = legend() ;
% set(leg,'visible','off') ;

%% RETURN
%[~,idx_min] = min(classLoss) ;
%SVMModel = CVSVMModel{idx_min}.Trained{1} ;
SVMModel = SVMModel{1} ;
params.gam = [] ;
params.sig2 = SVMModel.KernelParameters.Scale ;

alpha = SVMModel.Alpha ;
labels = SVMModel.SupportVectorLabels ;
sv  = SVMModel.SupportVectors ;
w = (alpha.*labels)'*sv ;

model           = struct ;      % prealloc
model.alpha     = SVMModel.Alpha.*SVMModel.SupportVectorLabels ;       % assign alpha
model.b         = SVMModel.Bias ;           % assign b
model.class     = class ;       % assign class
model.params    = params ;      % assign problem parameters
model.sv        = SVMModel.SupportVectors ; %TrainX(SVMModel.IsSupportVector,:) ;      % assign support vectors
model.SVMModel  = SVMModel ;
model.num_sv    = num_sv ;
model.w         = w ;

% assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = model ;

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

function out = mean_sv(CVSVMModel)

num_c = numel(CVSVMModel) ;

out = zeros(num_c,1) ;
for idx_c = 1:num_c
    nfold = CVSVMModel{idx_c}.KFold ;
    num_sv = zeros(nfold,1) ;
    for idx = 1:nfold
        num_sv(idx) = size(CVSVMModel{idx_c}.Trained{idx}.SupportVectors,1) ;
    end
    out(idx_c) = mean(num_sv) ;
end

end