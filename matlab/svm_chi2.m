% BENCHMARK TESTS
% Author: HENRI DE PLAEN

set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));

close all ; clear ; clc ;
format short ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 10 ;
plot_pca = false ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS 
%n = [500 2000 5000 10000 15000 30000 50000 100000] ;
n = 30000 ;
num_bags = 1 ;
params_svm.type = 'linear' ;

corr = zeros(2,length(n),num_bags,5,5);
accm = zeros(2,length(n),num_bags,5);
mccm = zeros(2,length(n),num_bags,5);
kappam = zeros(2,length(n),num_bags,5);
acc = zeros(2,length(n),num_bags);
mcc = zeros(2,length(n),num_bags);
kappa = zeros(2,length(n),num_bags);

h = waitbar(0,'Initializing') ;

for idxn = 1:length(n)
    disp('_____________________________') ;
    disp(n(idxn)) ;
    
    %% PRE-PROCESS
    idx_perm = randperm(length(trainY)) ;
    trainX_bis = trainX(idx_perm(1:100000),:) ;
    trainY_bis = trainY(idx_perm(1:100000)) ;
    testX_bis = trainX(idx_perm(100001:end),:) ;
    testY_bis = trainY(idx_perm(100001:end)) ;
    
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
        
        % PCA
        %[locX,locXtest] = pca_reduction(locX,locXtest,n_pca,plot_pca) ;
        
        disp(['Bag number ' num2str(idx_bag)]) ;
        
        expert_name = 'MyFirstExpert' ;
        
        %% SVM SEQ 1 EXPERT
        params_svm.seq = {'normal','dos','probe','r2l','u2r'} ;
        expert_svm = train_expert(locX,locY, 'seq-svm-chi2', params_svm) ;
        eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
        [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_svm,locYtest) ;
        
        corr(1,idxn,idx_bag,:,:) = corr_ ;
        accm(1,idxn,idx_bag,:) = accm_ ;
        mccm(1,idxn,idx_bag,:) = mccm_ ;
        kappam(1,idxn,idx_bag,:) = kappam_ ;
        acc(1,idxn,idx_bag) = acc_ ;
        mcc(1,idxn,idx_bag) = mcc_ ;
        kappa(1,idxn,idx_bag) = kappa_ ;
        
        %% SVM PAR EXPERT
        expert_svm = train_expert(locX,locY, 'par-svm-chi2', params_svm) ;
        eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
        [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_svm,locYtest) ;
        
        corr(2,idxn,idx_bag,:,:) = corr_ ;
        accm(2,idxn,idx_bag,:) = accm_ ;
        mccm(2,idxn,idx_bag,:) = mccm_ ;
        kappam(2,idxn,idx_bag,:) = kappam_ ;
        acc(2,idxn,idx_bag) = acc_ ;
        mcc(2,idxn,idx_bag) = mcc_ ;
        kappa(2,idxn,idx_bag) = kappa_ ;
        
        waitbar(((idxn-1)*num_bags + idx_bag)/(numel(n)*num_bags),h,...
            ['n = ' num2str(n(idxn)) newline 'bag = ' num2str(idx_bag)]);
    end
end

delete(h) ;

%% TABLES
corr = round(mean(corr(:,:,:,:,:),3));
accm = mean(accm(:,:,:,:),3);
mccm = mean(mccm(:,:,:,:),3);
kappam = mean(kappam(:,:,:,:),3);
acc = mean(acc(:,:,:),3);
mcc = mean(mcc(:,:,:),3);
kappa = mean(kappa(:,:,:),3);

save('svm_chi2.mat','corr','accm','mccm','kappam','acc','mcc','kappa') ;

% par
disp('O-A-A') ;
disp('acc');
print_latex(100*squeeze(accm(2,length(n),:,:)));
disp('mcc') ;
print_latex(100*squeeze(mccm(2,length(n),:,:)));
disp('kappa') ;
print_latex(100*squeeze(kappam(2,length(n),:,:)));
disp('corr') ;
print_latex(squeeze(corr(2,length(n),:,:,:))) ;

% seq
disp('TREE') ;
disp('acc');
print_latex(100*squeeze(accm(1,length(n),:,:)));
disp('mcc') ;
print_latex(100*squeeze(mccm(1,length(n),:,:)));
disp('kappa') ;
print_latex(100*squeeze(kappam(1,length(n),:,:)));
disp('corr') ;
print_latex(squeeze(corr(1,length(n),:,:,:))) ;


% %% PLOT
% figure ; hold on ;
% semilogx(n,acc(1,:,:),'-k','LineWidth',2) ;
% semilogx(n,acc(2,:,:),':k','LineWidth',2) ;
% ylabel('Accuracy') ; xlabel('Training set size') ;
% ax = gca ;
% %ax.XAxisLocation = 'origin' ;
% %ax.YAxisLocation = 'origin' ;
% set(0,'DefaultLineColor','k') ;
% set(gca,'box','off') ;
% set(gca, 'FontName', 'Baskervald ADF Std') ;
% set(gca, 'FontSize', 23) ;
% set(gca,'LineWidth',2) ;
% %axis([0 it(end) -20 5]) ;
% leg = legend() ;
% set(leg,'visible','off') ;
% 
% figure ; hold on ;
% % TP/(TN+FN)
% semilogx(n,mcc(1,:,:),'-k','LineWidth',2) ;
% semilogx(n,mcc(2,:,:),':k','LineWidth',2) ;
% ylabel('Matthews Corr. Coeff.') ; xlabel('Training set size') ;
% ax = gca ;
% %ax.XAxisLocation = 'origin' ;
% %ax.YAxisLocation = 'origin' ;
% set(0,'DefaultLineColor','k') ;
% set(gca,'box','off') ;
% set(gca, 'FontName', 'Baskervald ADF Std') ;
% set(gca, 'FontSize', 23) ;
% set(gca,'LineWidth',2) ;
% %axis([0 it(end) -20 5]) ;
% leg = legend() ;
% set(leg,'visible','off') ;
% 
% figure ; hold on ;
% semilogx(n,kappa(1,:,:),'-k','LineWidth',2) ;
% semilogx(n,kappa(2,:,:),':k','LineWidth',2) ;
% ylabel('Kappa Coeff.') ; xlabel('Training set size') ;
% ax = gca ;
% %ax.XAxisLocation = 'origin' ;
% %ax.YAxisLocation = 'origin' ;
% set(0,'DefaultLineColor','k') ;
% set(gca,'box','off') ;
% set(gca, 'FontName', 'Baskervald ADF Std') ;
% set(gca, 'FontSize', 23) ;
% set(gca,'LineWidth',2) ;
% %axis([0 it(end) -20 5]) ;
% leg = legend() ;
% set(leg,'visible','off') ;