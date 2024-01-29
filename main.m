%% Clear
clc, clearvars, close all;

%% Functions Path

addpath('functions');

rehash;

%% Global Variables

dataset_size = 3837;

global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories ...
        working_sub_dir ...
        landmarks_count ...
        angles ...
        directions ...
        face_midpoint_index;

dataset_path = '3d_dataset/';

projected_dataset_path = 'projected_2d_dataset/';

% %                         337,    2330,   135,    1035
dataset_sub_directories = ["AFW", "HELEN", "IBUG", "LFPW"];

working_sub_dir = 4;

landmarks_count = 68;

startAngle = 0;
endAngle = 360; 
interval = 30;

angles = linspace(startAngle, endAngle, (endAngle - startAngle) / interval + 1);

angles = angles(1:end-1);

directions = ['x', 'y', 'z'];

face_midpoint_index = 31;

%% Load Dataset

path = join([dataset_path, dataset_sub_directories(working_sub_dir), "/"], '');

fileNames = getDatasetFiles(path);

%% Load Model

load('model/Model_Shape_Sim.mat');

  
%% List all the files
for fileIndex = 1:numel(fileNames)
    
    disp(fileIndex);
    
    % Sample Image
    sample_name = cell2mat(fileNames(fileIndex));    
    sample_path = [dataset_path, dataset_sub_directories(working_sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '')
    load(sample_path);
        
    % 3D Points
    pt3d = Fitted_Face(:, keypoints);
    
    % Apply Projection on 3D
    projections_2d_data = perspectiveProjection(pt3d);
    
    % Save into mat file
    sample_path = [projected_dataset_path, dataset_sub_directories(working_sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '');
    save(sample_path,"projections_2d_data")
     
    
end

return;

%% Plot  

clc;

visualizeData(2);


%% Nearest Neighbours

source_img = getSampleImage3D(3);

source_img_pt2d = [source_img(1, :); source_img(2, :) ];

lastKMinDistances = getNearestNeighbours(100, source_img_pt2d);

disp('lastKMinDistances');

disp(lastKMinDistances);

 


%% Test

lastKMinDistances(1,:);
lastKMinDistances(1,2); 
load(lastKMinDistances{2,2}{1})
figure;
draw2DFace(projections_2d_data{1}, "projections 2d data");


