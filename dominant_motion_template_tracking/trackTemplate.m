
function trackTemplate(path_to_car_sequence, sigma, template)

    template = im2double(rgb2gray(template));

    carimage1 = im2double(rgb2gray(imread(strcat(path_to_car_sequence,'/frame00307.jpg'))));
    carimage2 = im2double(rgb2gray(imread(strcat(path_to_car_sequence,'/frame00308.jpg'))));
    carimagetemp = imread(strcat(path_to_car_sequence,'/frame00308.jpg'));

    c = normxcorr2(template, carimage1);
    [ypeak, xpeak] = find(c==max(c(:)));
    yoffSet = ypeak-size(template,1);
    xoffSet = xpeak-size(template,2);

    hAx  = axes;
    imshow(carimage1,'Parent', hAx);
    imrect(hAx, [xoffSet+1, yoffSet+1, size(template,2), size(template,1)]);

    xmin = xoffSet+1; ymin = yoffSet+1; w = size(template,2); h = size(template,1);

    fileId = fopen('coordinates.txt','w');
    fprintf(fileId, '%d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f\n', 307, ymin, xmin,...
        ymin, xmin + size(template,2), ymin + size(template,1), xmin + size(template,2),...
        ymin +size(template,1), xmin);

    g = fspecial('gaussian', 5, sigma);

    count = 308;

    while count < 404
        w1 = carimage1( ymin:ymin+h, xmin:xmin+w);
        w2 = carimage2( ymin:ymin+h, xmin:xmin+w);

        w1 = conv2(w1, g, 'same');
        w2 = conv2(w1, g, 'same');
        temp = [0 ; 0];
        for c = 1:50
            [ix, iy] = gradient(w1);
            s1 = [ix(:), iy(:)];
            it = w1 - w2;
            it = it(:);
            shift = (s1' * s1 )\(s1' * it );
            temp = temp + shift;
            xmin = xmin + shift(1,1); ymin = ymin + shift(2,1);
            w2 = carimage2( ymin:ymin+h, xmin:xmin+w);
        end

        imshow(carimagetemp);
        hold on
        rectangle('Position', [xmin, ymin, size(template,2), size(template,1)]);
        pause(0.1);

        fprintf(fileId, '%d %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f\n', count, ymin, xmin,...
        ymin, xmin + size(template,2), ymin + size(template,1), xmin + size(template,2),...
        ymin +size(template,1), xmin);

        count = count + 1;
        if count == 404 
            break;
        end
        carimage1 = carimage2;
        carimagetemp = imread(strcat('hw4data/CarSequence/frame00', num2str(count), '.jpg'));
        carimage2 = im2double(rgb2gray(imread(strcat('hw4data/CarSequence/frame00', num2str(count), '.jpg')))); 

    end

    fclose(fileId);

end