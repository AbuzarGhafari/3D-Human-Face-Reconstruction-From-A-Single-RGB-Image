function [errPrJnts, errPrFr, errPrAllFr] = compare_GT_AVG_NN(sample_file)

    disp("Loading...");
    load("mat_files/kd_tree_data.mat");
    load("mat_files/pathMatrix.mat");
    load('model/Model_Shape_Sim.mat');
    
    Mdl = KDTreeSearcher(kdtree);

    load(join(["dataset/AFLW2000/2D_dataset_normalized/", sample_file], '')); 
    Y = M(:)';

    gt_path = join(["dataset/AFLW2000/3d_dataset_gt/", sample_file], '');
    load(gt_path);            
    gt_pt3d = pt3d_68;

    % Reflect around y-axis
    gt_pt3d(2, :) = -gt_pt3d(2, :); 
    gt_pt3d = normalizeTranslate3D(gt_pt3d);
    gt_pt3d = normalizeOrientation3D(gt_pt3d);  
%     gt_pt3d = normalizeScale3D(gt_pt3d);     
%     gt_pt3d = normalizeTranslate3D(gt_pt3d); 

    fprintf("Finding Nearest Neighbours:\n");
    
    i = 8;

    k = 2^i;
    
    fprintf("K: %d\n", k);

    [Idx, D] = knnsearch(Mdl, Y, 'K', k);

    averageLandmarks = computeAverage_3DFaces(k, Idx, pathMatrix);          

    [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(averageLandmarks, gt_pt3d);
    
    % ==============================================================
    fprintf("Generating Image..\n");
    fig = figure('Name', gt_path);
    
    % black = GT, red = Avg. NN
    compare3DFace(gt_pt3d, averageLandmarks, "Avg. NN vs. Ground Truth");
    
    disp("Completed");
  
end
