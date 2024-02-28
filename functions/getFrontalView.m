function [pt3d] = getFrontalView(pt3d)

    
    landmarks = pt3d;
    
    % Calculate the mean of the landmarks to find the center
    centroid = mean(landmarks, 2);

    % Translate the landmarks to center them at the origin
    centeredLandmarks = landmarks - centroid;
    
    % Apply PCA to find the principal axes
    [coeff, ~, ~] = pca(centeredLandmarks');

    % The columns of coeff are the principal axes. The first two columns can be used to
    % align the face with the x-y plane for a frontal view.
    % Create a rotation matrix to align the first principal axis with the x-axis and
    % the second with the y-axis. This is an approximation.
    R = coeff(:,1:3);

    % Rotate the centered landmarks to align with the frontal view
    alignedLandmarks = R' * centeredLandmarks;

    
    pt3d = alignedLandmarks;
    
    angle = 00;
    
    % Convert angle to radians for MATLAB functions
    angleRadians = deg2rad(angle);
     
    Rx = [1, 0, 0;
      0, cos(angleRadians), -sin(angleRadians);
      0, sin(angleRadians), cos(angleRadians)];

    Ry = [cos(angleRadians), 0, sin(angleRadians);
      0, 1, 0;
      -sin(angleRadians), 0, cos(angleRadians)];
  
    pt3d = Rx * pt3d;
    
    disp(centroid);

end

