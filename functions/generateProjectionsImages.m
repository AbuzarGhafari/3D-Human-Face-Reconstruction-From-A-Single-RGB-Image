function generateProjectionsImages(sub_dir)


    global dataset_sub_directories;        

    parent_dir = "dataset/3d_dataset_normalized/";
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)
        
        visualizeData(sub_dir, fileIndex);
        
        disp(fileIndex);    
        
        disp("Done");
        
        return;
        
    end

    disp("Completed");
    
end

