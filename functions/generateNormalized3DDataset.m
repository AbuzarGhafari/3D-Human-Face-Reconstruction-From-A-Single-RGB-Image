function  generateNormalized3DDataset(sub_dir)

    global dataset_path ...
        dataset_sub_directories;        

    path = join([dataset_path, dataset_sub_directories(sub_dir), "/"], '');
    
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)
            
        sample_name = cell2mat(fileNames(fileIndex));

        pt3d = get3DLandmarks(sub_dir, fileIndex); 

        pt3d = normalizeTranslate3D(pt3d);

        pt3d = normalizeOrientation3D(pt3d);

        pt3d = zeroOneNormalize3D(pt3d);  

        path = join(['3d_normalized_dataset/' dataset_sub_directories(sub_dir) '/' sample_name], '');

        save(path,"pt3d"); 

        disp(fileIndex);             

    end
    
    disp("Completed");
    
end

