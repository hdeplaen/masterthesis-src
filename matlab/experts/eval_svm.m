function varargout = eval_svm(varargin)
%Trains a binary SVM algorithm on a unique class. To construct a
%multi-class classifier, please use one-against-all model.
%
%TestY_est = EVAL_SVM(model, TestX, bin_class)
%
% INPUTS
%   model       : SVM model structure               .alpha .b .class ...
%   TestX       : Feature of test set               array(elements, features)
%   bin_class   : [-1,1] only or shade inbetween    ('yes' or 'no')
%   TestY       : Optional classes of test set      ([] if not wanted)
%
% OUTPUT
%   TestY_est   : Estimated classes of test set     array(elements, 1)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==4, 'Wrong number of input arguments') ;
model       = varargin{1} ;                 % ls-svm model
TestX       = varargin{2} ;                 % features of the test set
bin_class   = varargin{3} ;                 % boolean ('yes' or 'no') to use sign() or leave the shade
TestY       = varargin{4} ;                 % get optional classes of test set

alpha           = model.alpha ;             % support vector values
b               = model.b ;                 % independent term
params          = model.params ;            % model parameters
support_vectors = model.sv ;                % supoprt vectors of the model
class           = model.class ;
SVMModel        = model.SVMModel ;

n_test  = size(TestX,1) ;                   % number of training elements

%% EVALUATE
TestY_est = zeros(n_test,1) ;

% for idx = 1:n_test
%     TestY_est(idx) = transform_x(TestX(idx,:),support_vectors,params)'*alpha+b ;
% end

[~,TestY_est] = predict(SVMModel,TestX) ;
TestY_est = TestY_est(:,2) ;

%TestY_est = 2*(TestY_est)/(max(TestY_est)-min(TestY_est)) ;

switch bin_class
    case 'yes' ; TestY_est = sign(TestY_est) ;
    case 'no'
    otherwise ; error('bin_class value not recognized') ;
end

%% RETURN
assert(nargout==1, 'Wrong number of output arguments (1)') ;
varargout{1} = TestY_est ;

%% RESULTS
if ~isempty(TestY)
    assert(size(TestY,1)==n_test, ...
        'Number of elements not consistent in the test set') ;
    
    % COMPUTE RESULTS
    TestY_bin = (strcmp(TestY,class)) ;
    TestY_est_bin = sign(TestY_est) ;
    TestY_est_bin(TestY_est_bin==-1) = 0 ;
    
    acc = sum(TestY_bin==TestY_est_bin)/n_test ;       % accuracy
    
    % PRINT RESULTS
%     fopen(1) ;
%     fprintf('%%%%%%   SVM TESTING   %%%%%% \n') ;
%     fprintf(['Class : ' class{1} '\n']) ;
%     
%     fprintf('TESTING RESULTS\n') ;
%     fprintf(['Accuracy = ' num2str(acc*100) '%%\n \n']) ;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = transform_x(input, support_vectors, params)

sig2 = params.sig2 ;
XXh1 = sum(support_vectors.^2,2)*ones(1,size(input,1)) ;
XXh2 = sum(input.^2,2)*ones(1,size(support_vectors,1)) ;
omega = XXh1+XXh2' - 2*support_vectors*input' ;
output = exp(-omega./(2*sig2)) ;

end