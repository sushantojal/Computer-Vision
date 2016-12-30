function [Iwarp, Imerge] = warpImage(Iin, Iref, H)

%Input: Input to the program are Iin- an input image to be warped, Iref- an
%image to be used as reference image, and H- Homography matrix calculated
%via computeH function 

%Output: Output of the program are Iwarp- warped Iin, input image, and
%Imerge- mosaic image

%Loading the required input files needed to run the program

    %load('H.mat');
    %Iin = imread('sbu1.jpg');
    %Iref = imread('sbu2.jpg');

    [h,w,~] = size(Iin);
    [h1,w1,~] = size(Iref);

    %Warping corner points in the input image: (1,1), (w,1), (1, h), (w,h)
    cp = H * [ 1 1 w w ; 1 h 1 h ; 1 1 1 1 ];  
    cp1 = cp(:, 1) / cp(3,1);
    cp2 = cp(:, 2) / cp(3,2);
    cp3 = cp(:, 3) / cp(3,3);
    cp4 = cp(:, 4) / cp(3,4);
    cp = [cp1, cp2, cp3, cp4];
    InXmin = min(cp(1,:));
    InXmax = max(cp(1,:)); 
    InYmin = min(cp(2,:));
    InYmax = max(cp(2,:)); 

    %Construct translation matrix to translate corner points
    T = [1 0 -InXmin; 0 1 -InYmin; 0 0 1];

    %Computing net transformation matrix by combining H and T
    transformation_matrix = T * H;

    %Finding corner points in the warped image
    cp_fin = transformation_matrix * [ 1 1 w w ; 1 h 1 h ; 1 1 1 1 ]; 
    cp_fin1 = cp_fin(:, 1) / cp_fin(3,1);
    cp_fin2 = cp_fin(:, 2) / cp_fin(3,2);
    cp_fin3 = cp_fin(:, 3) / cp_fin(3,3);
    cp_fin4 = cp_fin(:, 4) / cp_fin(3,4);
    cp_fin = [cp_fin1, cp_fin2, cp_fin3, cp_fin4];
    WXmin = min(cp_fin(1,:));
    WXmax = floor(max(cp_fin(1,:))); 
    WYmin = min(cp_fin(2,:));
    WYmax = floor(max(cp_fin(2,:)));

    %Warping the entire input image using inverse mapping
    warped_image = [];

    for i=1:WYmax
        for j=1:WXmax
            dimension = transformation_matrix \ [j, i, 1]';
            x = floor(dimension(2,1) / dimension(3,1));
            y = floor(dimension(1,1) / dimension(3,1));
            if(x >= 1 && y >= 1 && x <= h && y <= w)
                warped_image(i, j, :) = Iin(x, y, :);
            end
        end
    end
    
    Iwarp = uint8(warped_image);
    figure; imshow(uint8(warped_image));
    title('warped image');
    
    %Calculate reposition values and copy Iref onto the warped image
    reposition = -floor([min([cp(1,:), 0]), min([cp(2,:), 0])]);
    warped_image(1+reposition(2):h1+reposition(2), 1+reposition(1):w1+reposition(1), :) = double(Iref(1:h1, 1:w1, :));

    %Show the result
    Imerge = uint8(warped_image);
    figure; imshow(uint8(warped_image));
    title('mosaic image');

end


%written by: Leena Shekhar