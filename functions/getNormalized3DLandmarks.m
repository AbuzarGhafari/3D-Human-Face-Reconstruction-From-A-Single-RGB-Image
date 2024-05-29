function [npt3d] = getNormalized3DLandmarks(sub_dir, index)
 
    global dataset_sub_directories;
        
    parent_dir = "dataset/3d_dataset_normalized/";
    
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);
        
    sample_name = cell2mat(fileNames(index));    
    sample_path = [parent_dir, dataset_sub_directories(sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '');
    load(sample_path);
    
    disp(sample_path);

    npt3d = pt3d;
    
end

