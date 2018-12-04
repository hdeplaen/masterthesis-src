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
%   tot_acc         : Accuracy of the estimation
%   acc             : Accuries cell per class
%   tp              : True positive rate cell
%   tn              : True negative rate cell
%   fp              : False positive rate cell
%   fn              : False negative rate cell
%
%Author: HENRI DE PLAEN, KU Leuven
%Date: Dec, 2018

%% PRELIMINARIES
assert(nargin==2, 'Wrong number of input arguments (2)') ;
TestY_est   = varargin{1} ;
TestY       = varargin{2} ;

fopen(1) ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n') ;
fprintf('%%%%  EXPERT TESTING  %%%% \n') ;
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% \n \n') ;

%% PERFORMANCES
classes = union(unique(TestY_est), unique(TestY)) ;                                 % all the classes found in both sets
n_classes = numel(classes) ;
n_test = numel(TestY) ;

acc     = zeros(n_classes,1) ;
tp      = zeros(n_classes,1) ;
tn      = zeros(n_classes,1) ;
fp      = zeros(n_classes,1) ;
fn      = zeros(n_classes,1) ;

for idx_class = 1:n_classes
    loc_class = classes(idx_class) ;
    TestY_est_bin = strcmp(TestY_est,loc_class) ;
    TestY_bin = strcmp(TestY,loc_class) ;
    
    adder = TestY_est_bin + TestY_bin ;
    tp(idx_class)  = sum(adder== 2)/n_test ;      % true positives rate
    tn(idx_class)  = sum(adder== 0)/n_test ;      % ture negatives rate
    
    substr = TestY_est_bin - TestY_bin ;
    fp(idx_class)  = sum(substr== 1)/n_test ;     % false positives rate
    fn(idx_class)  = sum(substr==-1)/n_test ;     % false negatives rate
    
    acc(idx_class) = sum(TestY_est_bin==TestY_bin)/n_test ;
    
    %% PRINT RESULTS
    % PRINT RESULTS
    fprintf(['CLASS : ' loc_class '\n']) ;
    fprintf(['Accuracy = ' num2str(acc(idx_class)*100) '%%\n']) ;
    fprintf(['TP = ' num2str(tp(idx_class)*100) '%%   ']) ;
    fprintf(['TN = ' num2str(tn(idx_class)*100) '%%\n']) ;
    fprintf(['FP = ' num2str(fp(idx_class)*100) '%%   ']) ;
    fprintf(['FN = ' num2str(fn(idx_class)*100) '%%\n \n']) ;
end

tot_acc = mean(acc) ;
fprintf('TOTAL \n') ;
fprintf(['Accuracy  = ' num2str(tot_acc*100) '%%\n']) ;

%% RETURN
varargout{1} = tot_acc ;
varargout{2} = acc ;
varargout{3} = tp ;
varargout{4} = tn ;
varargout{5} = fp ;
varargout{6} = fn ;

end
