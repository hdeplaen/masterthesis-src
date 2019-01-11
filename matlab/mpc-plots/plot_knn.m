% PLOT RESULTS FROM MPC WITH LINEAR SVMs
% Author: HENRI DE PLAEN

%% PRELIMINARIES
clear all ; close all ; clc ;

%% VALUES
mthds = {['(P)1NN'], ...
    ['(P)2NN'], ...
    ['(P)3NN'], ...
    ['(P)PCA8-(P)1NN'], ...
    ['(P)PCA16-(P)1NN'], ...
    ['\chi^2-(P)1NN']} ;

acc = [98.25; ...
    90.54; ...
    90.53; ...
    97.85; ...
    98.00; ...
    98.48] ;

acc = [acc, acc, acc] ;

timing = [180, 366.55, 673.35 ; ...
    200, 419, 802 ; ...
    221, 465, 868 ; ...
    50, 74, 149 ; ...
    72, 147, 286 ; ...
    155, 269, 558] ;

rounds = [139, 352, 686 ; ...
    652, 1486, 2792 ; ...
    958, 2206, 4160 ; ...
    141, 354, 688 ; ...
    141, 354, 688 ; ...
    139, 352, 686] ;
    
comm = [55650, 139350, 278850 ; ...
    148040, 369740, 739249 ; ...
    208962, 522162, 1044162 ; ...
    35682, 87882, 174882 ; ...
    41514, 98279, 199914 ; ...
    49650, 124350, 248850] ;
    


%% PLOTS
figure ;
b = bar(acc,'group', 'FaceColor','flat') ;
b(1).FaceColor = 'black' ;
b(2).FaceColor = [.5 .5 .5] ;
b(3).FaceColor = 'white' ;
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
b(2).FaceColor = [.5 .5 .5] ;
b(3).FaceColor = 'white' ;
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
b(2).FaceColor = [.5 .5 .5] ;
b(3).FaceColor = 'white' ;
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
b(2).FaceColor = [.5 .5 .5] ;
b(3).FaceColor = 'white' ;
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