% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear ; clc ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 10 ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
k = 1 ;
%n = [500 2000 5000 10000 15000] ;
n = 300000 ;
num_bags = 1 ;

tot_acc_ = zeros(length(k), length(n), num_bags) ;
acc_ = zeros(length(k), length(n), num_bags, 5) ;
tp_ = zeros(length(k), length(n), num_bags, 5) ;
tn_ = zeros(length(k), length(n), num_bags, 5) ;
fp_ = zeros(length(k), length(n), num_bags, 5) ;
fn_ = zeros(length(k), length(n), num_bags, 5) ;

for idxn = 1:length(n)
    for idxk = 1:length(k)
        
        %% PRE-PROCESS
        % bagging
        [BagTrainX,BagTrainY] = bagging(n(idxn), num_bags, trainX, trainY) ;
        [BagTestX,BagTestY] = bagging(15000, num_bags, testX, testY) ;
        
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
            [trainX,testX] = pca_reduction(trainX,testX,n_pca) ;
            
            disp('_____________________________') ;
            disp(['Bag number ' num2str(idx_bag)]) ;
            
            expert_name = 'MyFirstExpert' ;
            
            %% KNN EXPERT
            params_knn.k = k(idxk) ;
            expert_knn = train_expert(locX,locY, 'knn', params_knn) ;
            eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
            [tot_acc, acc, tp, tn, fp, fn] = plot_perf(eval_knn,locYtest) ;
            
            tot_acc(idxk,idxn,idx_bag) = tot_acc ;
            acc_(idxk,idxn,idx_bag,:) = acc(:) ;
            tp_(idxk,idxn,idx_bag,:) = tp(:) ;
            tn_(idxk,idxn,idx_bag,:) = tn(:) ;
            fp_(idxk,idxn,idx_bag,:) = fp(:) ;
            fn_(idxk,idxn,idx_bag,:) = fn(:) ;
        end
    end
end

save('knn-1-quat.mat','tot_acc_','acc_','tp_','tn_','fp_','fn_') ;