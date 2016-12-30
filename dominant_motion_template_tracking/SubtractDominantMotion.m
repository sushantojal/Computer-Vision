
function [moving_image] = SubtractDominantMotion(im1, im2)
    im1 = (im1)/255.0;
    im2 = (im2)/255.0;

    [h,w] = size(im1);
    [xind yind] = meshgrid ( 1:w, 1:h );
    xind2 = xind .*xind; yind2 = yind .* yind;
    b1 = [0; 0; 0; 0; 0; 0];
    for counter = 1:100
        xwarp = double(zeros(h,w));
        xwarp = ((1+b1(1,1)) .* xind) + (b1(2,1) .* yind) + b1(3,1);
        ywarp = (b1(4,1) .* xind) + ((1+b1(5,1)) .* yind) + b1(6,1);
        imgwarped =  interp2(xind, yind, im2, xwarp, ywarp);
        checkmat = zeros(h,w);
        for i = 1:w
            for j = 1:h
                if xwarp(j,i) >= 1 && xwarp (j,i) <= w && ~isnan( xwarp(j,i) )
                    if ywarp(j,i) >= 1 && ywarp(j,i) <= h && ~isnan( ywarp(j,i) ) 
                        checkmat(j,i) = 1;
                    end
                end
            end
        end


        [ix, iy] = gradient(im1);
        ix = checkmat .* ix; iy = checkmat .* iy;
        ix2 = ix .* ix; iy2= iy.*iy;
        ixy = ix .*iy;
        it = im1 - imgwarped;
        it(isnan(it)) = 0;
        it = it .* checkmat;


        ix2 = ix .* ix; iy2 = iy .* iy; ixy = ix .* iy;
        row1 = [ sum(sum(ix2 .* xind2)) sum(sum( ix2 .* xind .* yind)) sum(sum(xind .* ix2))...
                sum(sum(xind2 .* ix .* iy)) sum(sum(xind .* yind .* ix .* iy)) sum(sum(xind .* ix .* iy)) ];
        row2 = [ 0 sum(sum( yind2 .* ix2 )) sum(sum( yind .* ix2)) sum(sum(xind .* yind .* ix .* iy)) ...
                sum(sum(yind2 .* ix .* iy)) sum(sum( yind .* ix .* iy ))];
        row3 = [0 0 sum(sum(ix2)) sum(sum( xind .* ix .* iy )) sum(sum(yind .* ix .* iy )) sum(sum(ix .* iy))];
        row4 = [0 0 0 sum(sum(xind2 .* iy2)) sum(sum(xind .* yind .* iy2)) sum(sum(xind .* iy2))];
        row5 = [0 0 0 0 sum(sum(yind2.*iy2)) sum(sum(yind .* iy2))];
        row6 = [0 0 0 0 0 sum(sum(iy2))];

        a1 = vertcat(row1, row2, row3, row4, row5, row6);

        c1 = [ sum(sum(xind .* ix .* it)); sum(sum(yind .* ix .* it)); sum(sum(ix .* it ));...
                sum(sum(xind.*iy.*it)); sum(sum(yind.*iy.*it)); sum(sum(iy.*it))];

        b1 = b1 + (a1\c1);

    end

    M = [ (1 + b1(1,1)) b1(2,1) b1(3,1); b1(4,1) (1+b1(5,1)) b1(6,1); 0 0 1];

    diff1 = abs(im2 - imgwarped);    
    moving_image = hysthresh(diff1, 0.30, 0.18);
    imshow(moving_image);

end


