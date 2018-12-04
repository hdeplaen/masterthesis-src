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
        disp('No training needed for (one-against-all) kNN model') ;          % no actions to be done except assignation
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
    case 'svm'                                              % TYPE SVM
        models = cell(n_classes,1) ;                        % prealloc
        for idx_model = 1:n_classes                         % one-against-all model
            loc_model = train_svm( ...                      % train each ls-svm apart
                TrainX,TrainY,classes(idx_model)) ;
            models{idx_model} = loc_model ;                 % assign each ls-svm
        end
    otherwise                                               % otherwise
        error('Model type not recognized') ;                % ERROR
end

%% RETURN
expert = struct() ;           % prealloc
expert.type = type ;            % assign type
expert.params = params ;        % assign model parameters
expert.models = models ;        % assign models
expert.classes = classes ;      % assign classes

assert(nargout==1, 'Wrong number of output arguments') ;
varargout{1} = expert ;

end

