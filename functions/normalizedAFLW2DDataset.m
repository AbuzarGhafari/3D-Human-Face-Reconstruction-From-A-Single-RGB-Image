function  normalizedAFLW2DDataset()
   
    clc; close all;
    
    fileNames = getDatasetFiles("dataset/AFLW2000/2D_dataset_gt/");

    for fileIndex = 1:numel(fileNames)
            
        path = join(["dataset/AFLW2000/2D_dataset_gt/", fileNames{fileIndex}], '');

        load(path);
                
        % Reflection matrix for reflecting around the x-axis
        Rx = [1, 0; 0, -1];

        % Perform the reflection
        M = Rx * M;
        
        % Translation Normalization
        M = normalizeTranslate2D(M);

        % 0 1 Normalize Data
        M = zeroOneNormalize2D(M);                         

        path = join(["dataset/AFLW2000/2D_dataset_normalized/", fileNames{fileIndex}], '');
        save(path,"M"); 
        
        disp(path);    
        
    end
    
    disp("Completed");
    
end

