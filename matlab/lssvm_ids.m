function varargout = lssvm_ids(varargin)
%LS-SVM_IDS Trains a LS-SVM
%   Author: HENRI DE PLAEN

%% PRELIMINARIES
assert(nargin==4,'Wrong number of inputs') ;
%C = varargin{1} ; sigma = varargin{2} ;
TrainX = varargin{1} ; TrainY = varargin{2} ;
TestX = varargin{3} ; 
%TestY = varargin{6} ;

%% DATASETS
n_train = size(TrainX,1) ;
assert(size(TrainY,1)==n_train,'Training sets not consistent') ;

n_test = size(TestX,1) ;
% assert(size(TestY,1)==n_test,'Test sets not consistent') ;

assert(size(TestX,2)==size(TrainX,2),'Number of input variables not consistent between training and test set') ;

%changing 0 to -1
TrainY = double(TrainY) ;
% TestY = double(TestY) ;

TrainY(TrainY==0) = -1 ;
% TestY(TestY==0) = -1 ;

%% SVM DESIGN
gam = 10 ; sig2 = 1 ;
model = {TrainX,TrainY,'c',gam,sig2, 'RBF_kernel'} ;
[gam,sig2,~] = tunelssvm(model,'simplex', 'crossvalidatelssvm',{10,'misclass'}) ;

model = {TrainX,TrainY,'c',gam,sig2, 'RBF_kernel'} ;
[alpha,b] = trainlssvm(model) ;

% [Ytr_sim,~] = simlssvm(model,{alpha,b},TrainX) ;
[Yte_sim,~] = simlssvm(model,{alpha,b},TestX) ;

%% RETURN
%assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = Yte_sim ;
varargout{2} = alpha ;
varargout{3} = b ;

%% TEST
% train_acc = sum(TrainY==Ytr_sim)/numel(TrainY) ;
% train_adder = TrainY+Ytr_sim ;
% train_tp = sum(train_adder== 2)/numel(TrainY) ;
% train_tn = sum(train_adder==-2)/numel(TrainY) ;
% train_substr = TrainY-Ytr_sim ;
% train_fp = sum(train_substr== 2)/numel(TrainY) ;
% train_fn = sum(train_substr==-2)/numel(TrainY) ;
% 
% test_acc = sum(TestY==Yte_sim)/numel(TestY) ;
% test_adder = TestY+Yte_sim ;
% test_tp = sum(test_adder== 2)/numel(TestY) ;
% test_tn = sum(test_adder==-2)/numel(TestY) ;
% test_substr = TestY-Yte_sim ;
% test_fp = sum(test_substr== 2)/numel(TestY) ;
% test_fn = sum(test_substr==-2)/numel(TestY) ;
% 
% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
% fprintf('%%%%%%  SVM RESULTS  %%%%%% \n') ;
% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
% fprintf(['C = ' num2str(gam) '\n']) ;
% fprintf(['sigma = ' num2str(sig2) '\n \n']) ;
% 
% fprintf('TRAINING RESULTS\n') ;
% fprintf(['Total accuracy = ' num2str(train_acc*100) '%%\n']) ;
% fprintf(['TP = ' num2str(train_tp*100) '%%   ']) ;
% fprintf(['TN = ' num2str(train_tn*100) '%%\n']) ;
% fprintf(['FP = ' num2str(train_fp*100) '%%   ']) ;
% fprintf(['FN = ' num2str(train_fn*100) '%%\n \n']) ;
% 
% fprintf('TEST RESULTS\n') ;
% fprintf(['Total accuracy = ' num2str(test_acc*100) '%%\n']) ;
% fprintf(['TP = ' num2str(test_tp*100) '%%    ']) ;
% fprintf(['TN = ' num2str(test_tn*100) '%%\n']) ;
% fprintf(['FP = ' num2str(test_fp*100) '%%    ']) ;
% fprintf(['FN = ' num2str(test_fn*100) '%%\n \n']) ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

