function varargout = eval_expert(varargin)
%Evaluates an expert model.
%
%TestY_eval = EVAL_EXPERT(expert, TestX, TestY)
%
% INPUTS
%   expert      : Trained expert model structure
%   TestX       : Features of test set
%   TestY       : Classes of test set (optional, [] if not wanted)
%
% OUTPUT
%   TestY_eval  : Evaluation of the test set classes
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Nov, 2018

%% PRELIMINARIES
assert(nargin==3,'Wrong number of input arguments (2 or 3)') ;
expert      = varargin{1} ;     % recover trained expert model
TestX       = varargin{2} ;     % recover test set features
TestY       = varargin{3} ;     % recover optional test set classes

type    = expert.type ;         % get model type
models  = expert.models ;       % get trained model
params  = expert.params ;       % get model parameters
classes = expert.classes ;      % get different classes

%% TYPE
n_test = size(TestX,1) ;        % number of training elements
TestY_eval = cell(n_test,1) ;   % prealloc

% Different actions per type
switch type                                                 % for each TYPE
    
    case {'knn','kmeans-knn','cnn-knn'}                               % TYPE kNN
        TestY_eval = eval_knn(models.TrainX, ...
            models.TrainY, TestX, params.k) ;
        
    case 'oaa-knn'
        n_classes = numel(classes) ;                          % #models
        oao_knn_results = zeros(n_test, n_classes) ;           % prealloc
        
        for idx_classe = 1:n_classes                     % one-against-all model
            oao_knn_results(:,idx_classe) = eval_oaa_knn( ...
                models, TestX, params.k, ...
                models.classes{idx_classe}, TestY) ;           % score for each class
        end
    case 'lssvm'                                            % TYPE LS-SVM
        n_models = size(models,1) ;                          % #models
        lssvm_results = zeros(n_test, n_models) ;           % prealloc
        
        for idx_model = 1:n_models                     % one-against-all model
            lssvm_results(:,idx_model) = eval_lssvm( ...
                models{idx_model}, TestX, 'no', TestY) ;           % score for each class
        end
        
        [~,idx_best] = max(lssvm_results,[],2) ;                % evaluate best score
        TestY_eval = classes(idx_best) ;                    % assign best score to corresponding class
        
    case 'par-svm'                                              % TYPE SVM
        n_models = size(models,1) ;                          % #models
        svm_results = zeros(n_test, n_models) ;           % prealloc
        
        for idx_model = 1:n_models                     % one-against-all model
            svm_results(:,idx_model) = eval_svm( ...
                models{idx_model}, TestX, 'no',TestY) ;           % score for each class
        end
        
        [~,idx_best] = max(svm_results,[],2) ;              % evaluate best score
        TestY_eval = classes(idx_best) ;                    % assign best score to corresponding class
        
    case 'par-svm-chi2'                                              % TYPE SVM
        n_models = size(models,1) ;                          % #models
        svm_results = zeros(n_test, n_models) ;           % prealloc
        
        for idx_model = 1:n_models                     % one-against-all model
            svm_results(:,idx_model) = eval_svm_chi2( ...
                models{idx_model}, TestX, 'no',TestY) ;           % score for each class
        end
        
        [~,idx_best] = max(svm_results,[],2) ;              % evaluate best score
        TestY_eval = classes(idx_best) ;                    % assign best score to corresponding class
        
    case 'seq-svm'                                              % TYPE SVM
        seq_in = params.seq ;
        n_models = numel(models) ;                          % #models
        svm_results = zeros(n_test, n_models) ;           % prealloc
        
        for idx_model = 1:n_models                     % one-against-all model
            svm_results(:,idx_model) = eval_svm( ...
                models{idx_model}, TestX, 'no',TestY) ;           % score for each class
        end
        
        svm_results = sign(svm_results) ;              % evaluate best score
        for idx_test = 1:size(TestX,1)
            for idx_class = 1:numel(seq_in)
                if idx_class == numel(seq_in)
                    TestY_eval{idx_test} = seq_in{idx_class} ;
                else
                    if svm_results(idx_test,idx_class) == 1
                        TestY_eval{idx_test} = seq_in{idx_class} ;
                        break ;
                    end
                end
            end
        end
        
    case 'seq-svm-chi2'                                              % TYPE SVM
        seq_in = params.seq ;
        n_models = numel(models) ;                          % #models
        svm_results = zeros(n_test, n_models) ;           % prealloc
        
        for idx_model = 1:n_models                     % one-against-all model
            svm_results(:,idx_model) = eval_svm_chi2( ...
                models{idx_model}, TestX, 'no',TestY) ;           % score for each class
        end
        
        svm_results = sign(svm_results) ;              % evaluate best score
        for idx_test = 1:size(TestX,1)
            for idx_class = 1:numel(seq_in)
                if idx_class == numel(seq_in)
                    TestY_eval{idx_test} = seq_in{idx_class} ;
                else
                    if svm_results(idx_test,idx_class) == 1
                        TestY_eval{idx_test} = seq_in{idx_class} ;
                        break ;
                    end
                end
            end
        end
        
    otherwise                                               % otherwise
        error('Model type not recognized') ;                % ERROR
end

%% RETURN
assert(nargout==1, 'Wrong number of output arguments') ;
varargout{1} = TestY_eval ;

%% EVAL
if ~isempty(TestY)                                              % if test set is given
    % GET & VERIFY TEST SET
    TestY   = varargin{3} ;
    assert(size(TestY,1)==n_test, ...
        'Number of elements not consistent in the test set') ;
    
    % COMPUTE RESULTS
    %    acc = sum(strcmp(TestY,TestY_eval))/n_test ;                % accuracy
    
    % PRINT RESULTS
    %     fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
    %     fprintf('%%%%%%  EXPERT RESULTS  %%%%%% \n') ;
    %     fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;
    %     fprintf(['Type : ' type '\n \n']) ;
    %
    %     fprintf('TESTING RESULTS\n') ;
    %     fprintf(['Accuracy = ' num2str(acc*100) '%%\n']) ;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

