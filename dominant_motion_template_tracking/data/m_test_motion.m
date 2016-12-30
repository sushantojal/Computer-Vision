function m_test_motion(path_to_images, numimages)
% CSE 527 -- Computer Vision HW4
% Make a gif file using the sequence of binary 
% images returned after every call of SubtractDominantMotion function
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 11-Nov-2016
% Last modified: 11-Nov-2016

% NOTE - you might have to change the path slashes depending on windows or unix.
fname = sprintf('%s//frame%d.pgm',path_to_images,0);
img1 = double(imread(fname));

outFile = 'motion.gif';
border = 5;


for frame = 1:numimages-1
    % Reads next image in sequence
    fname = sprintf('%s//frame%d.pgm',path_to_images,frame);
    
    img2 = double(imread(fname));
    
    % Runs the function to estimate dominant motion
    disp(['Processing pair of image ' num2str(frame-1) ' and ' num2str(frame)]);
    motion_img = SubtractDominantMotion(img1, img2);
    % Superimposes the binary image on img2, and adds it to the movie
    currframe=repmat(img2/255.0,[1 1 3]);
    motion_img=double(motion_img);
    temp=img2/255.0; temp(motion_img~=0.0)=1.0;
    currframe(:,:,1)=temp;
    currframe(:,:,3)=temp;
    
    % add currframe to gif file
    
    im = currframe;
    progress = ceil(frame/(numimages-1)*size(im,2));
    im(end-border+1:end,1:progress,1) = 0;
    im(end-border+1:end,1:progress,2) = 255;
    im(end-border+1:end,1:progress,3) = 0;
    
    [imind,cm] = rgb2ind(im,256);
    
    if frame==1
        imwrite(imind,cm,outFile,'gif', 'DelayTime', 0.1, 'Loopcount',inf);
    else
        imwrite(imind,cm,outFile,'gif', 'DelayTime', 0.1, 'WriteMode','append');
    end
    
    img1 = img2;
end
fprintf('\nFile motion.gif has been generated. Open with a Web browser to view\n');

