%% Image1
% load images and the fundamental matrix got from Q2
I11 = imread("stereo-pairs\p11.jpg");
I12 = imread("stereo-pairs\p12.jpg");
load('F1_ransac.mat');

pixel_pair11 = [
    121, 389; % bottom left corner of the book
    278, 183; % top left corner of the box
    513, 341; % bottom right corner of the box
    496, 101; % top left corner of the monitor
    692, 256; % bottom right corner of the monitor
    305, 50;  % wall
    ];
pixel_pair12 = [
    23, 372;
    255, 190;
    464, 339;
    540, 86;
    732, 250;
    457, 42;
    ];

M1 = get_intrinsic(31,size(I11,1),size(I11,2)); % camera intrinsic
E1 = M1' * F1_ransac * M1; % essential matrix
[R1,T1] = decomposeE(E1);

points_3D_1 = zeros(3,size(pixel_pair11,1));
for i = 1:size(pixel_pair11,1)
    pl = [pixel_pair11(i,:) 1]';
    pr = [pixel_pair12(i,:) 1]';
    p_3D = triang(pl,pr,R1,T1);
    points_3D_1(:,i) = p_3D;
end

% display
depth = 100*points_3D_1(3,:);
I1_dep = insertText(I11,pixel_pair11,depth,'AnchorPoint','LeftBottom');
figure;
imshow(I1_dep);


%% Image2
I21 = imread("stereo-pairs\p21.jpg");
I22 = imread("stereo-pairs\p22.jpg");
load('F2_ransac.mat');

pixel_pair21 = [
    537, 431; % bottom right corner of the phone
    321, 390; % book
    221, 357; % cup
    535, 319; % ball
    331, 289; % radio
    305, 230; % pendant over the radio
    ];
pixel_pair22 = [
    403, 430;
    264, 389;
    178, 354;
    486, 320;
    307, 289;
    290, 230;
    ];

M2 = get_intrinsic(32,size(I21,1),size(I21,2));
E2 = M2' * F2_ransac * M2;
[R2,T2] = decomposeE(E2);

points_3D_2 = zeros(3,size(pixel_pair21,1));
for i = 1:size(pixel_pair21,1)
    pl = [pixel_pair21(i,:) 1]';
    pr = [pixel_pair22(i,:) 1]';
    p_3D = triang(pl,pr,R2,T2);
    points_3D_2(:,i) = p_3D;
end

depth = 100*points_3D_2(3,:);
I2_dep = insertText(I21,pixel_pair21,depth,'AnchorPoint','LeftBottom');
figure;
imshow(I2_dep);


%% helper functions
% get camera matrix
function M = get_intrinsic(f,x,y)
% inputs: focal length, image size(x,y)
    sx = 31.2e-2; 
    sy = 31.2e-2;
    px = x/2;
    py = y/2;
    M = [f/sx 0 px;
        0 f/sy py;
        0 0 1];
end

% ger extrinsic parameters R and T from essential matrix
function [R,T] = decomposeE(E)
    [U,~,V] = svd(E);
    % translation vector is the last column of U
    T = U(:,3);
    T = T./norm(T); % unit vector, only has direction
    
    RR = [0,-1,0;1,0,0;0,0,1]; % rotate along z-axis by pi/2
    R1 = U * RR * V';
    R2 = U * RR' * V';
    
    % determinant should be 1
    if det(R1)<0
        R1 = -R1;
    end
    if det(R2)<0
        R2 = -R2;
    end   
    if R1(1,1)>0 && R1(2,2)>0 && R1(3,3)>0
        R = R1;
    else
        R = R2;
    end

end

% calculate the corresponding 3D scene point using TRIANG algorithm
function p = triang(pl,pr,R,T)
% inputs: left point in homo_cor, right point in homo_cor, 
%         rotation matrix, transition vector
% output: the corresponding 3D scene point of pl and pr

    % solve linear system
    x1 = pl;
    x2 = R'*pr;
    x3 = cross(pl,x2);
    A = [x1 x2 x3];
    X = linsolve(A,T);
    a0 = X(1);
    b0 = -X(2);
    % get end points of the segment
    endPoint1 = a0*pl;
    endPoint2 = T+b0.*(R'*pr);
    % p is the midpoint of the segment
    p = (endPoint1+endPoint2)/2;

end