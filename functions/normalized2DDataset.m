function  normalized2DDataset(sub_dir)

    global dataset_sub_directories;   
    
    dataset_path = "2d_dataset/";

    path = join([dataset_path, dataset_sub_directories(sub_dir), "/"], '');
    
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)
            
        file_name = cell2mat(fileNames(fileIndex));    
        
        path = join([dataset_path, dataset_sub_directories(sub_dir) , '/', file_name], '');

        load(path);
                
        % Reflection matrix for reflecting around the x-axis
        Rx = [1, 0; 0, -1];

        % Perform the reflection
        pt2d = Rx * pt2d;
        
        % Translation Normalization
        pt2d = normalizeTranslate2D(pt2d);

        % 0 1 Normalize Data
        pt2d = zeroOneNormalize2D(pt2d);                         

        save(path,"pt2d"); 
        
        disp(path);

        disp(fileIndex);              

    end
    
    disp("Completed");
    
end

