% BENCHMARK TESTS
% Author: HENRI DE PLAEN

set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));

close all ; clear ; clc ;
format short ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 8 ;
plot_pca = false ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS 
%n = [500 2000 5000 10000 15000 30000 50000 100000] ;
n = 15000 ;
num_bags = 1 ;
params_svm.type = 'rbf' ;

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

for idxn = 1:length(n)
    disp('_____________________________') ;
    disp(n(idxn)) ;
    
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
        %[locX,locY,locXtest,locYtest] = standardize_data(locX,locY,locXtest,locYtest) ;
        
        %% EXPORT TEST
        csvwrite('exports/test/lsvm_rbf_chi2.csv', locXtest) ;
         
        % PCA
        %[locX,locXtest] = pca_reduction(locX,locXtest,n_pca,plot_pca) ;
        
        %CHI2
        %locX = locX(:,chi2_sel) ;
        %locXtest = locXtest(:,chi2_sel) ;
        
        disp(['Bag number ' num2str(idx_bag)]) ;
        
        expert_name = 'RBFSVMCHI2' ;
        
        %% SVM SEQ 1 EXPERT
        params_svm.seq = {'normal','dos','probe','r2l','u2r'} ;
        expert_svm = train_expert(locX,locY, 'seq-svm', params_svm) ;
        eval_svm1 = eval_expert(expert_svm, locXtest, locYtest) ;
        export_expert(expert_svm,expert_name) ;
        
        
        %% SVM PAR EXPERT
        expert_svm = train_expert(locX,locY, 'par-svm', params_svm) ;
        eval_svm2 = eval_expert(expert_svm, locXtest, locYtest) ;
        export_expert(expert_svm,expert_name) ;
    end
end