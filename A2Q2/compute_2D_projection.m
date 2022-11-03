function [projectedDepthImage,projectedRGBImage]=compute_2D_projection(imageNumber,omegaT,rotationAxis,translationVector)


% This function create two images: 1) an image that contains the projected 
% depth value  (greyscale) and 2) an image that contains the projected 
% color of the 3D scene point.
%  
% INPUTS: 
% imageNumber: you may check the previous function and see how it has been
% used.
%
% omegaT is a value between 0 to pi/2 make sure not to use degrees!
%
% rotationAxis is either 'x' or 'y' or 'z' (you can use strcmp function
% to find which axis the rotation is about. 
%
% translationVector is a 3x1 vector that indicates the translation
% direction. For this assignment, it should have only 1 non-zero element,
% which defines the translation direction implicitly (i.e unlike what you 
% will do for rotation, you do not have to explicitly set a translation
% direction, the nonzero element will take care of direction and the
% translation amount).
%
% You can read the saved point cloud from the previous function and use
% that information here. You may also use any other inputs that are
% provided in the assignment description.
% 
% OUTPUTS:
% projectedDepthImage: an image that contains the projected depth
% value (greyscale)
% projectedRGBImage: an image that contains the projected color of the 3D 
% scene point.


%%% YOUR IMPLEMENTATION GOES HERE:
% add the corresponding folder name to the path 
addpath(num2str(imageNumber));
% load the inputs
depthImageFileName = strcat('depthImage_',num2str(imageNumber),'.png');
extrinsicFileName = strcat('extrinsic_',num2str(imageNumber),'.txt');
intrinsicsFileName = strcat('intrinsics_',num2str(imageNumber),'.txt');

depthImage = imread(depthImageFileName);
[h,w] = size(depthImage);
extrinsic_matrix = load(extrinsicFileName);
intrinsics_matrix = load(intrinsicsFileName);

% You have to compute the following images
projectedDepthImage = uint16(zeros(h,w));
projectedRGBImage = uint8(zeros(h,w,3));

point_cloud = compute_point_cloud(imageNumber);
homo_w_coor = [point_cloud(:,1:3) ones(size(point_cloud,1),1)]; % n*4

% Calculate the new extrinsic matrix after translation
R = extrinsic_matrix(1:3,1:3); %3*1
RC_new = extrinsic_matrix(1:3,4) - R * translationVector'; %3*1
extrinsic_new = [R RC_new]; %3*4

% 3D points in camera coordinates after translation
c_coor = extrinsic_new * homo_w_coor'; %3*n
% 3D points in camera coordinates after rotation
new_c_coor = rotation(c_coor,omegaT,rotationAxis); %3*n

% do projection
new_p_coor = intrinsics_matrix * new_c_coor;
for i = 1:size(new_p_coor,2)
    proj = new_p_coor(:,i);
    p = int16(proj(1:2)/proj(3)); % pixel index
    a = p(1);
    b = p(2);
    if a<= h && b<= w && a>0 && b>0
        projectedDepthImage(a,b) = proj(3);
        projectedRGBImage(a,b,:) = point_cloud(i,4:6);
    end
end

end
