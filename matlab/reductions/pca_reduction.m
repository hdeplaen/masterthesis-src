function varargout = pca_reduction(varargin)
%PCA_REDUCTION Perform PCA reduction on training and test set
%   Author: HENRI DE PLAEN
%
%[TrainX,TestX] = pca_reduction(TrainX,TestX,dim)

%% INPUT
assert(nargin>=3, 'Wrong number of input arguments (3)') ;
X           = varargin{1} ;
tX          = varargin{2} ;
dim_chosen  = varargin{3} ;
disp_plots  = varargin{4} ;

%% PCA REDUCTION

[coeff,~,~,~,explained,~] = pca(X) ;
reduced_dimension = coeff(:,1:dim_chosen) ;
%disp(explained(1:dim_chosen)) ;
%disp(sum(explained(1:dim_chosen))) ;

varargout{1} = X * reduced_dimension ;
varargout{2} = tX * reduced_dimension ;

csvwrite('exports/pca/knn_cnn.csv', reduced_dimension') ;

if disp_plots
    %% PLOT FEATURES
    figure ;
    bar(abs(sum(coeff(:,1:12),2)),'FaceColor','k') ;
    xlabel('Contribution') ; ylabel('Feature') ;
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
    set(gca,'YTick',1:size(coeff,1));
    
    %% PLOT VAR
    figure ;
    bar(explained(1:10),'FaceColor','k') ;
    ylabel('Variance contribution') ; xlabel('Principal component') ;
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
    set(gca,'XTick',1:size(coeff,1));
    %set(gca,'YScale','log')
end

end

