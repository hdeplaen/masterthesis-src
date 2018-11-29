function varargout = pca_reduction(varargin)
%PCA_REDUCTION Perform PCA reduction on training and test set
%   Author: HENRI DE PLAEN
%
%[TrainX,TestX] = pca_reduction(TrainX,TestX)
%
%       !!! UNFINISHED !!!

%% INPUT
assert(nargin==2, 'Wrong number of input arguments (2)') ;
X = varargin{1} ;
tX = varargin{2} ;

%% PRELIMINARIES
n_input = size(X,2) ;

%% PCA REDUCTION
dim_chosen = 4 ;

[coeff,~,~,~,explained,~] = pca(X) ;
reduced_dimension = coeff(:,1:dim_chosen) ;
disp(explained(1:dim_chosen)) ;

varargout{1} = X * reduced_dimension ;
varargout{2} = tX * reduced_dimension ;

end

