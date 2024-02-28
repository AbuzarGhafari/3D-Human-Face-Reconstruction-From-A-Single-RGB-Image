function KDTreeNearestNeighbours(sub_dir)

    global dataset_sub_directories;   

    load("kd_tree_data.mat");

    parent_dir = "2d_dataset/";
    path = join([parent_dir, dataset_sub_directories(sub_dir), "/"], '');
    fileNames = getDatasetFiles(path);

    for fileIndex = 1:numel(fileNames)
        
        file = cell2mat(fileNames(fileIndex));   
        
        [pathstr, file_name, ext] = fileparts(file);

        image_path = join([parent_dir, dataset_sub_directories(sub_dir) , '/', file_name, '.jpg'], '');
        
        load(join([parent_dir, dataset_sub_directories(sub_dir) , '/', file_name, '.mat'], ''));

        img = imread(image_path); 

        fig = figure('Name', image_path, 'Visible', 'off');
        figWidth = 800;
        figHeight = 500;
        set(fig, 'Position', [100, 100, figWidth, figHeight]);

        subplot(2, 2, 1);
        imshow(img);
        % ax1 = gca;
        % set(ax1, 'Position', [0.05, 0.5, 0.3, 0.45]);
        title("Test Image");

        subplot(2, 2, 3);
        draw2DFace(pt2d, '2D Face', 'black'); 
        ax2 = gca;
        set(ax2, 'Position', [0.1, 0.05, 0.3, 0.45]);

        Mdl = KDTreeSearcher(kd_tree_data);

        Y = pt2d(:)';
        [Idx, D] = knnsearch(Mdl, Y, 'K', 20);

        subplot(2, 2, [2, 4]);
        for i = 1:3
            v = kd_tree_data(Idx(i), :);
            nearest_pt = reshape(v, 2, 68);    
            draw2DFace(nearest_pt, "KDTree Nearest Neighbours", 'black');
        end

        draw2DFace(pt2d, "", 'red');
        ax2 = gca;
        set(ax2, 'Position', [0.5, 0.05, 0.4, 0.9]);

        title("KDTree Nearest Neighbours");

        sample_path = ["2d_nearest_neighbours_images/", dataset_sub_directories(sub_dir), "/", file_name, ".png"];  
        sample_path = join(sample_path, '');
        exportgraphics(fig, sample_path, 'Resolution', 300);        
        
        disp(sample_path);
        disp(fileIndex); 
        
    end

    disp("Completed");
    
end

