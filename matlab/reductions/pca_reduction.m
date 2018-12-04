function varargout = pca_reduction(varargin)
%PCA_REDUCTION Perform PCA reduction on training and test set
%   Author: HENRI DE PLAEN
%
%[TrainX,TestX] = pca_reduction(TrainX,TestX,dim)

%% INPUT
assert(nargin==3, 'Wrong number of input arguments (3)') ;
X           = varargin{1} ;
tX          = varargin{2} ;
dim_chosen  = varargin{3} ;

%% PCA REDUCTION

[coeff,~,~,~,explained,~] = pca(X) ;
reduced_dimension = coeff(:,1:dim_chosen) ;
disp(explained(1:dim_chosen)) ;
disp(sum(explained(1:dim_chosen))) ;


varargout{1} = X * reduced_dimension ;
varargout{2} = tX * reduced_dimension ;

end

