% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear all ; clc ;

%% PARAMS
data_set = 'nsl-kdd' ;
classes_red = true ;

bag_size = 500 ;
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

    param = 5 ;
    type = 'lssvm' ;
    [Ytest_est] = ids_expert(locX,locY,locXtest,locYtest,type,param) ;
end


%% VISUALIZATIONS