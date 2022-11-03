function output = compute_point_cloud(imageNumber)

% This function provides the coordinates of the associated 3D scene point 
% (X; Y;Z) and the associated color channel values for any pixel in the 
% depth image. You should save your output in the output_file in the 
% format of a N x 6 matrix where N is the number of 3D points with 3 
% coordinates and 3 color channel values:
% 
% X_1,Y_1,Z_1,R_1,G_1,B_1
% X_2,Y_2,Z_2,R_2,G_2,B_2
% X_3,Y_3,Z_3,R_3,G_3,B_3
% X_4,Y_4,Z_4,R_4,G_4,B_4
% X_5,Y_5,Z_5,R_5,G_5,B_5
% X_6,Y_6,Z_6,R_6,G_6,B_6
% .
% .
% .
% .
%
% IMPORTANT:
% "Your output should be saved in MATLAB binary format (.mat)"
% You may use any of the four following inputs for this part:
% For example, if imageNumber is 1 then possible inputs you might need
% can have the following values:
% rgbImageFileName = 'rgbImage_1.jpg';
% depthImageFileName = 'depthImage_1.png';
% extrinsicFileName = 'extrinsic_1.txt
% intrinsicsFileName = 'intrinsics_1.txt'
%
% Output file name = 'pointCloudImage_1.mat'


% add the corresponding folder name to the path 
addpath(num2str(imageNumber));

% You can remove any inputs you think you might not need for this part:
rgbImageFileName = strcat('rgbImage_',num2str(imageNumber),'.jpg');
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
extrinsicFileName = strcat('extrinsic_',num2str(imageNumber),'.txt');
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');

rgbImage = imread(rgbImageFileName);
depthImage = imread(depthImageFileName);
extrinsic_matrix = load(extrinsicFileName);
intrinsics_matrix = load(intrinsicsFileName);


%%% YOUR IMPLEMENTATION GOES HERE:
output = zeros(size(depthImage,1)*size(depthImage,2),6);
n=1;
for i = 1:size(depthImage,1)
    for j = 1:size(depthImage,2)
        p = [i;j;1];
        if depthImage(i,j) ~= 0 
            p = p * double(depthImage(i,j));
        end
        Xc = (intrinsics_matrix\p);
        E = [extrinsic_matrix; [0,0,0,1]];
        Xw = E\[Xc;1];
        output(n,1:3) = Xw(1:3);
        output(n,4:6) = rgbImage(i,j,:);
        n = n+1;
    end
end

%To save your ouptut use the following file name:
outputFileName = strcat('pointCloudImage_',num2str(imageNumber),'.mat');
save(outputFileName,"output","-mat");
end
