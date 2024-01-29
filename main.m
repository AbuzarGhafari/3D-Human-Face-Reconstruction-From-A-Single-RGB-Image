%% Clear
clc, clearvars, close all;

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

working_sub_dir = 2;

landmarks_count = 68;

startAngle = 0;
endAngle = 360; 
interval = 30;

angles = linspace(startAngle, endAngle, (endAngle - startAngle) / interval + 1);

angles = angles(1:end-1);

directions = ['x', 'y', 'z'];

face_midpoint_index = 31;


%%

applyProjectionOn3DLandmarks();

return;

%% Plot  

clc; close all;

visualizeData(2);


%% Nearest Neighbours

clc; close all;

source_img = getSampleImage3D(2145);

% 0 1 Normalize Data
source_img = zeroOneNormalize3D(source_img);

source_img_pt2d = [source_img(1, :); source_img(2, :) ];

k = 20;

lastKNearestNeighbours = getNearestNeighbours(k, source_img_pt2d);

disp('lastKNearestNeighbours');

disp(lastKNearestNeighbours);

 
% Plot Nearest Neighbours
% figure;
draw3DFace(source_img, "Query");

figure('Name', "Nearest Neighbours"); 

for n=1:k    
    
    subplot(4, 5, n);
    
    load(lastKNearestNeighbours{n,2}{1})
    
    draw2DFace(projections_2d_data{1}, "");
    
end


figure('Name', "Nearest Neighbours"); 

for n=1:k    
    
    load(lastKNearestNeighbours{n,2}{1})
    
    draw2DFace(projections_2d_data{1}, "");
    
end

    
    


%% Test

lastKMinDistances(1,:);
lastKMinDistances(1,2); 
load(lastKMinDistances{2,2}{1})
figure;
draw2DFace(projections_2d_data{1}, "projections 2d data");

%% 01 Normalization


data = getSampleImage3D(2);

draw3DFace(data, "Data");

dataNorm = zeroOneNormalize3D(data);
disp(dataNorm);

draw3DFace(dataNorm , "Query");


%%
clc; close all; clearvars;
% Create a sample dataset (replace with your own data)
data = randn(100, 3); % 100 data points in 3D space
 


% Create a KDTreeSearcher object
kdtree = KDTreeSearcher(data);