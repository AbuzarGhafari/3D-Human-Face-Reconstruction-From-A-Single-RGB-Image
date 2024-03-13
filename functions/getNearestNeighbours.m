function [Idx, D, gt_path] = getNearestNeighbours(sub_dir, index, k)

    global dataset_sub_directories;   

    load("kd_tree_data.mat");

    parent_dir = "2d_dataset/";
    
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], ''); 
    
    fileNames = getDatasetFiles(path); 

    file = cell2mat(fileNames(index));   

    [pathstr, file_name, ext] = fileparts(file);
  
    load(join([parent_dir, dataset_sub_directories(sub_dir) , '/', file_name, '.mat'], '')); 
    gt_path = join(["3d_dataset/", dataset_sub_directories(sub_dir) , '/', file_name, '.mat'], ''); 

    Mdl = KDTreeSearcher(kdtree);

    Y = pt2d(:)';
    
    [Idx, D] = knnsearch(Mdl, Y, 'K', k);
 
    
end

