function preOptimizationDataset(sample_file)
    
    fprintf("Preparing pre-optimization dataset, File: %s\n", sample_file);
    
    result.file = sample_file;

    [sample_2d_gt, sample_3d_gt, yaw_class, yaw_class_id] = loadGroundTruthData(sample_file);    

    load(join(["dataset/AFLW2000/2D_dataset_normalized/" sample_file], ''));
    normalized_2d = M;

    k = 256;
    [knnFrame, DA, Idx] = getNearestNeighboursMatrix(normalized_2d, k);    
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
    result.yaw_class = yaw_class;
    result.yaw_class_id = yaw_class_id;
    result.dir = dir;
    result.angle = angle;
    
    save(join(["results/pre-optimization/AFLW/", sample_file], ''), "result");   

end

