% BENCHMARK TESTS
% Author: HENRI DE PLAEN

set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));

close all ; clear ; clc ;
format short ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
n_pca = 4:4:28 ;
%n_pca = [6 8] ;
plot_pca = false ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
%n = [500 2000 5000 10000 15000 30000 50000 100000] ;
n = [15000] ;
num_bags = 5 ;
params_svm.type = 'rbf' ;

corr = zeros(3,length(n_pca),num_bags,5,5);
accm = zeros(3,length(n_pca),num_bags,5);
mccm = zeros(3,length(n_pca),num_bags,5);
kappam = zeros(3,length(n_pca),num_bags,5);
acc = zeros(3,length(n_pca),num_bags);
mcc = zeros(3,length(n_pca),num_bags);
kappa = zeros(3,length(n_pca),num_bags);
num_sv = zeros(3,length(n_pca),num_bags);

h = waitbar(0,'Initializing') ;

for idx_pca = 1:length(n_pca)
    disp('_____________________________') ;
    disp(n_pca(idx_pca)) ;
    
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
    [BagTrainX,BagTrainY] = bagging(n, num_bags, trainX_bis, trainY_bis) ;
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
        [locX,locXtest] = pca_reduction(locX,locXtest,n_pca(idx_pca),plot_pca) ;
        
        disp(['Bag number ' num2str(idx_bag)]) ;
        
        expert_name = 'MyFirstExpert' ;
        
        %% SVM SEQ 1 EXPERT
        params_svm.seq = {'normal','dos','probe','r2l','u2r'} ;
        expert_svm = train_expert(locX,locY, 'seq-svm', params_svm) ;
        eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
        [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_svm,locYtest) ;
        
        corr(1,idx_pca,idx_bag,:,:) = corr_ ;
        accm(1,idx_pca,idx_bag,:) = accm_ ;
        mccm(1,idx_pca,idx_bag,:) = mccm_ ;
        kappam(1,idx_pca,idx_bag,:) = kappam_ ;
        acc(1,idx_pca,idx_bag) = acc_ ;
        mcc(1,idx_pca,idx_bag) = mcc_ ;
        kappa(1,idx_pca,idx_bag) = kappa_ ;
        num_sv(1,idx_pca,idx_bag) = expert_svm.num_sv ;
        
        
        %% SVM SEQ 2 EXPERT
        params_svm.seq = {'probe','u2r','r2l','dos','normal'} ;
        expert_svm = train_expert(locX,locY, 'seq-svm', params_svm) ;
        eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
        [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_svm,locYtest) ;
        
        corr(2,idx_pca,idx_bag,:,:) = corr_ ;
        accm(2,idx_pca,idx_bag,:) = accm_ ;
        mccm(2,idx_pca,idx_bag,:) = mccm_ ;
        kappam(2,idx_pca,idx_bag,:) = kappam_ ;
        acc(2,idx_pca,idx_bag) = acc_ ;
        mcc(2,idx_pca,idx_bag) = mcc_ ;
        kappa(2,idx_pca,idx_bag) = kappa_ ;
        num_sv(2,idx_pca,idx_bag) = expert_svm.num_sv ;
        
        %% SVM PAR EXPERT
        expert_svm = train_expert(locX,locY, 'par-svm', params_svm) ;
        eval_svm = eval_expert(expert_svm, locXtest, locYtest) ;
        [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_svm,locYtest) ;
        
        corr(3,idx_pca,idx_bag,:,:) = corr_ ;
        accm(3,idx_pca,idx_bag,:) = accm_ ;
        mccm(3,idx_pca,idx_bag,:) = mccm_ ;
        kappam(3,idx_pca,idx_bag,:) = kappam_ ;
        acc(3,idx_pca,idx_bag) = acc_ ;
        mcc(3,idx_pca,idx_bag) = mcc_ ;
        kappa(3,idx_pca,idx_bag) = kappa_ ;
        num_sv(3,idx_pca,idx_bag) = expert_svm.num_sv ;
        
        waitbar(((idx_pca-1)*num_bags + idx_bag)/(numel(n)*num_bags),h,...
            ['#pca = ' num2str(n_pca(idx_pca)) newline 'bag = ' num2str(idx_bag)]);
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
num_sv = mean(num_sv(:,:,:),3);

save('svm_pca_nl.mat','corr','accm','mccm','kappam','acc','mcc','kappa','num_sv') ;

print_pca = length(n_pca) ;
% par
disp('O-A-A') ;
disp('acc');
print_latex(squeeze(100*accm(3,print_pca,:,:)));
disp('mcc') ;
print_latex(squeeze(100*mccm(3,print_pca,:,:)));
disp('kappa') ;
print_latex(squeeze(100*kappam(3,print_pca,:,:)));
disp('corr') ;
print_latex(squeeze(corr(3,print_pca,:,:,:))) ;

% seq
disp('TREE') ;
disp('acc');
print_latex(squeeze(100*accm(2,print_pca,:,:)));
disp('mcc') ;
print_latex(squeeze(100*mccm(2,print_pca,:,:)));
disp('kappa') ;
print_latex(squeeze(100*kappam(2,print_pca,:,:)));
disp('corr') ;
print_latex(squeeze(corr(2,print_pca,:,:,:))) ;


%% PLOT
figure ; hold on ;
semilogx(n_pca,acc(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,acc(2,:,:),':k','LineWidth',2) ;
semilogx(n_pca,acc(3,:,:),'-.k','LineWidth',2) ;
ylabel('Accuracy') ; xlabel('Number of principal components') ;
ax = gca ;
%ax.XAxisLocation = 'origin' ;
%ax.YAxisLocation = 'origin' ;
set(0,'DefaultLineColor','k') ;
set(gca,'box','off') ;
set(gca, 'FontName', 'Baskervald ADF Std') ;
set(gca, 'FontSize', 23) ;
set(gca,'LineWidth',2) ;
%axis([0 it(end) -20 5]) ;
leg = legend() ;
set(leg,'visible','off') ;

figure ; hold on ;
% TP/(TN+FN)
semilogx(n_pca,mcc(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,mcc(2,:,:),':k','LineWidth',2) ;
semilogx(n_pca,mcc(3,:,:),'-.k','LineWidth',2) ;
ylabel('Matthews Corr. Coeff.') ; xlabel('Number of principal components') ;
ax = gca ;
%ax.XAxisLocation = 'origin' ;
%ax.YAxisLocation = 'origin' ;
set(0,'DefaultLineColor','k') ;
set(gca,'box','off') ;
set(gca, 'FontName', 'Baskervald ADF Std') ;
set(gca, 'FontSize', 23) ;
set(gca,'LineWidth',2) ;
%axis([0 it(end) -20 5]) ;
leg = legend() ;
set(leg,'visible','off') ;

figure ; hold on ;
semilogx(n_pca,kappa(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,kappa(2,:,:),':k','LineWidth',2) ;
semilogx(n_pca,kappa(3,:,:),'-.k','LineWidth',2) ;
ylabel('Kappa Coeff.') ; xlabel('Number of principal components') ;
ax = gca ;
%ax.XAxisLocation = 'origin' ;
%ax.YAxisLocation = 'origin' ;
set(0,'DefaultLineColor','k') ;
set(gca,'box','off') ;
set(gca, 'FontName', 'Baskervald ADF Std') ;
set(gca, 'FontSize', 23) ;
set(gca,'LineWidth',2) ;
%axis([0 it(end) -20 5]) ;
leg = legend() ;
set(leg,'visible','off') ;

figure ; hold on ;
semilogx(n_pca,num_sv(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,num_sv(2,:,:),':k','LineWidth',2) ;
semilogx(n_pca,num_sv(3,:,:),'-.k','LineWidth',2) ;
ylabel('Kappa Coeff.') ; xlabel('Number of principal components') ;
ax = gca ;
%ax.XAxisLocation = 'origin' ;
%ax.YAxisLocation = 'origin' ;
set(0,'DefaultLineColor','k') ;
set(gca,'box','off') ;
set(gca, 'FontName', 'Baskervald ADF Std') ;
set(gca, 'FontSize', 23) ;
set(gca,'LineWidth',2) ;
%axis([0 it(end) -20 5]) ;
leg = legend() ;
set(leg,'visible','off') ;