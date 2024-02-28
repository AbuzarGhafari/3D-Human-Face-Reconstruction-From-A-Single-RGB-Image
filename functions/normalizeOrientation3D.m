function [pt3d] = normalizeOrientation3D(pt3d)
    global face_midpoint_index;
        
    left_eye = pt3d(:, 37: 42);
    left_eye_mean = mean(left_eye');
    right_eye = pt3d(:, 43: 48);
    right_eye_mean = mean(right_eye');    
    
    theta = atand((left_eye_mean(1) - right_eye_mean(1))/(left_eye_mean(3) - right_eye_mean(3)));
    
    P = [
        cosd(theta), 0, sind(theta), 0;
        0, 1, 0, 0;
        -sind(theta), 0, cosd(theta), 0;
        0, 0, 0, 1
        ];
    
    theta = atan2(left_eye_mean(3) - right_eye_mean(3), ...
              left_eye_mean(1) - right_eye_mean(1));
    
    % Step 2: Define the rotation matrix around the Y-axis
    Ry = [cos(theta)  0  sin(theta) 0;
      0           1  0          0;
      -sin(theta) 0  cos(theta) 0;
      0           0  0          1];

    %     points = [pt3d; ones(1, 68)];
    
    homogeneousLandmarks = [pt3d; ones(1, size(pt3d, 2))];

    % Apply the rotation to each landmark
    normalizedLandmarks = Ry * homogeneousLandmarks;

    % Remove the homogeneous coordinate to return to 3xN size
%     pt3d = normalizedLandmarks(1:3, :);

%     pt3d = P * points;


    % Define the reflection matrix around the Y-axis
    reflectionMatrix = [
        -1 0 0 0; 
        0 1 0 0; 
        0 0 1 0;
        0 0 0  1
        ];

    % Reflect the points around the Y-axis
    reflectedPoints = reflectionMatrix * normalizedLandmarks;
    
    pt3d = reflectedPoints(1:3, :);
end

