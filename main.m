%% Clear
clc, clearvars, close all;

%% Functions Path

addpath('functions');

rehash;

%% Global Variables

dataset_path = '3d_dataset/';

landmarks_count = 68;

startAngle = 0;
endAngle = 360; 
interval = 30;

angles = linspace(startAngle, endAngle, (endAngle - startAngle) / interval + 1);
angles = angles(1:end-1);


%% Load Dataset

fileNames = getDatasetFiles(dataset_path);


%% Load Model

load('model/Model_Shape_Sim.mat');


%% Sample Image

sample_name = [dataset_path, cell2mat(fileNames(2))]; 


load(sample_name);

%% 3D Points

pt3d = Fitted_Face(:, keypoints);
 

%% Apply Perpective Projection on Face 3D Points

data2d = [];

for angle = 1:numel(angles)
    
    pt2d = [];
    
    for index = 1:landmarks_count

        point_3d = [pt3d(1, index), pt3d(2, index), pt3d(3, index), 1];
    
        point_2d = conv3Dto2D(point_3d, angles(angle), 'z');

        pt2d = [pt2d, [point_2d(1); point_2d(2)]];        
        
    end
    
    data2d = [data2d; {pt2d}];

end 

%% Plot  

draw3DFace(pt3d)
 
figure;
for p = 1:numel(data2d)
    subplot(3, 4, p);
    draw2DFace(data2d{p}, [num2str(angles(p)), ' angle']);
end 