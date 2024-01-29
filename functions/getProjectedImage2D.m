function [pt2d_projections] = getProjectedImage2D(sample)
    
    global projected_dataset_path ... 
            dataset_sub_directories ...
            working_sub_dir;
        
    % Load 2D Projected Dataset
    path = join([projected_dataset_path, dataset_sub_directories(working_sub_dir), "/"], '');

    fileNames = getDatasetFiles(path);    
    
    % Sample Image
    sample_name = cell2mat(fileNames(sample));    
    sample_path = [projected_dataset_path, dataset_sub_directories(working_sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '')
    load(sample_path);
    
    pt2d_projections = projections_2d_data;
end

