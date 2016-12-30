% m_visEx1.m
% Example for visualizing the Homography between two images
% Click on one image and it shows the corresponding point on the other image
% The homography matrix is computed for the FLOOR plane of the CS building
% The correspondence between points not on the floor plane will be less accurate. 
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 21-Oct-2016
% Last modified: 21-Oct-2016

im1 = imread('../hw3data/cs1.jpg');
im2 = imread('../hw3data/cs2.jpg');
load H4CS.mat;
m_visualizeH(im1, im2, H);


