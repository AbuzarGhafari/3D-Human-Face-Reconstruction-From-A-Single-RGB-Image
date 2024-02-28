function generateProjectionsImages(sub_dir)


    global dataset_path ...
        dataset_sub_directories;        

    parent_dir = "3d_normalized_dataset/";
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)
        
        visualizeData(sub_dir, fileIndex);
        
        disp(fileIndex);
        
    end

    disp("Completed");
    
end

