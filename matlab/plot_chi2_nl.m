%% LOAD CHI2
load('/Users/hdeplaen/Documents/KULeuven/Thesis/masterthesis-src/matlab/chi2/arch_nl/chi2_nl_r2l.mat') ;
chi21 = chi2 ;

load('/Users/hdeplaen/Documents/KULeuven/Thesis/masterthesis-src/matlab/chi2/arch_nl/chi2_nl_dos.mat') ;
chi22 = chi2 ;

load('/Users/hdeplaen/Documents/KULeuven/Thesis/masterthesis-src/matlab/chi2/arch_nl/chi2_nl_normal.mat') ;
chi23 = chi2 ;

load('/Users/hdeplaen/Documents/KULeuven/Thesis/masterthesis-src/matlab/chi2/arch_nl/chi2_nl_probe.mat') ;
chi24 = chi2 ;

%% PROCESS
chi2 = [chi21 chi22 chi23 chi24] ;
chi2_mean = mean(chi2,2) ;


%% PLOT FEATURES
figure ;
bar(chi24,'FaceColor','k') ;
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

% figure ;
% bar(chi2_mean,'FaceColor','k') ;
% xlabel('Feature') ; ylabel('Measure') ;
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
% %set(gca,'YTick',1:size(coeff,1));