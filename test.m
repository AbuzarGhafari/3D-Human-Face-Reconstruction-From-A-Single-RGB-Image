clc, clearvars, close all;

%% 2D Rotation

points_x = [1, 1, -1, -1];
points_y = [1, -1, -1, 1];
rotated_points_x = [1, 1, -1, -1];
rotated_points_y = [1, -1, -1, 1];

theta = 0;

rotation_matrix = [cos(theta), -sin(theta); sin(theta), cos(theta)]

figure
plot(points_x, points_y)


for index = 1:4
    res = rotation_matrix * [points_x(index), points_y(index)]'

    rotated_points_x(index) = res(1)
    rotated_points_y(index) = res(2)
end

figure
plot(rotated_points_x, rotated_points_y)

%% test


% Example intrinsic parameters and distortion coefficients (replace with actual values)
focalLength = [1000, 1000];  % Focal lengths (fx, fy)
principalPoint = [640, 480]; % Principal point (cx, cy)
skew = 0;                    % Skew
imageSize = [1280, 960];     % Image size (width, height)
radialDistortion = [0.1, -0.2, 0.03]; % Radial distortion coefficients
tangentialDistortion = [0.01, -0.02]; % Tangential distortion coefficients

% Create a cameraParameters object
cameraParams = cameraParameters('IntrinsicMatrix', [focalLength(1), skew, principalPoint(1); 0, focalLength(2), principalPoint(2); 0, 0, 1], ...
    'ImageSize', imageSize, 'RadialDistortion', radialDistortion, 'TangentialDistortion', tangentialDistortion);
