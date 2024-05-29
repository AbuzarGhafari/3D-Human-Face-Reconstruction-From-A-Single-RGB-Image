function  generateNormalized3DImages(sub_dir)

    global dataset_sub_directories;        

    parent_dir = "dataset/3d_dataset_normalized/";
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)

        sample_name = cell2mat(fileNames(fileIndex));
        
        % original 3D dataset
        pt3d = get3DLandmarks(sub_dir, fileIndex);
        
        % normalized 3D dataset
        npt3d = getNormalized3DLandmarks(sub_dir, fileIndex);
        
        hFig = figure('Visible', 'off');
        figWidth = 1000;
        figHeight = 400;
        set(hFig, 'Position', [100, 100, figWidth, figHeight])

        subplot(1, 2, 1); 
        draw3DFace(pt3d, "3D");
        
        subplot(1, 2, 2);     
        draw3DFace(npt3d, "3D - Normalized");

        path = join(['images/3d_normalized_images/' dataset_sub_directories(sub_dir) '/' sample_name '.png'], '');
        saveas(hFig, path);
        close(hFig);

        disp(fileIndex);        

    end
        
    disp("Completed");
        
end

