% m_visEx2.m
% Example for visualizing the Fundamental matrix between two images
% Click on one image, display the corresponding epipolar line on the other image
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 21-Oct-2016
% Last modified: 21-Oct-2016

im1 = imread('../hw3data/cs1.jpg');
im2 = imread('../hw3data/cs2.jpg');
load F4CS.mat;
m_visualizeF(im1, im2, F);
