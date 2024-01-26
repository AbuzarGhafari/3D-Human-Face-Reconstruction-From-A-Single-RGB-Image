%% Clear
clc, clearvars, close all;

%% cameraParameters object

% Example intrinsic parameters and distortion coefficients (replace with actual values)
focalLength = [1000, 1000];  % Focal lengths (fx, fy)
principalPoint = [640, 480]; % Principal point (cx, cy)
skew = 0;                    % Skew
imageSize = [1280, 960];     % Image size (width, height)
radialDistortion = [0.1, -0.2, 0.03]; % Radial distortion coefficients
tangentialDistortion = [0.01, -0.02]; % Tangential distortion coefficients

% Create a cameraParameters object
cameraParams = cameraParameters('IntrinsicMatrix', [focalLength(1), skew, principalPoint(1); 0, focalLength(2), principalPoint(2); 0, 0, 1], ...
    'ImageSize', imageSize, 'RadialDistortion', radialDistortion, 'TangentialDistortion', tangentialDistortion);




%% 
R = [1 0 0; 0 0 -1;0 1 0];
t = [10 0 20];
pose = rigid3d(R,t);
cam = plotCamera('AbsolutePose',pose,'Opacity',0)
grid on
axis equal
axis manual

%%
images = imageSet(fullfile(toolboxdir('vision'),'visiondata','calibration','slr'));

[imagePoints,boardSize] = detectCheckerboardPoints(images.ImageLocation);




%%
clc, clearvars, close all;

%%

% Define the directory path you want to list files from
directoryPath = '3d_dataset';

% Use the dir function to list files in the directory
fileList = dir(directoryPath);

%%
% Extract the file names from the structure
fileNames = {fileList.name};
mask = endsWith(fileNames, '.mat');
fileNames = fileNames(mask);

% Display the list of file names
disp('List of File Names:');
disp(fileNames);

%%
res = cell2mat(fileNames(5));
