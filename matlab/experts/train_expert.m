function varargout = train_expert(varargin)
%Trains an expert model.
%
%expert = TRAIN_EXPERT(TrainX, TrainY, type, params)
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

%% PRELIMINARIES
assert(nargin==4,'Wrong number of input arguments (4)') ;
TrainX = varargin{1} ;
TrainY = varargin{2} ;
type   = varargin{3} ;
params = varargin{4} ;

%% DATASETS & CREATE EXPERT
n_train = size(TrainX,1) ; % number of training elements

assert(size(TrainY,1)==n_train, ...
    'Number of elements not consistent in the traning set') ;

%% TYPE
classes = unique(TrainY) ;
n_classes = numel(classes) ;

% Different actions per type
switch type                                                 % for each TYPE
    
    case 'knn'                                              % TYPE kNN
        disp('No training needed for kNN model') ;          % no actions to be done except assignation
        models.TrainX = TrainX ;
        models.TrainY = TrainY ;
        
    case 'oaa-knn'
        disp('No training needed for (one-against-all) kNN model') ;          % no actions to be done except from  assignation
        models.TrainX   = TrainX ;
        models.TrainY   = TrainY ;
        models.classes  = classes ;
        
    case 'lssvm'                                            % TYPE LS-SVM
        models = cell(n_classes,1) ;                        % prealloc
        for idx_model = 1:n_classes                         % one-against-all model
            loc_model = train_lssvm( ...                    % train each ls-svm apart
                TrainX,TrainY,classes(idx_model)) ;
            models{idx_model} = loc_model ;                 % assign each ls-svm
        end
    case 'par-svm'                                          % TYPE PARALLEL SVM
        type_svm = params.type ;
        models = cell(n_classes,1) ;                        % prealloc
        for idx_model = 1:n_classes                         % one-against-all model
            loc_model = train_svm( ...                      % train each ls-svm apart
                TrainX,TrainY,classes(idx_model),type_svm) ;
            models{idx_model} = loc_model ;                 % assign each ls-svm
        end
    case 'seq-svm'                                          % TYPE SEQUENTIAL SVM
        type_svm = params.type ;
        in_seq = params.seq ;
        [X_out, Y_out] = generate_seq(TrainX,TrainY, in_seq) ;
        for idx_model = 1:n_classes-1                       % one-against-all model
            loc_model = train_svm( ...                      % train each ls-svm apart
                X_out{idx_model}, ...
                Y_out{idx_model}, ...
                in_seq(idx_model), ...
                type_svm) ;
            models{idx_model} = loc_model ;                 % assign each ls-svm
        end
    otherwise                                               % otherwise
        error('Model type not recognized') ;                % ERROR
end

%% RETURN
expert = struct() ;             % prealloc
expert.type = type ;            % assign type
expert.params = params ;        % assign model parameters
expert.models = models ;        % assign models
expert.classes = classes ;      % assign classes

assert(nargout==1, 'Wrong number of output arguments') ;
varargout{1} = expert ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X_out,Y_out] = generate_seq(X,Y,in_seq)
% Creates bag by respecting original proportions

%% DEFINE PROPORTIONS
n_types = length(in_seq) ;                          % number of output classes
X_out = cell(n_types-1,1) ;
Y_out = cell(n_types-1,1) ;

for idx_t = 1:n_types-1                             % for each class
    loc_idx = find(strcmp(Y,in_seq(idx_t))) ;       % index of elements of that class
    
    X_out{idx_t} = X ;                              % add them to the bag (output)
    Y_out{idx_t} = Y ;
           
    X(loc_idx,:) = [] ;
    Y(loc_idx) = [] ;
end

end