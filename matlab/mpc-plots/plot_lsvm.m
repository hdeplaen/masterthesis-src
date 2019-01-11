% PLOT RESULTS FROM MPC WITH LINEAR SVMs
% Author: HENRI DE PLAEN

%% PRELIMINARIES
clear all ; close all ; clc ;

%% VALUES
mthds = {['(P)LSVM'], ...
    ['(P)PCA8-' , '(P)LSVM'], ...
    ['(P)PCA16-' , '(P)LSVM'], ...
    ['(P)PCA8-' , '(C)LSVM'], ...
    ['(P)PCA16-' , '(C)LSVM'], ...
    ['(C)PCA8-' , '(P)LSVM'], ...
    ['(C)PCA16-' , '(P)LSVM'], ...
    ['\chi^2-' , '(P)LSVM']} ;

acc = [94.62, 95.12 ; ...
    90.75, 91.51 ; ...
    93.31, 93.24 ; ...
    90.75, 91.51 ; ...
    93.31, 93.24 ; ...
    90.75, 91.51 ; ...
    93.31, 93.24 ; ...
    94.89, 94.79 ] ;

timing = [43.5, 33.3 ; ...
    76.7, 73.2 ; ...
    174.2, 150.3 ; ...
    70.5, 70.5 ; ...
    156.8, 156.8 ; ...
    4.46, 1.18 ; ...
    11.43, 8.3 ; ...
    31.3, 24.4] ;

rounds = [49, 15; ...
    53, 19 ; ...
    53, 19 ; ...
    4, 4 ; ...
    4, 4 ; ...
    49, 15 ; ...
    49, 15 ; ...
    49, 15] ;
    
comm = [13950, 11040 ; ...
    19020, 17160 ; ...
    30540, 28440 ; ...
    10320, 10320 ; ...
    20640, 20640 ; ...
    8700, 6840 ; ...
    9900, 7800 ; ...
    12450, 9840] ;


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
xlabel('Model') ; ylabel('Run time [s]') ;
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