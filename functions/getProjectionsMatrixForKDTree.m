function [kdtree, pathMatrix] = getProjectionsMatrixForKDTree()

    global dataset_sub_directories ...
        angles ...
        x_angles ...
        y_angles ...
        directions ;
  
    kdtree = [];
    
    pathMatrix = [];
    
    count = 0;
    
    for sub_dir = 1:numel(dataset_sub_directories)
    
        path = join(["dataset/projected_2d_dataset/", dataset_sub_directories(sub_dir), "/"], '');

        fileNames = getDatasetFiles(path); 
        
        for file = 1:numel(fileNames)                        
    
            sample_name = cell2mat(fileNames(file));    
            
            projection_2d_sample_path = join(["dataset/projected_2d_dataset/", dataset_sub_directories(sub_dir), "/", sample_name], '');         

            pt3d_sample_path = join(["dataset/3d_dataset_normalized/", dataset_sub_directories(sub_dir), "/", sample_name], '');         
            
            load(projection_2d_sample_path);

            disp(projection_2d_sample_path);

            % Flatten the 2D cell array to 1D
            C_flat = projections_2d_data(:);
            C_flat_filtered = C_flat(~cellfun(@isempty, C_flat));

            proj_matrix = [];
            
%             numel(C_flat_filtered)            
            for p = 1:numel(x_angles)
                D = C_flat_filtered{p}';
                proj_matrix = [proj_matrix; D(:)'];                                
                pathMatrix = [pathMatrix; pt3d_sample_path, directions(1), x_angles(p)];
            end
            
            for p = numel(x_angles)+1:numel(x_angles)+numel(y_angles)
                D = C_flat_filtered{p}';
                proj_matrix = [proj_matrix; D(:)'];                                
                pathMatrix = [pathMatrix; pt3d_sample_path, directions(2), y_angles(p-numel(x_angles))];
            end
            
            kdtree = [kdtree; proj_matrix];
            
            count = count + 1;

            disp(count);
             
        end
          
    end     
    
    disp("Completed");
    
end

