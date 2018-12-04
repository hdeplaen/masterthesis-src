import os
import argparse

import subprocess

def resize(path):
    val = subprocess.check_call("./converter.sh '%s'" % path,   shell=True)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-prefix', nargs="?",
                        type=str,
                        default="./101_ObjectCategories/",
                        help="path of train and test data.")
    args = vars(parser.parse_args())
    images_dir = args['path_prefix']
    sub_directories = [images_dir+f for f in os.listdir(images_dir)]
    for sub_dir in sorted(sub_directories):
        if os.path.isdir(sub_dir) and sub_dir != 'resized_features':
            resize(sub_dir)

