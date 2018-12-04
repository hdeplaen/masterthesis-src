function varargout = normalize_data(varargin)
%NORMALIZE_DATA normalizes all the data set based on the training set
%               based on the z-score.
%   Author: HENRI DE PLAEN
%
%[TrainX,TrainY,TestX,TestY] = normalize_data(TrainX,TrainY,TestX,TestY)

%% INPUT
assert(nargin==4, 'Wrong number of input arguments (4)') ;
X = varargin{1} ;
Y = varargin{2} ;
tX = varargin{3} ;
tY = varargin{4} ;

%% PRELIMINARIES
n_input = size(X,2) ;

%% NORMALIZE (z-score)
max_X = max(X,[],1) ;
min_X = min(X,[],1) ;
mean_X = mean(X,1) ;

Xo = X ;
tXo = tX ;

for idx = 1:n_input
    loc_max = max_X(idx) ;
    loc_min = min_X(idx) ;
    if loc_max==loc_min
        Xo(:,idx) = 0 ;
        tXo(:,idx) = 0 ;
    else
        loc_mean = mean_X(idx) ;
        Xo(:,idx) = 2*(X(:,idx)-loc_mean)/(loc_max-loc_min)-1 ;
        tXo(:,idx) = 2*(tX(:,idx)-loc_mean)/(loc_max-loc_min)-1 ;
    end
end

%% RETURN
assert(nargin==4, 'Wrong number of output arguments (4)') ;
varargout{1} = Xo ;
varargout{2} = Y ;
varargout{3} = tXo ;
varargout{4} = tY ;

end

