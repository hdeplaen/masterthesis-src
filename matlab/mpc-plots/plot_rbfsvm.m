% PLOT RESULTS FROM MPC WITH LINEAR SVMs
% Author: HENRI DE PLAEN

%% PRELIMINARIES
clear all ; close all ; clc ;

%% VALUES
mthds = {['(P)RBFSVM'], ...
    ['(P)PCA8-' , '(P)RBFSVM'], ...
    ['(P)PCA16-' , '(P)RBFSVM'], ...
    ['\chi^2-' , '(P)RBFSVM']} ;

acc = [98.96, 98.89; ...
    90.75, 91.51; ...
    98.89, 98.81; ...
    98.88, 98.87] ;
    

timing = [1921, 1555 ; ...
    899.5, 747.7  ; ...
    1112, 923, ; ...
    1707, 1454] ;

rounds = [2745, 2171; ...
    2747, 2172; ...
    2747, 2172; ...
    2747, 2171] ;
    
comm = [5037750, 4030188; ...
    4949820, 3968100; ...
    4984140, 3991320; ...
    5007750, 4006188]; ...


%% PLOTS
figure ;
b = bar(acc,'group', 'FaceColor','flat') ;
b(1).FaceColor = 'black' ;
b(2).FaceColor = 'white' ;
xlabel('Model') ; ylabel('Accuracy') ;
ylim([85 100]) ;
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
set(gca,'xtick',[])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure ;
b = bar(timing,'group', 'FaceColor','flat') ;
b(1).FaceColor = 'black' ;
b(2).FaceColor = 'white' ;
xlabel('Model') ; ylabel('Run time [min]') ;
%ylim([85 100]) ;
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
set(gca,'xticklabel',mthds);
xtickangle(45);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure ;
b = bar(rounds,'group', 'FaceColor','flat') ;
b(1).FaceColor = 'black' ;
b(2).FaceColor = 'white' ;
xlabel('Model') ; ylabel('Rounds') ;
%ylim([85 100]) ;
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
set(gca,'xtick',[])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure ;
b = bar(comm,'group', 'FaceColor','flat') ;
b(1).FaceColor = 'black' ;
b(2).FaceColor = 'white' ;
xlabel('Model') ; ylabel('SCALE Packets') ;
%ylim([85 100]) ;
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
set(gca,'xticklabel',mthds);
xtickangle(45);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%