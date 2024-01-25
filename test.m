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


perspected_point_2d_x = zeros(1,68)