function matrix = getProjectionsMatrixForKDTree()

    global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories ...
        angles ...
        directions;
  
    matrix = [];
    
    count = 0;
    
    for sub_dir = 1:numel(dataset_sub_directories)
    
        path = join([projected_dataset_path, dataset_sub_directories(sub_dir), "/"], '');

        fileNames = getDatasetFiles(path); 
        
        for file = 1:numel(fileNames)
    
            sample_name = cell2mat(fileNames(file));    
            projection_2d_sample_path = [projected_dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
            projection_2d_sample_path = join(projection_2d_sample_path, '');         
            load(projection_2d_sample_path);

            disp(projection_2d_sample_path);

            % Flatten the 2D cell array to 1D
            C_flat = projections_2d_data(:);
            C_flat_filtered = C_flat(~cellfun(@isempty, C_flat));             

            for p = 1:numel(C_flat_filtered)

                D = C_flat_filtered{p};

                matrix = [matrix; D(:)'];

            end
            
            count = count + 1;

            disp(count);
             
        end
          
    end     
    
    disp("Completed");
    
end

