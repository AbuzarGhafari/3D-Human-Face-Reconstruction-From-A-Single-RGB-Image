function [fileNames]  = ReadAFLW_CSV_MAT()

    clc; close all;
    
    % Use the dir function to list files in the directory
    fileList = dir("dataset/AFLW2000/2d_dataset_CSV_gt/");
    
    % Extract the file names from the structure
    fileNames = {fileList.name};
    mask = endsWith(fileNames, '.csv');
    fileNames = fileNames(mask);        
    
    for fileIndex = 1:numel(fileNames) 

        path = join(['dataset/AFLW2000/2d_dataset_CSV_gt/' fileNames{fileIndex} ], '');                
        M = readmatrix(path);        
        M = M';         
        [filepath, name, ext] = fileparts(path);        
        path = join(['dataset/AFLW2000/2D_dataset_gt/' name '.mat' ], '');
        save(path,"M"); 
 
        disp(path);            
        
    end
    
    disp("Completed");        


end

