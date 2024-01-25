%% Clear
clc, clearvars, close all;


%% Load Model
load('Model_Shape_Sim.mat');


%% Sample Image

sample_name = '134212_1.mat'; 

load(sample_name);
% load([face_path sample_name]);


%% Without Fitted_Face 
scatter3(pt3d_68(1,:), pt3d_68(2,:), pt3d_68(3,:),'filled')
% scatter3(x,y,z,'filled');

%% Code

ProjectVertex = Fitted_Face; 

pt3d = ProjectVertex(:, keypoints);


plot(pt3d(1,:), pt3d(2,:))
% plot(Fitted_Face(1,:), Fitted_Face(2,:))