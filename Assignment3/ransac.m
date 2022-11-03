function [F,matched_8] = ransac(matched_list,t,cmin)
% inputs: N*4 matched points, distance treshold, concensus min
% outputs: fundamental matrix F 
%          the 8 points used to fit F

% keep fitting until get a concensus set larger than cmin
while true
    n = size(matched_list,1);
    inliers = []; % concensus set
    % randomly pick 8 points
    index = randsample(n,8); 
    matched_8 = matched_list(index,:);
    F = fundamental_matrix(matched_8);
    
    % Check whether a pixel pair is in concensus set
    for j = 1:n
        % x1,x2 are the actual pair of pixels in left and right image
        x1 = [matched_list(j,1:2) 1];
        x2 = [matched_list(j,3:4) 1];
        % epipolar line in left image 
        l1 = x2*F;
        % distance from point x1 to epipolar line l1
        d = abs(dot(l1,x1))/sqrt(l1(1)^2+l1(2)^2);
        if d < t
            inliers = [inliers,j];
        end
    end
    
    if length(inliers) > cmin
        return;
    end
end
end