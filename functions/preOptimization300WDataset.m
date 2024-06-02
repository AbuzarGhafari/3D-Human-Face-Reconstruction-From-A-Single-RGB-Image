function preOptimization300WDataset(sample_file, kdtree, path)
    
    fprintf("Preparing pre-optimization dataset for 300W, File: %s\n", sample_file);
    
    result.file = sample_file;

    [sample_2d_gt, sample_3d_gt] = loadGroundTruthData_300W(sample_file);    

%     load(join(["dataset/AFLW2000/2D_dataset_normalized/" sample_file], ''));


    % Reflection matrix for reflecting around the x-axis
    Rx = [1, 0; 0, -1];

    % Perform the reflection
    pt2d = Rx * sample_2d_gt;

    % Translation Normalization
    pt2d = normalizeTranslate2D(pt2d);
    
    sample_2d_gt = pt2d;
        
    % 0 1 Normalize Data
    pt2d = zeroOneNormalize2D(pt2d);   

    normalized_2d = pt2d;        

    k = 256;
    [knnFrame, DA, Idx] = getNearestNeighboursMatrix(kdtree, normalized_2d, k);    
    [dir, angle] = getMostlyUsedDirAndAngle(DA);
            
    knn_avg_3d = computeAverage_3DFaces(k, Idx);
    [errPrJnts, errPrFr, errPrAllFr] = H_errorHumanEva(knn_avg_3d, sample_3d_gt);    
    
    result.k = k;
    result.gt_2d = sample_2d_gt;
    result.gt_3d = sample_3d_gt;
    result.normalized_2d = normalized_2d;
    result.knn_indexes = Idx;
    result.knnFrame = knnFrame;
    result.knn_avg_3d = knn_avg_3d;
    result.knn_avg_error = errPrAllFr;        
%     result.yaw_class = yaw_class;
%     result.yaw_class_id = yaw_class_id;
    result.dir = dir;
    result.angle = angle;
    
    save(join([path, sample_file], ''), "result");   
    fprintf("Completed");
end

