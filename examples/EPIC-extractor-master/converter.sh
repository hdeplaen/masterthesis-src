#!/bin/bash

var="$(ls "$@"/*.JPG)"
if [ -n "${var}" ]; then
    for name in "$@"/*.JPG; do
        convert -resize 256x256\! "$name" "$name"
    done
fi

var="$(ls "$@"/*.jpg)"
if [ -n "${var}" ]; then
    for name in "$@"/*.jpg; do
        convert -resize 256x256\! "$name" "$name"
    done
fi


