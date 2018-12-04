function varargout = kpca_reduction(varargin)
%Performs KPCA reduction
%
%expert = KPCA_REDUCTION(TrainX, TrainY, type, params)
%
% INPUTS
%   TrainX      : Features of training set      array(elements, features)
%   TrainY      : Classes of training set       cell(elements, 1)
%   type        : Type of classifier            ('ls-svm', 'svm' or 'knn')
%   params      : Parameters for the expert     (depends on the type)
%
% OUTPUT
%   expert      : Trained expert model structure
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% INPUT
assert(nargin==4, 'Wrong number of input arguments (4)') ;
X = varargin{1} ;
Y = varargin{2} ;
tX = varargin{3} ;
tY = varargin{4} ;

%% PRELIMINARIES
n_input = size(X,2) ;

%% NORMALIZE (z-score)
mean_X = mean(X,2) ;
std_X = std(X,0,2) ;

Xo = X ;
tXo = tX ;

for idx = 1:n_input
    loc_mean = mean_X(idx) ;
    loc_var = std_X(idx) ;
    Xo(:,idx) = (X(:,idx)-loc_mean)/loc_var ;
    tXo(:,idx) = (tX(:,idx)-loc_mean)/loc_var ;
end

%% RETURN
assert(nargin==4, 'Wrong number of output arguments (4)') ;
varargout{1} = Xo ;
varargout{2} = Y ;
varargout{3} = tXo ;
varargout{4} = tY ;

end

