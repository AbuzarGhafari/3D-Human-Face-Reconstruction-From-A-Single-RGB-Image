function visualizeData(keypoints, dataset_path, projected_dataset_path,dataset_sub_directories, working_sub_dir, directions, angles, sample)
    % Load 3D Dataset
    path = join([dataset_path, dataset_sub_directories(working_sub_dir), "/"], '');

    fileNames = getDatasetFiles(path);
    
    
    % Sample Image
    sample_name = cell2mat(fileNames(sample));    
    sample_path = [dataset_path, dataset_sub_directories(working_sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '')
    load(sample_path);

    % 3D Points
    pt3d = Fitted_Face(:, keypoints);
    draw3DFace(pt3d, sample_path)

    % Load 2D Projected Dataset
    path = join([projected_dataset_path, dataset_sub_directories(working_sub_dir), "/"], '');

    fileNames = getDatasetFiles(path);
    
    
    % Sample Image
    sample_name = cell2mat(fileNames(sample));    
    sample_path = [projected_dataset_path, dataset_sub_directories(working_sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '')
    load(sample_path);

    for direction = 1:numel(directions)
        figure('Name', sample_path); 
        data2d = projections_2d_data(:, direction);
        for p = 1:numel(data2d)
            subplot(3, 4, p);
            draw2DFace(data2d{p}, [num2str(angles(p)), ' angle']);
        end 
        sgtitle([directions(direction), ' Direction']);
    end
    
end

