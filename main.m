%% Clear
clc, clearvars, close all;

%% Functions Path

addpath('functions');

rehash;

return;

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

normalized2DDataset(4);

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

[errors, mean_error, all_errors] = compute_performance("results/optimization-3/AFLW/");

disp(errors);

disp(mean_error);

%% 11
% Qualitative Evaluation
clc; close all; clear;

qualitative_evaluation();


%% Testing on the Training Dataset with 80% Training and 20% Testing
clc; close all; clear;

allDataset = [getDatasetFiles("dataset/300W-3D/2d_dataset_gt/AFW/"),...
                getDatasetFiles("dataset/300W-3D/2d_dataset_gt/HELEN/"),... 
                getDatasetFiles("dataset/300W-3D/2d_dataset_gt/IBUG/"),... 
                getDatasetFiles("dataset/300W-3D/2d_dataset_gt/LFPW/") ];

chunkSize = floor(numel(allDataset) * 0.2);  % 20% of total, rounding down

% Initialize variables to store chunks
dataset_chunk1 = allDataset(1:chunkSize);
dataset_chunk2 = allDataset(chunkSize + 1:2*chunkSize);
dataset_chunk3 = allDataset(2*chunkSize + 1:3*chunkSize);
dataset_chunk4 = allDataset(3*chunkSize + 1:4*chunkSize);
dataset_chunk5 = allDataset(4*chunkSize + 1:end);  % This might be slightly larger than 20% if not evenly divisible

load("mat_files/kd_tree_data.mat");
load("mat_files/pathMatrix.mat");

kdtree_chunk1 = kdtree; 
kdtree_chunk2 = kdtree; 
kdtree_chunk3 = kdtree; 
kdtree_chunk4 = kdtree; 
kdtree_chunk5 = kdtree; 

kdtree_chunk1 = getFilteredKDTreeDataset(pathMatrix, dataset_chunk1, kdtree_chunk1);
kdtree_chunk2 = getFilteredKDTreeDataset(pathMatrix, dataset_chunk2, kdtree_chunk2);
kdtree_chunk3 = getFilteredKDTreeDataset(pathMatrix, dataset_chunk3, kdtree_chunk3);
kdtree_chunk4 = getFilteredKDTreeDataset(pathMatrix, dataset_chunk4, kdtree_chunk4);
kdtree_chunk5 = getFilteredKDTreeDataset(pathMatrix, dataset_chunk5, kdtree_chunk5);

save("mat_files/kdtree_chunk1","kdtree_chunk1");
save("mat_files/kdtree_chunk2","kdtree_chunk2");
save("mat_files/kdtree_chunk3","kdtree_chunk3");
save("mat_files/kdtree_chunk4","kdtree_chunk4");
save("mat_files/kdtree_chunk5","kdtree_chunk5");




% Prepare dataset before optimization, get 2D, 3D Dataset, get nearest neighbours, find error

clc; close all;
% Chunk 1
load("mat_files/kdtree_chunk1");
dataset_size = numel(dataset_chunk1);
for i = 1:dataset_size    
    preOptimization300WDataset(dataset_chunk1{i},... 
        kdtree_chunk1,... 
        "results/pre-optimization/300W-3D/chunk1/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

for i = 1:dataset_size    
    optimization(dataset_chunk1{i},... 
        "results/pre-optimization/300W-3D/chunk1/",... 
        "results/optimization/300W-3D/chunk1/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

% Chunk 2
load("mat_files/kdtree_chunk2");
dataset_size = numel(dataset_chunk2);
for i = 1:dataset_size    
    preOptimization300WDataset(dataset_chunk2{i},... 
        kdtree_chunk2,... 
        "results/pre-optimization/300W-3D/chunk2/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

for i = 1:dataset_size    
    optimization(dataset_chunk2{i},... 
        "results/pre-optimization/300W-3D/chunk2/",... 
        "results/optimization/300W-3D/chunk2/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

% Chunk 3
load("mat_files/kdtree_chunk3");
dataset_size = numel(dataset_chunk3);
for i = 1:dataset_size    
    preOptimization300WDataset(dataset_chunk3{i},... 
        kdtree_chunk3,... 
        "results/pre-optimization/300W-3D/chunk3/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

for i = 1:dataset_size    
    optimization(dataset_chunk3{i},... 
        "results/pre-optimization/300W-3D/chunk3/",... 
        "results/optimization/300W-3D/chunk3/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end


% Chunk 4
load("mat_files/kdtree_chunk4");
dataset_size = numel(dataset_chunk4);
for i = 1:dataset_size    
    preOptimization300WDataset(dataset_chunk4{i},... 
        kdtree_chunk4,... 
        "results/pre-optimization/300W-3D/chunk4/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

for i = 1:dataset_size    
    optimization(dataset_chunk4{i},... 
        "results/pre-optimization/300W-3D/chunk4/",... 
        "results/optimization/300W-3D/chunk4/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end


% Chunk 5
load("mat_files/kdtree_chunk5");
dataset_size = numel(dataset_chunk5);
for i = 1:dataset_size    
    preOptimization300WDataset(dataset_chunk5{i},... 
        kdtree_chunk5,... 
        "results/pre-optimization/300W-3D/chunk5/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end

for i = 1:dataset_size    
    optimization(dataset_chunk5{i},... 
        "results/pre-optimization/300W-3D/chunk5/",... 
        "results/optimization/300W-3D/chunk5/");    
    fprintf("\nProcessed %d/%d.\n", i, dataset_size);    
end


[all_errors1, mean_error1] = compute_performance_chunk("results/optimization/300W-3D/chunk1/");
[all_errors2, mean_error2] = compute_performance_chunk("results/optimization/300W-3D/chunk2/");
[all_errors3, mean_error3] = compute_performance_chunk("results/optimization/300W-3D/chunk3/");
[all_errors4, mean_error4] = compute_performance_chunk("results/optimization/300W-3D/chunk4/");
[all_errors5, mean_error5] = compute_performance_chunk("results/optimization/300W-3D/chunk5/");

fprintf("%f\n%f\n%f\n%f\n%f\n", mean_error1,mean_error2,mean_error3,mean_error4,mean_error5);
errors = [mean_error1 mean_error2 mean_error3 mean_error4 mean_error5];
mean_error = round(sum(errors)/numel(errors), 2);
fprintf("Mean Error: %f\n", mean_error);


%% Find Yaw Class for the Optimization Chunks

clc; close all; clear;

directories = ["results\optimization\300W-3D\chunk1\",...
               "results\optimization\300W-3D\chunk2\",...
               "results\optimization\300W-3D\chunk3\",...
               "results\optimization\300W-3D\chunk4\",...
               "results\optimization\300W-3D\chunk5\"];
for directory=1:numel(directories)
    fprintf("Directory: %s\n", directories(directory));
    files = getDatasetFiles(directories(directory));
    for i=1:numel(files)
        load(join([directories(directory), files(i)], ''));
        [yaw_class, yaw_class_id] = findYawClassId(result.file);
        result.yaw_class = yaw_class;
        result.yaw_class_id = yaw_class_id;
        save(join([directories(directory), files(i)], ''), "result");
        fprintf("Directory: %d, Processed: %d/%d\n", directory, i, numel(files));
    end    
end

for directory=1:numel(directories)
    [errors, mean_error, all_errors] = compute_performance(directories(directory));
    disp(errors);
    disp(mean_error);
end

sum([7.3332 6.5178 5.4653 5.1322 4.0730])/5
sum([6.4972 5.6391 5.0442 5.3370 4.3227])/5
sum([6.9200 6.0800 5.2500 5.2300 4.2000])/5

%%

optimization(dataset_chunk1{2},... 
        "results/pre-optimization/300W-3D/chunk1/",... 
        "results/optimization/300W-3D/chunk1/");

load('D:\MS(CS)\Thesis\Matlab Project\results\optimization\300W-3D\chunk1\1051618982_1.mat')
load('D:\MS(CS)\Thesis\Matlab Project\results\optimization\300W-3D\chunk1\111076519_1.mat')

disp(result);
figure('Name', 'GT vs. Optimized 3D');clf;
draw3DFace(result.gt_3d, '');hold on;
draw3DFace(result.optimized_3d, 'GT vs. Optimized 3D');drawnow();hold on;  
figure('Name', 'GT vs. KNN AVG 3D');clf;
draw3DFace(result.gt_3d, '');hold on;
draw3DFace(result.knn_avg_3d, 'GT vs. KNN AVG 3D');drawnow();hold on;
figure('Name', 'Ground Truth - 2D');
draw2DFace(result.gt_2d, 'Ground Truth - 2D');hold on;



%%
fig = figure;
draw3DFace(result.gt_3d, '');
% axis off;
fig = figure;
draw2DFace(result.gt_2d, '');
% exportgraphics(fig, "test1.jpg", 'Resolution', 300);        


%% 10.1
% Graph Plotting
clc; close all;

optimized_knn_error_plot();

return;
  


%%

averageLandmarks = computeAverage_3DFaces(k, Idx);  


% black = GT, red = Avg. NN
compare3DFace(result.gt_3d, result.optimized_3d);


%%
draw3DFace(result.optimized_3d, 'black')