
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
% pt2d = normalizeTranslate2D(pt2d);

k = 20;

lastKNearestNeighbours = getNearestNeighbours(k, pt2d);

disp('lastKNearestNeighbours');

disp(lastKNearestNeighbours);

% Plot Nearest Neighbours
% figure;
draw2DFace(pt2d, "Query", 'black');

% Load Model
load('model/Model_Shape_Sim.mat');

figure('Name', "Nearest Neighbours Euclidean Distance"); 

for n=1:k    
    
    subplot(4, 5, n);
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "", 'black');   
    
end


figure('Name', "Nearest Neighbours Euclidean Distance"); 

for n=1:3    
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "Nearest Neighbours Euclidean Distance", 'black');

end
    % Test Image
    draw2DFace(pt2d, "", 'red');
 

figure('Name', "Nearest Neighbours Euclidean Distance"); 

for n=1:k    
    
    load(lastKNearestNeighbours{n,2}{1})
    
    dir_index = find(directions == lastKNearestNeighbours{n,3}{1});
    
    angle_index = find(angles == lastKNearestNeighbours{n,4}{1});
    
    draw2DFace(projections_2d_data{angle_index, dir_index}, "", 'black');    
    
end
    % Test Image
    draw2DFace(pt2d, "", 'red');
    
return; 



%% Generate KD Tree Data
clc; close all; clearvars;

kd_tree_data = getProjectionsMatrixForKDTree();

save("kd_tree_data","kd_tree_data");

return;

%% KDTree Nearest Neighbours

% clc; close all; clearvars;
clc; close all; 

sub_dir = 'HELEN';

file_name = '100040721_2';

image_path = ['2d_dataset/', sub_dir , '/', file_name, '.jpg'];

load(['2d_dataset/', sub_dir , '/', file_name, '.mat']);

img = imread(image_path); 

figure('Name', image_path);
 
imshow(img);

figure('Name', image_path);
subplot(1, 3, 1);
draw2DFace(pt2d, 'pt2d', 'blue'); 
 

% Translation Normalization
pt2d = normalizeTranslate2D(pt2d);

% 0 1 Normalize Data
pt2d = zeroOneNormalize2D(pt2d); 

% % Translation Normalization
% pt2d = normalizeTranslate2D(pt2d);
 
load("kd_tree_data.mat");

Mdl = KDTreeSearcher(kd_tree_data);

Y = pt2d(:)';
[Idx, D] = knnsearch(Mdl, Y, 'K', 20);


% figure('Name', "KDTree Nearest 3 Neighbours"); 
subplot(1, 3, 2);
for i = 1:3
    
    v = kd_tree_data(Idx(i), :);
    
    nearest_pt = reshape(v, 2, 68);
    
    draw2DFace(nearest_pt, "KDTree Nearest 3 Neighbours", 'black');
end

draw2DFace(pt2d, "", 'red');


% figure('Name', "KDTree Nearest 20 Neighbours"); 
subplot(1, 3, 3);
for i = 1:numel(Idx)
    
    v = kd_tree_data(Idx(i), :);
    
    nearest_pt = reshape(v, 2, 68);
    
    draw2DFace(nearest_pt, "KDTree Nearest 20 Neighbours", 'black');
end

draw2DFace(pt2d, "", 'red');



%% Clear
clc, clearvars, close all;

load("kd_tree_data.mat");
