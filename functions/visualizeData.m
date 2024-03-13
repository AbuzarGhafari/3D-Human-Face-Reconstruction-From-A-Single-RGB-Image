function visualizeData(sub_dir, sample)

    global projected_dataset_path ...
            dataset_sub_directories ...
            directions ...
            x_angles ...
            y_angles ...
            angles;
        
    
    % normalized 3D dataset
    npt3d = getNormalized3DLandmarks(sub_dir, sample);
    % 3D Points
    pt3d = npt3d;
     
    mainfig = figure('Visible', 'off');
    draw3DFace(pt3d, "Normalized 3D");
%     path = join(['3d_normalized_images/' dataset_sub_directories(sub_dir) '/' sample_name '.png'], '');
    exportgraphics(mainfig, 'mainfig.png', 'Resolution', 300);
           
    % Load 2D Projected Dataset
    path = join([projected_dataset_path, dataset_sub_directories(sub_dir), "/"], '');

    fileNames = getDatasetFiles(path);    
    
    % Sample Image
    sample_name = cell2mat(fileNames(sample));    
    sample_path = [projected_dataset_path, dataset_sub_directories(sub_dir), "/", sample_name];  
    sample_path = join(sample_path, '');
    load(sample_path); 

    for direction = 1:numel(directions)
        subfig = figure('Name', sample_path, 'Visible', 'off');
        data2d = projections_2d_data(:, direction); 
        
        plotIndex = 1;
        columns = 5;
        if (directions(direction) == 'y')
            [r c] = size(y_angles);
            rows = ceil(c / columns);
            figWidth = 600;
            figHeight = 1000;
            set(subfig, 'Position', [100, 100, figWidth, figHeight])
        elseif (directions(direction) == 'x')            
            [r c] = size(x_angles);
            rows = ceil(c / columns);
        end
        
        for p = 1:numel(data2d)
            
            points = data2d{p};
            if (isempty(points) == 0)
                subplot(rows, columns, plotIndex);             
                points = points'; 
                draw2DFace(points, [num2str(angles(p)), ' angle'], 'black'); 
                plotIndex = plotIndex + 1;
            end
        end 
        
        sgtitle([directions(direction), ' Direction']);
        

        exportgraphics(subfig, ['subfig_' directions(direction) '.png'], 'Resolution', 300);
    end
    
    main_img = imread('mainfig.png');
    subfig_x = imread('subfig_x.png');
    subfig_y = imread('subfig_y.png');
    
    combinedfig = figure('Name', sample_path, 'Visible', 'off'); 
    figWidth = 1000;
    figHeight = 900;
    set(combinedfig, 'Position', [100, 100, figWidth, figHeight]);
    
    subplot(2, 2, 1); 
    imshow(main_img);
    
    ax1 = gca;
    set(ax1, 'Position', [0.05, 0.5, 0.45, 0.45]);
    
    subplot(2, 2, 3); 
    imshow(subfig_x); 
    ax2 = gca;
    set(ax2, 'Position', [0.05, 0.05, 0.45, 0.45]);
    
    subplot(2, 2, [2, 4]); 
    imshow(subfig_y); 
    ax2 = gca;
    set(ax2, 'Position', [0.525, 0.05, 0.45, 0.9]);

    
    sample_path = ["2d_projected_images/", dataset_sub_directories(sub_dir), "/", sample_name, ".png"];  
    sample_path = join(sample_path, '');
    exportgraphics(combinedfig, sample_path, 'Resolution', 300);
    
end

