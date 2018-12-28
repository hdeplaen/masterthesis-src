function varargout = train_cnn(varargin)
%Trains condensed nearest neighbours algorithm.
%
%model = TRAIN_CNN(TrainX, TrainY,class)
%
% INPUTS
%   TrainX      : Features of training set      array(elements, features)
%   TrainY      : Classes of training set       cell(elements, 1)
%
% OUTPUT
%   model       : kNN model
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==2,'Wrong number of input arguments (2)') ;
TrainX = varargin{1} ;
TrainY = varargin{2} ;

train_num = size(TrainX,1) ;

%% CNN
R1 = false(train_num,1) ;
R0 = false(train_num,1) ;

idx_rand = randi([1, train_num],1) ;
R1(idx_rand) = true ;

continue_loop = true ;
while continue_loop
    R0 = R1 ;
    for idx_add = randperm(train_num)
        loc_model = fitcknn(TrainX(R1,:),TrainY(R1),'NumNeighbors',1) ;
        knn_out = predict(loc_model,TrainX(idx_add,:)) ;
        if ~strcmp(knn_out,TrainY(idx_add))
            R1(idx_add) = true ;
        end
    end
continue_loop = sum(R0~=R1) ~= 0 ; %> 0.01*train_num ;
end


%% OUTPUT
model           = struct ;      % prealloc
model.TrainX    = TrainX(R1,:) ;
model.TrainY    = TrainY(R1) ;
model.num_nb    = sum(R1) ;

%assert(nargin==1, 'Wrong number of output arguments (1)') ;
varargout{1} = model ;


disp('CNN trained') ;

end