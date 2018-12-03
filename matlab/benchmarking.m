% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear ; clc ;

%% PARAMS
data_set = 'nsl-kdd' ;
classes_red = true ;

bag_size = 1500 ;
num_bags = 1 ;

%% PRELIMINARIES
[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PRE-PROCESS
% normalize
[trainX,trainY,testX,testY] = normalize_data(trainX,trainY,testX,testY) ;

% feature reduction (not for the moment)
%[trainX,testX] = pca_reduction(trainX,testX) ;

% bagging
[BagTrainX,BagTrainY] = bagging(bag_size, num_bags, trainX, trainY) ;
[BagTestX,BagTestY] = bagging(bag_size, num_bags, testX, testY) ;

%% EXECUTION
for idx_bag = 1:num_bags
    locX = BagTrainX{idx_bag} ;
    locY = BagTrainY{idx_bag} ;
    
    locXtest = BagTestX{idx_bag} ;
    locYtest = BagTestY{idx_bag} ;
    
    disp('_____________________________') ;
    disp(['Bag number ' num2str(idx_bag)]) ;
    
    expert_name = 'MyFirstExpert' ;

    %% KNN EXPERT
    params_knn.k = 5 ;
    expert_knn = train_expert(locX,locY, 'knn', params_knn) ;
    eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
    export_expert(expert_knn, expert_name) ;
    
    %% LS-SVM EXPERT
    params_lssvm = [] ;
    expert_lssvm = train_expert(locX,locY, 'lssvm', params_lssvm) ;
    eval_lssvm = eval_expert(expert_lssvm, locXtest, locYtest) ;
    export_expert(expert_lssvm, expert_name) ;

    %% SVM EXPERT
    params_svm = [] ;
    expert_svm = train_expert(locX,locY, 'svm', params_svm) ;
    eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
    export_expert(expert_svm, expert_name) ;
end