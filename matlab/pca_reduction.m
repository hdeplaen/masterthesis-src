function varargout = pca_reduction(varargin)
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

%% PCA REDUCTION
types_output = unique(Y) ;
n_types = length(types_output) ;

for idx_t = 1:n_types
    loc_idx = find(strcmp(Y,types_output(idx_t))) ;
    n_unique = numel(loc_idx) ;
    
    idx_perm = randi(n_unique,round(n_unique/n_elem*bag_size),1) ;
    sel_elem = loc_idx(idx_perm) ;
    
    Xb = [Xb ; X(sel_elem,:)] ;
    Yb = [Yb ; Y(sel_elem)] ;
end


[coeff,score,latent,tsquared,explained,mu] = pca

end

