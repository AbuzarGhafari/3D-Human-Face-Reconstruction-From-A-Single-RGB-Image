function [nn_matrix, DA, Idx] = getNearestNeighboursMatrix(pt2d, k)

    load("mat_files/kd_tree_data.mat");    
    load("mat_files/pathMatrix.mat");
 
    Mdl = KDTreeSearcher(kdtree);
    Y = pt2d(:)';    
    [Idx, D] = knnsearch(Mdl, Y, 'K', k);
    
    % Directions and Angles
    DA = [];
    
    PM = [];
    for i=1:k 
        pth = pathMatrix(Idx(i)); 
        DA = [DA; pathMatrix(Idx(i), 2), pathMatrix(Idx(i), 3)];
        newPth = replace(pth, "3d_dataset_normalized", "3d_dataset_gt");
        
        pt3d = get3DOriginalLandmarks(newPth);                
        pt3d = normalizeTranslate3D(pt3d);
        pt3d = normalizeOrientation3D(pt3d);    

        PM = [PM; pt3d(:)']; 
    end
 
    nn_matrix = PM;
end

