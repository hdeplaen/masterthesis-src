function export_expert(varargin)
%Exports an expert model.
%
%EXPORT_EXPERT(expert, filename)
%
% INPUTS
%   expert      : Trained expert model structure
%   filename    : filename for the expert to be saved
%
% NO OUTPUT
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==2,'Wrong number of input arguments (2)') ;
expert      = varargin{1} ;     % recover trained expert model
filename    = varargin{2} ;     % recover filename

export_path = 'exports' ;

type    = expert.type ;         % get model type
models  = expert.models ;       % get trained model
params  = expert.params ;       % get model parameters
classes = expert.classes ;      % get different classes

%% EXPORT DATA

% Different actions per type
switch type                                                 % for each TYPE
    
    case 'knn'                                              % TYPE kNN
         loc_name = [export_path '/' type '/' ...
                filename '_' type '_'] ;
        
        csvwrite([loc_name 'training_vec.csv'], models.TrainX) ;
            
        [TrainY, ~,~] = cat2num(cell2table(models.TrainY), array2table([]), {'normal','dos','probe','r2l','u2r'}) ;
        csvwrite([loc_name 'training_classes.csv'], table2array(TrainY)) ;
        
    case 'lssvm'                                            % TYPE LS-SVM
        n_models = size(models,1) ;                         % #models
        
        for idx_model = 1:n_models                          % one-against-all model
            loc_name = [export_path type '/' ...
                filename '_' type '_' num2str(idx_model) '_'] ;
            
            csvwrite([loc_name 'alpha.csv'], ...
                models{idx_model}.alpha) ;
            
            csvwrite([loc_name 'b.csv'], ...
                models{idx_model}.b) ;
            
            csvwrite([loc_name 'sv.csv'], ...
                models{idx_model}.sv) ;
            
            csvwrite([loc_name 'sig2.csv'], ...
                models{idx_model}.params.sig2) ;
        end
    case 'par-svm'                                              % TYPE SVM
        n_models = size(models,1) ;                         % #models
        
        for idx_model = 1:n_models                          % one-against-all model
            loc_name = [export_path '/' type '/' ...
                filename '_' type '_' num2str(idx_model) '_'] ;
            
            csvwrite([loc_name 'alpha.csv'], ...
                models{idx_model}.alpha) ;
            
            csvwrite([loc_name 'w.csv'], ...
                models{idx_model}.w) ;
            
            csvwrite([loc_name 'b.csv'], ...
                models{idx_model}.b) ;
            
            csvwrite([loc_name 'sv.csv'], ...
                models{idx_model}.sv) ;
            
            csvwrite([loc_name 'sig2.csv'], ...
                models{idx_model}.params.sig2) ;
        end
        
    case 'seq-svm'                                              % TYPE SVM
        n_models = numel(models) ;                         % #models
        
        for idx_model = 1:n_models                          % one-against-all model
            loc_name = [export_path '/' type '/' ...
                filename '_' type '_' num2str(idx_model) '_'] ;
            
            csvwrite([loc_name 'alpha.csv'], ...
                models{idx_model}.alpha) ;
            
            csvwrite([loc_name 'b.csv'], ...
                models{idx_model}.b) ;
            
            csvwrite([loc_name 'w.csv'], ...
                models{idx_model}.w) ;
            
            csvwrite([loc_name 'sv.csv'], ...
                models{idx_model}.sv) ;
            
            csvwrite([loc_name 'sig2.csv'], ...
                models{idx_model}.params.sig2) ;
        end
        
    otherwise                                               % otherwise
        error('Model type not recognized') ;                % ERROR
end

%% RETURN
assert(nargout==0, 'No output arguments') ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%