function KDTreeNearestNeighbours(k, p)

    load("mat_files/kd_tree_data.mat");

%     parent_dir = "dataset/AFLW2000/2D_dataset_gt/";
%     path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles("dataset/AFLW2000/2D_dataset_gt/");
    
    summary = [];    
    summary_path = "images/2d_nearest_neighbours_images/summary.csv";
    summary_file = fopen(summary_path, 'w');     
    fclose(summary_file);    

    for fileIndex = 1:numel(fileNames)
        
        file = cell2mat(fileNames(fileIndex));   
        
        [pathstr, file_name, ext] = fileparts(file);
        
        load(join(["dataset/AFLW2000/2D_dataset_normalized/", file_name, '.mat'], ''));
        
        image_path = join(["dataset/AFLW2000/3d_dataset_gt/",file_name, '.jpg'], '');
        img = imread(image_path); 

        fig = figure('Name', image_path, 'Visible', 'off');
        figWidth = 800;
        figHeight = 500;
        set(fig, 'Position', [100, 100, figWidth, figHeight]);

        subplot(2, 2, 1);
        imshow(img);
%         ax1 = gca;
%         set(ax1, 'Position', [0.05, 0.65, 0.3, 0.3]);
        title("Test Image");

        pt2d = M;
        subplot(2, 2, 3);
        draw2DFace(pt2d, '2D Face'); 
        ax2 = gca;
        set(ax2, 'Position', [0.1, 0.05, 0.3, 0.45]);

        Mdl = KDTreeSearcher(kdtree);

        Y = pt2d(:)';
        [Idx, D] = knnsearch(Mdl, Y, 'K', k);
        
        d_mean = saveKDTreeResult_CSV(Idx, D, file_name, summary_path);
        summary = [summary; {file_name, d_mean}];
        
        subplot(2, 2, [2, 4]);
        for i = 1:p
            v = kdtree(Idx(i), :);
            nearest_pt = reshape(v, 2, 68);               
            draw2DFace(nearest_pt, "KDTree Nearest Neighbours");
        end

        draw2DFace(pt2d, "");
        ax2 = gca;
        set(ax2, 'Position', [0.5, 0.05, 0.4, 0.9]);        

        title("KDTree Nearest Neighbours");

        sample_path = join(["images/2d_nearest_neighbours_images/", file_name, ".png"], '');
        exportgraphics(fig, sample_path, 'Resolution', 300);        
        
        disp(sample_path);
        disp(fileIndex);  
        
        if(fileIndex == 5)
            disp("5 done");
            saveKDTreeResultMinMean_CSV(summary, summary_path);
            return; 
        end
                
    end    
    
    saveKDTreeResultMinMean_CSV(summary, summary_path);

    disp("Completed");
    
end

