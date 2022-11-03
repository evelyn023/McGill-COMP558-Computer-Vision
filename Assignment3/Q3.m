close all;
%% Image1
% load images and the fundamental matrix got from Q2
I11 = imread("stereo-pairs\p11.jpg");
I12 = imread("stereo-pairs\p12.jpg");
load('F1_ransac.mat');

% calculate H and do rectify
[H11,H12] = get_homography(F1_ransac);
I11_rec = rectify(I11,H11);
I12_rec = rectify(I12,H12);
save("I11_rec.mat","I11_rec","-mat");
save("I12_rec.mat","I12_rec","-mat");

% display the rectified images
show_rectified_images(I11_rec,I12_rec);

%% Image2
I21 = imread("stereo-pairs\p21.jpg");
I22 = imread("stereo-pairs\p22.jpg");
load('F2_ransac.mat');

[H21,H22] = get_homography(F2_ransac);
I21_rec = rectify(I21,H21);
I22_rec = rectify(I22,H22);
save("I21_rec.mat","I21_rec","-mat");
save("I22_rec.mat","I22_rec","-mat");

show_rectified_images(I21_rec,I22_rec);


%% helper functions
% use fundamental matrix to get homography matrix
function [H1,H2] = get_homography(F)
% calculate epipoles
e1 = null(F);
e1 = e1 ./ e1(3);
e2 = null(F');
e2 = e2 ./ e2(3);

% define homography matrices
H1 = [1 0 0;
    -e1(2)/e1(1) 1 0;
    -1/e1(1) 0 1];

H2 = [1.1 0 -5;
    -e2(2)/e2(1) 1 0;
    -1/e2(1) 0 1];

end

% use H to rectify the stereo images
function I_rec = rectify(I,H)
    [a,b,~] = size(I);
    I_rec = zeros(a,b,3);
    for i=1:a
        for j=1:b
            % position after transformation
            new_p = H*[i;j;1];
            new_p = new_p ./ new_p(3);
            x = round(new_p(1));
            y = round(new_p(2));
            if x>0 && x<=a && y>0 && y<=b
                % copy intensity values
                I_rec(x,y,:) = I(i,j,:);
            end
        end
    end
    I_rec = uint8(I_rec);
end

% display the rectified images
function show_rectified_images(I1,I2)
    figure; 
    subplot(121);
    imshow(I1); 
    title("Rectified left image");
    subplot(122);
    imshow(I2);
    title("Rectified right image");
end