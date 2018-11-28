% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear all ; clc ;

%% PARAMS
data_set = 'nsl-kdd' ;
classes_red = true ;

bag_size = 15000 ;
num_bags = 2 ;

%% PRELIMINARIES
[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PRE-PROCESS
% normalize
[trainX,trainY,testX,testY] = normalize_data(trainX,trainY,testX,testY) ;

% feature reduction (not for the moment)

% bagging
[BagTrainX,BagTrainY] = bagging(bag_size, num_bags, trainX(:,2:end), trainY) ;

%% EXECUTION
for idx_bag = 1:num_bags
    locX = BagTrainX{idx_bag} ;
    locY = BagTrainY{idx_bag} ;
    
    trainY_normal = strcmp(locY,'normal') ;
    testY_normal = strcmp(testY,'normal') ;
    
    disp('_____________________________') ;
    disp(['Bag number ' num2str(idx_bag)]) ;
%     [alpha,b] = lssvm_ids(10,1,locX,trainY_normal,testX(:,2:end),testY_normal) ;
%     alpha_bag{idx_bag} = alpha ; b_bag{idx_bag} = b ;
    
%     knn_ids(locX,trainY_normal,testX(:,2:end),testY_normal,1) ;
%     knn_ids(locX,trainY_normal,testX(:,2:end),testY_normal,3) ;
%     knn_ids(locX,trainY_normal,testX(:,2:end),testY_normal,5) ;
%     knn_ids(locX,trainY_normal,testX(:,2:end),testY_normal,7) ;
end


%% VISULAISATIONS