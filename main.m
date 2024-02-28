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
        x_angles ...
        y_angles ...
        directions ...
        face_midpoint_index;

dataset_path = '3d_dataset/';

projected_dataset_path = 'projected_2d_dataset/';

% %                         337,    2330,   135,    1035
dataset_sub_directories = ["AFW", "HELEN", "IBUG", "LFPW"];

working_sub_dir = 1;

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

applyProjectionOn3DLandmarks(2);

return;

%% 4. Save Projections Images (.png)

clc; close all;

generateProjectionsImages(1);

return;

%% 5. Create KDTree Matrix of 2D Projections

clc; close all; 

kd_tree_data = getProjectionsMatrixForKDTree();

save("kd_tree_data","kd_tree_data");

return;

%% 6. Load KDTree Matrix

load("kd_tree_data.mat");

%% 7. Normalize 2D Dataset

clc; close all;

normalized2DDataset(4);

return;

%% 8. KDTree Nearest Neighbours

clc; close all;

KDTreeNearestNeighbours(1);

return;

%% Plot  

clc; close all;

visualizeData(1, 16);

return;
