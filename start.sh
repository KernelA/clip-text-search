#!/bin/bash

wget https://github.com/jbrownlee/Datasets/releases/download/Flickr8k/Flickr8k_Dataset.zip -O Flickr8k_Dataset.zip

unzip ./Flickr8k_Dataset.zip Flicker8k_Dataset/* && rm ./Flickr8k_Dataset.zip

exec "$@"