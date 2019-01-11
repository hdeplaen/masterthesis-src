% Privacy-friendly machine learning algorithms for intrusion detection
% systems
% Example script
%
% Author: HENRI DE PLAEN
% Copyright KULeuven

%% PRELIMINARIES
k = 1;                  % number of nearest neighbors
n = 10000;              % number of elements in the training sets
num_bags = 5;           % number of experiments
disp_pca = false;       % don't plot the PCA componenets
expert = 'knn-cnn';     % type of expert used
data-set = 'nsl-kdd';   % data-set used

% preallocate the experiments results
corr = zeros(num_bags,5,5);
accm = zeros(num_bags,5);
mccm = zeros(num_bags,5);
kappam = zeros(num_bags,5);
acc = zeros(num_bags);
mcc = zeros(num_bags);
kappa = zeros(num_bags);
num_nb = zeros(num_bags);

%% GENERATE TRAINING AND TEST SETS
[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;
[BagTrainX,BagTrainY] = bagging(n(idxn), num_bags, trainX, trainY) ;
[BagTestX,BagTestY] = bagging(10000, num_bags, testX, testY) ;
        
% EXECUTE EACH EXPERIMENT
for idx_bag = 1:num_bags
    % extract the corresponding training set for this experiment
    locX = BagTrainX{idx_bag} ;
    locY = BagTrainY{idx_bag} ;
            
    % extract the corresponding test set for this experiment
    locXtest = BagTestX{idx_bag} ;
    locYtest = BagTestY{idx_bag} ;
            
    % normalize
    [locX,locY,locXtest,locYtest] = normalize_data(locX,locY,locXtest,locYtest) ;
            
    % PCA
    [trainX,testX] = pca_reduction(trainX,testX,n_pca,disp_pca) ;
            
    %% train and evaluate expert
    params_knn.k = k ;
    expert_knn = train_expert(locX,locY, expert, params_knn) ;
    eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
    export_expert(expert_knn, 'MyFirstExpert') ;
            
    [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_knn,locYtest) ;
    
    % store the results of each experiment
    corr(idx_bag,:,:) = corr_ ;
    accm(idx_bag,:) = accm_ ;
    mccm(idx_bag,:) = mccm_ ;
    kappam(idx_bag,:) = kappam_ ;
    acc(idx_bag) = acc_ ;
    mcc(idx_bag) = mcc_ ;
    kappa(idx_bag) = kappa_ ;
    num_nb(idx_bag) = expert_knn.num_nb ;
end
    
%% PLOT RESULTS
% mean of all experiments
corr = round(mean(corr(:,:,:),1));
accm = mean(accm(:,:),1);
mccm = mean(mccm(:,:),1);
kappam = mean(kappam(:,:),1);
acc = mean(acc(:),1);
mcc = mean(mcc(:),1);
kappa = mean(kappa(:),1);
num_nb = mean(num_nb(:),1);

% display the mean results
disp('k = 1') ;
disp('acc');
disp(squeeze(100*acc) ;
disp(squeeze(100*accm(:,:)));
disp('mcc') ;
disp(squeeze(100*mcc)) ;
disp(squeeze(100*mccm(:,:)));
disp('kappa') ;
disp(squeeze(100*kappa)) ;
disp(squeeze(100*kappam(:,:)));
disp('corr') ;
disp(squeeze(corr(:,:,:))) ;