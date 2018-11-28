function varargout = bagging(varargin)
%BAGGING Creates bagging sets
%   Author: HENRI DE PLAEN
%
%[BagTrainX,BagTrainY] = bagging(bag_size, num_bags, TrainX, TrainY)
%
% Inputs:
%   bag_size: size of each bag
%   num_bags: number of bags in total
%   TrainX: a training set input
%   TrainY: a training set output
%
% Output:
%   BagtrainX{}: the different bag inputs
%   BagTrainY{}: the different bag outputs

%% PRELIMINARIES
assert(nargin==4,'Incorrect number of inputs') ;
bag_size = varargin{1} ;
num_bags = varargin{2} ;
TrainX = varargin{3} ;
TrainY = varargin{4} ;

%% GENERATE DATASETS
for idx = 1:num_bags
    [Xb,Yb] = draw_bag(TrainX,TrainY,bag_size) ;
    BagTrainX{idx} = Xb ;
    BagTrainY{idx} = Yb ;
end

%% RETURN
varargout{1} = BagTrainX ;
varargout{2} = BagTrainY ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xb,Yb] = draw_bag(X,Y,bag_size)
%creates bag by respecting proportions

    types_output = unique(Y) ;
    n_types = length(types_output) ;
    n_elem = size(X,1) ;
    
    Xb = [] ; Yb = [] ;
    for idx_t = 1:n_types
        loc_idx = find(strcmp(Y,types_output(idx_t))) ;
        n_unique = numel(loc_idx) ;
        
        idx_perm = randi(n_unique,round(n_unique/n_elem*bag_size),1) ;
        sel_elem = loc_idx(idx_perm) ;
        
        Xb = [Xb ; X(sel_elem,:)] ; 
        Yb = [Yb ; Y(sel_elem)] ;
    end
    
    shuffle_idx = randperm(size(Xb,1)) ;
    
    Xb = Xb(shuffle_idx,:) ;
    Yb = Yb(shuffle_idx) ;
end