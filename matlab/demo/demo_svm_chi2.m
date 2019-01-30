% BENCHMARK TESTS
% Author: HENRI DE PLAEN

set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));

close all ; clear ; clc ;
format short ;
rng(0681349) ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 10 ;
plot_pca = false ;
n_test = 10 ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
n = 15000 ;
num_bags = 1 ;
params_svm.type = 'lin' ;

% bagging
[BagTrainX,BagTrainY] = bagging(n, num_bags, trainX, trainY) ;
[BagTestX,BagTestY] = bagging(10000, num_bags, testX, testY) ;

%% EXECUTION
chi2 = [1 1 1 1 1 1 1 1 1 0 ...
    1 1 1 1 1 1 0 1 0 0 ...
    0 0 0 1 1 1 1 1 1 1 ...
    1 1 1 0 0 0 1 1 1 1 ...
    1 0 1]' ;
chi2 = logical(chi2) ;

for idx_bag = 1:num_bags
    locX = BagTrainX{idx_bag} ;
    locY = BagTrainY{idx_bag} ;
    
    locXtest = BagTestX{idx_bag} ;
    locYtest = BagTestY{idx_bag} ;
    
    locX = locX(:,chi2) ;
    locXtest = locXtest(1:n_test, chi2) ;
    locYtest = locYtest(1:n_test) ;
    
    % normalize
    [locX,locY,locXtest,locYtest] = normalize_data(locX,locY,locXtest,locYtest) ;
    
    csvwrite('tests.csv', locXtest) ;
    
    %% SVM SEQ 1 EXPERT
    params_svm.seq = {'normal','dos','probe','r2l','u2r'} ;
    expert_svm = train_expert(locX,locY, 'seq-svm', params_svm) ;
    export_expert(expert_svm,'DEMO-SVM') ;
    
    eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
end

%% DEMO
clc ;
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') ;

disp('Real attack class:') ;
disp(locYtest') ;

disp('Predicted attack class:') ;
disp(eval_svm') ;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') ;