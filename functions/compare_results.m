function compare_results()

fileNames = getDatasetFiles("results/optimization-3/AFLW/"); 

part1 = [];
part2 = [];
results = [];


for fileIndex = 1:numel(fileNames)
    
    load(join(["results/optimization-3/AFLW/" fileNames{fileIndex}], ''));       
    
    fprintf("%d: %s\n", fileIndex, join(["results/optimization-3/AFLW/" fileNames{fileIndex}], ''));
    
    if fileIndex <= 1000
        part1 = [part1; result];    
    else
        part2 = [part2; result];    
    end        
    
end

results = [part1; part2];

save("results/optimization-3/results.mat", 'results');

clc; close all; clear; clearvars;

load("results/optimization-3/results.mat");


file_name = "image00642";
matched_result = results(strcmp({results.file}, [file_name '.mat']));

figure();
img = imread(join(["dataset/AFLW2000/3d_dataset_gt/" file_name '.jpg'], '')); 

x2d = matched_result.gt_3d(1, :); % X coordinates
y2d = matched_result.gt_3d(2, :); % Y coordinates

minX = min(x2d(:));
maxX = max(x2d(:));
minY = min(y2d(:));
maxY = max(y2d(:));

width = maxX - minX;  % Width covered by the landmarks
height = maxY - minY;  % Height covered by the landmarks

resized_img = imresize(img, [height width]);  % Resize image to match landmark size
imshow(resized_img);
hold on; 

% Plot a rectangle around the expected landmark area
rectangle('Position', [minX, minY, ...
           maxX-minX, maxY-minY], ...
          'EdgeColor', 'b', 'LineWidth', 2);
      
plot(x2d, y2d, 'o', 'MarkerSize', 1, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', [1, 0, 0]);
hold on;
axis([minX maxX minY maxY]);
axis tight;
axis equal;
hold off;



end

