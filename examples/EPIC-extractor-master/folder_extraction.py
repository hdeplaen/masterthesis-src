import os
import time
from classify_image import *
import argparse
import re
import sys
from tensorflow.python.platform import gfile
import skimage
from skimage import io
from skimage import transform

def get_keywords(predictions):
    predictions = np.squeeze(predictions)

    # Creates node ID --> English string lookup.
    node_lookup = NodeLookup()

    top_k = predictions.argsort()[-FLAGS.num_top_predictions:][::-1]
    for node_id in top_k:
      human_string = node_lookup.id_to_string(node_id)
      score = predictions[node_id]
      print('%s (score = %.5f)' % (human_string, score))

def extract_features(dataset, file_name):
    data = dataset['paths']
    y = np.asarray(dataset['labels'], dtype='uint8')
    FLAGS.model_dir = 'model/'
    # comment this after model Inception-V3 model is downloaded
    maybe_download_and_extract()
    create_graph()
    with tf.Session() as sess:
        softmax_tensor = sess.graph.get_tensor_by_name('softmax:0')
        representation_tensor = sess.graph.get_tensor_by_name('pool_3:0')
        predictions = np.zeros((len(y), 1008), dtype='float32')
        representations = np.zeros((len(y), 2048), dtype='float32')
        for i in range(len(y)):
            start = time.time()
            im = skimage.io.imread(data[i])
            if len(im.shape) < 3:
                im = np.stack( (im, ) * 3, axis=-1)
            [reps, preds] = sess.run([representation_tensor, softmax_tensor], {'DecodeJpeg:0': im})
            if (i % 10 == 0):
                print("{}/{} Time for batch {} ".format(i, len(y), time.time() - start))
            representations[i] = np.squeeze(reps)
        if len(y) > 0:
            np.savez_compressed(file_name + ".npz", representations=representations, y=y)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-prefix', nargs="?",
                        type=str,
                        default="./datasets/Images/",
                        help="path of train and test data.")
    args = vars(parser.parse_args())
    images_dir = args['path_prefix']
    sub_directories = [images_dir+f for f in os.listdir(images_dir)]


    img_paths = dict()
    labels = dict()
    index = 0
    for sub_dir in sorted(sub_directories):
        if os.path.isdir(sub_dir):
            labels[sub_dir] = index
        index += 1

    for sub_dir in sub_directories:
        if os.path.isfile(sub_dir + ".npz"):
             # this is for resuming extraction purposes
             print "skipping ", sub_dir + ".npz"
             print "################################"
        elif os.path.isdir(sub_dir):
            img_paths[sub_dir] = [sub_dir + "/" + f for f in os.listdir(sub_dir) if re.search('jpg|JPG', f)]

    for index, directory in enumerate(sorted(img_paths.keys())):
        dataset = dict()
        dataset['labels'] = [labels[directory] for i in range(len(img_paths[directory]))]
        dataset['paths'] = img_paths[directory]
        extract_features(dataset, images_dir + directory.split('/')[-1])

