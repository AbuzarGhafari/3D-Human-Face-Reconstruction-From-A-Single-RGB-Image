function applyProjectionOn3DLandmarks(sub_dir)

    global dataset_sub_directories;

    % Load Dataset
    path = join(["dataset/3d_dataset_normalized/", dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    % List all the files
    for fileIndex = 1:numel(fileNames)

        pt3d = getNormalized3DLandmarks(sub_dir, fileIndex);

        % Apply Projection on 3D
        projections_2d_data = perspectiveProjection(pt3d);

        % Save into mat file
        sample_name = cell2mat(fileNames(fileIndex));  
        sample_path = ["dataset/projected_2d_dataset/", dataset_sub_directories(sub_dir), "/", sample_name];  
        sample_path = join(sample_path, '');
        save(sample_path,"projections_2d_data");
        
        disp(fileIndex);               

    end
    
    disp("Completed");

end

