function varargout = plot_perf(varargin)
%Plots the performance of the classification.
%
%[tot_acc, acc, tp, tn, fp, fn] = PLOT_PERF(TestY_est, TestY)
%
% INPUTS
%   TestY_est       : Classes cell of estimated classes
%   TestY           : Classes cell of real classes
%
% OUTPUT
% varargout{1} = c_matrix ;
% varargout{2} = ReferenceResults.Accuracy ;
% varargout{3} = ReferenceResults.MatthewsCorrelationCoefficient ;
% varargout{4} = ReferenceResults.Kappa ;
% varargout{5} = Results.Accuracy ;
% varargout{6} = Results.MatthewsCorrelationCoefficient ;
% varargout{7} = Results.Kappa ;
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Dec, 2018

%% PRELIMINARIES
assert(nargin==2, 'Wrong number of input arguments (2)') ;
TestY_est   = varargin{1} ;
TestY       = varargin{2} ;

% fopen(1) ;
% fprintf('%%%%  EXPERT TESTING  %%%% \n') ;

%% PERFORMANCES
% classes = union(unique(TestY_est), unique(TestY)) ;                                 % all the classes found in both sets
% n_classes = numel(classes) ;
% n_test = numel(TestY) ;
% 
% acc     = zeros(n_classes,1) ;
% tp      = zeros(n_classes,1) ;
% tn      = zeros(n_classes,1) ;
% fp      = zeros(n_classes,1) ;
% fn      = zeros(n_classes,1) ;
% 
% for idx_class = 1:n_classes
%     loc_class = classes(idx_class) ;
%     TestY_est_bin = strcmp(TestY_est,loc_class) ;
%     TestY_bin = strcmp(TestY,loc_class) ;
%     
%     np = sum(TestY_bin) ;
%     nn = n_test-np ;
%     
%     adder = TestY_est_bin + TestY_bin ;
%     tp_  = sum(adder== 2) ;      % true positives 
%     tn_  = sum(adder== 0) ;      % ture negatives 
%     
%     substr = TestY_est_bin - TestY_bin ;
%     fp_  = sum(substr== 1) ;     % false positives 
%     fn_  = sum(substr==-1) ;     % false negatives 
%     
%     tp(idx_class)  = tp_ ; %/(tp_+fn_) ;     % true positives rate
%     tn(idx_class)  = tn_ ; %/(tn_+fp_) ;     % ture negatives rate
%     fp(idx_class)  = fp_ ; %/(fp_+tn_) ;     % false positives rate
%     fn(idx_class)  = fn_ ; %/(fn_+tp_) ;     % false negatives rate
%     
%     acc(idx_class) = sum(TestY_est_bin==TestY_bin)/n_test ;
%     
%     %% PRINT RESULTS
%     % PRINT RESULTS
%     fprintf(['CLASS : ' loc_class{1} '\n']) ;
%     fprintf(['Accuracy = ' num2str(acc(idx_class)*100) '%%\n']) ;
%     fprintf(['TP = ' num2str(tp(idx_class)) '%%   ']) ;
%     fprintf(['TN = ' num2str(tn(idx_class)) '%%\n']) ;
%     fprintf(['FP = ' num2str(fp(idx_class)) '%%   ']) ;
%     fprintf(['FN = ' num2str(fn(idx_class)) '%%\n \n']) ;
% end


%% TOTAL
[TestY, TestY_est,~] = cat2num(cell2table(TestY), cell2table(TestY_est), {'normal','dos','probe','r2l','u2r'}) ;
[c_matrix,Result,RefereceResult]= getMatrix(table2array(TestY),table2array(TestY_est),0) ;

%tot_acc = sum(strcmp(TestY_est, TestY))/n_test ;
%tot_acc = mean(acc) ;

%fprintf('TOTAL \n') ;
%fprintf(['Accuracy  = ' num2str(tot_acc*100) '%%\n']) ;

%% RETURN
varargout{1} = c_matrix' ;
varargout{2} = RefereceResult.AccuracyOfSingle ;
varargout{3} = RefereceResult.MatthewsCorrelationCoefficient ;
varargout{4} = RefereceResult.Kappa ;
varargout{5} = Result.Accuracy ;
varargout{6} = Result.MatthewsCorrelationCoefficient ;
varargout{7} = Result.Kappa ;

end
