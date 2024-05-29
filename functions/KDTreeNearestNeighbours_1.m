function [Idx, D] = KDTreeNearestNeighbours_1(pt2d, p, k)

    global dataset_sub_directories;   

    load("kd_tree_data.mat");

    fig = figure;
    figWidth = 800;
    figHeight = 500;
%     set(fig, 'Position', [100, 100, figWidth, figHeight]);

    Mdl = KDTreeSearcher(kdtree);

    Y = pt2d(:)';
    [Idx, D] = knnsearch(Mdl, Y, 'K', k);

    for i = 1:p
        v = kdtree(Idx(i), :);
        nearest_pt = reshape(v, 2, 68);               
        draw2DFace(nearest_pt, "", 'black');
    end

    draw2DFace(pt2d, "", 'red');
        

%         sample_path = ["2d_nearest_neighbours_images/", dataset_sub_directories(sub_dir), "/", file_name, ".png"];  
%         sample_path = join(sample_path, '');
%         exportgraphics(fig, sample_path, 'Resolution', 300);        
        

        disp("Completed");
    
end

