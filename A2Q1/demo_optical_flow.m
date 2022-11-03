function [Vx,Vy] = demo_optical_flow(folder_name,frame_number_1,frame_number_2)

% -------------------------------- %
% DO NOT CHANGE THIS FUNCTION !!!! %
% -------------------------------- %

% This is just a helper function to test your code

% This is a demo to show the optical flow in quiver plot
% Examples of using it:
% demo_optical_flow('Backyard',10,11)
% demo_optical_flow('Backyard',10) -> it automatically runs  demo_optical_flow('Backyard',10,11)
% demo_optical_flow('Backyard') -> it runs demo_optical_flow('Backyard',7,8)

if(nargin == 0)
    folder_name = 'Backyard';
    frame_number_1 = 7;
    frame_number_2 = frame_number_1 + 1;
elseif(nargin == 1)
    frame_number_1 = 7;
    frame_number_2 = frame_number_1 + 1;
elseif(nargin ==2)
    frame_number_2 = frame_number_1 + 1;
end

addpath(folder_name);

frame_1 = read_image(folder_name,frame_number_1);
frame_2 = read_image(folder_name,frame_number_2);

[Vx,Vy] = compute_LK_optical_flow(frame_1,frame_2);


plotflow(frame_1,Vx,Vy);
title('Quiver plot');

end

function plotflow(frame,Vx,Vy)

% -------------------------------- %
% DO NOT CHANGE THIS FUNCTION !!!! %
% -------------------------------- %

s = size(Vx);
step = max(s)/40; % You can change this if you want a finer grid
[X, Y] = meshgrid(1:step:s(2), s(1):-step:1);
u = interp2(Vx, X, Y);
v = interp2(Vy, X, Y);

imshow(frame);

hold on
quiver(X, Y, u, v, 1, 'cyan', 'LineWidth', 0.8);
axis image;
hold off

end

function I = read_image(folder_name,index)

% -------------------------------- %
% DO NOT CHANGE THIS FUNCTION !!!! %
% -------------------------------- %

if(index < 10)
    I = imread(fullfile(folder_name,strcat('frame0',num2str(index),'.png')));
    % Used to be 'frame0'
else
    I = imread(fullfile(folder_name,strcat('frame',num2str(index),'.png')));
    % Used to be 'frame'
end

end
