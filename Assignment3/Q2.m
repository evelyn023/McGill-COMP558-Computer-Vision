%% Image1
% read images
I11 = imread("stereo-pairs\p11.jpg");
I12 = imread("stereo-pairs\p12.jpg");

% find matched points
[matchedLeft, matchedRight] = SurfFeaturepoints(rgb2gray(I11),rgb2gray(I12));
matched_list = [matchedLeft.Location matchedRight.Location];

% RANSAC, parameters are tau=0.5,cmin=150
[F1_ransac,matched8_1] = ransac(matched_list,0.5,150);
rank(F1_ransac);

% save F1_ransac matix
save('F1_ransac.mat',"F1_ransac","-mat")

% Draw epipolar lines
%matched1 = matched_list1(inliers,1:2);
%matched2 = matched_list1(inliers,3:4);
draw_epipolar_lines(I11,I12,F1_ransac,matched8_1(:,1:2),matched8_1(:,3:4));


%% Image2
I21 = imread("stereo-pairs\p21.jpg");
I22 = imread("stereo-pairs\p22.jpg");

% find matched points
[matchedLeft, matchedRight] = SurfFeaturepoints(rgb2gray(I21),rgb2gray(I22));
matched_list2 = [matchedLeft.Location matchedRight.Location];

% RANSAC, parameters are tau=0.5,cmin=55
[F2_ransac,matched8_2] = ransac(matched_list2,0.5,55);
rank(F2_ransac);

% save F2_ransac matrix
save("F2_ransac.mat","F2_ransac","-mat")

% Draw epipolar lines
draw_epipolar_lines(I21,I22,F2_ransac,matched8_2(:,1:2),matched8_2(:,3:4));
