function varargout = chi2_reduction(varargin)
%PCA_REDUCTION Perform PCA reduction on training and test set
%   Author: HENRI DE PLAEN
%
%[TrainX,TrainY,TestX,TestY] = pca_reduction(TrainX,TrainY,TestX,TestY)
%
%       !!! UNFINISHED !!!

%% INPUT
assert(nargin==4, 'Wrong number of input arguments (4)') ;
X = varargin{1} ;
Y = varargin{2} ;
tX = varargin{3} ;
tY = varargin{4} ;

%% PRELIMINARIES
n_input = size(X,2) ;



ends

