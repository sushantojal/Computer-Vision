

function [Iwarp, Imerge] = warpImage(Iin, Iref, H)
%warpImage warps an image wrt to another image returns Iwarp and mosaics
%this to the other image. Merged image is Imerge
%inputs: Iin: input image
%        Iref: reference image
%        H: 3x3 homography matrix
%outputs : Iwarp : warped input image wrt to reference image
%          Imerge: mosaiced image

%by: sushant ojal

in = im2double(Iin);
iref = im2double(Iref);

% in = im2double(imread('sbu1.jpg'));
% iref = im2double(imread('sbu2.jpg'));
% H = computeH(movingPoints, fixedPoints);

[hin, win, zin] = size(in);
[href, wref, zref] = size(iref);

p1 = H * ([1,1,1]'); p1 = p1(:,1)./p1(3,1);
p2 = H * ([win,1,1]'); p2 = p2(:,1)./p2(3,1);
p3 = H * ([1,hin,1]'); p3 = p3(:,1)./p3(3,1);
p4 = H * ([win,hin,1]'); p4 = p4(:,1)./p4(3,1);


xmin = (min([p1(1,1), p2(1,1), p3(1,1), p4(1,1)]));
xmax = (max([p1(1,1), p2(1,1), p3(1,1), p4(1,1)]));

ymin = (min([p1(2,1), p2(2,1), p3(2,1), p4(2,1)]));
ymax = (max([p1(2,1), p2(2,1), p3(2,1), p4(2,1)]));

wid = (xmax - xmin); hei = (ymax - ymin);

Tin = [1,0,1 - xmin; 0,1, 1 - ymin; 0,0,1];
imout = zeros(ceil(hei), ceil(wid), zin);

for i = 1:wid
    for j = 1:hei    
        temp3 = Tin\([i,j,1]');
        temp = H \ ([temp3(1,1),temp3(2,1),1]');   
        temp = temp(:,1)./temp(3,1);
        if(floor(temp(1,1))>=1 && floor(temp(1,1)) <= win && floor(temp(2,1)) >=1 && floor(temp(2,1))<=hin)
            imout(j,i,:) = in(floor(temp(2,1)), floor(temp(1,1)),:);

        end    
    end
end

Iwarp = imout;
Imerge = Iwarp;
for i = 1:wref
    for j = 1:href
        temp = Tin * [i,j,1]';
        temp = temp(:,1)./temp(3,1);
        Imerge(floor(temp(2,1)), floor(temp(1,1)),:) = iref(j,i,:);
    end
end

figure(1)
imshow(Iwarp);
figure(2)
imshow(Imerge);

end


