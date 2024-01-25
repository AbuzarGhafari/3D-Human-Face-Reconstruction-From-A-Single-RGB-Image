%% Clear
clc, clearvars, close all;

%% Variables

perspected_point_2d_x = zeros(1,68);
perspected_point_2d_y = zeros(1,68);

left = 100;

right = 100;

bottom = 100;

top = 100;

near = 5;

far = 20;

nx = 600;

ny = 600;

%% Matrices

rotation_matrix = [
    1, 0, 0, 0; 
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1
    ];

translation_matrix = [
    1, 0, 0, 0; 
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1
    ];

camera_matrix = rotation_matrix * translation_matrix;

viewport_matrix = [
    nx / 2, 0, 0, (nx - 1) / 2;
    0, ny / 2, 0, (ny - 1) / 2;
    0, 0, 0.5, 0.5;
    ];


%% Perspective Projection Matrix
 
projection_matrix = perspective_projection(left, right, bottom, top, near, far);


%% Load Model
load('Model_Shape_Sim.mat');


%% Sample Image

sample_name = '134212_1.mat'; 

load(sample_name);

%% 3D Points

pt3d = Fitted_Face(:, keypoints);

plot(pt3d(1,:), pt3d(2,:))

%% Parameters

point_3d_x = pt3d(1,:);
point_3d_y = pt3d(2,:);
point_3d_z = pt3d(3,:);


%% Apply Perpective Projection on Face 3D Points

for index = 1:68

    point_3d = [point_3d_x(index), point_3d_y(index), point_3d_z(index), 1];

    res = projection_matrix * camera_matrix * point_3d';
      
    res = res./ res(4);

%     point_2d = viewport_matrix * res;
    point_2d = res; 
    perspected_point_2d_x(index) = point_2d(1);
    perspected_point_2d_y(index) = point_2d(2);
end

%% Plot 3D
figure
plot(point_3d_x, point_3d_y);

%% Plot Perspected Projection
figure
plot(perspected_point_2d_x, perspected_point_2d_y);