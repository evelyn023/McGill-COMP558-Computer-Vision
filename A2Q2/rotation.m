function new_coor_c = rotation(old_coor_c,omegaT,rotationAxis)
% Compute 3 explicit rotations of the camera coordinate system. 
% Output the new coordinates of the 3D scene point with respect to the 
% camera reference frame.

% rotation matrix 
if strcmp(rotationAxis,'x')
    R = [1 0 0 0;
         0 cos(omegaT) -sin(omegaT) 0; 
         0 sin(omegaT) cos(omegaT) 0;
         0 0 0 1];
elseif strcmp(rotationAxis,'y')
    R = [cos(omegaT) 0 sin(omegaT) 0;
         0 1 0 0; 
         -sin(omegaT) 0 cos(omegaT) 0;
         0 0 0 1];    
elseif strcmp(rotationAxis,'z')
    R = [cos(omegaT) -sin(omegaT) 0 0; 
         sin(omegaT) cos(omegaT) 0 0;
         0 0 1 0;
         0 0 0 1];
else
    print('Error: invalid rotationAxis');
end

% convert original camera coordinates into 3D homogeneous coordinates
homo_coor = [old_coor_c; ones(1,size(old_coor_c,2))];
% do rotation and translation
new_coor_c = R * homo_coor;
new_coor_c = new_coor_c(1:3,:);
 
end

