from sklearn import svm
import numpy as np 
import argparse
from time import time
from sklearn.dummy import DummyClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.externals.joblib import Memory
from sklearn.kernel_approximation import RBFSampler
from sklearn.kernel_approximation import Nystroem
from sklearn.svm import LinearSVC
from sklearn.metrics import zero_one_loss
from sklearn.metrics import average_precision_score
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import GridSearchCV
from sklearn.decomposition import PCA
from sklearn.preprocessing import Normalizer
import random
import os
import cv2

from sklearn.datasets import get_data_home
from sklearn.datasets import fetch_mldata
from sklearn.utils import check_array

class ImageNetExtractor(object):
    def __init__(self, path_prefix, features_type, keep_training):
        func = None
        if features_type == 'recursive':
            func = process_imagenet_caltech
        elif features_type == 'non-recursive':
            func = process_imagenet_cifar
        else:
            raise Exception('Type of feature extraction incorrectly used \
                See features_type flag')
        self.path_prefix = path_prefix
        self.apply_func(func, keep_training)

    def apply_func(self, feature_func, keep_training):
        x_train, x_test, y_train, y_test = \
            feature_func(self.path_prefix, keep_training)
        self.x_train = x_train
        self.y_train = y_train

        self.x_test = x_test
        self.y_test = y_test

    def _get_data(self):
        return self.x_train, self.x_test ,\
            self.y_train, self.y_test

    def get_processed_features(self):
        return (np.array(_) for _ in self._get_data())

def process_imagenet_cifar(prefix=None):
    test_batch = np.load(prefix + 'test_batch.npz')
    batch = [None] * 1
    batch[0] = np.load(prefix + 'data_batch_1.npz')
    resulted_dict = merge_dictionaries(batch)
    x_train, y_train = resulted_dict['representations'], resulted_dict['y']
    x_test, y_test = test_batch['representations'], test_batch['y']
    return x_train, x_test, y_train, y_test

def process_imagenet_caltech(prefix, keep_training=80):
    sub_directories = [prefix+f for f in os.listdir(prefix)]
    training_batches = list()
    testing_batches = list()
    lengths = list()
    cur_label = 0
    for sub_dir in sorted(sub_directories):
        if os.path.isfile(sub_dir):
            cur_batch = np.load(sub_dir)
            representations = cur_batch['representations']
            y = np.array([cur_label for _ in range(len(representations))])
            indices = range(len(y))
            random.shuffle(indices)
            representations = representations[indices]
            y = y[indices]
            lengths.append(len(y))
            training_batches.append(dict({
                'representations': representations[:keep_training],
                'y': y[:keep_training]
                }))
            testing_batches.append(dict({
                'representations': representations[keep_training:],
                'y': y[keep_training:]
                }))
            cur_label += 1

    print "min lengths: ", min(lengths)
    merged_trains = merge_dictionaries(training_batches)
    x_train, y_train = merged_trains['representations'], merged_trains['y']
    merged_tests = merge_dictionaries(testing_batches)
    x_test, y_test = merged_tests['representations'], merged_tests['y']
    return x_train, x_test, y_train, y_test

def merge_dictionaries(batch):
    res = dict()
    for key in batch[0].keys():
        res[key] = batch[0][key]
    def inner_merge(data):
        for key in data.keys():
            item = data[key]
            if key == 'representations':
                res[key] = np.vstack((res[key], item))
            elif key == 'y':
                res[key] = np.hstack((res[key], item))

    for k in range(1, len(batch)):
        inner_merge(batch[k])
    return res

ESTIMATORS = {
    "dummy": DummyClassifier(),
    'CART': DecisionTreeClassifier(),
    'Nystroem-SVM': make_pipeline(
        Nystroem(gamma=2**-10.0, n_components=1000), LinearSVC(C=1)),
    'SampledRBF-SVM': make_pipeline(
        RBFSampler(gamma=2**-10.0, n_components=256), LinearSVC(C=0.1)),
    'Linear-SVM': make_pipeline(
        LinearSVC(C=10)),
    'Normalized-Linear-SVM': make_pipeline(
        Normalizer(norm='l2'), LinearSVC(C=0.01)),
    'HardCoded-RBF': make_pipeline(
        Normalizer(norm='l2'), RBFSampler(gamma=0.001, n_components=500), LinearSVC(C=0.1)),
    'PCA-SVM': make_pipeline(
        Normalizer(norm='l2'), PCA(n_components=500), LinearSVC(C=10.0)),
}


def extract_estimator(estimator, file_name, xtest, ytest, keep):
    coef_ = estimator.coef_
    intercept_ = estimator.intercept_
    np.savez_compressed("spdz_models/" + file_name + ".npz", coef_=coef_, intercept_=intercept_, xtest=xtest[:keep], ytest=ytest[:keep])

class ParamsFinder(object):
    def __init__(self, estimator, name):
        self.estimator = estimator
        self.name = name
        self.init_param_grid()

    def init_param_grid(self):
        if self.name == 'SampledRBF-SVM':
            self.param_grid = dict(
                rbfsampler__n_components=[2048/2**i for i in range(0,4)],
                rbfsampler__gamma=[10 ** -i for i in range(-2,2)],
                linearsvc__C=[10**i for i in range(0, 3)],
            )
        elif self.name == 'Linear-SVM':
            self.param_grid = dict(
                linearsvc__C = [10 ** i for i in range(-3, 3)]
            )
        elif self.name == 'PCA-SVM':
            self.param_grid = dict(
                pca__n_components=[2048/2**i for i in range(0, 4)],
                linearsvc__C = [10**i for i in range(-3, 3)]
            )

    def do_grid_search(self, X_train, y_train):
        param_grid = self.param_grid
        estimator = self.estimator
        grid_search = GridSearchCV(estimator, param_grid, n_jobs=args["n_jobs"], verbose=1,
            return_train_score=True)
        grid_search.fit(X_train, y_train)
        print("Best parameters set found on development set:")
        print()
        print(grid_search.best_params_)
        print()
        print("Grid scores on development set:")
        print()
        def get_grid_stats():
            cv_results = grid_search.cv_results_
            params = cv_results['params']
            mean_score = cv_results['mean_train_score']
            std_score = cv_results['std_train_score']
            for i in range(len(mean_score)):
                print("%0.3f (+/-%0.03f) for %r"
                      % (mean_score[i], std_score[i] * 2, params[i]))

        get_grid_stats()

def get_rounded_estimator(estimator, X_test, y_test):
    def round_estimator(est):
        coef_ = est.coef_
        round1_func = lambda x: int(x*2**20)
        round2_func = lambda x: int(x*2**40)

        vfunc = np.vectorize(round1_func)
        for i in range(len(coef_)):
            coef_[i] = vfunc(coef_[i])

        est.coef_ = coef_

        vfunc = np.vectorize(round2_func)
        est.intercept_ = vfunc(est.intercept_)
        return est

    def round_test(xt):
        round_func = lambda x: int(x*2**20)
        vfunc = np.vectorize(round_func)
        for i in range(len(xt)):
            xt[i] = vfunc(xt[i])
        return xt

    # needs to be tuned for each estimator, currently for SampledRBF-SVM
    linearsvc = estimator.get_params('linearsvc')['linearsvc'] 
    exact_svc = linearsvc
    linearsvc = round_estimator(linearsvc)
    rbf_sampler = estimator.get_params('rbfsampler')['rbfsampler']
    rounded_samples = round_test(rbf_sampler.transform(X_test))
    y_pred = linearsvc.predict(rounded_samples)
    print zero_one_loss(y_test, y_pred)
    return exact_svc

def compute_map(y_test, y_pred):
    n_classes = np.unique(y_test).size
    hits = [0.0 for _ in range(n_classes + 1)]
    total = [0 for _ in range(n_classes + 1)]

    for i in range(len(y_test)):
        if y_test[i] == y_pred[i]:
            hits[y_pred[i]] += 1
        total[y_test[i]] += 1
    mean = [0 for i in range(n_classes)]
    for i in range(n_classes):
        mean[i] = hits[i] / total[i]

    print "#############################"
    print "Computed MAP"
    print min(mean), max(mean), " mean: ", np.mean(mean)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--classifiers', nargs="+",
                        choices=ESTIMATORS, type=str,
                        default=['dummy', 'Linear-SVM'],
                        help="list of classifiers to benchmark.")
    parser.add_argument('--n-jobs', nargs="?", default=10, type=int,
                        help="Number of concurrently running workers for "
                             "models that support parallelism.")
    parser.add_argument('--random-seed', nargs="?", default=0, type=int,
                        help="Common seed used by random number generator.")
    parser.add_argument('--path-prefix', nargs="?",
                        type=str,
                        default="./datasets/CIFAR10/",
                        help="path of train and test data.")
    parser.add_argument('--param-finder', nargs='?', default=0, type=int,
                        help='set this to 1 if you want to do a grid search')
    parser.add_argument('--round-estimator', nargs='?', default=0, type=int,
                        help='set this to 1 if you want to do save parameters \
                        for SPDZ')
    parser.add_argument('--keep-training', nargs='?', default=30, type=int,
                        help='flag used for MIT-67 or Caltech-101 files,  \
                        meant to be used to do training on the first 30 or 80 samples \
                        respectively')
    parser.add_argument('--features_type', nargs='?', default='non-recursive', type=str,
                        help='whether do recursive feature lookup or predefined \
                        test/train batches as for CIFAR10')
    parser.add_argument('--save_model', nargs='?', default=0, type=int,
                        help='whether dump learnt model into .npz file')
 
  
    args = vars(parser.parse_args())
    # X_train, X_test, y_train, y_test = (np.array(_) for _ in process_mnist())

    extractor = ImageNetExtractor(args['path_prefix'], args['features_type'], args['keep-training'])
    X_train, X_test, y_train, y_test = extractor.get_processed_features()
    print("")
    print("Dataset statistics:")
    print("===================")
    print("%s %d" % ("number of features:".ljust(25), X_train.shape[1]))
    print("%s %d" % ("number of classes:".ljust(25), np.unique(y_train).size))
    print("%s %s" % ("data type:".ljust(25), X_train.dtype))
    print("%s %d (size=%dMB)" % ("number of train samples:".ljust(25),
                                 X_train.shape[0], int(X_train.nbytes / 1e6)))
    print("%s %d (size=%dMB)" % ("number of test samples:".ljust(25),
                                 X_test.shape[0], int(X_test.nbytes / 1e6)))

    print()
    print("Training Classifiers")
    print("====================")

    error, train_time, test_time = {}, {}, {}
    for name in sorted(args["classifiers"]):
        print "Training %s ... " % name
        estimator = ESTIMATORS[name]
        estimator_params = estimator.get_params()

        estimator.set_params(**{p: args["random_seed"]
                                for p in estimator_params
                                if p.endswith("random_state")})

        if "n_jobs" in estimator_params:
            print "njobs: ", args["n_jobs"]
            estimator.set_params(n_jobs=args["n_jobs"])
        time_start = time()

        if args['param_finder'] == 0:
            train_time[name] = time() - time_start
            estimator.fit(X_train, y_train)
            time_start = time()
            y_pred = estimator.predict(X_test)
            test_time[name] = time() - time_start
            compute_map(y_test, y_pred)
            error[name] = zero_one_loss(y_test, y_pred)
            print("done")
        elif args['param_finder'] == 1:
            finder = ParamsFinder(estimator, name)
            finder.do_grid_search(X_train, y_train)

        if args['round_estimator'] == 1:
           extract_estimator(estimator.get_params('linearsvc')['linearsvc'], 'rbf_svm', X_test, y_test, 30)

        save_model = args['save_model']
        if save_model:
            extract_estimator(estimator, 'rbf_svm', X_test, y_test, 30)

    if args['param_finder'] == 0:
        print()
        print("Classification performance:")
        print("===========================")
        print("{0: <24} {1: >10} {2: >11} {3: >12}"
              "".format("Classifier  ", "train-time", "test-time", "error-rate"))
        print("-" * 60)
        for name in sorted(args["classifiers"], key=error.get):
            print("{0: <23} {1: >10.2f}s {2: >10.2f}s {3: >12.4f}" \
             "".format(name, train_time[name], test_time[name], error[name]))


# evaluate LinerSVC custom_svc.coef_.dot(xtrans[0]) + custom_svc.intercept_
