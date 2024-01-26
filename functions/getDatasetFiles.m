function [fileNames] = getDatasetFiles(datasetPath)

disp(datasetPath)
% Use the dir function to list files in the directory
fileList = dir(datasetPath);

% Extract the file names from the structure
fileNames = {fileList.name};
mask = endsWith(fileNames, '.mat');
fileNames = fileNames(mask);

end

