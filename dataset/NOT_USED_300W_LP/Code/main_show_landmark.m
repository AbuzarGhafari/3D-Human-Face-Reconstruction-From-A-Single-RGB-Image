%% Load Model
data_path = '../';
landmark_path = '../landmarks/';

%% Load Sample
sample_name = 'AFW/AFW_134212_1_5.mat';
img = imread([data_path sample_name(1:end-4) '.jpg']);
load([data_path sample_name]);
load([landmark_path sample_name(1:end-4) '_pts.mat']);
[height, width, nChannels] = size(img);

imshow(img);
hold on;
%plot(pts_2d(:,1),pts_2d(:,2),'b.');
plot(pts_3d(:,1),pts_3d(:,2),'r.');
hold off;

