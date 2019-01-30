% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear ; clc ;
rng(0681349) ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
method = 'cnn-knn' ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
k = 1 ;
n = 10000 ;
num_bags = 1 ;
disp_pca = false ;
n_pca = 16 ;
vec_idx = 1:10 ;

for idx_pca = 1:length(n_pca)
    disp(n_pca(idx_pca)) ;
    for idxk = 1:length(k)
        
        %% PRE-PROCESS        
        % bagging
        [BagTrainX,BagTrainY] = bagging(n, num_bags, trainX, trainY) ;
        [BagTestX,BagTestY] = bagging(10000, num_bags, testX, testY) ;
        
        %% EXECUTION
        
        for idx_bag = 1:num_bags
            locX = BagTrainX{idx_bag} ;
            locY = BagTrainY{idx_bag} ;
            
            locXtest = BagTestX{idx_bag} ;
            locYtest = BagTestY{idx_bag} ;
            
            % normalize
            [locX,locY,locXtest,locYtest] = normalize_data(locX,locY,locXtest,locYtest) ;
            [locX,locY,locXtest,locYtest] = standardize_data(locX,locY,locXtest,locYtest) ;
            
            locXtest = locXtest(vec_idx,:) ;
            locYtest = locYtest(vec_idx) ;
            
            csvwrite('testing_vec.csv', locXtest) ;
            
            % PCA
            [locX,locXtest] = pca_reduction(locX,locXtest,n_pca(idx_pca),disp_pca) ;
            
            disp('_____________________________') ;
            disp(['Bag number ' num2str(idx_bag)]) ;
            
            expert_name = 'DEMO_' ;
            
            %% KNN EXPERT
            params_knn.k = k(idxk) ;
            expert_knn = train_expert(locX,locY, method, params_knn) ;
            export_expert(expert_knn,expert_name) ;
            
            eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
        end
    end
end
%% DEMO
clc ;
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') ;

disp('Real attack class:') ;
disp(locYtest') ;

disp('Predicted attack class:') ;
disp(eval_knn') ;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') ;