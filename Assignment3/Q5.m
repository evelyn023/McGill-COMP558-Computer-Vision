close all;
%% Test diparity function using image pair took by rectified camera
% Read images
I1 = rgb2gray(imread("stereo-pairs\p41.png"));
I2 = rgb2gray(imread("stereo-pairs\p42.png"));
%dismap = disparity(I1,I2,11,20);
% Display Results
%show_map(dismap);


%% Image 1
load("I11_rec.mat");
load("I12_rec.mat");
I11 = rgb2gray(I11_rec);
I12 = rgb2gray(I12_rec);

%dismap1 = disparity(I11,I12,40,40);
%show_map(dismap1);
%show_depMap(dismap1,20,31);

%% Image 2
load("I21_rec.mat");
load("I22_rec.mat");
I21 = rgb2gray(I21_rec);
I22 = rgb2gray(I22_rec);

dismap2 = disparity(I21,I22,20,50);
show_map(dismap2);
%show_depMap(dismap2,20,31);


%% functions
%Get disparity map from stereo pairs by SSD
function [dispMap] = disparity(I1, I2, winSize, dispMax)

    I1 = im2double(I1);
    I2 = im2double(I2);
    [size_r, size_c] = size(I1);
    dispMap = zeros(size_r, size_c);
    win = round(winSize/2);
    % padding the images to deal with the boundry
    I1 = padarray(I1, [win, win + dispMax], 'both');
    I2 = padarray(I2, [win, win + dispMax], 'both');
    
    % Use progress bar
    bar = waitbar(0, 'Loading...');
    
    for r = win+1 : win+size_r        
        for c = win+dispMax+1 : win+dispMax+size_c
            ssd_opt = 1000000;
            optimum = 0;
            % check along a row
            for d = -dispMax : -1
                window1 = I1(r-win : r+win, c-win : c+win);
                window2 = I2(r-win : r+win, c-win+d : c+win+d);
                % compute the sum of squared difference in the window
                ssd = sum(sum((window1-window2).^2));
                if (ssd_opt > ssd)
                    ssd_opt = ssd;
                    optimum = d;
                end
            end
            dispMap(r-win, c-win-dispMax) = abs(optimum);
        end
        waitbar(r/(win + size_r),bar);
    end
 
    close(bar);
end

function show_map(dispMap)
    figure;
    imshow(dispMap,[1,50]);
    colormap jet;
    colorbar;
    title('Disparity Map');
    impixelinfo;
end

function show_depMap(dispMap,T,f)
    depMap = f * T ./ dispMap;
    figure;
    imshow(depMap,[1,50]);
    colormap jet;
    colorbar;
    title('Depth Map');
    impixelinfo;
end