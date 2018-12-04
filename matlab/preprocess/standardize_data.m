function varargout = standardize_data(varargin)
%NORMALIZE_DATA normalizes all the data set based on the training set
%               based on the z-score.
%   Author: HENRI DE PLAEN
%
%[TrainX,TrainY,TestX,TestY] = z_score_data(TrainX,TrainY,TestX,TestY)

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

