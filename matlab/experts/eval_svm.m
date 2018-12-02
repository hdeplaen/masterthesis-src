function varargout = eval_svm(varargin)
%Trains a binary SVM algorithm on a unique class. To construct a
%multi-class classifier, please use one-against-all model or other.
%
%TestY_est = EVAL_LSSVM(model, TestX, bin_class)
%
% INPUTS
%   model       : LS-SVM model structure            .alpha .b .class
%   TestX       : Feature of test set               array(elements, features)
%   bin_class   : [-1,1] only or shade inbetween    ('yes' or 'no')
%
% OUTPUT
%   TestY_est   : Estimated classes of test set     array(elements, 1)
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==3, 'Wrong number of input arguments') ;
model       = varargin{1} ;                 % ls-svm model
TestX       = varargin{2} ;                 % features of the test set
bin_class   = varargin{3} ;                 % boolean ('yes' or 'no') to use sign() or leave the shade

alpha           = model.alpha ;             % support vector values
b               = model.b ;                 % independent term
params          = model.params ;            % model parameters
support_vectors = model.sv ;                % supoprt vectors of the model

n_test  = size(TestX,1) ;                   % number of training elements

%% EVALUATE
TestY_est = zeros(n_test,1) ;

for idx = 1:n_test
    TestY_est(idx) = transform_x(TestX(idx,:),support_vectors,params)'*alpha+b ;
end

% TestY_est = TestY_est-mean(TestY_est)/std(TestY_est) ;

switch bin_class
    case 'yes' ; TestY_est = sign(TestY_est) ;
    case 'no'
    otherwise ; error('bin_class value not recognized') ;
end

%% RETURN
assert(nargout==1, 'Wrong number of output arguments (1)') ;
varargout{1} = TestY_est ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = transform_x(input, support_vectors, params)

sig2 = params.sig2 ;
XXh1 = sum(support_vectors.^2,2)*ones(1,size(input,1)) ;
XXh2 = sum(input.^2,2)*ones(1,size(support_vectors,1)) ;
omega = XXh1+XXh2' - 2*support_vectors*input' ;
output = exp(-omega./(2*sig2)) ;

end