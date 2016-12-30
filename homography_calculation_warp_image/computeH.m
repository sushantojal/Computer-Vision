
function H = computeH (t1, t2)

%question 2: function to compute homography matrix
%inputs: t1 is the set of movingPoints and t2 is the set of fixedPoints
%output: the 3x3 homography matrix H
%by: sushant ojal

[~, n, ~] = size(t1);
hMat = (zeros(2*n, 9));
j = 1;
for i = 1:n
    x1 = t1(1,i); y1 = t1(2,i);
    x2 = t2(1,i); y2 = t2(2,i);
    temp1 = [x1, y1, 1, 0, 0, 0, -x1*x2, -y1*x2, -x2];
    temp2 = [0, 0, 0, x1, y1, 1, -x1*y2, -y1*y2, -y2];
    hMat(j,:) = temp1;
    hMat(j+1,:) = temp2;
    j = j + 2;
end

[~,~,V] = svd(hMat,'econ');
hVec = V(:,9);

H = (reshape(hVec, 3, 3))';

end



