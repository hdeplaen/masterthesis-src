# EPIC-extractor

This is a helper for the feature extraction of datasets used in our paper: https://eprint.iacr.org/2017/1190

It should extract Inception-v3 features from the following datasets:

- [CIFAR-10](http://www.cs.toronto.edu/~kriz/cifar.html)
- [MIT-67](http://web.mit.edu/torralba/www/indoor.html)
- [Caltech101](http://www.vision.caltech.edu/Image_Datasets/Caltech101/)


In order to get the features in an easy-to-manipulate format (.npz) you
need to perform the following steps:
- Download and extract the image archives (we will follow the instalation as if they are extracted in a datasets/ folder inside the repo, you can change it though).
- Resize the pictures using converter.sh script or using the resize_folder_images.py
- Run folder_extracion.py for MIT-67 and Caltech101 datasests. This script puts images into a (labels, path) dictionary format as in CIFAR-10 and then extract_features using the Inception-V3 CNN. Results are placed into a '.npz' file where each '.npz' is a dictionary with keys as ['representations', 'y']. The 'representations' is a 2048 feature vector and 'y' is the class index.
- Then use model_generator.py to get the training model baked for the .mpc file or whatever inside a spdz_models/ folder
