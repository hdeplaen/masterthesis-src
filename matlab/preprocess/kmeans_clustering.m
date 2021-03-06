function [varargout] = kmeans_clustering(varargin)
%normalizes reduces the size of the normal instances present in the
%dataset based on k-means clustering.
%   Author: HENRI DE PLAEN
%
%[TrainX,TrainY] = KMEANS_CLUSTERING (TrainX,TrainY,disp_plots)

%% PRELIMINARIES
assert(nargin==3, 'Wrong number of input arguments (3)') ;
TrainX = varargin{1} ;
TrainY = varargin{2} ;
disp_plots = varargin{3} ;

idx_normal = strcmp(TrainY,'normal') ;
tX_normal = TrainX(idx_normal,:) ;
tY_normal = TrainY(idx_normal) ;
tX_other = TrainX(~idx_normal,:) ;
tY_other = TrainY(~idx_normal,:) ;

if disp_plots
    max_k = 9 ;
    within_distance = zeros(max_k,1) ;
    
    for idx_k = 1:max_k
        [~, ~, sumd, ~] = kmeans(tX_normal,idx_k) ;
        within_distance(idx_k) = mean(sumd) ;
    end
    
    %% PLOT DIST
    figure ;
    bar(within_distance,'FaceColor','k') ;
    xlabel('Number of clusters') ; ylabel('Within-cluster distance') ;
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
else
    %% REDUCE
    mean_other  = mean(tX_other,1) ;
    
    k_chosen = 5 ;
    [idx_cluster, centroids] = kmeans(tX_normal, k_chosen) ;
    
    means_other = repmat(mean_other,[k_chosen 1]) ;
    differences = vecnorm(centroids - means_other,2,2) ;
    
    [~, idx_max] = max(differences) ;
    
    tX_normal = tX_normal(idx_cluster~=idx_max,:) ;
    tX_normal = [tX_normal ; centroids] ;
    tY_normal = tY_normal(idx_cluster~=idx_max) ;
    tY_normal = [tY_normal ; repmat({'normal'},[size(centroids,1),1])] ;
end

%% OUT
varargout{1} = [tX_normal ; tX_other] ;
varargout{2} = [tY_normal ; tY_other] ;

end

