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

working_sub_dir = 2;

landmarks_count = 68;

startAngle = 0;
endAngle = 360; 
interval = 15;

angles = linspace(startAngle, endAngle, (endAngle - startAngle) / interval + 1);

angles = angles(1:end-1);

directions = ['x', 'y', 'z'];

face_midpoint_index = 31;


return;

%%

applyProjectionOn3DLandmarks();

return;

%% Plot  

clc; close all;

visualizeData(2);


%% Nearest Neighbours

clc; close all; 

image_path = '2d_dataset/HELEN/302142585_1.jpg';

load('2d_dataset\HELEN\302142585_1.mat')

img = imread(image_path); 

imshow(img);

draw2DFace(pt2d, 'pt2d', 'blue');

% Translation Normalization
pt2d = normalizeTranslate2D(pt2d);

% 0 1 Normalize Data
pt2d = zeroOneNormalize2D(pt2d); 

% Translation Normalization
pt2d = normalizeTranslate2D(pt2d);

k = 20;

lastKNearestNeighbours = getNearestNeighbours(k, pt2d);

disp('lastKNearestNeighbours');

disp(lastKNearestNeighbours);

% Plot Nearest Neighbours
% figure;
draw2DFace(pt2d, "Query", 'black');


% Load Model
load('model/Model_Shape_Sim.mat');

figure('Name', "Nearest Neighbours"); 

for n=1:k    
    
    subplot(4, 5, n);
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "", 'black');

    
%     draw2DFace(projections_2d_data{1}, "");

    % 3D Points
%     pt3d = Fitted_Face(:, keypoints);
%     
%     draw3DFace(pt3d, "");
    
end


figure('Name', "Nearest Neighbours"); 

for n=1:3    
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "", 'black');

    % 3D Points
%     pt3d = Fitted_Face(:, keypoints);
%     
%     draw3DFace(pt3d, "");
    
end
    % Test Image
    draw2DFace(pt2d, "", 'red');
 

figure('Name', "Nearest Neighbours"); 

for n=1:k    
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "", 'black');    

    % 3D Points
%     pt3d = Fitted_Face(:, keypoints);
%     
%     draw3DFace(pt3d, "");
    
end
    % Test Image
    draw2DFace(pt2d, "", 'red');
    
return;

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




%% Clear
clc, clearvars, close all;

%%
    
% Load Model
load('model/Model_Shape_Sim.mat');

image_path = '2d_dataset/AFW/134212_1.jpg';

load('2d_dataset\AFW\134212_1.mat')

load('3d_dataset\AFW\134212_1.mat')

img = imread(image_path); 

imshow(img);
draw2DFace(pt2d, 'sample');

figure;
% 3D Points
pt3d = Fitted_Face(:, keypoints);

draw3DFace(pt3d, 'sample');

%% 

image_path = '2d_dataset/AFW/134212_1.jpg';

load('2d_dataset\AFW\134212_1.mat')