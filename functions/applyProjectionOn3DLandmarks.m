function applyProjectionOn3DLandmarks()

    global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories;
    
    
    % Load Model
    load('model/Model_Shape_Sim.mat');

    for sub_dir = 1:numel(dataset_sub_directories)
        % Load Dataset
        path = join([dataset_path, dataset_sub_directories(sub_dir), "/"], '');
        fileNames = getDatasetFiles(path);

        % List all the files
        for fileIndex = 1:numel(fileNames)

            disp(fileIndex);

            % Sample Image
            sample_name = cell2mat(fileNames(fileIndex));    
            sample_path = [dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
            sample_path = join(sample_path, '')
            load(sample_path);

            % 3D Points
            pt3d = Fitted_Face(:, keypoints);

            % Apply Projection on 3D
            projections_2d_data = perspectiveProjection(pt3d);
             

            % Save into mat file
            sample_path = [projected_dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
            sample_path = join(sample_path, '');
            save(sample_path,"projections_2d_data")

        end

    end


end

