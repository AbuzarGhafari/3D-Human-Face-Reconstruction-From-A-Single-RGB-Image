function applyProjectionOn3DLandmarks(sub_dir)

    global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories;

    % Load Dataset
    path = join([dataset_path, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    % List all the files
    for fileIndex = 1:numel(fileNames)

        pt3d = getNormalized3DLandmarks(sub_dir, fileIndex);

        % Apply Projection on 3D
        projections_2d_data = perspectiveProjection(pt3d);

        % Save into mat file
        sample_name = cell2mat(fileNames(fileIndex));  
        sample_path = [projected_dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
        sample_path = join(sample_path, '');
        save(sample_path,"projections_2d_data")
        
        disp(fileIndex);        

    end
    
    disp("Completed");

end

