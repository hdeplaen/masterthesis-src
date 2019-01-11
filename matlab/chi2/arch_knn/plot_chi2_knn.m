%% LOAD CHI2
load('/Users/hdeplaen/Documents/KULeuven/Thesis/masterthesis-src/matlab/chi2/arch_knn/chi2_knn.mat') ;
chi2_mean = mean(chi2,2) ;


%% PLOT FEATURES
figure ;
bar(chi2(:,1), 'FaceColor','k') ;
xlabel('Feature') ; ylabel('Measure') ;
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
%set(gca,'YTick',1:size(coeff,1));

figure ;
bar(chi2(:,2), 'FaceColor','k') ;
xlabel('Feature') ; ylabel('Measure') ;
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
%set(gca,'YTick',1:size(coeff,1));

figure ;
bar(chi2(:,3), 'FaceColor','k') ;
xlabel('Feature') ; ylabel('Measure') ;
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
%set(gca,'YTick',1:size(coeff,1));

figure ;
bar(chi2(:,4), 'FaceColor','k') ;
xlabel('Feature') ; ylabel('Measure') ;
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
%set(gca,'YTick',1:size(coeff,1));

figure ;
bar(chi2(:,5), 'FaceColor','k') ;
xlabel('Feature') ; ylabel('Measure') ;
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
%set(gca,'YTick',1:size(coeff,1));