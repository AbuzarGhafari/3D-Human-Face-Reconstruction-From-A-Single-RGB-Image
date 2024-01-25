%% Clear
clc, clearvars, close all;
  

%% Load Model
load('Model_Shape_Sim.mat');


%% Sample Image

sample_name = '11329920_1.mat'; 

load(sample_name);

%% 3D Points

pt3d = Fitted_Face(:, keypoints);
 

%% Apply Perpective Projection on Face 3D Points

pt2d = [];

for index = 1:68

    point_3d = [pt3d(1, index), pt3d(2, index), pt3d(3, index), 1];

    point_2d = conv3Dto2D(point_3d);
    
    pt2d = [pt2d, [point_2d(1); point_2d(2)]];
     
end 

%% Plot  

draw3DFace(pt3d)
 
draw2DFace(pt2d)
