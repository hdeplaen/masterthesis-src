% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear ; clc ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 8 ;
method = 'knn' ;

chi2 = [  1
   1
   0
   1
   1
   1
   1
   1
   0
   0
   0
   1
   1
   1
   1
   0
   0
   1
   1
   0
   0
   0
   0
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1] ;
chi2 = logical(chi2) ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
k = 1 ;
%n = [2000 5000 10000 15000 30000 50000 100000] ;
n = 2000 ;
num_bags = 1 ;
disp_pca = false ;

corr = zeros(length(k),length(n),num_bags,5,5);
accm = zeros(length(k),length(n),num_bags,5);
mccm = zeros(length(k),length(n),num_bags,5);
kappam = zeros(length(k),length(n),num_bags,5);
acc = zeros(length(k),length(n),num_bags);
mcc = zeros(length(k),length(n),num_bags);
kappa = zeros(length(k),length(n),num_bags);

for idxn = 1:length(n)
    disp(n(idxn)) ;
    for idxk = 1:length(k)
        
        %% PRE-PROCESS
        idx_perm = randperm(length(trainY)) ;
        trainX_bis = trainX(idx_perm(1:100000),:) ;
        trainY_bis = trainY(idx_perm(1:100000)) ;
        testX_bis = trainX(idx_perm(100001:end),:) ;
        testY_bis = trainY(idx_perm(100001:end)) ;
        
        trainX_bis = trainX_bis(:,chi2) ;
        testX_bis = testX_bis(:,chi2) ;
        
        %     trainX_bis = trainX ;
        %     trainY_bis = trainY ;
        %     testX_bis = testX ;
        %     testY_bis = testY ;
        
        % bagging
        [BagTrainX,BagTrainY] = bagging(n(idxn), num_bags, trainX_bis, trainY_bis) ;
        [BagTestX,BagTestY] = bagging(10000, num_bags, testX_bis, testY_bis) ;
        
        %% EXECUTION
        
        for idx_bag = 1:num_bags
            locX = BagTrainX{idx_bag} ;
            locY = BagTrainY{idx_bag} ;
            
            locXtest = BagTestX{idx_bag} ;
            locYtest = BagTestY{idx_bag} ;
            
            % normalize
            [locX,locY,locXtest,locYtest] = normalize_data(locX,locY,locXtest,locYtest) ;
            [locX,locY,locXtest,locYtest] = standardize_data(locX,locY,locXtest,locYtest) ;
            
            % PCA
            [trainX,testX] = pca_reduction(trainX,testX,n_pca,disp_pca) ;
            
            %CHI2
            %locX = locX(:,chi2_sel) ;
            %locXtest = locXtest(:,chi2_sel) ;
            
            csvwrite('exports/test/knn_chi2.csv', locXtest) ;
            
            disp('_____________________________') ;
            disp(['Bag number ' num2str(idx_bag)]) ;
            
            expert_name = 'KNNNCHI2' ;
            
            %% KNN EXPERT
            params_knn.k = k(idxk) ;
            expert_knn = train_expert(locX,locY, method, params_knn) ;
            eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
            export_expert(expert_knn,expert_name) ;

        end
    end
end