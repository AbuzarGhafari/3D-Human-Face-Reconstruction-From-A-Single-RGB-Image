%% Clear
clc, clearvars, close all;

%% Functions Path

addpath('functions');

rehash;

%% Global Variables

dataset_size = 3837;

global dataset_sub_directories ...
        landmarks_count ...
        angles ...
        x_angles ...
        y_angles ...
        directions ...
        face_midpoint_index;

% %                         337,    2330,   135,    1035
dataset_sub_directories = ["AFW", "HELEN", "IBUG", "LFPW"];

landmarks_count = 68;

angle = 5;

angles = -180:angle:180-angle;

x_angles = -45:angle:45;

y_angles = -90:angle:90;
 
directions = ['x', 'y']; 

face_midpoint_index = 31;

return;


%% 1. Save 3D Normalized Dataset (.mat)

clc; close all;

generateNormalized3DDataset(4);

return;

%% 2. Save 3D Normalized Images (.png)

clc; close all;

generateNormalized3DImages(1);

return;

%% 3. Apply projections on 3D Normalized Dataset

clc; close all;

applyProjectionOn3DLandmarks(4);

return;

%% 4. Save Projections Images (.png)

clc; close all;

generateProjectionsImages(1);

return;

%% 5. Create KDTree Matrix of 2D Projections

clc; close all; 

[kdtree, pathMatrix] = getProjectionsMatrixForKDTree();

save("mat_files/kd_tree_data","kdtree");

save("mat_files/pathMatrix","pathMatrix");

return;

%% 6. Load KDTree Matrix

load("mat_files/kd_tree_data.mat");
load("mat_files/pathMatrix.mat");

%% 7. Normalize 2D Dataset

clc; close all;

% normalized2DDataset(4);

return;

%% 7.1
% READ AFLW2000 CSV files to MAT files

fileNames = ReadAFLW_CSV_MAT();


%% 7.2
% Normalize the AFLW2000 2D Dataset

normalizedAFLW2DDataset();


%% 8. KDTree Nearest Neighbours

clc; close all;

k = 256;

p = 8;

KDTreeNearestNeighbours(k, p);

return;

%% 8.1

clc; close all;

for i=1:10

    file_index = i;

    compareNearestNeighbours(file_index);
    
end

%% 9.0
% Prepare dataset before optimization, get 2D, 3D Dataset, get nearest neighbours, find error

clc; close all;

preOptimizationDataset("image02695.mat");

return;

fileNames = getDatasetFiles("dataset/AFLW2000/2D_dataset_gt/"); 
% 10 to 349 left
for fileIndex = 10:349 %numel(fileNames)
    
    fprintf("%d, %s\n", fileIndex, fileNames{fileIndex});

    preOptimizationDataset(fileNames{fileIndex});
end


%% 9.1
% Optimization

clc; close all;

% optimization("image02695.mat");
% 
% return;

fileNames = getDatasetFiles("dataset/AFLW2000/2D_dataset_gt/"); 

for fileIndex = 1:numel(fileNames)
    
    fprintf("%d, %s\n", fileIndex, fileNames{fileIndex});

    optimization(fileNames{fileIndex});
end

return;

%% 10.0
% Normalized Mean Error

clc; close all;

[errors, mean_error, all_errors] = compute_performance();

disp(errors);

disp(mean_error);

%% 11
% Qualitative Evaluation
clc; close all; clear;

qualitative_evaluation();

%%
clc; close all; clear; clearvars;

optimization("image00045.mat");

load('D:\MS(CS)\Thesis\Matlab Project\results\optimization-cm\AFLW\image00045.mat')

result

return;
load('D:\MS(CS)\Thesis\Matlab Project\results\optimization-2\AFLW\image00045.mat')

%%

clc; close all; clear; 

files1 = getDatasetFiles("results/optimization/AFLW/");
files2 = getDatasetFiles("dataset/AFLW2000/3d_dataset_gt");

onlyInFiles2 = setdiff(files2, files1);

%%
fig = figure;
draw3DFace(result.optimized_3d, '');
axis off;
% exportgraphics(fig, "test1.jpg", 'Resolution', 300);        


%% 10.1
% Graph Plotting
clc; close all;

optimized_knn_error_plot();

return;
  
%% Plot  

clc; close all;

visualizeData(1, 16);

return;
    

%%

averageLandmarks = computeAverage_3DFaces(k, Idx);  


% black = GT, red = Avg. NN
compare3DFace(gt_pt3d, averageLandmarks);

%%
draw3DFace(result.optimized_3d, 'black')