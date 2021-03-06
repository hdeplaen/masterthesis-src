function varargout = svm_ids(varargin)
%SVM_IDS Trains a SVM
%   Author: HENRI DE PLAEN

%% PRELIMINARIES
assert(nargin==6,'Wrong number of inputs') ;
C = varargin{1} ; sigma = varargin{2} ;
TrainX = varargin{3} ; TrainY = varargin{4} ;
TestX = varargin{5} ; TestY = varargin{6} ;

%% DATASETS
n_train = size(TrainX,1) ;
assert(size(TrainY,1)==n_train,'Training sets not consistent') ;

n_test = size(TestX,1) ;
assert(size(TestY,1)==n_test,'Test sets not consistent') ;

assert(size(TestX,2)==size(TrainX,2),'Number of input variables not consistent between training and test set') ;

%changing 0 to -1
TrainY = double(TrainY) ;
TestY = double(TestY) ;

TrainY(TrainY==0) = -1 ;
TestY(TestY==0) = -1 ;

%% SVM DESIGN
H = zeros(n_train,n_train) ;

h = waitbar(0,'Computing') ;
for idx1=1:n_train
    if mod(idx1,1000)
        waitbar(idx1/n_train,h,'Computing') ;
    end
    for idx2=idx1:n_train
        x1 = TrainX(idx1,:) ;
        x2 = TrainX(idx2,:) ;
        H(idx1,idx2) = TrainY(idx1)*TrainY(idx2)*K_rbf(x1,x2,sigma) ;
        H(idx2,idx1) = H(idx1,idx2);
    end
end
delete(h) ;

f = -ones(n_train,1) ;
Aeq = TrainY' ;
beq = 0 ;
lb = zeros(n_train,1) ;
ub = C*ones(n_train,1) ;

%% SVM COMPUT
alg{1}='trust-region-reflective';
alg{2}='interior-point-convex';

options=optimset('Algorithm',alg{2},...
    'display','on',...
    'MaxIter',20);

alpha = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],options)' ;

AlmostZero = (abs(alpha) < max(abs(alpha)) / 1e5) ;
alpha(AlmostZero) = 0 ; %sparsifying
S = find(alpha > 0 & alpha < C) ;
w = 0 ;

for idx = S
    w = w + alpha(idx) * TrainY(idx) * TrainX(idx,:) ;
end

b = mean( TrainY(S)' - w * TrainX(S,:)' ) ;

%% RETURN
output_TestY = w * TestX' + b ;

assert(nargin==1, 'Wrong number of output arguments') ;
varargout{1} = output_TestY ;

%% TEST
% output_TrainY = sign(w * TrainX' + b) ;
% output_TestY = sign(w * TestX' + b) ;

% train_acc = sum(TrainY'==output_TrainY)/numel(TrainY) ;
% train_adder = TrainY'+output_TrainY ;
% train_tp = sum(train_adder== 2)/numel(TrainY) ;
% train_tn = sum(train_adder==-2)/numel(TrainY) ;
% train_substr = TrainY'-output_TrainY ;
% train_fp = sum(train_substr== 2)/numel(TrainY) ;
% train_fn = sum(train_substr==-2)/numel(TrainY) ;
% 
% test_acc = sum(TestY'==output_TestY)/numel(TestY) ;
% test_adder = TestY'+output_TestY ;
% test_tp = sum(test_adder== 2)/numel(TestY) ;
% test_tn = sum(test_adder==-2)/numel(TestY) ;
% test_substr = TestY'-output_TestY ;
% test_fp = sum(test_substr== 2)/numel(TestY) ;
% test_fn = sum(test_substr==-2)/numel(TestY) ;

% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
% fprintf('%%%%%%  SVM RESULTS  %%%%%% \n') ;
% fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
% fprintf(['C = ' num2str(C) '\n']) ;
% fprintf(['sigma = ' num2str(sigma) '\n \n']) ;
% 
% fprintf('TRAINING RESULTS\n') ;
% fprintf(['Total accuracy = ' num2str(train_acc) '%%\n']) ;
% fprintf(['TP = ' num2str(train_tp) '%%   ']) ;
% fprintf(['TN = ' num2str(train_tn) '%%\n']) ;
% fprintf(['FP = ' num2str(train_fp) '%%   ']) ;
% fprintf(['FN = ' num2str(train_fn) '%%\n \n']) ;
% 
% fprintf('TEST RESULTS\n') ;
% fprintf(['Total accuracy = ' num2str(test_acc) '%%\n']) ;
% fprintf(['TP = ' num2str(test_tp) '%%    ']) ;
% fprintf(['TN = ' num2str(test_tn) '%%\n']) ;
% fprintf(['FP = ' num2str(test_fp) '%%    ']) ;
% fprintf(['FN = ' num2str(test_fn) '%%\n \n']) ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function K = K_lin(x1,x2,~)
% %Author: HENRI DE PLAEN
%     assert(nummel(x1)==numel(x2)) ;
%     x1 = x1(:) ;
%     x2 = x2(:) ;
%     K = x1'*x2 ;
% end

function K = K_rbf(x1,x2,param)
%Author: HENRI DE PLAEN
    assert(numel(x1)==numel(x2)) ;
    norm2 = sum((x1-x2).^2) ;
    K = exp(-norm2/2/(param^2)) ;
end

