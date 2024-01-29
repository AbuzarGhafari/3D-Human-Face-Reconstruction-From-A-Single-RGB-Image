function [pt3d] = getSampleImage3D(sample)
    global dataset_path ... 
            dataset_sub_directories ...
            working_sub_dir;

    % Load Model
    load('model/Model_Shape_Sim.mat');

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
end

