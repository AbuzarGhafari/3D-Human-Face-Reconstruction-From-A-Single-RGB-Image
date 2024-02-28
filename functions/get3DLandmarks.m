function [faceVertices] = get3DLandmarks(sub_dir, index)
 
    global dataset_path ...
        projected_dataset_path ...
        dataset_sub_directories;
        
    % Load Model
    load('model/Model_Shape_Sim.mat');
    
    % Load Dataset
    path = join([dataset_path, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);
    
    % Sample Image
    sample_name = cell2mat(fileNames(index));    
    sample_path = [dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '');
    load(sample_path);
    
    disp(sample_path);

    % 3D Points
    pt3d = Fitted_Face(:, keypoints);
        
    faceVertices = pt3d ;
    
end

