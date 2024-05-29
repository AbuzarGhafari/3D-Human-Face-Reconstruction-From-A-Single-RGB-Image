function qualitative_evaluation()

clc; close all; clear;

fileNames = getDatasetFiles("results/optimization-2/AFLW/"); 

results = [];

for fileIndex = 1:numel(fileNames)
    load(join(["results/optimization-2/AFLW/" fileNames{fileIndex}], ''));       
    
    fprintf("%d: %s\n", fileIndex, join(["results/optimization-2/AFLW/" fileNames{fileIndex}], ''));
    
    results = [results; result];    
end




% Extract `op_error` values from the structure array
op_errors = [results.op_error];

% Get sorted indices based on `op_error`
[~, sorted_indices] = sort(op_errors);

% Sort the structure array `all_errors` using the sorted indices
sorted_results = results(sorted_indices);

% Extract only the first 1980 elements (or all if less than 1980)
sorted_all_errors = sorted_results(1:min(1980, length(sorted_results)));

sample_results = sorted_all_errors(1:120);
sample_results_2 = sorted_all_errors(1500:1620);


% Define the angle in degrees
angleDegreesLeft = 30;
angleDegreesRight = -30;

% Convert degrees to radians
angleRadiansLeft = deg2rad(angleDegreesLeft);
angleRadiansRight = deg2rad(angleDegreesRight);

% Rotation matrices for 30 degrees left and right around the y-axis
R_y_left = [cos(angleRadiansLeft) 0 sin(angleRadiansLeft);
            0 1 0;
            -sin(angleRadiansLeft) 0 cos(angleRadiansLeft)];

R_y_right = [cos(angleRadiansRight) 0 sin(angleRadiansRight);
             0 1 0;
             -sin(angleRadiansRight) 0 cos(angleRadiansRight)];


         
         
sample_index = 40;
% Draw 3D Faces:
fig = figure('Visible', 'off');
figWidth = 800;
figHeight = 300;
set(fig, 'Position', [0, 0, figWidth, figHeight]);

subplot(1, 3, 1);
draw3DFaceColor(sample_results(sample_index ).gt_3d, 'black');hold on;
draw3DFaceColor(sample_results(sample_index ).optimized_3d, 'red');drawnow();hold off;

subplot(1, 3, 2);
draw3DFaceColor(R_y_left *sample_results(sample_index ).gt_3d, 'black');hold on;
draw3DFaceColor(R_y_left *sample_results(sample_index ).optimized_3d, 'red');drawnow();hold off;

subplot(1, 3, 3);
draw3DFaceColor(R_y_right *sample_results(sample_index ).gt_3d, 'black');hold on;
draw3DFaceColor(R_y_right *sample_results(sample_index ).optimized_3d, 'red');drawnow();hold off;

exportgraphics(fig, "results/optimization-2/estimated_2.jpg", 'Resolution', 300);  

         
         
fig = figure('Visible', 'off');
figWidth = 900;
figHeight = 800;
set(fig, 'Position', [0, 0, figWidth, figHeight]);

sub_i = 1;
totalCols = 6;
totalRows = 6;
  
for i = 1:totalRows

    file = sample_results(i).file;
    [filepath, name, ext] = fileparts(file);
    img = imread(fullfile('dataset', 'AFLW2000', '3d_dataset_gt', [name, '.jpg'])); 

    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;    
    imshow(img);    
    if i == 1
        title("Input Image");
    end
    
    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;
    draw3DFaceOnly(sample_results(i).gt_3d, 'black');
    if i == 1
        title("3D Ground Truth");
    end
    
    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;
    draw3DFaceOnly(sample_results(i).optimized_3d, 'red');
    if i == 1
        title("Estimated 3D");
    end
        
    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;
    draw3DFaceOnly(sample_results(i).optimized_3d, 'red');
    hold on;
    draw3DFaceOnly(sample_results(i).gt_3d, 'black');
    hold off;
    if i == 1
        title("Estimated vs. GT 3D");
    end
    
    % Get current axes limits
    x_limits = xlim;
    y_limits = ylim;

    % Position for the text: bottom right corner of the subplot
    x_pos = x_limits(2); % x maximum
    y_pos = y_limits(1); % y minimum
    y_pos = y_pos - 30;

    % Add text at the determined position
    text(x_pos, y_pos, ['NME: ' num2str(sample_results(i).op_error * 100, '%.2f') '%'], ...
         'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
         'FontSize', 11, 'Color', 'black');

    
    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;
    draw3DFaceOnly(R_y_left * sample_results(i).optimized_3d, 'red');
    if i == 1
        title(["Left Rotated", "Estimated 3D "]);
    end
    
    subplot(totalRows, totalCols, sub_i);
    sub_i = sub_i + 1;
    draw3DFaceOnly(R_y_right * sample_results(i).optimized_3d, 'red');
    if i == 1
        title(["Right Rotated","Estimated 3D"]);
    end
    
    
end


exportgraphics(fig, "results/optimization-2/qualitative_evaluation_1.jpg", 'Resolution', 300);  

%   
% for i = 1:2 
% 
%     file = sample_results_2(i).file;
%     [filepath, name, ext] = fileparts(file);
%     img = imread(fullfile('dataset', 'AFLW2000', '3d_dataset_gt', [name, '.jpg'])); 
% 
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;    
%     imshow(img); 
%     
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;
%     draw3DFaceOnly(sample_results_2(i).gt_3d, 'black');
%     
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;
%     draw3DFaceOnly(sample_results_2(i).optimized_3d, 'red');
%         
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;
%     draw3DFaceOnly(sample_results_2(i).optimized_3d, 'red');
%     hold on;
%     draw3DFaceOnly(sample_results_2(i).gt_3d, 'black');
%     hold off;
%     
%     % Get current axes limits
%     x_limits = xlim;
%     y_limits = ylim;
% 
%     % Position for the text: bottom right corner of the subplot
%     x_pos = x_limits(2); % x maximum
%     y_pos = y_limits(1); % y minimum
%     y_pos = y_pos - 30;
% 
%     % Add text at the determined position
%     text(x_pos, y_pos, ['NME: ' num2str(sample_results_2(i).op_error * 100, '%.2f') '%'], ...
%          'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
%          'FontSize', 11, 'Color', 'black');
% 
%     
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;
%     draw3DFaceOnly(R_y_left * sample_results_2(i).optimized_3d, 'red');
%     
%     subplot(totalRows, totalCols, sub_i);
%     sub_i = sub_i + 1;
%     draw3DFaceOnly(R_y_right * sample_results_2(i).optimized_3d, 'red');
%     
%     
% end
















end