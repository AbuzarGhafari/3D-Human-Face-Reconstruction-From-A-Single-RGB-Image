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

% projected_dataset_path = 'projected_2d_dataset/';

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

applyProjectionOn3DLandmarks(4);

return;

%% 4. Save Projections Images (.png)

clc; close all;

generateProjectionsImages(1);

return;

%% 5. Create KDTree Matrix of 2D Projections

clc; close all; 

[kdtree, pathMatrix] = getProjectionsMatrixForKDTree();

save("kd_tree_data","kdtree");
save("pathMatrix","pathMatrix");

return;

%% 6. Load KDTree Matrix

load("kd_tree_data.mat");

%% 7. Normalize 2D Dataset

clc; close all;

normalized2DDataset(4);

return;

%% 8. KDTree Nearest Neighbours

clc; close all;

k = 256;

p = 8;

KDTreeNearestNeighbours(1, k, p);

return;

%% 8.1

clc; close all;

sub_dir = 4;

no_of_figs = 12;

no_of_examples = 4;

compareNearestNeighbours(sub_dir, no_of_figs, no_of_examples);


 

%% Plot  

clc; close all;

visualizeData(1, 16);

return;

%%


clc; close all;
fig = figure('Name', 'Errors'); 
figWidth = 1600;
figHeight = 1050;
set(fig, 'Position', [50, 50, figWidth, figHeight]);

for i=2:numel(overall_errors(1,:))

    ER = overall_errors(:, i);
    
    subplot(3,3,i-1);
    
    plot(ER,'o', ...
        'LineWidth',1,...
        'MarkerSize',5,...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor',[0.85,0.85,0.75]);

    hold on;
    
    [r c] = size(ER);
    x = ceil(r/2);

    plot(x, mean(ER),'s', ...
        'LineWidth',2,...
        'MarkerSize',8,...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor',[0.85,0.5,0.75]);
    
    xlabel(join(['k = ', num2str(2^i), ' NN'], ''));
    ylabel("Error")
    
    avg_error = join(["Avg. Error ", num2str(mean(ER))], '');
    x = ceil(r/3);
    text(x, max(ER), avg_error,'Color','red','FontSize',12);
end

sub_dir = 3;
sample_path = join(["3D_AVG_GT_Compare/", dataset_sub_directories(sub_dir), "/", "errors", ".png"], '');
exportgraphics(fig, sample_path, 'Resolution', 300);


%%
clc; close all;
x = 1:337; % Example independent variable, such as time or another ordered variable
y = ER;

scatter(x, y);
hold on;
scatter(x(168), mean(y));
xlabel('X-axis label'); % Customize with your label
ylabel('Y-axis label'); % Customize with your label
title('Scatter Chart Title'); % Customize with your title

