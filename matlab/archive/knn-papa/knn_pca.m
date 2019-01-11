% BENCHMARK TESTS
% Author: HENRI DE PLAEN

close all ; clear ; clc ;

%% PRELIMINARIES
data_set = 'nsl-kdd' ;
classes_red = true ;
method = 'cnn-knn' ;

[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;

%% PARAMS
k = 1:1:3 ;
%n = 10000 ; %[2000 5000 10000 15000 30000 50000 100000] ;
n = [500 600] ;
num_bags = 5 ;
disp_pca = false ;
n_pca = 4:4:28 ;

corr = zeros(length(k),length(n_pca),num_bags,5,5);
accm = zeros(length(k),length(n_pca),num_bags,5);
mccm = zeros(length(k),length(n_pca),num_bags,5);
kappam = zeros(length(k),length(n_pca),num_bags,5);
acc = zeros(length(k),length(n_pca),num_bags);
mcc = zeros(length(k),length(n_pca),num_bags);
kappa = zeros(length(k),length(n_pca),num_bags);
num_nb = zeros(3,length(n_pca),num_bags);

for idx_pca = 1:length(n_pca)
    disp(n_pca(idx_pca)) ;
    for idxk = 1:length(k)
        
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
            [locX,locY,locXtest,locYtest] = standardize_data(locX,locY,locXtest,locYtest) ;
            
            % PCA
            [locX,locXtest] = pca_reduction(locX,locXtest,n_pca(idx_pca),disp_pca) ;
            
            disp('_____________________________') ;
            disp(['Bag number ' num2str(idx_bag)]) ;
            
            %% KNN EXPERT
            params_knn.k = k(idxk) ;
            expert_knn = train_expert(locX,locY, method, params_knn) ;
            eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
            
            [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_knn,locYtest) ;
            
            corr(idxk,idx_pca,idx_bag,:,:) = corr_ ;
            accm(idxk,idx_pca,idx_bag,:) = accm_ ;
            mccm(idxk,idx_pca,idx_bag,:) = mccm_ ;
            kappam(idxk,idx_pca,idx_bag,:) = kappam_ ;
            acc(idxk,idx_pca,idx_bag) = acc_ ;
            mcc(idxk,idx_pca,idx_bag) = mcc_ ;
            kappa(idxk,idx_pca,idx_bag) = kappa_ ;
            num_nb(idxk,idx_pca,idx_bag) = expert_knn.num_sv ;
        end
    end
end

%% TABLES
corr = round(mean(corr(:,:,:,:,:),3));
accm = mean(accm(:,:,:,:),3);
mccm = mean(mccm(:,:,:,:),3);
kappam = mean(kappam(:,:,:,:),3);
acc = mean(acc(:,:,:),3);
mcc = mean(mcc(:,:,:),3);
kappa = mean(kappa(:,:,:),3);
num_nb = mean(num_nb(:,:,:),3);

save('knn_cnn_pca_bis.mat','corr','accm','mccm','kappam','acc','mcc','kappa','num_nb') ;

print_n = 4 ;

% seq
disp('k = 1') ;
disp('acc');
print_latex(squeeze(100*accm(1,print_n,:,:)));
disp('mcc') ;
print_latex(squeeze(100*mccm(1,print_n,:,:)));
disp('kappa') ;
print_latex(squeeze(100*kappam(1,print_n,:,:)));
disp('corr') ;
print_latex(squeeze(corr(1,print_n,:,:,:))') ;

disp('k = 2') ;
disp('acc');
print_latex(squeeze(100*accm(2,print_n,:,:)));
disp('mcc') ;
print_latex(squeeze(100*mccm(2,print_n,:,:)));
disp('kappa') ;
print_latex(squeeze(100*kappam(2,print_n,:,:)));
disp('corr') ;
print_latex(squeeze(corr(2,print_n,:,:,:))') ;

disp('k = 3') ;
disp('acc');
print_latex(squeeze(100*accm(3,print_n,:,:)));
disp('mcc') ;
print_latex(squeeze(100*mccm(3,print_n,:,:)));
disp('kappa') ;
print_latex(squeeze(100*kappam(3,print_n,:,:)));
disp('corr') ;
print_latex(squeeze(corr(3,print_n,:,:,:))') ;



%% PLOT
figure ; hold on ;
semilogx(n_pca,acc(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,acc(2,:,:),'--k','LineWidth',2) ;
semilogx(n_pca,acc(3,:,:),':k','LineWidth',2) ;
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
semilogx(n_pca,mcc(2,:,:),'--k','LineWidth',2) ;
semilogx(n_pca,mcc(3,:,:),':k','LineWidth',2) ;
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
semilogx(n_pca,kappa(2,:,:),'--k','LineWidth',2) ;
semilogx(n_pca,kappa(3,:,:),':k','LineWidth',2) ;
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
semilogx(n_pca,num_nb(1,:,:),'-k','LineWidth',2) ;
semilogx(n_pca,num_nb(2,:,:),':k','LineWidth',2) ;
semilogx(n_pca,num_nb(3,:,:),'-.k','LineWidth',2) ;
ylabel('Reduced training set size') ; xlabel('Number of principal components') ;
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