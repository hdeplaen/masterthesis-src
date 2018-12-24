function varargout = bagging(varargin)
%Creates different bags with proportions as equal as possible between the
%different classes.
%
%[BagTrainX,BagTrainY] = BAGGING(bag_size, num_bags, TrainX, TrainY)
%
% INPUTS
%   bag_size    : size of each bag
%   num_bags    : number of bags in total
%   TrainX      : a training set input
%   TrainY      : a training set output
%
% OUTPUTS
%   BagTrainX{} : the different bags inputs
%   BagTrainY{} : the different bags outputs
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==4,'Incorrect number of inputs') ;
bag_size = varargin{1} ;
num_bags = varargin{2} ;
TrainX = varargin{3} ;
TrainY = varargin{4} ;


%% GENERATE DATASETS
for idx = 1:num_bags                                % for each bag
    [Xb,Yb] = draw_bag(TrainX,TrainY,bag_size) ;    % generate the bag
    BagTrainX{idx} = Xb ;                           % assign to a structure (input)
    BagTrainY{idx} = Yb ;                           % assign to a structure (output)
end


%% RETURN
varargout{1} = BagTrainX ;
varargout{2} = BagTrainY ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xb,Yb] = draw_bag(X,Y,bag_size)
% Creates bag by respecting original proportions

%% DEFINE PROPORTIONS
types_output = unique(Y) ;                              % output classes
n_types = length(types_output) ;                        % number of output classes
idx_normal = find(strcmp(types_output, 'normal')) ;

n_restant = n_types ;                                   % number of classes above the threshold
num_unique = zeros(n_types,1) ;                         % prealloc
num_unique(idx_normal) = round(.3*bag_size) ;
threshold = round(bag_size*.3/(n_types-1)) ;            % minimum number of elements needed

for idx_t = setdiff(1:n_types,idx_normal)
    num_idx = sum(strcmp(Y,types_output(idx_t))) ;      % number of element of a class
    if num_idx < threshold                              % verify if this number is under the threshold
        num_unique(idx_t) = num_idx ;                   % if so, get all instances possible 
        n_restant = n_restant-1 ;                       % reduce the number of classes above the threshold
    end
end

% divide the number of restant elements to divide between the classes above
% the threshold
num_unique(num_unique==0) = round((bag_size-sum(num_unique))/n_restant) ;


%% CREATE PARTS
Xb = [] ; Yb = [] ;                                     % predefine empty (not optimal, prealloc better)

for idx_t = 1:n_types                                   % for each class
    loc_idx = find(strcmp(Y,types_output(idx_t))) ;     % index of elements of that class
    n_unique = numel(loc_idx) ;                         % number of elements of that class
    
    idx_perm = randi(n_unique,num_unique(idx_t),1) ;    % select randomly num_unique(idx_t) elements
    sel_elem = loc_idx(idx_perm) ;                      % between the elements of the class
    
    Xb = [Xb ; X(sel_elem,:)] ;                         % add them to the bag (input)
    Yb = [Yb ; Y(sel_elem)] ;                           % add them to the bag (output)
end


%% SUFFLE FINAL BAG
shuffle_idx = randperm(size(Xb,1)) ;                    % compute the shuffle
Xb = Xb(shuffle_idx,:) ;                                % shuffle input
Yb = Yb(shuffle_idx) ;                                  % shuffle output

end