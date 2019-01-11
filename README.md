# Privacy-friendly machine-learning algorithms for intrusion detection systems: source code

## Information
Promotor: 
* Prof. Dr. ir. Bart Preneel
Assessors:
* Prof. Dr. ir. Karl Meerbergen
* Prof. Dr. ir. Sabine Van Huffel
Supervisors:
* Dr. Aysajan Abidin
* Dr. Abdelrahaman Aly

## Abstract
In this thesis, we present a set of practically usable machine-learning algorithms for intrusion detection systems using multi-party computation (secret sharing). This allows a user to query an already trained model preserving both the privacy of the query and of the model. We investigate two major classes of machine-learning algorithms broadly used on anomaly-based intrusion detection systems: support vector machines, both linear and non-linear, and nearest neighbors classifiers. In addition, different data-reduction methods in the feature space are investigated such as the principal components analysis decomposition or the chi-square feature selection. Instance space reduction methods are also investigated such as the condensed nearest neighbors algorithm, which has been applied for the first time to intrusion detection systems, or the k-means clustering. We also systematically compare two different multi-class models for support vector machines.

Based on these algorithms, we investigate how they can be made privacy-friendly. Different methods to achieve the privacy-friendliness are briefly described such as differential privacy, fully homomorphic encryption, garbled circuits and secret sharing. We justify our choice for the secret sharing and explain how we can use it to achieve a privacy-friendly evaluation on the classifiers. Finally, we benchmark the results of the privacy-friendly algorithms and their variants using data reduction. 

Linear support vector machines allow a rapid evaluation for a good accuracy. The best performance is achieved using the chi-square reduction. Higher accuracies can be achieved with non-linear support vector machines and nearest neighbors. However, compared to nearest neighbors, non-linear support vector machines are much more expensive using multi-party computation due to the need for dual evaluation. Nearest neighbors are also very expensive, but can be reduced to practically feasible evaluation times using the condensed nearest neighbors beforehand. This way we exploit the trade-off between expensive clear pre-processing and a lightweight secret model. When applying feature size reduction to the nearest neighbors, the PCA reduction seems more adapted than the chi-square feature selection.

## Information about the code

### MATLAB
The MATLAB implementation has been constructed as a toolbox. The toolbox is built around the notion of experts, which is an entire model as described in the thesis (one-against-all RBFSVMs or kNN with consensed nearest neighbors). The different experts usable are:

* 'knn': normal nearest neighbors;
* 'kmeans-knn': nearest neighbors with k-means instance set reduction;
* 'knn-cnn': consensed nearest neighbors;
* 'knn-cnn-chi2': condensed nearest neighbors with chi-square feature selection;
* 'par-svm': one-against-all (parallel) SVM multi-class model;
* 'seq-svm': tree-based (sequential) SVM multi-class model;
* 'par-svm': one-against-all (parallel) SVM multi-class model with chi-square feature selection;
* 'seq-svm': tree-based (sequential) SVM multi-class model with chi-square feature selection.

The code can be found in the [matlab folder](https://github.com/hdeplaen/masterthesis-src/tree/master/matlab). Here is a short list of the main functions that can be used:
* load_data: extraction of the data-set with conversion from categorical to numerical values (makes use of subroutines to_numeric, cat2freq and cat2bin);
* normalize_data: normalizes the data according to the values of the training set;
* bagging: creates different training and test sets;
* pca_reduction: performs the PCA reduction to the specified number of components;
* kmeans_clustering: performs $k$-means clustering according to the training set;
* train_expert: generates and expert model with training if required;
* eval_expert: evaluates the expert according to the test set;
* plot_perf: computes and eventually plots the performance of the classifier on the test set;
* export_expert: exports the expert model for MPC-usage.
\end{itemize}

More information about each function (e.g. input and output arguments) can be found by typing help function, where function is the queried function.

Here follows a short example of the toolbox used to load, train, evaluate and export a condensed nearest neighbors expert with PCA reduction:
```
% Privacy-friendly machine learning algorithms for intrusion detection
% systems
% Example script
%
% Author: HENRI DE PLAEN
% Copyright KULeuven

%% PRELIMINARIES
k = 1;                  % number of nearest neighbors
n = 10000;              % number of elements in the training sets
num_bags = 5;           % number of experiments
disp_pca = false;       % don't plot the PCA componenets
expert = 'knn-cnn';     % type of expert used
data-set = 'nsl-kdd';   % data-set used

% preallocate the experiments results
corr = zeros(num_bags,5,5);
accm = zeros(num_bags,5);
mccm = zeros(num_bags,5);
kappam = zeros(num_bags,5);
acc = zeros(num_bags);
mcc = zeros(num_bags);
kappa = zeros(num_bags);
num_nb = zeros(num_bags);

%% GENERATE TRAINING AND TEST SETS
[trainX,trainY,testX,testY] = load_kdd(data_set,classes_red) ;
[BagTrainX,BagTrainY] = bagging(n(idxn), num_bags, trainX, trainY) ;
[BagTestX,BagTestY] = bagging(10000, num_bags, testX, testY) ;
        
% EXECUTE EACH EXPERIMENT
for idx_bag = 1:num_bags
    % extract the corresponding training set for this experiment
    locX = BagTrainX{idx_bag} ;
    locY = BagTrainY{idx_bag} ;
            
    % extract the corresponding test set for this experiment
    locXtest = BagTestX{idx_bag} ;
    locYtest = BagTestY{idx_bag} ;
            
    % normalize
    [locX,locY,locXtest,locYtest] = normalize_data(locX,locY,locXtest,locYtest) ;
            
    % PCA
    [trainX,testX] = pca_reduction(trainX,testX,n_pca,disp_pca) ;
            
    %% train and evaluate expert
    params_knn.k = k ;
    expert_knn = train_expert(locX,locY, expert, params_knn) ;
    eval_knn = eval_expert(expert_knn, locXtest, locYtest) ;
    export_expert(expert_knn, 'MyFirstExpert') ;
            
    [corr_, accm_, mccm_, kappam_, acc_, mcc_, kappa_] = plot_perf(eval_knn,locYtest) ;
    
    % store the results of each experiment
    corr(idx_bag,:,:) = corr_ ;
    accm(idx_bag,:) = accm_ ;
    mccm(idx_bag,:) = mccm_ ;
    kappam(idx_bag,:) = kappam_ ;
    acc(idx_bag) = acc_ ;
    mcc(idx_bag) = mcc_ ;
    kappa(idx_bag) = kappa_ ;
    num_nb(idx_bag) = expert_knn.num_nb ;
end
    
%% PLOT RESULTS
% mean of all experiments
corr = round(mean(corr(:,:,:),1));
accm = mean(accm(:,:),1);
mccm = mean(mccm(:,:),1);
kappam = mean(kappam(:,:),1);
acc = mean(acc(:),1);
mcc = mean(mcc(:),1);
kappa = mean(kappa(:),1);
num_nb = mean(num_nb(:),1);

% display the mean results
disp('k = 1') ;
disp('acc');
disp(squeeze(100*acc) ;
disp(squeeze(100*accm(:,:)));
disp('mcc') ;
disp(squeeze(100*mcc)) ;
disp(squeeze(100*mccm(:,:)));
disp('kappa') ;
disp(squeeze(100*kappa)) ;
disp(squeeze(100*kappam(:,:)));
disp('corr') ;
disp(squeeze(corr(:,:,:))) ;
```

Example of the benchmarks and other scripts used can be bound in [this folder](https://github.com/hdeplaen/masterthesis-src/tree/master/matlab/benchmarking).

### SCALE-MAMBA
To compile and run the SCALE-MAMBA code, the framework first has to be installed. The installation and compilation are explained in the documentation (the framework can be found [here](https://github.com/KULeuven-COSIC/SCALE-MAMBA)). The programs have to be used with training data produced by the MATLAB code and place in the  folder of each program. The following programs can be found:
* knn_1: Secure nearest neighbors evaluation with k=1;
* knn_chi2: Secure nearest neighbors evaluation with k=1 and chi-square feature selection;
* knn_1_pca: Secure nearest neighbors evaluation with k=1 and PCA reduction;
* knn_n: Secure nearest neighbors evaluation with k>1;
* svm_lin: Secure linear support vector machines evaluation;
* svm_lin_chi2: Secure linear support vector machines with chi-square feature selection;
* svm_lin_pca: Secure linear support vector machines with PCA reduction (the PCA or SVM evaluation can be done securely or in clear by commenting the corresponding lines);
* svm_rbf: Secure support vector machines with radial based kernel function;
* svm_rbf_chi2: Secure support vector machines with radial based kernel function with chi-square feature selection;
* svm_rbf_pca: Secure support vector machines with radial based kernel function with PCA reduction.

The code can be found in the [this folder](https://github.com/hdeplaen/masterthesis-src/tree/master/frameworks/scale-mamba/SCALE-MAMBA-master/Thesis).
